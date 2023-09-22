import 'package:flutter/material.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/auth_screen/otp_verify_screen.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/images.dart';
import 'package:onpods/widgets/custom_text_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/widgets_exports.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _field1FocusNode = FocusNode();
  @override
  void dispose() {
    _emailController.dispose();
    _field1FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    void submit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        authProvider.forgotPassword(_emailController.text.trim());
      }
    }

    bool isEmailValid(String email) {
      const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
      final regExp = RegExp(emailPattern);
      return regExp.hasMatch(email);
    }

    return WidgetHUD(
      hud: HUD(
          progressIndicator: Image.asset(
        liveGif,
        color: blueColor,
        scale: 3,
      )),
      showHUD: authProvider.isLoading,
      builder: (context, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white, size: 32),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        emailImage,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Forgot your password',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        "Don't worry enter your registered email id to recieve OTP for reset password.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: CustomTextFormField(
                        controller: _emailController,
                        autofocus: false,
                        focusNode: _field1FocusNode,
                        radius: 10,
                        hintText: "Enter your Email",
                        obscureText: false,
                        vertical: 16,
                        fillColor: textFieldColor,
                        hintStyle: const TextStyle(color: Colors.grey),
                        textStyle: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!isEmailValid(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: CustomElevatedButton(
                        onTap: submit,
                        height: 45,
                        text: 'Send',
                        buttonTextStyle:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        buttonStyle: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          fixedSize: MaterialStateProperty.resolveWith<Size?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Size(
                                    1.sw, 40); // Size for disabled state
                              }
                              return Size(
                                  1.sw, 40); // Default size for enabled state
                            },
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Color for disabled state
                              }
                              return Colors
                                  .blue; // Default color for enabled state
                            },
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          )),
    );
  }
}
