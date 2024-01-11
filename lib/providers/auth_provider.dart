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

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.login(email, password);

      userId = userData['data']['id'];
      notifyListeners();
      UserSession.setUserId(userId);
      showSnackbar('Successful', 'You are logged in!');
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

  Future<void> oauthLogin(String id) async {

    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.oAuthlogin(id);

      userId = userData['data']['id'];
      notifyListeners();
      UserSession.setUserId(userId);
      showSnackbar('Successful', 'You are logged in!');
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

  Future<void> signUp(String name, String email, String password) async {

    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.signup(name, email, password);

      userId = userData['userId'];
      notifyListeners();
      UserSession.setUserId(userId);
      showSnackbar('Successful', 'Account Created Successfully!');
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

  Future<void> oAuthsignUp(String name, String email, String id,String photoUrl) async {

    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.oAuthsignup(name, email, id,photoUrl);

      userId = userData['userId'];
      notifyListeners();
      UserSession.setUserId(userId);
      showSnackbar('Successful', 'Account Created Successfully!');
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

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      final otp = await _authService!.forgotPassword(email);
      return otp;
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
