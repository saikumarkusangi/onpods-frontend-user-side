import 'package:onpods/utils/exports.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _field1FocusNode = FocusNode();
  final FocusNode _field2FocusNode = FocusNode();
  @override
  void dispose() {
    _passwordController1.dispose();
    _passwordController2.dispose();
    _field1FocusNode.dispose();
    _field2FocusNode.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_passwordController1.text.trim() ==
          _passwordController2.text.trim()) {
        final response = await authProvider.resetPassword(
            _passwordController1.text.trim(), widget.email);
       if(response['success']){
         showSnackbar("Success", 'Password reset successful',ContentType.success,context);
        Get.offAll(const LoginScreen());
       }
      } else {
        showSnackbar("Not Matching", "Please recheck password again.",ContentType.warning,context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(size: 32, color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: CustomTextFormField(
              controller: _passwordController1,
              autofocus: false,
              focusNode: _field1FocusNode,
              radius: 10,
              hintText: "Enter new password",
              obscureText: false,
              vertical: 16,
              fillColor: darktextFieldColor,
              hintStyle: const TextStyle(color: Colors.grey),
              textStyle: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter password';
                }
                if (value.length < 6) {
                  return 'Password must atleast length of 6';
                }
                return null;
              },
              onSubmit: (String data) {},
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: CustomTextFormField(
              controller: _passwordController2,
              autofocus: false,
              focusNode: _field2FocusNode,
              radius: 10,
              hintText: "Confirm password",
              obscureText: false,
              vertical: 16,
              fillColor: darktextFieldColor,
              hintStyle: const TextStyle(color: Colors.grey),
              textStyle: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter password';
                }
                if (value != _passwordController1.text) {
                  return 'Password must be match';
                }
                return null;
              },
              onSubmit: (String data) {},
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: CustomElevatedButton(
              onTap: submit,
              height: 45,
              text: 'Reset Password',
              buttonTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 18),
              buttonColor: blueColor,
            ),
          ),
        ]),
      ),
    );
  }
}
