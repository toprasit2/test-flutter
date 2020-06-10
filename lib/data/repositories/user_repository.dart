import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final GoogleSignIn _googleSignIn;

  UserRepository({GoogleSignIn googleSignin})
      : _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    return googleAuth.accessToken;
  }

  Future<void> signOut() async {
    return Future.wait([
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _googleSignIn.currentUser;
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _googleSignIn.currentUser).email;
  }
}
