import 'package:get/get.dart';
import 'package:hair_style_app/controller/home_controller.dart';
import 'package:hair_style_app/controller/on_boarding_controller.dart';
import 'package:hair_style_app/controller/splash_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.put(HomeController());
    Get.put(OnBoardingController());
  }
}