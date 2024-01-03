import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_style_app/confing/app_colors.dart';
import 'package:hair_style_app/confing/constant.dart';
import 'package:hair_style_app/controller/home_controller.dart';

class HairStyleSelectionScreen extends StatelessWidget {
  const HairStyleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: Get.find<HomeController>(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppColors.kf0f0f0fColor,
            title: Text(
              'hair_style_selection'.tr,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor),
            ),
            leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset('assets/images/ic_back_button.png')),
          ),
          backgroundColor: AppColors.kf0f0f0fColor,
          body: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Column(
                  children: [
                    const Divider(
                      color: AppColors.kDEDEDEColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          size.heightSpace(25),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.kC7C7F1Color,
                                  borderRadius: BorderRadius.circular(24)),
                              child: Center(
                                  child: Text(
                                'upload_custom_hairstyle'.tr,
                                style: const TextStyle(
                                    color: AppColors.k030303Color,
                                    fontSize: 18),
                              )),
                            ),
                          ),
                          size.heightSpace(26),
                          Container(
                            height: size.height(425),
                            color: AppColors.kC2C2C2Color,
                            child: Scrollbar(
                              controller: controller.scrollController,
                              child: Center(
                                child: GridView.builder(
                                  itemCount: controller
                                      .hairStylePreset?.hairstyles?.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                      left: 9, top: 15, bottom: 15, right: 23),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 26,
                                          mainAxisSpacing: 26),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.selectedImageIndex = index;

                                        for (var i = 0;
                                            i <
                                                controller.hairStylePreset!
                                                    .hairstyles!.length;
                                            i++) {
                                          controller.hairStylePreset!
                                                  .hairstyles![i].isSelected =
                                              (i ==
                                                  controller
                                                      .selectedImageIndex);
                                        }

                                        controller.update();
                                        if (controller.selectedImageIndex !=
                                            -1) {
                                          controller.selectedImageId =
                                              controller
                                                  .hairStylePreset
                                                  ?.hairstyles?[index]
                                                  .hairstlyeId;
                                          controller.update();
                                          printData(
                                              "Selected Image ID: ${controller.selectedImageId}");
                                        }
                                      },
                                      child: Container(
                                        height: size.height(100),
                                        width: size.width(100),
                                        decoration: BoxDecoration(
                                            color: AppColors.kC7C7F1Color,
                                            borderRadius:
                                                BorderRadius.circular(26),
                                            border: Border.all(
                                                color: controller
                                                        .hairStylePreset!
                                                        .hairstyles![index]
                                                        .isSelected
                                                    ? AppColors.primaryColor
                                                    : AppColors.k505050Color,
                                                width: controller
                                                        .hairStylePreset!
                                                        .hairstyles![index]
                                                        .isSelected
                                                    ? 4
                                                    : 3)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          child: Image.network(
                                            controller
                                                    .hairStylePreset
                                                    ?.hairstyles?[index]
                                                    .hairstyleUrl ??
                                                "",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: GestureDetector(
            onTap: controller.selectedImageIndex == -1
                ? () {}
                : () {
                    /// do needful operation here
                    printData("Tap on Button");
                  },
            child: Container(
              height: size.height(45),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  color: controller.selectedImageIndex == -1
                      ? Colors.black12
                      : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.k030303Color, width: 4)),
              child: Center(
                  child: Text(
                'select_hairstyle'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: controller.selectedImageIndex == -1
                        ? Colors.black
                        : AppColors.whiteColor),
              )),
            ),
          ),
        );
      },
    );
  }
}
