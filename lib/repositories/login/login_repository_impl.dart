import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> _ensureInitialized() async {
    await _googleSignIn.initialize();
  }

  @override
  Future<UserCredential> login() async {
    await _ensureInitialized();

    GoogleSignInAccount? googleUser = await _googleSignIn.attemptLightweightAuthentication();

    if (googleUser == null) await _googleSignIn.authenticate();

    if (googleUser == null) throw Exception('Falha no Login');

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final GoogleSignInClientAuthorization googleAuto =
        GoogleSignInClientAuthorization(accessToken: 'email');

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuto.accessToken,
      idToken: googleAuth.idToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> logout() async {
    await _ensureInitialized();
    await _googleSignIn.signOut();
  }
}
