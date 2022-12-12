import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/common/failure.dart';
import 'package:reddit_tutorial/core/common/providers/firebase_provider.dart';
import 'package:reddit_tutorial/core/common/type_dev.dart';

final storageRepositoryProvider = Provider((ref) {
  return StorageRepository(firebaseStorage: ref.watch(firebaseStorageProvider));
});

class StorageRepository {
  final FirebaseStorage _firebaseStorage;
  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile(
      {required String path, required String uid, required File file}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(uid);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return right(downloadUrl);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
