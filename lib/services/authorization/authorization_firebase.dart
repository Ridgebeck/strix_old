import 'authorization_abstract.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/database/user_doc_abstract.dart';
import 'package:firebase_auth/firebase_auth.dart';

// interaction with game document on Firestore
class AuthorizationFirebase implements Authorization {
  final UserDoc _userDoc = serviceLocator<UserDoc>();

  @override
  Future<void> signInUserAnonymous() async {
    UserCredential userCredential;

    // sign in user into app
    try {
      userCredential = await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      // TODO: error handling
      print('Sign in anonymously failed with error code: ${e.code}');
      print('Credential: ${e.credential}');
      print('Message: ${e.message}');
    }

    // save current login time in user document
    _userDoc.updateUserSignIn(uid: userCredential.user.uid);
  }

  @override
  String getCurrentUserID() {
    // TODO: error handling with getting UID
    return FirebaseAuth.instance.currentUser.uid;
  }
}
