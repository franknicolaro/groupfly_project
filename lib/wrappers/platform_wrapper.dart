import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformWrapper extends StatefulWidget{
  @override
  _PlatformWrapperState createState() => _PlatformWrapperState();
}

class _PlatformWrapperState extends State<PlatformWrapper>{
  @override
  Widget build(BuildContext context){
    if(kIsWeb){
      //return WebWrapper();
      return Text("done");
    }
    else{
      //return MobileWrapper();
      return Text("done");
    }
  }
}