
import 'package:flutter/material.dart';
import 'package:raku_app/Root/View/Forum/forum_post_page.dart';
import 'package:raku_app/Root/View/Messenger/chat_home.dart';

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
      body: CustomPost(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => ForumPostPage()
        )),
      ),
    );
  }
}

class CustomPost extends StatelessWidget {
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
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(

            child: Card(
              child: Container(
                height: height * 0.4,
                width: width,
                child: Column(
                  children: [
                    Container(
                      height: height*0.4*0.8,
                      child: Image.network(
                          "https://images.unsplash.com/photo-1606788073305-5f071cb80485?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1046&q=80",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: height*0.4*0.2,
                      child: Center(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage("https://images.unsplash.com/photo-1610194426904-0460481cf7b4?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80"),
                          ),
                          title: Text("Shahfiq Shah"),
                          subtitle: Text("Spending time with the only one who occupy my heart"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => CommentView()
            )),
          ),
        )
      ],
    );
  }
}
