import 'package:flutter_hud/flutter_hud.dart';
import 'package:onpods/utils/exports.dart';

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
        authProvider.forgotPassword(_emailController.text.trim(),context);
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
                        }, onSubmit: (String data) {  },
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
                        buttonColor:Colors.blue
                      ),
                    ),
                  ]),
            ),
          )),
    );
  }
}
