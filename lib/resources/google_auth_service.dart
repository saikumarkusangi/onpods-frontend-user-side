import 'package:google_sign_in/google_sign_in.dart';
import 'package:onpods/utils/exports.dart';

final _googleOauth = GoogleSignIn();

Future<void> googleSignUp(context) async {
  final provider = Provider.of<AuthProvider>(context);
  final response = await _googleOauth.signIn();
  provider.signUp(
      response!.displayName.toString(), response.email, response.id,context);
}

Future<void> googleSignIn(context) async {
  
}

Future<void> googleOut() async {
  await _googleOauth.signOut();
}
