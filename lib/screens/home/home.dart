import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:memon_friend/models/user.dart';
import 'package:memon_friend/screens/home/friends.dart';
import 'package:memon_friend/screens/home/homeFeed.dart';
import 'package:memon_friend/screens/home/messages.dart';
import 'package:memon_friend/screens/home/profile.dart';
import 'package:memon_friend/screens/home/setting.dart';
import 'package:memon_friend/services/auth.dart';
import 'package:memon_friend/services/database.dart';
import 'package:provider/provider.dart';



const String testDevice = '';

class NavDrawerExample extends StatefulWidget {
  final List<HomePagePost> homePagePost;

  const NavDrawerExample({Key key, this.homePagePost}) : super(key: key);

  @override
  _NavDrawerExampleState createState() => _NavDrawerExampleState();
}

class _NavDrawerExampleState extends State<NavDrawerExample> {

  int _currentTabIndex = 0;




  @override
  Widget build(BuildContext context) {


    final _kTabPages = <Widget>[
      HomeFeed(homePagePost: widget.homePagePost,),
      Friends(),
      Messages(),
      //Setting(),
      Profile(),
    ];
    final _kBottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.local_fire_department_sharp), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
      const BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
      //const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
      const BottomNavigationBarItem(icon: Icon(Icons.account_circle_sharp), label: 'Profile'),
    ];
    //assert(_kTabPages.length == _kBottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: _kBottmonNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );

    return Scaffold(
      body: _kTabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );

  }
}

