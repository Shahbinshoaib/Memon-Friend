import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memon_friend/authenticate/authenticate.dart';
import 'package:memon_friend/models/user.dart';
import 'package:memon_friend/screens/home/home.dart';
import 'package:memon_friend/services/database.dart';
import 'package:memon_friend/widgets/loader.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    // return either home or authenticate
    if (user == null){
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      );
      return Authenticate();
    } else {
      return StreamBuilder<List<HomePagePost>>(
          stream: DatabaseService().homePagePostData,
          builder: (context,snapshot){
            if(snapshot.hasData){
              List<HomePagePost> homePagePost = snapshot.data;

              return NavDrawerExample(homePagePost: homePagePost);
            }else{
              return Loader();
            }
          },
      );
    }
  }
}

