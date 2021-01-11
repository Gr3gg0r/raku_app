import 'package:flutter/material.dart';
import 'package:raku_app/Root/View/Messenger/chat_home.dart';

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => print("Add Post"),
      ),
    );
  }
}
