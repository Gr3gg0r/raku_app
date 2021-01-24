import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:raku_app/shared/loading_view.dart';

class CommentView extends StatelessWidget {
  final DocumentSnapshot snapshot;
  CommentView({@required this.snapshot});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("SocialPost")
            .doc(snapshot.id)
            .collection("Comments")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data.docs.isNotEmpty) {
              return ListView(
                children: snapshot.data.docs
                    .map((e) => Card(
                          child: ListTile(
                            title: Text(e.data()['']),
                            subtitle: Text(e.data()['']),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(e.data()['']),
                            ),
                          ),
                        ))
                    .toList(),
              );
            }
            return Center(child: Text("No Comment"));
          }
          return LoadingPage();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){},
      ),
    );
  }
}
