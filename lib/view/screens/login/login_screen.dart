// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:bus_booking_app/services/firebase_service.dart';
import 'package:bus_booking_app/services/shared_preference_service.dart';
import 'package:bus_booking_app/utility/colors.dart';
import 'package:bus_booking_app/utility/strings.dart';
import 'package:bus_booking_app/utility/utils.dart';
import 'package:bus_booking_app/view/widgets/common/common_button_widget.dart';
import 'package:bus_booking_app/view/widgets/common/common_text_widget.dart';
import 'package:bus_booking_app/view/widgets/common/empty_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../router/router.dart';
import '../../../utility/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool enableButton = false;
  bool isFocus = false;
  bool isLoading = false;
  bool canResend = false;
  String otpCode = "";
  String? resendTimeText;
  Timer? countdownTimer;
  int resendTime = 10;
  String _comingSms = 'Unknown';
  final TextEditingController _codeController = TextEditingController();
  bool _isOtpVisible = false;
  String _verificationId = "";
  late PhoneNumber phoneNo;

  @override
  void initState() {
    initSmsListener();
    super.initState();
  }

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms ?? "";
      if (_comingSms.length >= 22) {
        _codeController.text = _comingSms[16] +
            _comingSms[17] +
            _comingSms[18] +
            _comingSms[19] +
            _comingSms[20] +
            _comingSms[21];
      } //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
    });
  }

  void startCountdownTimer() {
    setState(() {
      canResend = false;
      resendTimeText = Utils.formatTime(resendTime);
    });
    int timer_sec = resendTime;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timer_sec--;
        resendTimeText = Utils.formatTime(timer_sec);
      });
      if (timer_sec == 0) {
        if (countdownTimer != null) {
          setState(() {
            canResend = true;
            countdownTimer!.cancel();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                      height: 150,
                      width: 150,
                      child: Lottie.asset(Assets.splash_animation)),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: CommonText(
                      text: Strings.title_login,
                      color: BrandColors.text,
                      fontSize: 45,
                      fontFamily: 'baloo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: CommonText(
                      text: Strings.subtitle_login,
                      color: BrandColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red[50]!,
                            Colors.red[100]!,
                            Colors.red[200]!,
                            BrandColors.primary
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: BrandColors.shadow,
                              blurRadius: 10,
                              spreadRadius: 3)
                        ]),
                    margin: const EdgeInsets.all(25),
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: IntlPhoneField(
                            dropdownTextStyle: const TextStyle(
                              color: BrandColors.text,
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                                hintText: Strings.hint_mobile,
                                hintStyle: TextStyle(color: BrandColors.text),
                                labelText: Strings.mobile,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                counterText: ""),
                            initialCountryCode: 'IN',
                            controller: _phoneNumberController,
                            autofocus: isFocus,
                            style: CommonText.defaultStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: BrandColors.text),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) {
                              try {
                                if (value!.completeNumber.isEmpty ||
                                    !RegExp(
                                      r'^(?:[+0]9)?[0-9]{10}$',
                                      multiLine: false,
                                    ).hasMatch(value!.completeNumber)) {
                                  return Strings.error_mobile;
                                }
                              } catch (e) {
                                return Strings.error_mobile;
                              }
                            },
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              phoneNo = value;
                              setState(() {});
                              if (_phoneNumberController.text.length == 10) {
                                enableButton = true;
                                setState(() {});
                              } else {
                                enableButton = false;
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        _isOtpVisible
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  PinCodeTextField(
                                    autoFocus: true,
                                    backgroundColor: Colors.transparent,
                                    appContext: context,
                                    pastedTextStyle: const TextStyle(
                                        color: BrandColors.text,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'poppins'),
                                    length: 6,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      selectedColor: Colors.grey,
                                      shape: PinCodeFieldShape.box,
                                      activeColor: BrandColors.primary,
                                      inactiveColor: BrandColors.primary,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      activeFillColor: Colors.transparent,
                                    ),
                                    enablePinAutofill: true,
                                    cursorColor: BrandColors.primary,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    controller: _codeController,
                                    keyboardType: TextInputType.number,
                                    onCompleted: (v) {
                                      otpCode = _codeController.text.toString();
            
                                      enableButton = true;
                                      setState(() {});
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        enableButton =
                                            _codeController.text.length == 6
                                                ? true
                                                : false;
                                      });
                                    },
                                    beforeTextPaste: (text) {
                                      return true;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const CommonText(
                                          text: 'Didn\'t receive code?',
                                          fontSize: 15,
                                          textAlign: TextAlign.center),
                                      const Spacer(),
                                      TextButton(
                                          onPressed: canResend
                                              ? () {
                                                  _codeController.text = "";
                                                  // getOtp(
                                                  //     _phoneNumberController.text,
                                                  //     country!,
                                                  //     countryId!);
                                                }
                                              : null,
                                          child: canResend
                                              ? const CommonText(
                                                  text: 'Resend',
                                                  fontSize: 15,
                                                  color: BrandColors.text,
                                                  textAlign: TextAlign.center)
                                              : CommonText(
                                                  text:
                                                      'Resend OTP in $resendTimeText',
                                                  fontSize: 14,
                                                  color: BrandColors.text,
                                                  fontWeight: FontWeight.normal,
                                                  textAlign: TextAlign.center)),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(
                                height: 50,
                              ),
                        CommonButton(
                            isEnabled: enableButton,
                            onTap: () {
                              if (enableButton) {
                                isLoading = true;
                                setState(() {});
                                if (_isOtpVisible) {
                                  _signInWithPhoneNumber();
                                } else {
                                  _verifyPhone();
                                }
                              }
                            },
                            isLoading: isLoading,
                            buttonText:
                                _isOtpVisible ? Strings.login : Strings.send_otp)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(25),
              child: CommonText(text: "v1.0"),
            )
          ],
        ),
      ),
    );
  }

  void _verifyPhone() async {
    await FirebaseService.auth.verifyPhoneNumber(
      phoneNumber: phoneNo.completeNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        isLoading = false;
        setState(() {});
        enableOTPUI();
        await FirebaseService.auth
            .signInWithCredential(credential)
            .then((result) {
          if (result.user != null) {
            _checkIfUserExists();
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        isLoading = false;
        setState(() {});
        Utils.getSnackBar(
            context, "${Strings.verification_failed} : ${e.message}");
      },
      codeSent: (String verificationId, [int? forceResendingToken]) {
        _verificationId = verificationId;
        isLoading = false;
        setState(() {});
        enableOTPUI();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        isLoading = false;
        setState(() {});
        enableOTPUI();
      },
    );
  }

  void _signInWithPhoneNumber() async {
    final code = _codeController.text.trim();
    isLoading = true;
    setState(() {});
    if (_verificationId != "") {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code);
      await FirebaseService.auth
          .signInWithCredential(credential)
          .then((result) {
        if (result.user != null) {
          _checkIfUserExists();
        }
      });
    } else {
      Utils.getSnackBar(context,
          "${Strings.verification_failed} : ${Strings.something_went_wrong}");
    }
  }

  void _checkIfUserExists() async {
    String userId = phoneNo.completeNumber;
    DatabaseEvent event =
        await FirebaseService.database.child('users').child(userId).once();

    if (!event.snapshot.exists) {
      _uploadUserData(userId);
    }

    isLoading = false;
    setState(() {});
    Preference.setLoginStatus(true);
    Preference.setUser(phoneNo.completeNumber);
    Utils.getSnackBar(context, Strings.verification_success);
    AppRouter.replaceWith(context, AppRouter.homeScreen);
  }

  void _uploadUserData(String userId) async {
    await FirebaseService.database.child('users').child(userId).set({
      'name': "New User",
      'email': "",
      'profile_image': "",
      'mobile': userId,
      'created_at': DateTime.now().toString(),
    });
  }

  enableOTPUI() {
    if (!_isOtpVisible) {
      _isOtpVisible = true;
      enableButton = false;
      setState(() {});
      startCountdownTimer();
    }
  }
}
