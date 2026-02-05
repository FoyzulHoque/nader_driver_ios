import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../core/network_caller/network_config.dart';
import '../../../core/network_caller/endpoints.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../model/wallet_model.dart';


class DriverIncomeController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = "".obs;

  var totalIncome = 0.0.obs;
  var totalDuration = 0.obs;
  var totalDistance = 0.0.obs;
  var totalTrips = 0.obs;

  var transactionHistory = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDriverIncome();
  }

  Future<void> fetchDriverIncome() async {
    isLoading.value = true;
    errorMessage.value = "";
    EasyLoading.show(status: "Fetching wallet...");

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "Access token not found. Please login.";
        EasyLoading.showError(errorMessage.value);
        return;
      }

      final response = await NetworkCall.getRequest(
        url: NetworkPath.driverIncome
      );

      if (response.isSuccess) {
        final data = response.responseData?["data"];
        if (data != null) {
          final incomeModel = DriverIncomeModel.fromJson(data);

          totalIncome.value = incomeModel.totalIncome;
          totalDuration.value = incomeModel.totalDuration;
          totalDistance.value = incomeModel.totalDistance;
          totalTrips.value = incomeModel.totalTrips;
          transactionHistory.value = incomeModel.transactions;
        }
        EasyLoading.dismiss();
      } else {
        errorMessage.value = response.errorMessage ?? "Failed to fetch income";
        EasyLoading.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      EasyLoading.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
      if (EasyLoading.isShow) EasyLoading.dismiss();
    }
  }
}
