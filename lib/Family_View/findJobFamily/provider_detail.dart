// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/familyChat/family_chat_view.dart';
import 'package:nanny_fairy/Family_View/payment_family/payment_family.dart';
import 'package:nanny_fairy/Repository/get_family_info_repo.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import '../../FamilyController/family_home_controller.dart';
import '../../res/components/colors.dart';

class ProviderDetails extends StatefulWidget {
  const ProviderDetails({
    super.key,
    required this.profile,
    required this.name,
    required this.bio,
    required this.horseRate,
    required this.experience,
    required this.degree,
    required this.dayButtons,
    required this.timeData,
    required this.familyId,
    this.ratings,
    this.totalRatings,
  });
  final String profile;
  final String name;
  final String bio;
  final String horseRate;
  final String experience;
  final String degree;
  final List<Widget> dayButtons;
  final Map<String, String> timeData;
  final String familyId;
  final double? ratings;
  final int? totalRatings;

  @override
  State<ProviderDetails> createState() => _ProviderDetailsState();
}

class _ProviderDetailsState extends State<ProviderDetails> {
  GetFamilyInfoRepo getFamilyInfoRepo = GetFamilyInfoRepo();
  @override
  void initState() {
    getFamilyInfoRepo.fetchCurrentFamilyInfo();
    fetchReviews();
    super.initState();
  }

  List<Widget> reviewCards = [];

