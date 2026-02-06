import 'dart:developer';

import 'package:app_5roga/components/buttons/main_button_custom.dart';
import 'package:app_5roga/components/inputs/custome_text_form_field%20copy.dart';
import 'package:app_5roga/core/functions/extension.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/services/notification/local_notification.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/placeDetails/data/khorogamodel.dart';
import 'package:app_5roga/features/userHome/data/models/catogery.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:app_5roga/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacedetailsScreen extends StatefulWidget {
  const PlacedetailsScreen({super.key, required this.model});
  final PlaceModel? model;

  @override
  State<PlacedetailsScreen> createState() => _PlacedetailsScreenState();
}

class _PlacedetailsScreenState extends State<PlacedetailsScreen> {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  bool get isDark => themeNotifier.value == ThemeMode.dark;

  double? rate;
  DateTime pickedDate = DateTime.now();
  late TimeOfDay? pickedTime;
  String? role;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadUserRole();
    loadFavoriteStatus();
    final today = DateTime.now();
    dateController.text = DateFormat('dd-MM-yyyy').format(today);
  }

  Future<void> loadUserRole() async {
    final doc = await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {
      role = doc['role'];
    });
  }

  Future<void> loadFavoriteStatus() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection("favoriteList").doc(userId).get();

    if (doc.exists) {
      final List fav = doc.data()?["favoriteList"] ?? [];
      setState(() {
        isFavorite = fav.contains(widget.model?.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),

        actions: [
          if (role == null)
            const SizedBox()
          else if (role == 'user') ...[
            IconButton(
              style: IconButton.styleFrom(overlayColor: Colors.transparent, padding: const EdgeInsets.all(0)),
              onPressed: () async {
                if (isFavorite) {
                  await removeFromfavoriteList();
                } else {
                  await addTofavoriteList();
                }
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              icon: isFavorite ? const Icon(Icons.favorite, size: 30, color: AppColors.primaryColor) : const Icon(Icons.favorite_border, size: 30),
            ),
          ] else ...[
            IconButton(
              onPressed: () {
                pushTo(context, Routes.addPlace, extra: model);
              },
              icon: const Icon(Icons.edit),
            ),
          ],

          const SizedBox(width: 5),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Hero(
                  tag: widget.model?.id ?? "",
                  child: CachedNetworkImage(imageUrl: widget.model?.mainImage ?? '', width: double.infinity, height: 300, fit: BoxFit.cover),
                ),
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: Center(child: Text(context.isArabic ? widget.model?.arName ?? "" : widget.model?.enName ?? "", style: TextStyles.size24)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(widget.model!.rating!.toDouble().toString(), style: TextStyles.size16.copyWith(color: isDark ? Colors.amberAccent : AppColors.primaryColor)),
                    ],
                  ),
                ],
              ),
              const Gap(15),
              Text("bio".tr(), style: TextStyles.size20),
              const Gap(10),
              Text(context.isArabic ? widget.model?.arDescription ?? '' : widget.model?.enDescription ?? '', style: TextStyles.size16, textAlign: TextAlign.justify),
              const Gap(15),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.primaryColor, size: 30),
                  const Gap(5),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("location2".tr(), style: TextStyles.size20),
                        TextButton(
                          style: TextButton.styleFrom(overlayColor: Colors.transparent, padding: const EdgeInsets.all(0)),
                          onPressed: () {
                            launchUrl(Uri.parse(widget.model?.location ?? ''));
                          },
                          child: Text("onMaps".tr()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Text(widget.model?.address ?? '', style: TextStyles.size16),
              const Gap(20),
              Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.primaryColor),
                  const Gap(5),
                  Text("work_hour".tr(), style: TextStyles.size20),
                  const Gap(30),
                  Text("${widget.model?.openHour} : ${widget.model?.closeHour} ", style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor)),
                ],
              ),
              const Gap(20),
              widget.model?.englishPlaceCategories == 'restaurant' || widget.model?.englishPlaceCategories == 'cafe'
                  ? Row(
                      children: [
                        Text("menu".tr(), style: TextStyles.size20),
                        const Spacer(),
                        IconButton(
                          style: IconButton.styleFrom(overlayColor: Colors.transparent, padding: const EdgeInsets.all(0)),
                          onPressed: () {
                            pushTo(context, Routes.menu, extra: widget.model);
                          },
                          icon: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? AppColors.wightColor : AppColors.darkColor),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const Gap(20),
              if (role == 'user')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("rate".tr(), style: TextStyles.size20),
                    RatingBar.builder(
                      unratedColor: isDark ? AppColors.wightColor : AppColors.inputColor,
                      initialRating: widget.model?.rating ?? 0.0,
                      allowHalfRating: true,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 25,
                      minRating: 0,
                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (value) async {
                        setState(() {
                          rate = value;
                        });

                        final query = await FirebaseFirestore.instance.collection('places').where("id", isEqualTo: widget.model?.id).limit(1).get();
                        if (query.docs.isNotEmpty) {
                          final docRef = query.docs.first.reference;
                          final currentData = query.docs.first.data();

                          List<double> currentRatings = [];
                          if (currentData["ratings"] != null) {
                            currentRatings = List<double>.from(currentData['ratings'].map((x) => x.toDouble()));
                          }
                          currentRatings.add(value);
                          final double averageRating = currentRatings.reduce((a, b) => a + b) / currentRatings.length;
                          await docRef.update({"ratings": currentRatings, "rating": averageRating.toStringAsFixed(2), "ratingCount": currentRatings.length});

                          final updatedDoc = await docRef.get();
                          final updateRate = PlaceModel.fromJson(updatedDoc.data()!);
                          setState(() {
                            widget.model!.rating = updateRate.rating;
                          });
                        }
                      },
                    ),
                  ],
                ),
              const Gap(20),
              MainButtonCustom(
                title: "contact_us".tr(),
                onPressed: () {
                  launchUrl(Uri.parse('tel:${widget.model?.phoneNumber}'));
                },
                textColor: AppColors.wightColor,
                backgroundColor: AppColors.primaryColor,
                icon: Icons.phone,
              ),
              const Gap(15),
              if (role == 'user')
                MainButtonCustom(
                  title: "add_place".tr(),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: false,
                      context: context,
                      builder: (context) => Container(
                        decoration: BoxDecoration(color: AppColors.primaryColor.withValues(alpha: 0.1)),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(widget.model?.arName ?? '', style: TextStyles.size24.copyWith(color: AppColors.primaryColor)),
                                const Gap(20),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(imageUrl: widget.model?.mainImage ?? '', width: double.infinity, height: 150, fit: BoxFit.fill),
                                ),
                                const Gap(20),
                                CustomeTextFormField(
                                  inputColor: AppColors.primaryColor,
                                  color: AppColors.primaryColor,
                                  fontSize: 20,
                                  controller: dateController,
                                  readOnly: true,
                                  suffixIcon: const Icon(Icons.date_range_outlined, color: AppColors.primaryColor),
                                  onTap: () async {
                                    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

                                    await showDatePicker(barrierColor: AppColors.darkColor, context: context, firstDate: today, lastDate: DateTime(2050), initialDate: today).then((date) {
                                      if (date != null) {
                                        log(date.toString());
                                        pickedDate = date;
                                        dateController.text = DateFormat('dd-MM-yyyy').format(date);
                                      } else {
                                        pickedDate = today;
                                        log(pickedDate.toString());
                                      }
                                    });
                                  },
                                  hintText: '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                ),
                                const Gap(20),
                                CustomeTextFormField(
                                  inputColor: AppColors.primaryColor,
                                  color: AppColors.primaryColor,
                                  fontSize: 20,
                                  controller: timeController,
                                  readOnly: true,
                                  suffixIcon: const Icon(Icons.access_time, color: AppColors.primaryColor),
                                  onTap: () async {
                                    final selectedTime = (await showTimePicker(
                                      builder: (context, child) {
                                        return MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!);
                                      },
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ));
                                    if (selectedTime != null) {
                                      pickedTime = selectedTime;
                                      log(pickedTime.toString());
                                      timeController.text = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
                                    }
                                  },
                                  hintText: "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
                                ),
                                const Gap(20),
                                MainButtonCustom(
                                  title: "confirm".tr(),
                                  textColor: AppColors.wightColor,
                                  backgroundColor: AppColors.primaryColor,
                                  onPressed: () async {
                                    await addKhoroga();
                                    LocalNotificationService.schduledNotification(pickDate: pickedDate, pickTime: pickedTime!, title: widget.model?.arName ?? '', body: "bodyText".tr());

                                    pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  textColor: AppColors.wightColor,
                  backgroundColor: AppColors.primaryColor,
                  icon: Icons.add_circle_outline,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addKhoroga() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = FirebaseFirestore.instance.collection("khoroga").doc(userId);
    final khorogamodel = KhorogaModel(id: widget.model?.id ?? "", arName: widget.model?.arName ?? '', enName: widget.model?.enName ?? "", image: widget.model?.mainImage ?? "", rating: widget.model?.rating, date: dateController.text, time: timeController.text);
    final data = khorogamodel.toJson();
    await doc.set({
      "list": FieldValue.arrayUnion([data]),
    }, SetOptions(merge: true));
  }

  Future<void> addTofavoriteList() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final docref = FirebaseFirestore.instance.collection("favoriteList").doc(userId);
    await docref.set({
      "userId": userId,
      "favoriteList": FieldValue.arrayUnion([(widget.model?.id).toString()]),
    }, SetOptions(merge: true));
  }

  Future<void> removeFromfavoriteList() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final docref = FirebaseFirestore.instance.collection("favoriteList").doc(userId);
    await docref.update({
      "favoriteList": FieldValue.arrayRemove([(widget.model?.id).toString()]),
    });
  }
}
