import 'package:flutter/material.dart';
import 'package:raku_app/Root/View/Messenger/chat_friends.dart';

class ChatHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Messenger Home"),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("CHAT"),
              ),
              Tab(
                child: Text("FRIENDS"),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CustomFriends(),
            ChatFriends()
          ],
        ),
      ),
    );
  }
}

class CustomFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1610344389740-360295d620ce?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=658&q=80"
              ),
            ),
            title: Text("Shahfiq Shah"),
          ),
        )
      ],
    );
  }
}
