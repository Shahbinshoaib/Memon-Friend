import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memon_friend/models/user.dart';
import 'package:memon_friend/screens/loading.dart';
import 'package:memon_friend/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    Map<int, Color> color =
    {
      50:Color.fromRGBO(253,170,171, .1),
      100:Color.fromRGBO(253,170,171, .2),
      200:Color.fromRGBO(253,170,171, .3),
      300:Color.fromRGBO(253,170,171, .4),
      400:Color.fromRGBO(253,170,171, .5),
      500:Color.fromRGBO(253,170,171, .6),
      600:Color.fromRGBO(253,170,171, .7),
      700:Color.fromRGBO(253,170,171, .8),
      800:Color.fromRGBO(253,170,171, .9),
      900:Color.fromRGBO(253,170,171, 1),
    };

    MaterialColor colorCustom = MaterialColor(0xFFE39999, color);

    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp,DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Memon_Friend',
        theme: ThemeData(
          primarySwatch: colorCustom,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        home: Loading(),
      ),
    );
  }
}
