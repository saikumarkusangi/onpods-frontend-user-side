import 'package:flutter/gestures.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onpods/utils/exports.dart';
import 'package:onpods/widgets/google_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<bool> passwordToggle = ValueNotifier<bool>(false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _field1FocusNode = FocusNode();
  final FocusNode _field2FocusNode = FocusNode();
  final FocusNode _field3FocusNode = FocusNode();

  @override
  void dispose() {
    _field1FocusNode.dispose();
    _field2FocusNode.dispose();
    _field3FocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    void submit() {
      FocusManager.instance.primaryFocus?.unfocus();
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        authProvider.signUp(_nameController.text.trim(),
            _emailController.text.trim(), _passwordController.text.trim());
      }
    }

    bool isEmailValid(String email) {
      const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
      final regExp = RegExp(emailPattern);
      return regExp.hasMatch(email);
    }

    final _googleOauth = GoogleSignIn();
    return WidgetHUD(
        showHUD: authProvider.isLoading,
        hud: HUD(
            progressIndicator: Image.asset(
          liveGif,
          color: blueColor,
          scale: 3,
        )),
        builder: (context, child) => Scaffold(
              body: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(children: [
                        SizedBox(
                          height: 0.6.sh,
                          child: Image.asset
                          (
                            signupimage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, top: 150, right: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Explore Podcasts,\nQuotes and more.',
                                  style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomTextFormField(
                                  focusNode: _field1FocusNode,
                                  controller: _nameController,
                                  autofocus: false,
                                  radius: 10,
                                  hintText: "User Name",
                                  vertical: 16,
                                  fillColor: darktextFieldColor,
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    if (value.length < 3) {
                                      return 'Name must be at least 3 characters long';
                                    }
                                    return null;
                                  },
                                  onSubmit: (String data) {},
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextFormField(
                                  focusNode: _field2FocusNode,
                                  controller: _emailController,
                                  autofocus: false,
                                  radius: 10,
                                  hintText: "Email Address",
                                  vertical: 16,
                                  fillColor: darktextFieldColor,
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter email';
                                    }
                                    if (!isEmailValid(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  onSubmit: (String data) {},
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ValueListenableBuilder(
                                  valueListenable: passwordToggle,
                                  builder: (context, value, child) =>
                                      CustomTextFormField(
                                    focusNode: _field3FocusNode,
                                    controller: _passwordController,
                                    autofocus: false,
                                    radius: 10,
                                    hintText: "Password",
                                    obscureText: !value,
                                    vertical: 16,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters long';
                                      }
                                      return null;
                                    },
                                    suffix: IconButton(
                                      color: Colors.white,
                                      icon: Icon(
                                        value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        passwordToggle.value =
                                            !passwordToggle.value;
                                      },
                                    ),
                                    fillColor: darktextFieldColor,
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    onSubmit: (String data) {},
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomElevatedButton(
                                  onTap: submit,
                                  height: 50,
                                  text: 'Create Account',
                                  buttonTextStyle: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  buttonColor: blueColor,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 1,
                                      width: 0.35.sw,
                                      color: Colors.white54,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      width: 0.35.sw,
                                      color: Colors.white54,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                customGoogleButton('Signup with Google',
                                    () async {
                                  final response = await _googleOauth.signIn();
                                  authProvider.oAuthsignUp(
                                      response!.displayName.toString(),response.email, response.id,response.photoUrl ?? '');
                                }),
                                const SizedBox(
                                  height: 20,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'Already have account?',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      children: [
                                        TextSpan(
                                            text: ' Login',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Get.off(
                                                    () => const LoginScreen(),
                                                    transition:
                                                        Transition.rightToLeftWithFade);
                                              },
                                            style: const TextStyle(
                                                color: blueColor))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ));
  }
}
