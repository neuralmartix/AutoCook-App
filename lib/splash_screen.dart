import 'package:derek_zhu/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State createState() => _State();
}

class _State extends State{

  @override
  Widget build(context) {

    Future.delayed(
        const Duration(seconds: 3),
        (){
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false
            );
        }
    );

    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          height: 250,
          width: 250,
        ),
      )
    );
  }

}