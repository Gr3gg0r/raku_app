import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:raku_app/model/user_auth.dart';

class ServiceFirestore {
  final String uid;
  final String document;
  ServiceFirestore({this.document, @required this.uid});

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // UserProfile Database Service start here
  Stream<UserProfile> get userProfile {
    return _firestore
        .collection("UserProfile")
        .doc(uid)
        .snapshots()
        .map((event) => UserProfile.fromMap(event.data()));
  }

  Stream<QuerySnapshot> get userProfileAll {
    return _firestore.collection("UserProfile").snapshots();
  }

  Future<void> addData(Object abc) {
    return _firestore.collection("UserProfile").doc(uid).set(abc);
  }

  //Social page service start her


}
