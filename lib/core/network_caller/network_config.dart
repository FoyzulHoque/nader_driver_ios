import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import '../../feature/auth/register/screen/register_screen.dart';
import '../shared_preference/shared_preferences_helper.dart';

class NetworkResponse {
  final int statusCode;
  final Map<String, dynamic>? responseData;
  final String? errorMessage;
  final String? successMessage;
  final bool isSuccess;

  NetworkResponse({
    required this.statusCode,
    this.responseData,
    this.errorMessage = "Request failed !",
    this.successMessage = "Request success",
    required this.isSuccess,
  });

}

class NetworkCall {
  static final Logger _logger = Logger();

  /// POST Multipart request
  static Future<NetworkResponse> multipartRequest({
    required String url,
    Map<String, String>? fields,
    File? imageFile,
    File? videoFile,
    required String methodType,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      var request = http.MultipartRequest(methodType, uri);

      // Add Authorization header
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers['Authorization'] = accessToken;
        // request.headers['Authorization'] = 'Bearer ${accessToken!}';
      }

      // Add fields (e.g. name, email)
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Attach image if present
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      // Attach video if present
      if (videoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'video',
            videoFile.path,
            contentType: MediaType('video', 'mp4'),
          ),
        );
      }

      // Send request
      _logRequest(url, request.headers, requestBody: fields);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseDecode = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseDecode,
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> multipartRequestForData({
    required String url,
    required Map<String, dynamic> formData,
    required String methodType,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      var request = http.MultipartRequest(methodType, uri);

      // 🔑 Add Authorization header
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers['Authorization'] = accessToken;
      }

      for (var entry in formData.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is File) {
          String fileName = value.path.split('/').last;
          String mimeType = key.contains("video") ? "video/mp4" : "image/jpeg";
          request.files.add(
            await http.MultipartFile.fromPath(
              key,
              value.path,
              contentType: MediaType(
                mimeType.split('/')[0],
                mimeType.split('/')[1],
              ),
              filename: fileName,
            ),
          );
        } else if (value is List<File>) {
          for (var file in value) {
            String fileName = file.path.split('/').last;
            String mimeType = key.contains("video")
                ? "video/mp4"
                : "image/jpeg";
            request.files.add(
              await http.MultipartFile.fromPath(
                key,
                file.path,
                contentType: MediaType(
                  mimeType.split('/')[0],
                  mimeType.split('/')[1],
                ),
                filename: fileName,
              ),
            );
          }
        } else {
          request.fields[key] = value.toString();
        }
      }

      // Send request
      _logRequest(url, request.headers, requestBody: request.fields);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logResponse(url, response);
      final responseDecode = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          statusCode: response.statusCode,
          successMessage:responseDecode["message"],
          isSuccess: true,
          responseData: responseDecode,
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          errorMessage:responseDecode["message"],
          isSuccess: false,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage:responseDecode["message"],
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// POST request
  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      Map<String, String> headers = {"Content-Type": "application/json"};

      final accessToken = await SharedPreferencesHelper.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = accessToken;
        // headers['Authorization'] = 'Bearer ${accessToken!}';
      }
      _logRequest(url, headers, requestBody: body);

      Response response = await post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      _logResponse(url, response);

      final responseDecode = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          statusCode: response.statusCode,
          successMessage:responseDecode["message"],
          isSuccess: true,
          responseData: responseDecode,
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          errorMessage:responseDecode["message"],
          isSuccess: false,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage:responseDecode["message"],
          responseData: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// PATCH request
  static Future<NetworkResponse> patchRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      Map<String, String> headers = {"Content-Type": "application/json"};
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = accessToken;
        // headers['Authorization'] = 'Bearer ${accessToken!}';
      }

      _logRequest(url, headers, requestBody: body);
      Response response = await patch(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseDecode = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseDecode,
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// GET request
  static Future<NetworkResponse> getRequest({
    required String url,
    Map<String, dynamic>? queryParams
  }) async {
    try {
      String fullUrl = url;
      if (queryParams != null && queryParams.isNotEmpty) {
        fullUrl += '?';
        queryParams.forEach((key, value) {
          fullUrl += '$key=$value&';
        });
        fullUrl = fullUrl.substring(0, fullUrl.length - 1);
      }

      final Uri uri = Uri.parse(fullUrl);
      Map<String, String> headers = {"Content-Type": "application/json"};
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = accessToken;
        // headers['Authorization'] = '${accessToken}';
      }

      _logRequest(fullUrl, headers);
      Response response = await get(uri, headers: headers);
      _logResponse(fullUrl, response);

      final responseDecode = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          statusCode: response.statusCode,
          successMessage:responseDecode["message"],
          isSuccess: true,
          responseData: responseDecode,
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          errorMessage:responseDecode["message"],
          isSuccess: false,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          errorMessage:responseDecode["message"],
          isSuccess: false,
          responseData: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// PUT request
  static Future<NetworkResponse> putRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      Map<String, String> headers = {"Content-Type": "application/json"};
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = accessToken;
        // headers['Authorization'] = 'Bearer ${accessToken}';
      }

      _logRequest(url, headers, requestBody: body);
      Response response = await put(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseDecode = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseDecode,
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// DELETE request
  static Future<NetworkResponse> deleteRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      Map<String, String> headers = {"Content-Type": "application/json"};
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = accessToken;
        // headers['Authorization'] = 'Bearer ${accessToken}';
      }

      _logRequest(url, headers, requestBody: body);
      Response response = await delete(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseDecode = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseDecode,
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// PUT Multipart request
  static Future<NetworkResponse> putMultipartRequest({
    required String url,
    required File file,
    String? fieldName = 'file',
    Map<String, String>? fields,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      final request = http.MultipartRequest('PUT', uri);

      // Token header
      request.headers['Accept'] = 'application/json';

      final accessToken = await SharedPreferencesHelper.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers['Authorization'] = accessToken;
        // request.headers['Authorization'] = 'Bearer ${accessToken}';
      }

      // Attach image file
      request.files.add(
        await http.MultipartFile.fromPath(fieldName!, file.path),
      );

      // Add optional fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      _logRequest(url, request.headers, requestBody: fields);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseDecode = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseDecode,
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Logging request
  static void _logRequest(
    String url,
    Map<String, dynamic> headers, {
    Map<String, dynamic>? requestBody,
  }) {
    _logger.i(
      "🌐 REQUEST\nURL: $url\nHeaders: $headers\nBody: ${jsonEncode(requestBody)}",
    );
  }

  /// Logging response
  static void _logResponse(String url, Response response) {
    _logger.i(
      "📥 RESPONSE\nURL: $url\nStatus Code: ${response.statusCode}\nBody: ${response.body}",
    );
  }

  /// Logout and navigate to login
  static Future<void> _logOut() async {
    await SharedPreferencesHelper.clearAllData();
    Get.offAll(RegisterScreen());
  }
}
