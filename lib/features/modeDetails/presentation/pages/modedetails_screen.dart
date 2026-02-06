import 'package:app_5roga/components/inputs/custome_text_form_field%20copy.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/categoryDetails/presentation/widgets/grid_places.dart';
import 'package:app_5roga/features/userHome/data/models/mode.dart';
import 'package:app_5roga/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gap/gap.dart';

class ModeDetailsScreen extends StatefulWidget {
  const ModeDetailsScreen({super.key, required this.model});
  final ModeModel model;
  @override
  State<ModeDetailsScreen> createState() => _ModeDetailsScreenState();
}

class _ModeDetailsScreenState extends State<ModeDetailsScreen> {
  final TextEditingController searchController = TextEditingController();
  bool get isDark => themeNotifier.value == ThemeMode.dark;
  String? fullAddress;
  final MapController mapcontroller = MapController(initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324), areaLimit: const BoundingBox(east: 10.4922941, north: 47.8084648, south: 45.817995, west: 5.9559113));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.model.title.tr(), style: TextStyles.size24.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor)),
        leading: IconButton(
          onPressed: () {
            pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: _buildOtherContent(),
    );
  }

  Padding _buildOtherContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (widget.model.title != "location".tr()) ...[
            CustomeTextFormField(
              inputColor: AppColors.inputColor,
              color: AppColors.inputColor,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (String value) {
                if (searchController.text.isNotEmpty) {
                  pushTo(context, Routes.search, extra: searchController.text);
                }
              },
              controller: searchController,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(30),
              ),
              hintText: widget.model.title.tr() == "location".tr() ? 'ابحث عن مكان' : '${"searchFor".tr()} ${widget.model.title.tr()}',
              suffixIcon: IconButton(
                onPressed: () {
                  if (searchController.text.isNotEmpty) pushTo(context, Routes.search, extra: searchController.text);
                },
                icon: const Icon(Icons.search, color: AppColors.primaryColor),
              ),
            ),

            const Gap(20),
          ],
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (widget.model.type) {
      case ModeType.friends:
        return const GridPlaces(modeCategory: "friends");

      case ModeType.romantic:
        return const GridPlaces(modeCategory: "romantic");

      case ModeType.sea:
        return const GridPlaces(modeCategory: "calm");
    }
  }
}
