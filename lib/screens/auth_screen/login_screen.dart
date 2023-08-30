import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/screens_exports.dart';
import 'package:onpods/utils/utils_exports.dart';
import 'package:onpods/widgets/widgets_exports.dart';
import 'package:provider/provider.dart';

import '../../providers/providers_exports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final passwordToggle = Provider.of<PasswordToggle>(context);
    void submit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        authProvider.login(
            _emailController.text.trim(), _passwordController.text.trim());
      }
    }

    bool isEmailValid(String email) {
      const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
      final regExp = RegExp(emailPattern);
      return regExp.hasMatch(email);
    }

    return WidgetHUD(
      hud: HUD(progressIndicator: const CircularProgressIndicator(
        color: Colors.blue,
      )),
      showHUD: authProvider.isLoading,
      builder: (context, child) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 0.55.sh,
                    child: Image.asset(
                      loginImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 0.25.sh,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.black.withOpacity(0.9),
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Welcome back to Onpods, It's time to listen to the music you want and enjoy the music!",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextFormField(
                        controller: _emailController,
                        autofocus: false,
                        radius: 10,
                        hintText: "Email Address",
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
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _passwordController,
                        autofocus: false,
                        radius: 10,
                        hintText: "Password",
                        obscureText: !passwordToggle.isPasswordVisible,
                        vertical: 16,
                        suffix: IconButton(
                          color: Colors.white,
                          icon: Icon(
                            passwordToggle.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            passwordToggle.togglePasswordVisibility();
                          },
                        ),
                        fillColor: textFieldColor,
                        hintStyle: const TextStyle(color: Colors.grey),
                        textStyle: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomElevatedButton(
                        onTap: submit,
                        height: 42,
                        text: 'Login',
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
                      const SizedBox(
                        height: 5,
                      ),
                      const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blue),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '( OR )',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                          style: ButtonStyle(
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
                                  return Colors
                                      .grey; // Color for disabled state
                                }
                                return Colors
                                    .white; // Default color for enabled state
                              },
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                googleLogo,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
                                'Login With Google',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'Don’t have account?',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            children: [
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(const SignUpScreen(),
                                          transition: Transition.rightToLeft);
                                    },
                                  text: ' Sign up',
                                  style: const TextStyle(color: Colors.blue))
                            ]),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
