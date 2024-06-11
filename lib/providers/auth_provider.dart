import 'package:google_sign_in/google_sign_in.dart';
import 'package:onpods/utils/exports.dart';

class AuthProvider with ChangeNotifier {
  final _googleOauth = GoogleSignIn();
  bool _isLoading = false;
  AuthService? _authService;
  String userId = '';
  
  AuthProvider() {
    _authService = AuthService(this);
  }

  bool get isLoading => _isLoading;

  // ---------------------------- Login -----------------------------------------

  Future<void> login(String email, String password,BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.login(email, password,context);

      userId = userData['data']['id'];
      notifyListeners();
      UserSession.setUserId(userId);
      showSnackbar('Successful', 'You are logged in!',ContentType.success,context);
      Get.offAll(const Layout(), transition: Transition.fadeIn);
    } catch (error) {
      await _googleOauth.signOut();
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// ---------------------------- Login -----------------------------------------

  Future<void> oauthLogin(String id,BuildContext context) async {

    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.oAuthlogin(id,context);

      userId = userData['data']['id'];
      notifyListeners();
      UserSession.setUserId(userId);
      showSnackbar('Successful', 'You are logged in!',ContentType.success,context);
      Get.offAll(const Layout(), transition: Transition.fadeIn);
    } catch (error) {

      await _googleOauth.signOut();
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------- Sign UP -----------------------------------------

  Future<void> signUp(String name, String email, String password,BuildContext context) async {

    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.signup(name, email, password,context);

      userId = userData['userId'];
      notifyListeners();
      UserSession.setUserId(userId);
      showSnackbar('Successful', 'Account Created Successfully!',ContentType.success,context);
      Get.offAll(const ChooseYourInterestScreen(),
          transition: Transition.cupertino);
    } catch (error) {
      await _googleOauth.signOut();
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------- Sign UP -----------------------------------------

  Future<void> oAuthsignUp(String name, String email, String id,String photoUrl,BuildContext context) async {

    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.oAuthsignup(name, email, id,photoUrl,context);

      userId = userData['userId'];
      notifyListeners();
      UserSession.setUserId(userId);
      showSnackbar('Successful', 'Account Created Successfully!',ContentType.success,context);
      Get.offAll(const ChooseYourInterestScreen(),
          transition: Transition.cupertino);
    } catch (error) {
      await _googleOauth.signOut();
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------- Forgot Password -----------------------------------------

  Future<Map<String, dynamic>> forgotPassword(String email,BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final otp = await _authService!.forgotPassword(email,context);
      return otp;
    } catch (error) {
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   // ---------------------------- Reset Password -----------------------------------------

  Future<Map<String, dynamic>> resetPassword(String password,String email,BuildContext context)async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService!.resetPassword(password,email,context);
      return response;
    } catch (error) {
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// ---------------------------- Logout -----------------------------------------

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await _googleOauth.signOut();
    notifyListeners();
  }
}
