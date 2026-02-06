import 'package:app_5roga/components/inputs/custome_text_form_field%20copy.dart';
import 'package:app_5roga/core/location/location_handler.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/categoryDetails/presentation/widgets/games_tab_bar.dart';
import 'package:app_5roga/features/categoryDetails/presentation/widgets/grid_places.dart';
import 'package:app_5roga/features/categoryDetails/presentation/widgets/location_map.dart';
import 'package:app_5roga/features/categoryDetails/presentation/widgets/resturant_tab_bar.dart';
import 'package:app_5roga/features/userHome/data/models/catogery.dart';
import 'package:app_5roga/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gap/gap.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({super.key, required this.model});
  final CategoryModel model;

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  String? fullAddress;
  final TextEditingController searchController = TextEditingController();
  final MapController mapcontroller = MapController(initPosition: GeoPoint(latitude: 30.0818165, longitude: 31.3630254));
  bool get isDark => themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          extendBodyBehindAppBar: widget.model.type == CategryType.map,
          appBar: AppBar(
            elevation: 0,
            title: widget.model.title.tr() == "location".tr() ? const SizedBox.shrink() : Text(widget.model.title.tr(), style: TextStyles.size24.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor)),
            leading: IconButton(
              onPressed: () {
                pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            backgroundColor: widget.model.type == CategryType.map ? Colors.transparent : Colors.transparent,
          ),
          body: widget.model.type == CategryType.map ? LocationMap(controller: mapcontroller) : _buildOtherContent(),
          floatingActionButton: widget.model.type == CategryType.map
              ? FloatingActionButton(
                  heroTag: null,
                  backgroundColor: AppColors.primaryColor,
                  onPressed: () async {
                    final value = await determinePosition();
                    setState(() {
                      fullAddress = value;
                    });
                  },
                  child: const Icon(Icons.location_on, color: AppColors.wightColor),
                )
              : null,
        );
      },
    );
  }

  Padding _buildOtherContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (widget.model.title.tr() != "location".tr()) ...[
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
      case CategryType.map:
        return LocationMap(controller: mapcontroller);

      case CategryType.cinema:
        return const GridPlaces(category: "cinema");

      case CategryType.cafes:
        return const GridPlaces(category: "cafe");

      case CategryType.resturants:
        return const ResturantTabBar();

      case CategryType.games:
        return const GamesTabBar();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
