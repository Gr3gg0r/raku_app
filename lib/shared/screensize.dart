
import 'package:flutter/cupertino.dart';

class ScreenSize {
  final BuildContext context;
  ScreenSize(this.context);


  double high(){
    return MediaQuery.of(context).size.height;
  }

  double width(){
    return MediaQuery.of(context).size.width;
  }

}