import 'dart:io';

import 'package:app_5roga/components/buttons/main_button_custom.dart';
import 'package:app_5roga/components/inputs/custome_text_form_field%20copy.dart';
import 'package:app_5roga/core/functions/classification.dart';
import 'package:app_5roga/core/functions/dialog.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/addPlace/presentation/cubit/addPlace_state.dart';
import 'package:app_5roga/features/addPlace/presentation/cubit/addplace_cubit.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:app_5roga/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key, this.model});
  final PlaceModel? model;

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  // @override
  // void initState() {
  //   super.initState();

  //   final cubit = context.read<AddplaceCubit>();

  //   if (widget.model != null) {
  //     cubit.arabicNameController.text = widget.model!.arName ?? '';
  //     cubit.englishNameController.text = widget.model!.enName ?? "";
  //     cubit.arabicDescribtionController.text = widget.model!.arDescription ?? '';
  //     cubit.englishDescribtionController.text = widget.model!.enDescription ?? '';

  //     cubit.phoneController.text = widget.model!.phoneNumber ?? "";
  //     cubit.addressController.text = widget.model!.address ?? "";
  //     cubit.locationController.text = widget.model!.location ?? "";

  //     cubit.openingHourController.text = widget.model!.openHour ?? "";
  //     cubit.closingHourController.text = widget.model!.closeHour ?? "";

  //     cubit.englishPlaceCategory = widget.model!.englishPlaceCategories;
  //     arabicPlaceCategory = widget.model!.arabicPlaceCategories;

  //     cubit.englishSubCategory = widget.model!.englishSubCategories;
  //     cubit.arabicSubCategory = widget.model!.arabicSubCategories;

  //     cubit.englishMode = widget.model!.enMode;
  //     cubit.arabicMode = widget.model!.arMode;

  //     cubit.isChosenForYou = widget.model!.isChosen ?? false;

  //     mainImage = File(widget.model!.mainImage ?? '');
  //     menuImages = widget.model!.menuImage!.map((path) => File(path)).toList();
  //   }
  // }

  File? mainImage;
  List<File> menuImages = [];

  String? arabicPlaceCategory;
  bool get isDark => themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddplaceCubit>();
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              // widget.model != null ?
              'اضافة مكان',
              //: 'تعديل مكان'
              style: TextStyles.size24.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor),
            ),
            leading: IconButton(
              onPressed: () {
                pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              child: Form(
                key: cubit.formKey,
                child: BlocListener<AddplaceCubit, AddPlaceState>(
                  listener: (BuildContext context, state) {
                    if (state is AddPlaceLoading) {
                      showLoadingDialog(context);
                    } else if (state is AddPlaceSuccess) {
                      pop(context);
                      showErrorDialog(context, 'تم اضافة المكان بنجاح');
                      pushTo(context, Routes.adminMain);
                    } else if (state is AddPlaceError) {
                      pop(context);
                      showErrorDialog(context, state.error);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.primaryColor),
                          const Gap(10),
                          Text('معلومات  رئيسية', style: TextStyles.size20.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                        ],
                      ),
                      const Gap(20),
                      Text('اسم المكان(عربي)', style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                      const Gap(10),
                      arabicName(cubit),
                      const Gap(10),
                      Text('اسم المكان(انجليزي)', style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                      const Gap(10),
                      englishName(cubit),
                      const Gap(10),
                      Text('وصف المكان(عربي)', style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                      const Gap(10),
                      arabicDescribtion(cubit),
                      const Gap(10),
                      Text('وصف المكان(انجليزي)', style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                      const Gap(10),
                      englishDescribtion(cubit),
                      const Gap(30),
                      const Divider(),
                      const Gap(10),
                      Row(
                        children: [
                          const Icon(Icons.category_outlined, color: AppColors.primaryColor),
                          const Gap(10),
                          Text('تصنيف', style: TextStyles.size20.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                        ],
                      ),
                      const Gap(20),
                      claaification(cubit),
                      const Gap(20),
                      subClassification(cubit),
                      const Gap(20),
                      modeClassification(cubit),
                      const Gap(20),
                      isChosenForYou(cubit),
                      const Gap(30),
                      const Divider(),
                      const Gap(10),
                      Row(
                        children: [
                          const Icon(Icons.schedule, color: AppColors.primaryColor),
                          const Gap(10),
                          Text('تفاصيل', style: TextStyles.size20.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                        ],
                      ),
                      const Gap(20),
                      Text('ساعات العمل', style: TextStyles.size20.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                      const Gap(10),
                      workingHour(cubit, context),
                      const Gap(20),
                      Text("رقم التليفون", style: TextStyles.size20.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                      const Gap(10),
                      phoneNumber(cubit),
                      const Gap(30),
                      const Divider(),
                      const Gap(10),
                      Row(
                        children: [
                          const Icon(Icons.add_location_alt_outlined, color: AppColors.primaryColor),
                          const Gap(10),
                          Text("الوسائط والموقع", style: TextStyles.size20.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                        ],
                      ),
                      const Gap(20),
                      Text("صورة المكان", style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                      const Gap(10),
                      uploadMainImage(),
                      const Gap(20),
                      Text("صور المنيو", style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                      const Gap(10),
                      uploadMenuImage(),
                      const Gap(20),
                      Text("العنوان", style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                      const Gap(10),
                      CustomeTextFormField(
                        controller: cubit.addressController,
                        maxLines: 1,
                        hintText: 'ادخل عنوان المكان',
                        color: AppColors.inputColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }
                          return null;
                        },
                      ),
                      const Gap(20),
                      Text("الموقع", style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
                      const Gap(10),
                      location(cubit),
                      const Gap(30),
                      savePlace(cubit),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  MainButtonCustom savePlace(AddplaceCubit cubit) {
    return MainButtonCustom(
      title: "حفظ المكان",
      onPressed: () {
        if (cubit.formKey.currentState!.validate()) {
          cubit.addplace(mainImage, menuImages.map((e) => e.path).toList());
        }
      },
      textColor: AppColors.wightColor,
      backgroundColor: AppColors.primaryColor,
    );
  }

  GestureDetector uploadMainImage() {
    return GestureDetector(
      onTap: pickMainImage,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.inputColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.inputColor.withValues(alpha: 0.1), style: BorderStyle.solid),
        ),
        child: mainImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate, size: 50, color: AppColors.inputColor),
                  const Gap(10),
                  TextButton(
                    onPressed: pickMainImage,
                    child: Text('اضف صورة المكان', style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor)),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(mainImage!, fit: BoxFit.cover),
              ),
      ),
    );
  }

  Wrap uploadMenuImage() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (int i = 0; i < menuImages.length; i++)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(15),
                child: Image.file(menuImages[i], width: 120, height: 120, fit: BoxFit.cover),
              ),
              Positioned(
                right: 5,
                child: Container(
                  width: 30,
                  decoration: BoxDecoration(color: AppColors.darkColor.withValues(alpha: 0.3), shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        menuImages.removeAt(i);
                      });
                    },
                    icon: const Icon(Icons.close, color: AppColors.wightColor, size: 15),
                  ),
                ),
              ),
            ],
          ),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.inputColor.withValues(alpha: 0.1),
            border: Border.all(color: AppColors.inputColor.withValues(alpha: 0.1), style: BorderStyle.solid),
          ),
          child: IconButton(
            onPressed: pickedMenueImage,
            icon: const Icon(Icons.add_photo_alternate, size: 50, color: AppColors.inputColor),
          ),
        ),
      ],
    );
  }

  CustomeTextFormField location(AddplaceCubit cubit) {
    return CustomeTextFormField(
      controller: cubit.locationController,
      maxLines: 1,
      hintText: "ادخل موقع المكان على الخريطة",
      color: AppColors.inputColor,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  CustomeTextFormField phoneNumber(AddplaceCubit cubit) {
    return CustomeTextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
      controller: cubit.phoneController,
      maxLines: 1,
      hintText: 'ادخل رقم التليفون',
      color: AppColors.inputColor,
      keyboardType: TextInputType.phone,
    );
  }

  Row workingHour(AddplaceCubit cubit, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("موعد الفتح", style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
              const Gap(10),
              CustomeTextFormField(
                height: 60,
                color: AppColors.primaryColor,
                fontSize: 20,
                controller: cubit.openingHourController,
                readOnly: true,
                suffixIcon: const Icon(Icons.access_time, color: AppColors.primaryColor),
                onTap: () async {
                  final selectedTime = await showTimePicker(
                    builder: (context, child) {
                      return MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!);
                    },
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    cubit.openingHourController.text = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
                  }
                },
                hintText: "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
              ),
            ],
          ),
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("موعد الاغلاق", style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
              const Gap(10),
              CustomeTextFormField(
                height: 60,
                color: AppColors.primaryColor,
                fontSize: 20,
                controller: cubit.closingHourController,
                readOnly: true,
                suffixIcon: const Icon(Icons.access_time, color: AppColors.primaryColor),
                onTap: () async {
                  final selectedTime = await showTimePicker(
                    builder: (context, child) {
                      return MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!);
                    },
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    cubit.closingHourController.text = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
                  }
                },
                hintText: "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container isChosenForYou(AddplaceCubit cubit) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.wightColor, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("اخترنالك", style: TextStyles.size18.copyWith(color: AppColors.darkColor)),
            Switch.adaptive(
              value: cubit.isChosenForYou,
              onChanged: (value) {
                setState(() {
                  cubit.isChosenForYou = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Row modeClassification(AddplaceCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('المزاج(عربي)', style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
              const Gap(10),
              Container(
                height: 50,
                decoration: BoxDecoration(color: AppColors.wightColor, borderRadius: BorderRadius.circular(15)),
                child: DropdownButton2(
                  dropdownStyleData: DropdownStyleData(
                    isOverButton: false,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isDark ? AppColors.darkColor : AppColors.wightColor),
                  ),
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: Text('اختر المزاج', style: TextStyles.size14.copyWith(color: AppColors.inputColor)),
                  value: cubit.arabicMode,
                  items: [for (var category in arabicModes) DropdownMenuItem(value: category, child: Text(category))],
                  onChanged: (String? newValue) {
                    setState(() {
                      cubit.arabicMode = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const Gap(5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('المزاج(انجليزي)', style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
              const Gap(10),
              Container(
                height: 50,
                decoration: BoxDecoration(color: AppColors.wightColor, borderRadius: BorderRadius.circular(15)),
                child: DropdownButton2(
                  dropdownStyleData: DropdownStyleData(
                    isOverButton: false,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isDark ? AppColors.darkColor : AppColors.wightColor),
                  ),
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: Text('اختر المزاج', style: TextStyles.size14.copyWith(color: AppColors.inputColor)),
                  value: cubit.englishMode,
                  items: [for (var category in englishModes) DropdownMenuItem(value: category, child: Text(category))],
                  onChanged: (String? newValue) {
                    setState(() {
                      cubit.englishMode = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row subClassification(AddplaceCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('تصنيفات فرعية(عربي)', style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
              const Gap(10),
              Container(
                height: 50,
                decoration: BoxDecoration(color: AppColors.wightColor, borderRadius: BorderRadius.circular(15)),
                child: DropdownButton2(
                  dropdownStyleData: DropdownStyleData(
                    isOverButton: false,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isDark ? AppColors.darkColor : AppColors.wightColor),
                  ),
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: Text('اختر تصنيف المكان', style: TextStyles.size14.copyWith(color: AppColors.inputColor)),
                  value: cubit.arabicSubCategory,
                  items: [for (var category in arabicSubCategories) DropdownMenuItem(value: category, child: Text(category))],
                  onChanged: (String? newValue) {
                    setState(() {
                      cubit.arabicSubCategory = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const Gap(5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('تصنيفات فرعية(انجليزي)', style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
              const Gap(10),
              Container(
                height: 50,
                decoration: BoxDecoration(color: AppColors.wightColor, borderRadius: BorderRadius.circular(15)),
                child: DropdownButton2(
                  dropdownStyleData: DropdownStyleData(
                    isOverButton: false,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isDark ? AppColors.darkColor : AppColors.wightColor),
                  ),
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: Text('اختر تصنيف المكان', style: TextStyles.size14.copyWith(color: AppColors.inputColor)),
                  value: cubit.englishSubCategory,
                  items: [for (var category in englishSubCategories) DropdownMenuItem(value: category, child: Text(category))],
                  onChanged: (String? newValue) {
                    setState(() {
                      cubit.englishSubCategory = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row claaification(AddplaceCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('تصنيف المكان(عربي)', style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
              const Gap(10),
              Container(
                height: 50,
                decoration: BoxDecoration(color: AppColors.wightColor, borderRadius: BorderRadius.circular(15)),
                child: DropdownButton2(
                  dropdownStyleData: DropdownStyleData(
                    isOverButton: false,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isDark ? AppColors.darkColor : AppColors.wightColor),
                  ),
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: Text('اختر تصنيف المكان', style: TextStyles.size14.copyWith(color: AppColors.inputColor)),
                  value: cubit.arabicPlaceCategory,
                  items: [for (var category in arabicPlaceCategories) DropdownMenuItem(value: category, child: Text(category))],
                  onChanged: (String? newValue) {
                    setState(() {
                      cubit.arabicPlaceCategory = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const Gap(5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('تصنيف المكان(انجليزي)', style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor)),
              const Gap(10),
              Container(
                height: 50,
                decoration: BoxDecoration(color: AppColors.wightColor, borderRadius: BorderRadius.circular(15)),
                child: DropdownButton2(
                  dropdownStyleData: DropdownStyleData(
                    isOverButton: false,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isDark ? AppColors.darkColor : AppColors.wightColor),
                  ),
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: Text('اختر تصنيف المكان', style: TextStyles.size14.copyWith(color: AppColors.inputColor)),
                  value: cubit.englishPlaceCategory,
                  items: [for (var category in englishPlaceCategories) DropdownMenuItem(value: category, child: Text(category))],
                  onChanged: (String? newValue) {
                    setState(() {
                      cubit.englishPlaceCategory = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  CustomeTextFormField englishDescribtion(AddplaceCubit cubit) {
    return CustomeTextFormField(
      inputColor: AppColors.inputColor,
      maxLines: 5,
      hintText: 'ادخل وصف المكان بالانجليزي',
      color: AppColors.inputColor,
      controller: cubit.englishDescribtionController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  CustomeTextFormField arabicDescribtion(AddplaceCubit cubit) {
    return CustomeTextFormField(
      inputColor: AppColors.inputColor,
      maxLines: 5,
      hintText: 'ادخل وصف المكان بالعربي',
      color: AppColors.inputColor,
      controller: cubit.arabicDescribtionController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  CustomeTextFormField englishName(AddplaceCubit cubit) {
    return CustomeTextFormField(
      inputColor: AppColors.inputColor,
      maxLines: 1,
      hintText: 'ادخل اسم المكان بالانجليزي',
      color: AppColors.inputColor,
      controller: cubit.englishNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  CustomeTextFormField arabicName(AddplaceCubit cubit) {
    return CustomeTextFormField(
      inputColor: AppColors.inputColor,
      maxLines: 1,
      hintText: 'ادخل اسم المكان بالعربي',
      color: AppColors.inputColor,
      controller: cubit.arabicNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  Future<void> pickMainImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        mainImage = File(picked.path);
      });
    }
  }

  Future<void> pickedMenueImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        menuImages.add(File(picked.path));
      });
    }
  }

  @override
  void dispose() {
    final cubit = context.read<AddplaceCubit>();
    cubit.arabicNameController.dispose();
    cubit.englishNameController.dispose();
    cubit.arabicDescribtionController.dispose();
    cubit.englishDescribtionController.dispose();
    cubit.openingHourController.dispose();
    cubit.closingHourController.dispose();
    cubit.phoneController.dispose();
    cubit.addressController.dispose();
    cubit.locationController.dispose();
    super.dispose();
  }
}
