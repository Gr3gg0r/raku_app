import 'package:flutter/material.dart';
import 'package:raku_app/shared/screensize.dart';

class DashboardPage extends StatelessWidget {

  Widget CustomCard(){
    return Card(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(8),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: ScreenSize(context).width(),
            height: ScreenSize(context).high()*0.1,
            color: Colors.red,
          )
        ],
      ),
    );
  }
}
