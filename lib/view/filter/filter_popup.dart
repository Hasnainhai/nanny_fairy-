// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'package:nanny_fairy/ViewModel/provider_distance_view_model.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/utils/utils.dart';

import '../../res/components/colors.dart';
import '../../res/components/widgets/vertical_spacing.dart';

class FilterPopUp extends StatefulWidget {
  final String maxDistance;
  const FilterPopUp({
    super.key,
    required this.maxDistance,
  });

  @override
  State<FilterPopUp> createState() => _FilterPopUpState();
}

class _FilterPopUpState extends State<FilterPopUp> {
  List<String> selectedPassions = [];
  final List<String> categories = [
    "Hondenuitlaatservice",
    "Dierenoppas",
    "Plantenverzorging",
    "Tuinman",
    "Huisoppas",
    "Kinderoppas",
    "Huiswerkbegeleiding",
    "Wiskundebijles",
    "Nederlandsbijles",
    "Engelsbijles",
    "Scheikundebijles",
    "Biologiebijles",
    "Aardrijkskundebijles",
    "Geschiedenisbijles",
    "Fysicabijles",
    "Muziekbijles",
    "Tekenbijles",
    "LichamelijkeOpvoedingbijles",
    "Fransbijles",
    "Duitsbijles",
    "Spaansbijles",
    "Economiebijles",
    "Informatica bijles",
    "Programmeerbijles",
    "Literatuurbijles",
    "Kunstbijles",
    "Philosophiebijles",
    "Zangles",
    "Gitaarles",
    "Pianoles",
    "Vioolles",
    "Celloles",
    "Trompetles",
    "Saxofoneles",
    "Fluitles",
    "Drumles",
    "Basgitaarles",
    "Accordeonles",
    "Keyboardles",
    "Zanglessen",
    "Harmonica les",
    "Ukeleleles",
    "Tromboneles",
    "Fagottles",
    "Mandolijnles",
    "Saxofoonles",
    "Tubales",
    "Klarinetles",
    "Tromboneles",
    "Schoonmaker",
    "Kok",
    "Fietsonderhoud",
    "Yoga",
    "Gymles",
    "Fotografiedienst",
    "Boodschappenservice",
    "Feestplanning",
    "Tuinaanleg",
    "Verhuisservice",
    "Technischehulp",
    "Personaltraining",
    "Creatieveworkshops",
    "Vervoersdienst",
    "Digitalevaardigheden",
    "Ouderenverzorger",
    "Huisarts",
    "Tandarts",
    "Fysiotherapie",
    "Psycholoog",
    "70Diëtist",
    "Verpleegkundige",
    "Boekhouder",
    "Belastingadviseur",
    "Juridisch",
    "Notaris",
    "IT-support",
    "Webontwikkeling",
    "Socialmedia",
    "App-ontwikkeling",
    "Kapper",
    "Masseuse",
    "Schoenmaker",
    "Taxi",
    "Evenementdecoratie",
    "Bruiloftsplanning",
    "Ouderenzorg",
    "Apparatuurinstallatie",
    "Woningstyling",
    "Ouderenzorg",
    "Dierentraining",
    "Loopbaancoaching",
    "FinanciëlePlanning",
    "Privékok",
    "Stylist",
    "Geschenken",
    "Dakgootschoonmaak",
    "Meubelmontage",
    "Timmerwerk",
  ];

  // void _updateQuery() {
  //   setState(() {
  //     selectedPassions = categories.entries
  //         .where((entry) => entry.value)
  //         .map((entry) => entry.key)
  //         .toList();
  //   });
  // }

  double totalRating = 2;
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: AppColor.secondaryBgColor,
      child: ListView(
        children: [
          Container(
            height: 116,
            width: double.infinity,
            color: AppColor.lavenderColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColor.creamyColor,
                      ),
                    ),
                    const Text(
                      "Filters",
                      style: TextStyle(
                        fontFamily: 'CenturyGothic',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColor.creamyColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // setState(() {
                        //   filters.updateAll((key, value) => false);
                        //   _updateQuery();
                        // });
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                          fontFamily: 'CenturyGothic',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: AppColor.creamyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpeacing(16),
                const Text(
                  "Provider Categories",
                  style: TextStyle(
                    fontFamily: 'CenturyGothic',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColor.blackColor,
                  ),
                ),
                const VerticalSpeacing(20),
                SizedBox(
                  height: 250,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        return SizedBox(
                          width: 150,
                          height: 40,
                          child: FilterButton(
                            label: category,
                            isSelected: selectedPassions.contains(category),
                            onTap: () {
                              print('Category: $category');
                              setState(() {
                                if (selectedPassions.contains(category)) {
                                  selectedPassions.remove(category);
                                } else {
                                  selectedPassions.add(category);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const VerticalSpeacing(14),
                RatingBar.builder(
                  initialRating: 2,
                  minRating: 1,
                  allowHalfRating: true,
                  glowColor: AppColor.peachColor,
                  itemCount: 5,
                  itemSize: 30,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_rate_rounded,
                    color: AppColor.peachColor,
                  ),
                  onRatingUpdate: (rating) {
                    totalRating = rating;
                  },
                ),
                const VerticalSpeacing(50),
                Consumer<ProviderDistanceViewModel>(
                  builder: (context, filteredViewModel, child) {
                    return RoundedButton(
                      buttonColor: AppColor.lavenderColor,
                      titleColor: AppColor.creamyColor,
                      title: 'Apply Filters',
                      onpress: () {
                        if (selectedPassions.isNotEmpty) {
                          try {
                            if (widget.maxDistance == "Alle") {}
                            debugPrint(
                                "this is the widget maxdis:${widget.maxDistance}");

                            double maxdis = widget.maxDistance == "Alle"
                                ? double.parse("100")
                                : double.parse(widget.maxDistance);
                            debugPrint("this is the maxdis:$maxdis");
                            filteredViewModel.filteredFamiliesByMultipleQueries(
                                maxdis, context, selectedPassions, totalRating);
                          } catch (e) {
                            print(e.toString());
                          }

                          // Navigator.pop(context);

                          // uiState.switchToType(UIType
                          //     .FilterSection); // Switch to FilterSection after applying filters
                        } else {
                          Utils.flushBarErrorMessage(
                              "Please select the filters", context);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? AppColor.lavenderColor : Colors.transparent,
          border: Border.all(color: AppColor.borderColor, width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'CenturyGothic',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isSelected ? AppColor.creamyColor : AppColor.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
