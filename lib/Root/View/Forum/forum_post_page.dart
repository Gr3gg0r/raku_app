import 'package:flutter/material.dart';

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

class PostItem extends StatelessWidget {
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
            child: Center(
              child: Icon(
                Icons.add_a_photo,
                size: height * 0.05,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          maxLines: null,
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
            onPressed: (){},
            color: Colors.orange,
          ),
        )
      ]),
    );
  }
}
