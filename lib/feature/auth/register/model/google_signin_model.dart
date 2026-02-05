import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network_caller/endpoints.dart';


class GoogleSignInModel {
  final String apiUrl = '${Urls.baseUrl}/auth/google';

  // Function to handle Google sign-in
  Future<Map<String, dynamic>> signInWithGoogle(String googleToken) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);

      if (response.statusCode == 200) {
        // Parse the response as needed
        return json.decode(response.body);
      } else {
        throw Exception('Failed to sign in with Google');
      }
    } catch (e) {
      rethrow;
    }
  }
}
