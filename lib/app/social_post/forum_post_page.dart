import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:raku_app/model/user_auth.dart';
import 'package:raku_app/services/service_storage.dart';

class ForumPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

  String _content, _warning = "";

  Future getImageFrom(selection, context) async {
    PickedFile pickedFile;
    if (selection) {
      if (await Permission.camera.request().isGranted)
        pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      if (await Permission.storage.request().isGranted)
        pickedFile = await picker.getImage(source: ImageSource.gallery);
    }

    if (pickedFile != null)
      setState(() {
        _image = File(pickedFile.path);
        _warning = "";
      });
    Navigator.pop(context);
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose from"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  RaisedButton(
                    color: Colors.deepPurpleAccent,
                    child: Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => getImageFrom(true, context),
                  ),
                  Text(
                    "OR",
                    textAlign: TextAlign.center,
                  ),
                  RaisedButton(
                    color: Colors.deepPurpleAccent,
                    child: Text(
                      "Gallery",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => getImageFrom(false, context),
                  )
                ],
              ),
            ),
          );
        });
  }

  void verifyData(UserProfile userProfile) {
    setLoading();
    if (_content == null)
      setLoading(text: "Please enter some content");
    else
      _addData(userProfile);
  }

  void _addData(UserProfile userProfile) async {
    if (_content == null) {
      setLoading(text: "Please write captions.");
    } else {
      final String uniqueid =
          FirebaseFirestore.instance.collection("ForumPost").doc().id;
      String _downloadUrl =
          await ServiceStorage(location: "ForumPost/$uniqueid")
              .uploadTask(_image);
      FirebaseFirestore.instance
          .collection("SocialPost")
          .doc(uniqueid)
          .set({
            "image_url": _downloadUrl,
            "content": _content,
            "postId": uniqueid,
            "owner_id" : userProfile.uid
          })
          .whenComplete(() => Navigator.pop(context))
          .catchError((e) =>
              setLoading(text: "An error occurred ! Check your connection!"));
    }
  }

  void setLoading({text}) {
    setState(() {
      _loading = !_loading;
      _warning = text ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userProfile = Provider.of<UserProfile>(context);
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
            decoration: _image != null
                ? BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_image),
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
            child: _image != null
                ? null
                : Center(
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
          onChanged: (val) => _content = val,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: "Say something..."),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: width * 0.5,
          child: RaisedButton(
            child: Text("Post"),
            onPressed: ()=>verifyData(userProfile),
            color: Colors.orange,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "$_warning",
          style: TextStyle(color: Colors.red),
        ),
      ]),
    );
  }
}