  void fetchReviews() async {
    DatabaseReference reviewsRef = FirebaseDatabase.instance
        .ref()
        .child('Providers')
        .child(widget.familyId)
        .child('reviews');

    reviewsRef.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> reviews =
            dataSnapshot.value as Map<dynamic, dynamic>;
        List<Widget> loadedReviewCards = [];

        reviews.forEach((key, value) {
          String familyName = value['familyName'] ?? 'Unknown';
          String familyComment = value['FamilyComment'] ?? 'No comment';
          String familyProfile = value['familyProfile'] ??
              'https://newprofilepic.photo-cdn.net//assets/images/article/profile.jpg?90af0c8';
          double countRatingStars =
              double.parse(value['countRatingStars']?.toString() ?? '0.0');

          loadedReviewCards.add(buildReviewCard(
              familyName, familyComment, familyProfile, countRatingStars));
        });

        setState(() {
          reviewCards = loadedReviewCards;
        });
      } else {
        setState(() {
          reviewCards = [
            Center(
              child: Text(
                'Geen beoordelingen beschikbaar',
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ];
        });
      }
    });
  }

  // popUp
  void showSubscribtionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.creamyColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.zero,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // Set width to 80% of screen width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width:
                      double.infinity, // Fill the width of the parent container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                    color: AppColor.lavenderColor,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/popImg.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                const VerticalSpeacing(16),
                Text(
                  'Accepteer abonnement\nvan €2 per maand',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor,
                    ),
                  ),
                ),
                const VerticalSpeacing(30),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: RoundedButton(
                    buttonColor: AppColor.lavenderColor,
                    title: 'Abonneer en chat',
                    onpress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentFamilyView(
                                    userName: widget.name,
                                    currentUserName:
                                        getFamilyInfoRepo.familyName.toString(),
                                    familyId: widget.familyId,
                                    currentUserProfile: getFamilyInfoRepo
                                        .familyProfile
                                        .toString(),
                                    profile: widget.profile,
                                    providerRatings: widget.ratings.toString(),
                                    providerTotalRatings:
                                        widget.totalRatings.toString(),
                                    education: widget.degree,
                                    horlyRate: widget.horseRate,
                                  )));
                      // print(
                      //     'profile:${widget.profile}: userName:${widget.name}:familyId: ${widget.familyId}: currentUserName:${getFamilyInfoRepo.familyName!}:Family profile${getFamilyInfoRepo.familyProfile} ');
                    },
                  ),
                ),
                const VerticalSpeacing(16),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isExpanded = false;

  void _toggleViewMore() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  String selectedDay = 'Monday';
  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  @override
  Widget build(BuildContext context) {
    final familyhomeController = Provider.of<FamilyHomeController>(context);
    return Scaffold(
      backgroundColor: AppColor.lavenderColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: AppColor.creamyColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Gegevens',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColor.creamyColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: AppColor.creamyColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          widget.name,
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star,
                                color: AppColor.peachColor, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.ratings} (${widget.totalRatings} Recens)',
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.blackColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.bio,
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.grayColor,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Officia irure ir',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.blackColor),
                                  ),
                                ),
                                Text(
                                  'Officia irure irOfficia',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.blackColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gesproken taal',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.blackColor),
                                  ),
                                ),
                                Text(
                                  'English, urdu',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.blackColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Officia irure ir',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.blackColor),
                                  ),
                                ),
                                Text(
                                  'Officia irure irOfficia',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.blackColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vaardigheid en ervaring',
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.blackColor),
                              ),
                            ),
                            const VerticalSpeacing(10),
                            Row(
                              children: [
                                SkillContainerWidget(
                                    title: '${widget.horseRate}€',
                                    subTitle: 'Uren'),
                                const SizedBox(width: 16),
                                SkillContainerWidget(
                                    title: widget.experience,
                                    subTitle: 'Ervaring'),
                                const SizedBox(width: 16),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.peachColor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.school_outlined,
                                            color: AppColor.creamyColor),
                                        Text(
                                          widget.degree,
                                          style: GoogleFonts.getFont(
                                            "Poppins",
                                            textStyle: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.creamyColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //Availability portion
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    height: 16), // Added spacing from the top
                                Text(
                                  'Beschikbaarheid',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.blackColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                Row(
                                  children: widget
                                      .dayButtons, // Use the day buttons here
                                ),
                              ],
                            ),
                            const VerticalSpeacing(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: _toggleViewMore,
                                      child: Text(
                                        'Bekijk meer',
                                        style: GoogleFonts.getFont(
                                          "Poppins",
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            if (_isExpanded)
                              // time container
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColor.creamyColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: const Color(0xff1B81BC)
                                        .withOpacity(0.10),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff1B81BC)
                                          .withOpacity(0.1),
                                      blurRadius: 2,
                                      offset: const Offset(1, 2),
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FutureBuilder(
                                    future:
                                        familyhomeController.getPopularJobs(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (snapshot.data!.isEmpty) {
                                        return const Center(
                                            child:
                                                Text('Availability Empty...'));
                                      } else if (snapshot.hasData) {
                                        Map<dynamic, dynamic> bookings =
                                            snapshot.data
                                                as Map<dynamic, dynamic>;
                                        String familyId = widget.familyId;

                                        Map<String, String> timeData = {};

                                        bookings.forEach((key, value) {
                                          if (value['uid'] == familyId) {
                                            if (value['Time'] is Map) {
                                              final dayData = value['Time']
                                                      [selectedDay]
                                                  as Map<dynamic, dynamic>?;
                                              if (dayData != null) {
                                                timeData = dayData.map((k, v) =>
                                                    MapEntry(k.toString(),
                                                        v.toString()));
                                              }
                                            }
                                          }
                                        });

                                        return Column(
                                          children: [
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Tijdstip',
                                                  style: GoogleFonts.getFont(
                                                    "Poppins",
                                                    textStyle: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColor.blackColor,
                                                    ),
                                                  ),
                                                ),
                                                DropdownButton<String>(
                                                  icon: const Icon(
                                                    Icons.expand_more,
                                                    color: AppColor.oceanColor,
                                                  ),
                                                  underline:
                                                      const SizedBox.shrink(),
                                                  dropdownColor:
                                                      AppColor.creamyColor,
                                                  value: selectedDay,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedDay = newValue!;
                                                    });
                                                  },
                                                  items: days.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String day) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: day,
                                                      child: Text(
                                                        day,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Poppins',
                                                            color: AppColor
                                                                .oceanColor),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                            const VerticalSpeacing(16),
                                            // Morning Time Slot
                                            _buildTimeSlotRow(
                                                'Ochtend',
                                                timeData['MorningStart'],
                                                timeData['MorningEnd']),
                                            const Divider(),
                                            // Afternoon Time Slot
                                            _buildTimeSlotRow(
                                                'Middag',
                                                timeData['AfternoonStart'],
                                                timeData['AfternoonEnd']),
                                            const Divider(),
                                            // Evening Time Slot
                                            _buildTimeSlotRow(
                                                'Avond',
                                                timeData['EveningStart'],
                                                timeData['EveningEnd']),
                                          ],
                                        );
                                      }
                                      return const Center(
                                          child: Text('Format exception'));
                                    },
                                  ),
                                ),
                              ),
                            const Divider(
                              color: AppColor.lavenderColor,
                            ),
                            const VerticalSpeacing(16),
                            //Family rating Portion
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Familiebeoordelingen',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const VerticalSpeacing(16.0),
                            SizedBox(
                              height: 90,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const ScrollPhysics(),
                                child: Row(
                                  children: reviewCards,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpeacing(26),
                        RoundedButton(
                            buttonColor: AppColor.lavenderColor,
                            titleColor: AppColor.creamyColor,
                            title: 'Chat',
                            onpress: () async {
                              var paymentInfo =
                                  await getCurrentUserPaymentInfo();
                              if (paymentInfo != null &&
                                  paymentInfo['status'] == 'completed') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => FamilyChatView(
                                            profilePic: widget.profile,
                                            isSeen: false,
                                            currentUserName: getFamilyInfoRepo
                                                .familyName
                                                .toString(),
                                            name: widget.name,
                                            id: widget.familyId,
                                            currentUserProfilePic:
                                                getFamilyInfoRepo.familyProfile
                                                    .toString(),
                                            providerRatings:
                                                widget.ratings.toString(),
                                            providerTotalRatings:
                                                widget.totalRatings.toString(),
                                            education: widget.degree,
                                            horlyRate: widget.horseRate,
                                          )),
                                );
                              } else {
                                showSubscribtionDialog(context);
                              }
                            }),
                        const VerticalSpeacing(40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                widget.profile,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotRow(String label, String? startTime, String? endTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
            ),
          ),
        ),
        Text(
          '${startTime ?? 'N/A'} to ${endTime ?? 'N/A'}',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColor.lavenderColor,
            ),
          ),
        ),
      ],
    );
  }

  Future<Map<dynamic, dynamic>?> getCurrentUserPaymentInfo() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference paymentInfoRef = FirebaseDatabase.instance
          .ref()
          .child('Family')
          .child(currentUserId)
          .child('paymentInfo');

      // Fetch the payment info data from Firebase
      DatabaseEvent event = await paymentInfoRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        // Cast snapshot value to a Map
        return snapshot.value as Map<dynamic, dynamic>?;
      } else {
        print("No payment info found for the current user.");
        return null;
      }
    } catch (e) {
      print("Error fetching payment info: $e");
      return null;
    }
  }

  Widget buildReviewCard(String familyName, String familyComment,
      String familyProfile, double countRatingStars) {
    return Container(
      margin: const EdgeInsets.only(right: 10), // Space between cards
      decoration: BoxDecoration(
        color: AppColor.creamyColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 12.0),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(familyProfile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  familyName,
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 90,
                  child: Text(
                    familyComment.length > 30
                        ? '${familyComment.substring(0, 30)}...'
                        : familyComment,
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.star,
              color: AppColor.peachColor,
              size: 20,
            ),
            Text(
              countRatingStars.toString(),
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColor.peachColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillContainerWidget extends StatelessWidget {
  const SkillContainerWidget(
      {super.key, required this.title, required this.subTitle});
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.peachColor, borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColor.creamyColor,
                ),
              ),
            ),
            Text(
              subTitle,
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColor.creamyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
