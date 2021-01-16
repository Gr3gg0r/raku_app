import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:raku_app/Root/Controller/db_controller.dart';
import 'package:raku_app/Root/Controller/storage.dart';

class ForumPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Forum"),
        centerTitle: true,
      ),
      body: PostItem(),
    );
  }
}

class PostItem extends StatefulWidget {

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {

  File _image;
  bool _loading = false;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String _content,_warning="";

  Future getImageFrom(selection,context) async {
    PickedFile pickedFile;
    if(selection){
      if(await Permission.camera.request().isGranted)
        pickedFile = await picker.getImage(source: ImageSource.camera);
    }else{
      if(await Permission.storage.request().isGranted)
        pickedFile = await picker.getImage(source: ImageSource.gallery);
    }

    if(pickedFile != null)
      setState(() {
        _image = File(pickedFile.path);
        _warning="";
      });
    Navigator.pop(context);
  }

  Future<void> _showDialog() async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Choose from"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                RaisedButton(
                  color: Colors.deepPurpleAccent,
                  child: Text("Camera",style: TextStyle(
                      color: Colors.white
                  ),),
                  onPressed:() => getImageFrom(true,context),
                ),
                Text("OR",textAlign: TextAlign.center,),
                RaisedButton(
                  color: Colors.deepPurpleAccent,
                  child: Text("Gallery",style: TextStyle(
                      color: Colors.white
                  ),),
                  onPressed: () => getImageFrom(false,context),
                )              ],
            ),
          ),
        );
      }
    );
  }

  void verifyData(){
    setLoading();
    if (_content==null)
      setLoading(text: "Please enter some content");
    else
      _addData();
  }

  void _addData() async {
    if(_content==null){
      setLoading(text: "Please write captions.");
    }else{
      final String uniqueid = FirebaseFirestore.instance.collection("ForumPost").doc().id;
      String _downloadUrl = await StorageService(location: "ForumPost/$uniqueid").uploadTask(_image);
      Exception status = DBController(collection: "UserProfile",docu: uniqueid).addData({
        "image_url" : _downloadUrl,
        "content" : _content,
        "postId": uniqueid,
      });
      if(status==null){
        Navigator.pop(context);
      }else{
        setLoading(text: "An error occurred ! Check your connection!");
        print(status.toString());
      }
    }
  }

  void setLoading({text}){
    setState(() {
      _loading = !_loading;
      _warning = text??"";
    });
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Card(
          child: Container(
            width: width,
            height: height * 0.3,
            decoration:_image!=null? BoxDecoration(
              image: DecorationImage(
                image: FileImage(_image),
                fit: BoxFit.cover,
              ),
            ):null,
            child:_image!=null?null: Center(
              child: IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  size: height * 0.05,
                ),
                onPressed: _showDialog,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          maxLines: null,
          onChanged: (val) => _content=val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Say something..."
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: width*0.5,
          child: RaisedButton(
            child: Text("Post"),
            onPressed: verifyData,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 10,),
        Text("$_warning",style: TextStyle(color: Colors.red),),
      ]),
    );
  }
}
