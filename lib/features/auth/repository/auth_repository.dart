import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_tutorial/core/common/failure.dart';
import 'package:reddit_tutorial/core/constants/constant.dart';
import 'package:reddit_tutorial/core/constants/firebase_constant.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/core/common/providers/firebase_provider.dart';
import 'package:reddit_tutorial/core/common/type_dev.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firestoreProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        googleAuthProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleAuthProvider);
      } else {
        GoogleSignInAccount? userGoogle = await _googleSignIn.signIn();

        final googleAuth = await userGoogle?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        if (isFromLogin) {
          userCredential = await _auth.signInWithCredential(credential);
        } else {
          userCredential =
              await _auth.currentUser!.linkWithCredential(credential);
        }
      }

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'No name',
          profilePic: userCredential.user!.photoURL ?? Constant.avatarDefault,
          banner: Constant.bannerDefault,
          isAuthenticated: true,
          karma: 0,
          awards: [
            'awesomeAns',
            'gold',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'til',
          ],
        );
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else if (!isFromLogin) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'No name',
          profilePic: userCredential.user!.photoURL ?? Constant.avatarDefault,
          banner: Constant.bannerDefault,
          isAuthenticated: true,
          karma: 0,
          awards: [
            'awesomeAns',
            'gold',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'til',
          ],
        );
        await _users.doc(userModel.uid).update(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      if (kDebugMode) print('debug: ${e.message}');
      switch (e.code) {
        case "provider-already-linked":
          throw ("The provider has already been linked to the user.");

        case "invalid-credential":
          throw ("The provider's credential is not valid.");

        case "credential-already-in-use":
          return left(Failure(
              "The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User."));

        // See the API reference for the full list of error codes.
        default:
          throw ("Unknown error.");
      }
      // throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logout() async {
    _googleSignIn.signOut();
    _auth.signOut();
  }

  FutureEither<UserModel> signInWithGest() async {
    try {
      final credential = await _auth.signInAnonymously();
      UserModel user = UserModel(
          uid: credential.user!.uid,
          name: 'Gest',
          profilePic: Constant.avatarDefault,
          banner: Constant.bannerDefault,
          isAuthenticated: false,
          karma: 0,
          awards: []);
      await _users.doc(user.uid).set(user.toMap());
      return right(user);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
