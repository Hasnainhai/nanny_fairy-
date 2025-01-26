import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:nanny_fairy/utils/utils.dart';
import '../../../res/components/colors.dart';
import '../../../res/components/day_button.dart';

class EditAvailabilityView extends StatefulWidget {
  const EditAvailabilityView({super.key});

  @override
  State<EditAvailabilityView> createState() => _EditAvailabilityViewState();
}

class _EditAvailabilityViewState extends State<EditAvailabilityView> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
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

// This map now accumulates times for all days.
  Map<String, Map<String, String>> selectedTimes = {};

// Store all selected days and their times in Firebase.
  void _storeAllTimesInDatabase() {
    if (!_isAllTimeSelectedForDay()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select times for all periods.')),
      );
      return;
    }

    final firebaseAuth = FirebaseAuth.instance;
    final userId = firebaseAuth.currentUser!.uid;

    // Store all days and their times in Firebase under the specific user's path.
    _dbRef
        .child('Providers')
        .child(userId)
        .child('Time')
        .update(selectedTimes)
        .then((_) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.dashboard, (router) => false);
      Utils.toastMessage('SuccessFully Update details');
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to store time data: $error');
      }
    });
  }

// Ensure that all periods have selected times for the selected day before saving.
  bool _isAllTimeSelectedForDay() {
    Map<String, String>? timesForDay = selectedTimes[selectedDay];
    return timesForDay != null &&
        timesForDay.containsKey('MorningStart') &&
        timesForDay.containsKey('MorningEnd') &&
        timesForDay.containsKey('AfternoonStart') &&
        timesForDay.containsKey('AfternoonEnd') &&
        timesForDay.containsKey('EveningStart') &&
        timesForDay.containsKey('EveningEnd');
  }

// Time picker widget for selecting times for each period, updated to store each day separately.
  Widget _timePicker(String period, String type) {
    return InkWell(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            // Ensure the selected day has a map, then add the time.
            selectedTimes[selectedDay] ??= {};
            selectedTimes[selectedDay]!['$period$type'] =
                pickedTime.format(context);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          selectedTimes[selectedDay]?['$period$type'] ?? 'Select Time',
          style: const TextStyle(fontSize: 10, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

// UI for displaying time rows for each period
  Widget _buildTimeRow(String label, String period) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
            ),
          ),
        ),
        const Text('Van'),
        _timePicker(period, 'Start'),
        const Text('Tot'),
        _timePicker(period, 'End'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lavenderColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
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
            'Edit Availability',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColor.creamyColor,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColor.creamyColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.creamyColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xff1B81BC)
                          .withOpacity(0.10), // Stroke color with 10% opacity
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1B81BC).withOpacity(
                            0.1), // Drop shadow color with 4% opacity
                        blurRadius: 2,
                        offset: const Offset(1, 2),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            height: 16), // Added spacing from the top
                        Text(
                          'Availability',
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Officia irure irure an',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.grayColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DayButton(
                              day: 'M',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'T',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'W',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'T',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'F',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'S',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'S',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const AvailabilityRow(
                          label: 'Morning',
                          availability: [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ],
                          timePeriod: 'morning',
                        ),
                        const Divider(),
                        const AvailabilityRow(
                          label: 'Evening',
                          availability: [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ],
                          timePeriod: 'Evening',
                        ),
                        const Divider(),
                        const AvailabilityRow(
                          label: 'Afternoon',
                          availability: [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ],
                          timePeriod: 'Afternoon',
                        ),
                        const VerticalSpeacing(10),
                      ],
                    ),
                  ),
                ),
                const VerticalSpeacing(20.0),
                Container(
                  height: 216,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.authCreamColor,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xff1B81BC)
                          .withOpacity(0.10), // Stroke color with 10% opacity
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1B81BC).withOpacity(
                            0.1), // Drop shadow color with 4% opacity
                        blurRadius: 2,
                        offset: const Offset(1, 2),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tijdschema',
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor,
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              icon: const Icon(
                                Icons.expand_more,
                                color: AppColor.oceanColor,
                              ),
                              underline: const SizedBox.shrink(),
                              value: selectedDay,
                              dropdownColor: AppColor.creamyColor,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDay = newValue!;
                                });
                              },
                              items: days
                                  .map<DropdownMenuItem<String>>((String day) {
                                return DropdownMenuItem<String>(
                                  value: day,
                                  child: Text(
                                    day,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        color: AppColor.oceanColor),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            _buildTimeRow('Ochtend', 'Morning'),
                            const SizedBox(height: 18),
                            _buildTimeRow('Middag', 'Afternoon'),
                            const SizedBox(height: 18),
                            _buildTimeRow('Avond', 'Evening'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalSpeacing(46.0),
                RoundedButton(
                  title: 'Update',
                  onpress: _storeAllTimesInDatabase,
                ),
                const VerticalSpeacing(40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AvailabilityRow extends StatefulWidget {
  final String label;
  final List<bool> availability;
  final String timePeriod; // morning, evening, or afternoon

  const AvailabilityRow({
    super.key,
    required this.label,
    required this.availability,
    required this.timePeriod,
  });

  @override
  _AvailabilityRowState createState() => _AvailabilityRowState();
}

class _AvailabilityRowState extends State<AvailabilityRow> {
  late List<bool> _availability;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _availability =
        List.from(widget.availability); // Initialize with widget's availability
  }

  void _toggleAvailability(int index) {
    setState(() {
      _availability[index] = !_availability[index];
      _storeAvailabilityInDatabase(index);
    });
  }

  void _storeAvailabilityInDatabase(int index) {
    final firebaseAuth = FirebaseAuth.instance;
    final userId = firebaseAuth.currentUser!.uid;
    String day = _getDayName(index);
    _dbRef
        .child('Providers')
        .child(userId)
        .child('Availability')
        .child('${widget.timePeriod}/$day')
        .set(_availability[index]);
  }

  String _getDayName(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Row(
            children: _availability
                .asMap()
                .entries
                .map((entry) => GestureDetector(
                      onTap: () => _toggleAvailability(entry.key),
                      child: AvailabilityCheckBox(isAvailable: entry.value),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class AvailabilityCheckBox extends StatelessWidget {
  final bool isAvailable;

  const AvailabilityCheckBox({
    super.key,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isAvailable ? AppColor.lavenderColor : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColor.blackColor, width: 0.5),
      ),
      height: 23,
      width: 22,
      child: isAvailable
          ? const Icon(
              Icons.check,
              size: 16,
              color: AppColor.creamyColor,
            )
          : null,
    );
  }
}
