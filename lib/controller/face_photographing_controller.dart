import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hair_style_app/confing/app_colors.dart';
import 'package:hair_style_app/confing/end_points.dart';
import 'package:hair_style_app/controller/home_controller.dart';
import 'package:hair_style_app/http_handler/http_handler.dart';
import 'package:hair_style_app/screens/face_photographing/face_photographing_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../model/get_rendering_result.dart';

class FacePhotoGraphingController extends GetxController {
  CarouselController buttonCarouselController = CarouselController();
  bool isLoading = false;
  bool isInProgress = false;
  int tempIndex = 0;
  bool isEnable = false;
  GetRenderingResultModel? getRenderingResultModel;

  final myImagesList = [];

  Future<File?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        return null;
      } else {
        final imageTemp = File(image.path);
        isEnable = true;
        myImagesList.add(imageTemp);
        update();
        return imageTemp;
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    update();
    return null;
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
          Fluttertoast.showToast(msg: "Waiting for image to be uploaded…");
        } else {
          Get.find<HomeController>().selectedImageId = response["hairstyle_id"];
          Get.to(const FacePhotoGraphingScreen());
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

  startRendering() async {
    isLoading = true;
    update();
    final eventId = getStorage.read("eventId");

    await HttpHandler.postHttpMethod(
        url: EndPoints().startRendering(eventId: eventId),
        data: {
          "hairstyle_id": Get.find<HomeController>().selectedImageId,
          "photo_ids": {"front": 0, "right": 1, "left": 2, "back": 3}
        }).then((value) {
      if (value["statusCode"] == 200) {
        final response = jsonDecode(value["body"]);

        printData("getImageId Data----------------$response");
        // Get.to(const TransFormationResultScreen());
        // Get.find<TransFormationResultController>().getRenderingResult();
        getRenderingResult();
        update();
      } else {
        printData("Error-----------------");
      }
    });
    // Get.to(const TransFormationResultScreen());

    isLoading = false;
    update();
  }

  List<String> myImagesList1 = [];
  getRenderingResult() async {
    isLoading = true;
    update();
    final eventId = getStorage.read("eventId");
    printData("eventId:: $eventId");
    myImagesList1 = [];
    await HttpHandler.getHttpMethod(
      url: EndPoints().getRenderingResult(eventId: eventId),
    ).then((value) {
      print("value in rendering result:: $value");
      final response = jsonDecode(value["body"]);
      isInProgress = response["inprogress"];
      if (isInProgress) {
        Fluttertoast.showToast(msg: "Waiting for the your hairstyle preview.");
        getRenderingResult();
      } else {
        getRenderingResultModel =
            GetRenderingResultModel.fromJson(jsonDecode(value["body"]));
        printData(
            "Success-employeeData----------------$getRenderingResultModel");
        if (getRenderingResultModel?.hairstyleId?.front != "") {
          myImagesList1.add(getRenderingResultModel!.hairstyleId!.front!);
        }

        // Add right image to the list
        if (getRenderingResultModel?.hairstyleId?.right != "") {
          myImagesList1.add(getRenderingResultModel!.hairstyleId!.right!);
        }
        if (getRenderingResultModel?.hairstyleId?.left != "") {
          myImagesList1.add(getRenderingResultModel!.hairstyleId!.left!);
        }
        if (getRenderingResultModel?.hairstyleId?.back != "") {
          myImagesList1.add(getRenderingResultModel!.hairstyleId!.back!);
        }
        print("image :: $myImagesList1");
        Fluttertoast.showToast(
            msg: "The hairstyle Preview has been successfully generated.");

        // Get.to(const TransFormationResultScreen());
      }

      printData("getImageId Data----------------$response");
    });
    // Get.to(const TransFormationResultScreen());

    isLoading = false;
    update();
  }
}
