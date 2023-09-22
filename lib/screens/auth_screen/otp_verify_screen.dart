import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/auth_screen/reset_password_screen.dart';
import 'package:pinput/pinput.dart';

import '../../utils/utils_exports.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String otp;
  const OtpVerifyScreen({super.key, required this.otp});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.white, border: Border.all(color: Colors.red, width: 2)),
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white, size: 32),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    mailSent,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 250,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Email has been sent!',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'We\'ve just sent your OTP to your email,Check your mail.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Verify OTP',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Pinput(
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  validator: (s) {
                    return s == widget.otp ? null : 'Incorrect OTP';
                  },
                  onCompleted: (value) {
                    if (value == widget.otp) {
                      Get.to(ResetPassword(),transition: Transition.rightToLeft);
                    }
                  },
                  showCursor: true,
                  errorPinTheme: errorPinTheme,
                )
              ]),
        ));
  }
}
