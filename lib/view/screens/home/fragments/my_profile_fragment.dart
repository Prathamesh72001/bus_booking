import 'dart:io';
import 'dart:typed_data';
import 'package:bus_booking_app/models/user_model.dart';
import 'package:bus_booking_app/router/router.dart';
import 'package:bus_booking_app/services/firebase_service.dart';
import 'package:bus_booking_app/services/shared_preference_service.dart';
import 'package:bus_booking_app/utility/assets.dart';
import 'package:bus_booking_app/view/widgets/common/common_button_widget.dart';
import 'package:bus_booking_app/view/widgets/common/loader_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:images_picker/images_picker.dart';

import '../../../../utility/colors.dart';
import '../../../../utility/strings.dart';
import '../../../../utility/utils.dart';

class ProfileFragment extends StatefulWidget {
  ProfileFragment({Key? key}) : super(key: key);

  @override
  State<ProfileFragment> createState() => _ProfileFragment();
// final _navigatorService = locator<INavigationService>();
}

class _ProfileFragment extends State<ProfileFragment> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  Future<Uint8List>? profile;
  bool isLoading = false;
  UserModel? userDetailModel;
  String? img;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    isLoading = true;
    var user = await Preference.getUser();
    await FirebaseService.database.child('users').child(user!).once().then((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        userDetailModel = UserModel.fromJson(Map<String, dynamic>.from(values));
        fullNameController.text = userDetailModel!.name;
        emailController.text = userDetailModel!.email;
        phoneNumberController.text = userDetailModel!.mobile;
      } else {
        Utils.getSnackBar(context, Strings.something_went_wrong);
      }
    });

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: isLoading == true
            ? const Center(child: LoaderWidget())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    // height: 140,
                    // width: 140,
                    child: Stack(
                      children: [
                        profile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: FutureBuilder(
                                    future: profile!,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<Uint8List> snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return const Text('Loading....');
                                        default:
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return Image.memory(snapshot.data!,
                                                fit: BoxFit.cover,
                                                width: 110,
                                                height: 110);
                                          }
                                      }
                                    }))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: Image.network(
                                  userDetailModel?.profile_image != null
                                      ? userDetailModel!.profile_image
                                      : 'https://www.pngitem.com/pimgs/m/272-2720656_user-profile-dummy-hd-png-download.png',
                                  fit: BoxFit.fill,
                                  width: 110,
                                  height: 110,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    Assets.profile,
                                    fit: BoxFit.fill,
                                    width: 110,
                                    height: 110,
                                  ),
                                )),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: GestureDetector(
                            onTap: pickImageFromGallery,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: BrandColors.primary.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: BrandColors.secondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .55,
                        padding: const EdgeInsets.all(25),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                            color: BrandColors.primary.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                                readOnly: false,
                                maxLength: 50,
                                controller: fullNameController,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: BrandColors.secondary),
                                decoration: InputDecoration(
                                    hintStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: BrandColors.secondary),
                                    hintText: 'Enter your Full Name',
                                    labelText: 'Full Name',
                                    labelStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: BrandColors.secondary))),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                readOnly: false,
                                maxLength: 50,
                                controller: emailController,inputFormatters: [FilteringTextInputFormatter.singleLineFormatter,],
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: BrandColors.secondary),
                                decoration: InputDecoration(
                                    hintStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: BrandColors.secondary),
                                    hintText: 'Enter your Email',
                                    labelText: 'Email',
                                    labelStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: BrandColors.secondary))),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: phoneNumberController,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: BrandColors.secondary),
                              decoration: InputDecoration(
                                  hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: BrandColors.secondary),
                                  labelText: 'Phone Number',
                                  labelStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: BrandColors.secondary)),
                            ),
                            const Spacer(),
                            CommonButton(
                              isEnabled: true,
                              onTap: () async {
                                if (profile != null) {
                                  isLoading = true;
                                  setState(() {});
                                  _uploadImage();
                                  setState(() {});
                                } else {
                                  isLoading = true;
                                  setState(() {});
                                  _uploadImage();
                                  setState(() {});
                                }
                              },
                              buttonText: 'Save',
                            ),
                          ],
                        )),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    if (profile == null) {
      try {
        // Save the download URL to Firebase Realtime Database
        await FirebaseService.database.child('users')
            .child(userDetailModel!.mobile).update({
          'name': fullNameController.text,
          'email': emailController.text,
        });

        isLoading = false;
        Utils.getSnackBar(context, 'Profile details updated');
        setState(() {});
      } catch (e) {
        isLoading = false;
        Utils.getSnackBar(context, 'Profile details not updated');
        setState(() {});
        Utils.getSnackBar(context, 'Something went wrong');
      }
    } else {
      try {
        // Create a unique file name
        String fileName =
            'profile/${DateTime.now().millisecondsSinceEpoch}.png';
        await Utils.uint8ListToFile(profile!, "${DateTime.now().millisecondsSinceEpoch}.png").then((value) async {
          // Upload image to Firebase Storage
          UploadTask uploadTask =
              FirebaseService.storage.ref().child(fileName).putFile(value);
          TaskSnapshot taskSnapshot = await uploadTask;

          // Get the download URL
          String downloadURL = await taskSnapshot.ref.getDownloadURL();

          // Save the download URL to Firebase Realtime Database
          await FirebaseService.database.child('users')
              .child(userDetailModel!.mobile)
              .update({
            'name': fullNameController.text,
            'email': emailController.text,
            'profile_image': downloadURL,
          });

          isLoading = false;
          Utils.getSnackBar(context, 'Profile details updated');
          setState(() {});
        });
      } catch (e) {
        isLoading = false;
        Utils.getSnackBar(context, 'Profile details not updated');
        setState(() {});
        Utils.getSnackBar(context, 'Something went wrong');
      }
    }
  }

  Future pickImageFromGallery() async {
    final imageBytes = await pickImage();
    setState(() {
      profile = Future.value(imageBytes);
    });
  }

  Future<Uint8List?> pickImage() async {
    List<Media>? cameraFile = await ImagesPicker.openCamera(
      pickType: PickType.image,
      quality: 0.8,
      maxSize: 800,
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.custom,
        cropType: CropType.rect, // currently for android
      ),
    );
    if (cameraFile != null) {
      File file = File(cameraFile[0].path);
      return file.readAsBytes();
    }
    return null;
  }
}
