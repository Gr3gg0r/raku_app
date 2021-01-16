import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:raku_app/Root/Controller/db_controller.dart';
import 'package:raku_app/Root/Controller/storage.dart';

class NewUser extends StatelessWidget {
  final String uid;
  NewUser({this.uid});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("New User Registration"),centerTitle: true,),
      body: Center(
        child: CustomForm(height: height,width: width,uid: uid,),
      ),
    );
  }
}



class CustomForm extends StatefulWidget {
  final width,height,uid;
  CustomForm({this.width,this.height,this.uid});
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {

  File _image;
  bool loading = false;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String username,user_card,user_phone,masalah;

  Future getImageFrom(selection,context) async{
    PickedFile pickedFile ;
    if(selection){
      if(await Permission.camera.request().isGranted){
        pickedFile = await picker.getImage(source: ImageSource.camera);
      }
    }else{
      if(await Permission.storage.request().isGranted){
        pickedFile = await picker.getImage(source: ImageSource.gallery);
      }
    }
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose from'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void CheckData(){
    if(_formKey.currentState.validate()){
      addData();
    }
  }

  void setLoading({text}){
    setState(() {
      loading = !loading;
      masalah = text??null;
    });
  }


  void addData() async{
    setLoading();
    if(_image!=null){
      String downloadUrl = await StorageService(location: "UserProfile/${widget.uid}").uploadTask(_image);
      Exception status = DBController(collection: "UserProfile",docu: widget.uid).addData({
        "image_url" : downloadUrl,
        "username" : username,
        "researcher_id" : user_card,
        "contact_no" : user_phone,
        "uid" : widget.uid,
      });
      if(status==null){
        setLoading();
      }else{
        setLoading(text: "An error occurred ! Check your connection!");
        print(status.toString());
      }
    }else{
      setLoading(text: "Please select profile picture!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: widget.height * 0.03),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              minRadius: 50,
              maxRadius: 100,
              backgroundColor: Colors.orangeAccent,
              backgroundImage: _image!=null? FileImage(_image):null,
              child: Center(
                child: IconButton(
                  icon: _image!=null?Container():Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _image==null?_showMyDialog:(){},
                ),
              ),
            ),
          ),
          SizedBox(height: widget.height * 0.03),
          Container(
            width: 0.8 * widget.width,
            color: Colors.white,
            child: TextFormField(
              onChanged: (val) => username = val,
              validator: (val){
                if(val.isEmpty){
                  return "Please enter your name";
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purpleAccent,width: 5.0),
                ),
                labelText: "Researcher Name",
                prefixIcon: Icon(Icons.person),
                hoverColor: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: widget.height * 0.01),
          Container(
            width: 0.8 * widget.width,
            color: Colors.white,
            child: TextFormField(
              validator: (val){
                if(val.isEmpty){
                  return "Researcher ID Card";
                }
                return null;
              },
              onChanged: (val) => user_card = val,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purpleAccent,width: 5.0),
                ),
                labelText: "Your researcher card id",
                prefixIcon: Icon(Icons.assignment),
              ),
            ),
          ),
          SizedBox(height: widget.height * 0.01),
          Container(
            width: 0.8 * widget.width,
            color: Colors.white,
            child: TextFormField(
              validator: (val){
                if(val.isEmpty){
                  return "Please key in phone number";
                }
                return null;
              },
              onChanged: (val) => user_phone = val,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purpleAccent,width: 5.0),
                ),
                labelText: "Researcher Phone Number",
                prefixIcon: Icon(Icons.call),
              ),
            ),
          ),
          SizedBox(height: widget.height * 0.03),
          Container(
            height: widget.height * 0.05,
            width: 0.5 * widget.width,
            child:!loading?RaisedButton(
              color: Colors.deepOrangeAccent,
              child: Text("CONFIRM",style: TextStyle(
                  color: Colors.white
              ),),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              onPressed: CheckData,
            ):Center(
              child: CircularProgressIndicator(),
            ),
          ),
          SizedBox(height: widget.height * 0.01),
          Text(masalah??"",style: TextStyle(color: Colors.red),)
        ],
      ),
    );
  }
}
