import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raku_app/app/social_post/forum_post_page.dart';
import 'package:raku_app/app/messenger/chat_home.dart';
import 'package:raku_app/model/user_auth.dart';
import 'package:raku_app/shared/loading_view.dart';

import 'forum_comments.dart';

class ForumHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum Home"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.messenger),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatHome(),
              ),
            ),
          ),
        ],
      ),
      body: PostList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ForumPostPage())),
      ),
    );
  }
}

class PostList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection("SocialPost").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if(snapshot.data.docs.isNotEmpty)
          return ListView(
            children: snapshot.data.docs
                .map((data) => CustomPost(
                      snapshot: data,
                    ))
                .toList(),
          );
          return Center(
            child: Text("No Post Yet ..."),
          );
        }
        return LoadingPage();
      },
    );
  }
}

class CustomPost extends StatelessWidget {
  final DocumentSnapshot snapshot;
  CustomPost({@required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 3),
          child: GestureDetector(
            child: Card(
              child: Container(
                height: height * 0.4,
                width: width,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.4 * 0.8,
                      width: width,
                      child: Image.network(
                        snapshot.data()['image_url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    OwnerSection(
                      doc: snapshot,
                    )
                  ],
                ),
              ),
            ),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => CommentView(snapshot: snapshot,))),
          ),
        )
      ],
    );
  }
}

class OwnerSection extends StatelessWidget {
  final DocumentSnapshot doc;
  OwnerSection({@required this.doc});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = Provider.of<UserProfile>(context);
    final height = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: _firestore
          .collection("UserProfile")
          .doc(doc.data()['owner_id'])
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Container(
            height: height * 0.4 * 0.2,
            child: Center(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(snapshot.data.data()['image_url']),
                ),
                title: Text(snapshot.data.data()['username']),
                subtitle: Text(doc.data()['content']),
                trailing: doc.data()['owner_id'] == snapshot.data.id
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _firestore
                            .collection("SocialPost")
                            .doc(doc.id)
                            .delete(),
                      )
                    : null,
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
