import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/ViewModel/auth_view_model.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../../res/components/colors.dart';

class SelectPreference extends StatefulWidget {
  const SelectPreference({super.key});

  @override
  State<SelectPreference> createState() => _SelectPreferenceState();
}

class _SelectPreferenceState extends State<SelectPreference> {
  TextEditingController experinceController = TextEditingController();
  TextEditingController jobController = TextEditingController();

  TextEditingController landController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  String _btn2SelectedVal = "Hondenuitlaatservice";
  static const items = <String>[
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
  // final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
  //     .map(
  //       (String value) => DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(
  //           value,
  //           style: const TextStyle(color: AppColor.blackColor),
  //         ),
  //       ),
  //     )
  //     .toList();
  final GlobalKey<DropdownSearchState<String>> dropDownKey =
      GlobalKey<DropdownSearchState<String>>();
  @override
  void dispose() {
    super.dispose();
    experinceController.dispose();
    jobController.dispose();
    landController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: AppColor.authCreamColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: AppColor.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Referentie',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: [
              const VerticalSpeacing(30.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldCustom(
                    controller: experinceController,
                    prefixIcon: const Icon(Icons.school_outlined),
                    maxLines: 1,
                    hintText: 'Vul uw ervaring in',
                  ),
                  const VerticalSpeacing(16.0),
                  Text(
                    'Referentie',
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                  const VerticalSpeacing(16.0),
                  Text(
                    'Naam',
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                  TextFieldCustom(
                    controller: jobController,
                    maxLines: 1,
                    hintText: 'Functie',
                  ),
                  Text(
                    'Thuiszorg',
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                  const VerticalSpeacing(10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.creamyColor,
                      border: Border.all(
                        color: const Color(0xff1B81BC).withOpacity(0.10),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff1B81BC).withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(1, 2),
                          spreadRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                          8), // Optional: Adds rounded corners
                    ),
                    child: DropdownSearch<String>(
                      key: dropDownKey,
                      items: (filter, infiniteScrollProps) => items,
                      selectedItem: "Selecteer een optie",
                      decoratorProps: DropDownDecoratorProps(
                        baseStyle: GoogleFonts.getFont(
                          "Poppins",
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.blackColor,
                          ),
                        ),
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            border: InputBorder.none),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        constraints: const BoxConstraints(maxHeight: 300),
                        fit: FlexFit
                            .loose, // Allows the popup to fit the height of items
                        menuProps: MenuProps(
                          backgroundColor: AppColor
                              .creamyColor, // Customize popup background color
                          elevation: 0, // Remove shadow effect
                          borderRadius: BorderRadius.circular(8),
                          margin: EdgeInsets
                              .zero, // Remove any internal padding if needed
                        ),
                        searchFieldProps: const TextFieldProps(
                          decoration: InputDecoration(
                            labelText: 'Search...',
                            fillColor: AppColor
                                .creamyColor, // Matches popup background
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            border: InputBorder
                                .none, // Removes border from search field
                          ),
                        ),
                      ),
                      onChanged: (String? value) {},
                    ),
                  ),
                  const VerticalSpeacing(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: TextFieldCustom(
                        keyboardType: TextInputType.phone,
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              '+31',
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.blackColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        controller: landController,
                        hintText: 'Telefoonnummer',
                      )),
                      const SizedBox(width: 10.0),
                      Expanded(
                          child: TextFieldCustom(
                        keyboardType: TextInputType.phone,
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              '+31',
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.blackColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        controller: phoneController,
                        hintText: 'Mobiel nummer',
                      )),
                    ],
                  ),
                  const VerticalSpeacing(60.0),
                  RoundedButton(
                      title: 'Opslaan',
                      onpress: () {
                        if (experinceController.text.isNotEmpty ||
                            jobController.text.isNotEmpty ||
                            landController.text.isNotEmpty ||
                            phoneController.text.isNotEmpty) {
                          authViewModel.savePrefernce(
                            context: context,
                            experince: experinceController.text,
                            job: jobController.text,
                            skill: _btn2SelectedVal,
                            land: landController.text,
                            phoneNumber: phoneController.text,
                          );
                        } else {
                          Utils.flushBarErrorMessage(
                              'Vul alle velden in', context);
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
