import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/family_all_jobs_view.dart';
import 'package:nanny_fairy/Family_View/findJobFamily/provider_detail.dart';
import 'package:nanny_fairy/Family_View/homeFamily/home_view_family.dart';
import 'package:nanny_fairy/Family_View/homeFamily/widgets/bookCart_home_widget.dart';
import 'package:nanny_fairy/Family_View/homeFamily/widgets/home_Family_feature_widget.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';

class FamilyDefaultView extends StatefulWidget {
  const FamilyDefaultView({super.key});

  @override
  State<FamilyDefaultView> createState() => _FamilyDefaultViewState();
}

class _FamilyDefaultViewState extends State<FamilyDefaultView> {
  List<Color> lightColorList = [
    Colors.cyan,
    Colors.blue,
    const Color(0xFF0008b8),
    const Color(0xffADD8E6),
    Colors.purple,
    Colors.yellow,
    Colors.lightBlue,
    const Color(0xffFF00FF),
    Colors.pink,
    const Color(0xffC0C0C0),
    Colors.orange,
    Colors.brown,
    const Color(0xff800000),
    Colors.green,
    const Color(0xff808000),
    const Color(0xff7FFFD4)
  ];
  List<String> imageList = [
    for (int i = 1; i <= 98; i++) "$i.png",
  ];
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
  Map<String, String> getRatingsAndTotalRatings(Map<dynamic, dynamic> value) {
    String ratings = value['countRatingStars'] != null
        ? value['countRatingStars'].toString()
        : 'N/A';
    String totalRatings =
        value['reviews'] != null ? value['reviews'].length.toString() : '0';

    return {
      'ratings': ratings,
      'totalRatings': totalRatings,
    };
  }

  double calculateAverageRating(Map<dynamic, dynamic> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating = 0.0;
    reviews.forEach((key, review) {
      totalRating += review['countRatingStars'] ?? 0.0;
    });
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Waar bent u naar op zoek',
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Consumer<FamilyDistanceViewModel>(
          builder: (context, familyDistanceViewModel, child) {
            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories
                    .length, // Ensure categories, colorList, and imageList have the same length
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      const SizedBox(width: 16),
                      HomeFeatureContainerFamily(
                        bgColor: lightColorList[index %
                            lightColorList
                                .length], // Rotate colors if list length is less
                        img:
                            'images/${imageList[index % imageList.length]}', // Rotate images if list length is less
                        title: categories[index],
                        txColor: AppColor.creamyColor,
                        ontap: () {
                          familyDistanceViewModel
                              .filterProvidersBySinglePassions(
                            categories[index],
                            familyDistance == null
                                ? 2
                                : double.parse(familyDistance!),
                            context,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: [
              Consumer2<FamilyHomeUiRepository, FamilyDistanceViewModel>(
                builder: (context, uiState, familyDistanceController, child) {
                  return Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Waar bent u naar op zoek',
                                style: GoogleFonts.getFont(
                                  "Poppins",
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.blackColor,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => FamilyAllJobsView(
                                        providers: familyDistanceController
                                            .distanceFilteredProviders,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Bekijk alles',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.lavenderColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const VerticalSpeacing(16.0),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.6,
                            child: familyDistanceController
                                    .distanceFilteredProviders.isEmpty
                                ? const Text(
                                    "No Providers avaliable with in Range")
                                : SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: familyDistanceController
                                          .distanceFilteredProviders
                                          .map((provider) {
                                        try {
                                          Map<String, String> ratingsData =
                                              getRatingsAndTotalRatings(
                                                  provider);
                                          Map<dynamic, dynamic> reviews =
                                              provider['reviews'] ?? {};
                                          double averageRating =
                                              calculateAverageRating(reviews);
                                          return BookingCartWidgetHome(
                                            primaryButtonTxt: 'Bekijk',
                                            ontapView: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (c) =>
                                                      ProviderDetails(
                                                    familyId: provider['uid'],
                                                    profile:
                                                        provider['profile'],
                                                    name:
                                                        "${provider['firstName']} ${provider['lastName']}",
                                                    bio: provider['bio'],
                                                    horseRate:
                                                        provider['hoursrate'],
                                                    experience:
                                                        provider['Refernce']
                                                            ['experince'],
                                                    degree:
                                                        provider['education'],
                                                    dayButtons:
                                                        _buildDayButtons(
                                                            provider),
                                                    timeData: (provider['Time']
                                                            as Map<dynamic,
                                                                dynamic>)
                                                        .map(
                                                      (key, value) => MapEntry(
                                                        key.toString(),
                                                        value.toString(),
                                                      ),
                                                    ),
                                                    ratings: averageRating,
                                                    totalRatings: int.parse(
                                                        ratingsData[
                                                            'totalRatings']!),
                                                  ),
                                                ),
                                              );
                                            },
                                            profile: provider['profile'],
                                            name:
                                                "${provider['firstName']} ${provider['lastName']}",
                                            degree: provider['education'],
                                            skill: '',
                                            hoursRate: provider['hoursrate'],
                                            dayButtons:
                                                _buildDayButtons(provider),
                                            ratings: averageRating,
                                            totalRatings: int.parse(
                                                ratingsData['totalRatings']!),
                                            primaryButtonColor:
                                                AppColor.primaryColor,
                                          );
                                        } catch (e) {
                                          // Handle potential errors with data mapping
                                          debugPrint(
                                              'Error processing provider data: $e');
                                          return const SizedBox(); // Return an empty widget on error
                                        }
                                      }).toList(),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDayButtons(Map<dynamic, dynamic> provider) {
    Map<String, dynamic> availabilityMap =
        Map<String, dynamic>.from(provider['Availability'] ?? {});
    Set<String> daysSet = {};

    availabilityMap.forEach((timeOfDay, daysMap) {
      if (daysMap is Map) {
        daysMap.forEach((day, isAvailable) {
          if (isAvailable && !daysSet.contains(day)) {
            daysSet.add(day.substring(0, 1).toUpperCase());
          }
        });
      }
    });

    return daysSet.map((dayAbbreviation) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: DayButtonFamily(day: dayAbbreviation),
      );
    }).toList();
  }
}
