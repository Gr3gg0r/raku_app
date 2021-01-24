import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ServiceStorage{
  final String location;
  ServiceStorage({this.location});

  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadTask(File file) async {
    final uploadTask = _storage.ref(location);
    await uploadTask.putFile(file);
    String downloadUrl = await uploadTask.getDownloadURL();
    return downloadUrl;
  }

}