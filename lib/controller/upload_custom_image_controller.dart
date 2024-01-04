import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hair_style_app/confing/app_colors.dart';
import 'package:hair_style_app/confing/end_points.dart';
import 'package:hair_style_app/controller/home_controller.dart';
import 'package:hair_style_app/http_handler/http_handler.dart';
import 'package:hair_style_app/screens/custom_image/upload_custom_image.dart';

class UploadCustomImageController extends GetxController {
  bool isLoading = false;
  String urlLink = "";
  bool isInProgress = false;

  getQrUrl() async {
    isLoading = true;
    update();
    final eventId = getStorage.read("eventId");
    urlLink = "";
    await HttpHandler.getHttpMethod(url: EndPoints().qrLink(eventId: eventId))
        .then((value) {
      if (value["statusCode"] == 200) {
        final response = jsonDecode(value["body"]);
        urlLink = response["link"];
        Get.to(const UploadCustomImageScreen());

        printData("getQrUrl Data----------------$response");
        printData("getQrUrl urlLink----------------$urlLink");

        update();
      } else {
        printData("Error-----------------");
      }
    });

    isLoading = false;
    update();
  }

  getImageId() async {
    isLoading = true;
    update();
    final eventId = getStorage.read("eventId");

    await HttpHandler.getHttpMethod(
        url: EndPoints().getImageId(eventId: eventId))
        .then((value) {
      if (value["statusCode"] == 200) {
        final response = jsonDecode(value["body"]);
        isInProgress = response["inprogress"];
        if (isInProgress) {
          Fluttertoast.showToast(
              msg:
              "The hairstyle has not been generated yet, Please try again.");
        } else {
          Get.find<HomeController>().selectedImageId = response["hairstyle_id"];
          // Get.to(const FacePhotoGraphingScreen());
          Fluttertoast.showToast(
              msg: "The hairstyle has been successfully generated.");
        }

        printData("getImageId Data----------------$response");
        printData(
            "selectedImageId----------------${Get.find<HomeController>().selectedImageId}");

        update();
      } else {
        printData("Error-----------------");
      }
    });

    isLoading = false;
    update();
  }
}
