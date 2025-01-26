// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/Family_View/profileFamily/my_profile_family.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';

import '../../../res/components/colors.dart';
import '../../../utils/utils.dart';

class EditProfileFamily extends StatefulWidget {
  final Map<dynamic, dynamic> familyData;

  const EditProfileFamily({required this.familyData, super.key});

  @override
  State<EditProfileFamily> createState() => _EditProfileFamilyState();
}

class _EditProfileFamilyState extends State<EditProfileFamily> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  late TextEditingController emailController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: widget.familyData['firstName'] +
            ' ' +
            widget.familyData['lastName']);
    addressController =
        TextEditingController(text: widget.familyData['address']);
    phoneController =
        TextEditingController(text: widget.familyData['phoneNumber']);
    dobController = TextEditingController(text: widget.familyData['dob']);
    emailController = TextEditingController(text: widget.familyData['email']);
    descriptionController =
        TextEditingController(text: widget.familyData['bio']);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    dobController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    try {
      final DatabaseReference providerRef =
          FirebaseDatabase.instance.ref().child('Family');

      final userDocument =
          providerRef.child(FirebaseAuth.instance.currentUser!.uid);

      // Prepare the data to be updated
      Map<String, dynamic> updatedData = {
        'firstName': nameController.text.split(' ')[0],
        'lastName': nameController.text.split(' ').sublist(1).join(' '),
        'address': addressController.text,
        'phoneNumber': phoneController.text,
        'dob': dobController.text,
        'email': emailController.text,
        'bio': descriptionController.text,
      };
      // Update the user's profile information in the database
      await userDocument.update(updatedData);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MyProfileFamily()));
    } catch (e) {
      Utils.flushBarErrorMessage('Failed to update profile', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lavenderColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.west,
                color: AppColor.creamyColor,
              )),
          title: Text(
            'Profiel Bewerken',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, right: 16.0, left: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TextFieldCustom(
                    controller: nameController,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColor.lavenderColor,
                    ),
                    maxLines: 1,
                    hintText: 'Name'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: addressController,
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: AppColor.lavenderColor,
                    ),
                    maxLines: 1,
                    hintText: 'Address'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: phoneController,
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: AppColor.lavenderColor,
                    ),
                    maxLines: 1,
                    hintText: 'Telephone Number'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: dobController,
                    prefixIcon: const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColor.lavenderColor,
                    ),
                    maxLines: 1,
                    hintText: 'Date of Birth'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: emailController,
                    prefixIcon: const Icon(
                      Icons.mail_outline,
                      color: AppColor.lavenderColor,
                    ),
                    maxLines: 1,
                    hintText: 'Email Address'),
                const VerticalSpeacing(16.0),
                TextFieldCustom(
                    controller: descriptionController,
                    prefixIcon: const Icon(
                      Icons.border_color_outlined,
                      color: AppColor.lavenderColor,
                    ),
                    maxLines: 1,
                    hintText: 'Description'),
                const VerticalSpeacing(16.0),
                const VerticalSpeacing(16.0),
                RoundedButton(
                    buttonColor: AppColor.lavenderColor,
                    titleColor: AppColor.creamyColor,
                    title: 'Opslaan',
                    onpress: () {
                      _updateProfile();
                    }),
                const VerticalSpeacing(30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
