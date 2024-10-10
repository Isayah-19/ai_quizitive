import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      // Attempt to sign in the user
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in process, return null
      if (gUser == null) {
        return null; // User canceled the sign-in
      }

      // Obtain the auth details from the selected account
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential using the obtained tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in to Firebase with the new credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the signed-in user
      return userCredential.user;
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null; // Handle errors and return null
    }
  }
}
