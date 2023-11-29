import 'package:flutter/gestures.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onpods/utils/exports.dart';
import 'package:onpods/widgets/google_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> passwordToggle = ValueNotifier<bool>(false);
  final FocusNode _field1FocusNode = FocusNode();
  final FocusNode _field2FocusNode = FocusNode();

  @override
  void dispose() {
    _field1FocusNode.dispose();
    _field2FocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isEmailValid(String email) {
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  void submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<AuthProvider>(context, listen: false)
          .login(_emailController.text.trim(), _passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
               Stack(
      children: [
        SizedBox(
          height: 0.5.sh,
          child: Image.asset(loginImage,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(left: 20, top: 150, right: 20),
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
                    'Enjoy Podcasts,\nQuotes and more.',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildEmailField(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildPasswordField(),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    onTap: submit,
                    height: 50,
                    text: 'Login',
                    buttonTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 18),
                    buttonColor: blueColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildForgotPasswordLink(),
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
                  customGoogleButton('Login with Google', () async {
                    final response = await _googleOauth.signIn();
                    authProvider.login(response!.email, response.id);
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildSignUpLink()
                ],
              ),
            ),
          ),
        ),
      ],
    )
  
              ],
            ),
          ),
        ),
      ),
    );
  }




  Widget _buildEmailField() {
    return CustomTextFormField(
      controller: _emailController,
      autofocus: false,
      focusNode: _field1FocusNode,
      radius: 10,
      hintText: "Email Address",
      vertical: 16,
      fillColor: darktextFieldColor,
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
      onSubmit: (String data) {},
    );
  }

  Widget _buildPasswordField() {
    return ValueListenableBuilder(
      valueListenable: passwordToggle,
      builder: (context, value, child) => CustomTextFormField(
        focusNode: _field2FocusNode,
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
            value ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            passwordToggle.value = !passwordToggle.value;
          },
        ),
        fillColor: darktextFieldColor,
        hintStyle: const TextStyle(color: Colors.grey),
        textStyle: const TextStyle(color: Colors.white),
        onSubmit: (String data) {},
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return GestureDetector(
      onTap: () => Get.to(const ForgotPasswordScreen(),
          transition: Transition.cupertino),
      child: const Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: blueColor, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return RichText(
      text: TextSpan(
        text: 'Don’t have account?',
        style: const TextStyle(color: Colors.white, fontSize: 16),
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(const SignUpScreen(), transition: Transition.rightToLeftWithFade);
              },
            text: ' Sign up',
            style: const TextStyle(color: blueColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
