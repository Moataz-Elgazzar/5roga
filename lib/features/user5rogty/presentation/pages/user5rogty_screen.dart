import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:app_5roga/core/constants/app_images.dart';
import 'package:app_5roga/core/functions/extension.dart';
import 'package:app_5roga/core/functions/loading.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/placeDetails/data/khorogamodel.dart';
import 'package:app_5roga/features/user5rogty/presentation/widget/item_tile.dart';
import 'package:app_5roga/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class User5rogtyScreen extends StatefulWidget {
  const User5rogtyScreen({super.key});

  @override
  State<User5rogtyScreen> createState() => _User5rogtyScreenState();
}

class _User5rogtyScreenState extends State<User5rogtyScreen> {
  DateTime selectedDate = DateTime.now();
  bool get isDark => themeNotifier.value == ThemeMode.dark;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final String date = DateFormat('dd-MM-yyyy').format(selectedDate);
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("5rogty".tr(), style: TextStyles.size24.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                color: isDark ? AppColors.darkColor : AppColors.backGroundColor,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.none,
                  child: Column(
                    children: [
                      datePicker(),
                      const Gap(30),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("khoroga").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const AppLoadingScreen();
                          }
                          final List allKhoroga = snapshot.data?.data()?["list"] ?? [];

                          final List filtered = allKhoroga.where((item) => item["date"] == date).toList();
                          if (filtered.isEmpty) {
                            return Column(mainAxisAlignment: MainAxisAlignment.center, children: [Lottie.asset(AppImages.empty, width: 300, height: 300), Text("noplace2".tr())]);
                          } else {
                            return ListView.separated(
                              itemCount: filtered.length,
                              physics: const NeverScrollableScrollPhysics(),
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final kModel = KhorogaModel.fromJson(filtered[index]);
                                return ItemTile(kmodel: kModel);
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 10);
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10),
            child: Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.primaryColor : AppColors.wightColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                    ),
                    child: IconButton(
                      style: IconButton.styleFrom(overlayColor: Colors.transparent),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        try {
                          final imageBytes = await screenshotController.capture();

                          if (imageBytes != null) {
                            // 2. الحصول على مسار المجلد المؤقت للجهاز
                            final directory = await getTemporaryDirectory();
                            final imagePath = await File('${directory.path}/screenshot.png').create();

                            // 3. كتابة البيانات في ملف
                            await imagePath.writeAsBytes(imageBytes);

                            // 4. مشاركة الملف باستخدام share_plus

                            if (await imagePath.exists()) {
                              await SharePlus.instance.share(ShareParams(files: [XFile(imagePath.path)], text: 'يلا نخرج'));
                            }
                          }
                        } catch (e, s) {
                          log("Screenshot error: $e");
                          log("StackTrace: $s");
                        }
                      },
                      icon: Icon(Icons.share_outlined, color: isDark ? AppColors.wightColor : AppColors.primaryColor, size: 30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  EasyDateTimeLinePicker datePicker() {
    return EasyDateTimeLinePicker.itemBuilder(
      headerOptions: HeaderOptions(
        headerBuilder: (context, date, onTap) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('d MMMM yyyy', context.isArabic ? "ar" : "en").format(date),
                  style: TextStyle(color: isDark ? AppColors.wightColor : AppColors.primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),

                IconButton(
                  style: IconButton.styleFrom(overlayColor: Colors.transparent),
                  icon: Icon(Icons.arrow_drop_down, color: isDark ? AppColors.wightColor : AppColors.primaryColor),
                  onPressed: onTap,
                ),
              ],
            ),
          );
        },
      ),
      physics: const BouncingScrollPhysics(),
      locale: Locale(context.isArabic ? "ar" : "en"),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 3, 18),
      focusedDate: selectedDate,
      itemExtent: 64.0,
      itemBuilder: (context, date, isSelected, isDisabled, isToday, onTap) {
        return InkResponse(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.rectangle, color: isSelected ? AppColors.primaryColor : AppColors.wightColor, borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Text(date.day.toString(), style: TextStyles.size20.copyWith(color: isSelected ? AppColors.wightColor : AppColors.inputColor)),
            ),
          ),
        );
      },
      onDateChange: (date) {
        setState(() {
          selectedDate = date;
        });
      },
    );
  }
}
