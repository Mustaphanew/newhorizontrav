// lib/controller/flight/flight_detail_controller.dart
import 'package:get/get.dart';
import 'package:newhorizontrav/model/flight/flight_offer_model.dart';
import 'package:newhorizontrav/model/flight/revalidated_flight_model.dart';
import 'package:newhorizontrav/utils/app_apis.dart';
import 'package:newhorizontrav/utils/app_vars.dart';
import 'package:newhorizontrav/view/frame/flights/flight_detail/flight_detail_page.dart';

class FlightDetailApiController extends GetxController {
  final Rxn<RevalidatedFlightModel> revalidatedDetails = Rxn<RevalidatedFlightModel>();
  final RxBool isLoading = false.obs;

  Future<void> revalidateAndOpen({required FlightOfferModel offer}) async {
    
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final res = await AppVars.api.post(
        AppApis.revalidateFlight,
        params: <String, dynamic>{
          "api_session_id": AppVars.apiSessionId,
          "id": offer.id,
          "return_id": null,
        },
      );

      if (res == null) {
        Get.snackbar("Error".tr, "".tr);
        return;
      }

      final data = res as Map<String, dynamic>;
      final detail = RevalidatedFlightModel.fromResponseJson(data);
      revalidatedDetails.value = detail;

      // فتح صفحة تفاصيل الرحلة
      Get.to(() => FlightDetailPage(detail: detail, showContinueButton: true));
    } catch (e) {
      Get.snackbar("Error".tr, "Could not load flight details".tr);
    } finally {
      isLoading.value = false;
    }
    
  }
}
