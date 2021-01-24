
import 'package:cloud_firestore/cloud_firestore.dart';

class DBController {
  final String collection;
  final String docu;
  DBController({this.collection,this.docu});

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> get data {
     return _firestore.collection(collection).doc(docu).snapshots();
  }
  
  Exception addData(Object abc){
   try{
     _firestore.collection(collection).doc(docu).set(abc);
     return null;
   }catch(e){
     return e;
   }
  }

}