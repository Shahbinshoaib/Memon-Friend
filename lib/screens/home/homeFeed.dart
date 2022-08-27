import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memon_friend/models/user.dart';
import 'package:memon_friend/screens/addHomePost.dart';
import 'package:memon_friend/screens/home/HomePostComment.dart';
import 'package:memon_friend/services/auth.dart';
import 'package:memon_friend/services/database.dart';
import 'package:memon_friend/widgets/loader.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class HomeFeed extends StatefulWidget {
  final List<HomePagePost> homePagePost;

  const HomeFeed({Key key, this.homePagePost}) : super(key: key);
  @override
  _HomeFeedState createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  final AuthService _auth = AuthService();
  int _currentTabIndex = 0;
  File _imageFile;
  bool _isLoading = false;

  final List<String> product = ['1', '2', '3', '4', '5', '6', '7', '8'];

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://memon-friend.appspot.com');

  int _state = 1;
  StorageUploadTask _uploadTask;
  bool loader = false;

  Future<void> _pickImage(
      ImageSource source, UsersData user, String count) async {
    // ignore: deprecated_member_use
    File selected =
        await ImagePicker.pickImage(source: source, imageQuality: 50);
    setState(() {
      _imageFile = selected;
    });
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy.MM.dd').format(now);
    dynamic currentTime = DateFormat.Hms().format(DateTime.now());
    String _date = '$formattedDate-$currentTime';
    String filePath = 'status/${_date}-${user.email}.png';
    print('fdffssdffffff');
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
    });
    await DatabaseService().updateMyStatusData(
        user.name, user.email, user.pic, '${_date}-${user.email}', count);
    setState(() {
      _imageFile = null;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  dynamic result;
  final CloudStorageService _cloudStorageService = CloudStorageService();

  // _loadMorePosts() async {
  //   _isLoading = true;
  //   List<HomePagePost> morePosts = await APIService.instance
  //       .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
  //   List<Video> allVideos = _channel.videos..addAll(moreVideos);
  //   setState(() {
  //     _channel.videos = allVideos;
  //   });
  //   _isLoading = false;
  // }



  String _count;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy.MM.dd').format(now);
    dynamic currentTime = DateFormat.Hms().format(DateTime.now());
    String _date = '$formattedDate-$currentTime';

    _buildHomePost(HomePagePost homePagePost) async {
      if (homePagePost.image == '') {
      } else {
        result = await _cloudStorageService.downloadImage(homePagePost.image);
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
        child: Container(
          //height: widget.homePagePost.image == '' ? h*0.23 : h * 0.5,
          width: w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                Container(
                  //height: h * 0.07,
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              //radius: 20.0,
                              backgroundImage: NetworkImage(homePagePost.pic ==
                                      ''
                                  ? 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'
                                  : homePagePost.pic),
                            ),
                          ),
                          Text(
                            homePagePost.name,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.more_horiz, color: Color(0xFFE39999)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                homePagePost.image == ''
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                            width: w * 0.9,
                            child: Text(
                              homePagePost.postText,
                              style: TextStyle(fontSize: 17),
                            )),
                      )
                    : Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  homePagePost.postText,
                                  textAlign: TextAlign.left,
                                )),
                          ),
                          Image.network(
                            result.toString(),
                            height: h * 0.3,
                          ),
                        ],
                      )),
                HomePostComment(homePagePost: homePagePost,),
              ],
            ),
          ),
        ),
      );
    }

    Future<void> _showlogoutDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to logout?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'LOGOUT',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    return StreamBuilder<UsersData>(
      stream: DatabaseService(gmail: user.email).usersIndividualData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UsersData usersData = snapshot.data;

          return StreamBuilder<List<Status>>(
            stream: DatabaseService().statusData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Status> status = snapshot.data;

                if (status.length <= 9) {
                  _count = '00000000000000000' + status.length.toString();
                } else if (status.length <= 99) {
                  _count = '0000000000000000' + status.length.toString();
                } else if (status.length <= 999) {
                  _count = '000000000000000' + status.length.toString();
                } else if (status.length <= 9999) {
                  _count = '00000000000000' + status.length.toString();
                } else if (status.length <= 99999) {
                  _count = '0000000000000' + status.length.toString();
                } else if (status.length <= 999999) {
                  _count = '000000000000' + status.length.toString();
                } else if (status.length <= 9999999) {
                  _count = '00000000000' + status.length.toString();
                } else if (status.length <= 99999999) {
                  _count = '0000000000' + status.length.toString();
                } else if (status.length <= 999999999) {
                  _count = '000000000' + status.length.toString();
                } else if (status.length <= 9999999999) {
                  _count = '00000000' + status.length.toString();
                } else if (status.length <= 99999999999) {
                  _count = '0000000' + status.length.toString();
                } else if (status.length <= 999999999999) {
                  _count = '000000' + status.length.toString();
                } else if (status.length <= 9999999999999) {
                  _count = '00000' + status.length.toString();
                } else if (status.length <= 99999999999999) {
                  _count = '0000' + status.length.toString();
                } else if (status.length <= 999999999999999) {
                  _count = '000' + status.length.toString();
                } else if (status.length <= 9999999999999999) {
                  _count = '00' + status.length.toString();
                } else if (status.length <= 99999999999999999) {
                  _count = '0' + status.length.toString();
                } else if (status.length <= 99999999999999999) {
                  _count = status.length.toString();
                }
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: Text('Feed'),
                    centerTitle: true,
                    elevation: 1,
                    backgroundColor: Colors.white,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.add, color: Color(0xFFE39999)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: AddHomePostPage(
                                      usersData: usersData,
                                      count: widget.homePagePost.length)));
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.more_horiz, color: Color(0xFFE39999)),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                  body: Container(
                    color: Colors.grey[100],
                    child: ListView.builder(
                      itemCount: 1 + widget.homePagePost.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Container(
                              height: h * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Container(
                                  height: h * 0.1,
                                  child: ListView.builder(
                                    itemCount: 1 + status.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ButtonTheme(
                                            child: RaisedButton(
                                              color: Colors.grey[200],
                                              child: Icon(
                                                Icons.add,
                                                size: h * 0.04,
                                              ),
                                              onPressed: () {
                                                _pickImage(ImageSource.camera,
                                                    usersData, _count);
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        255.0),
                                              ),
                                            ),
                                            height: h * 0.08,
                                            minWidth: h * 0.08,
                                          ),
                                        );
                                      }
                                      Status _status = status[index - 1];
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Material(
                                            type: MaterialType
                                                .transparency, //Makes it usable on any background color, thanks @IanSmith
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey[400],
                                                    width: 4.0),
                                                color: Color(0xFFE39998),
                                                shape: BoxShape.circle,
                                              ),
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(
                                                    1000.0), //Something large to ensure a circle
                                                onTap: () async {
                                                  result =
                                                      await _cloudStorageService
                                                          .downloadStatus(
                                                              _status.status);
                                                  _showZoomImage(context,
                                                      result.toString());
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(_status
                                                                      .pic ==
                                                                  ''
                                                              ? 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'
                                                              : _status.pic)),
                                                ),
                                              ),
                                            )),
                                      );
                                    },
                                  )),
                            ),
                          );
                        }
                        HomePagePost homePagePost =
                            widget.homePagePost[index - 1];
                        return FutureBuilder<dynamic>(
                            future: _buildHomePost(homePagePost),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) return snapshot.data;

                              return Container(
                                  child: LinearProgressIndicator(
                                minHeight: 1,
                              ));
                            });
                      },
                    ),
                  ),

                  // drawer: Container(
                  //   child: Drawer(
                  //     child: Container(
                  //       child: ListView(
                  //         padding: EdgeInsets.zero,
                  //         children: <Widget>[
                  //           drawerHeader,
                  //           ListTile(
                  //             leading: Icon(Icons.account_circle),
                  //             title: Text('Profile'),
                  //             onTap: () {
                  //               //createInterstitialAd()..load()..show();
                  //              // Navigator.of(context).push(_NewPage1(1));
                  //               },
                  //           ),
                  //           ListTile(
                  //             leading: Icon(Icons.settings),
                  //             title: Text('Settings'),
                  //            // onTap: () => Navigator.of(context).push(_NewPage2(2)),
                  //           ),
                  //           ListTile(
                  //             leading: Icon(Icons.exit_to_app),
                  //             title: Text('Logout'),
                  //             onTap: () {
                  //               setState(() {
                  //                 Navigator.pop(context);
                  //                 _showlogoutDialog();
                  //               });
                  //             },
                  //           ),
                  //           Divider(
                  //             thickness: 1.0,
                  //           ),
                  //           ListTile(
                  //             leading: Icon(Icons.info),
                  //             title: Text('About'),
                  //             //onTap: () => Navigator.of(context).push(_NewPage3(3)),
                  //           ),
                  //           user.email == 'shahbinshoaib@gmail.com' ?
                  //           ListTile(
                  //             leading: Icon(Icons.devices),
                  //             title: Text('Admin Panel'),
                  //             onTap: () {
                  //               setState(() {
                  //                // Navigator.pop(context);
                  //                 //_showMyDialog();
                  //               });
                  //             },
                  //           ) : ListTile(),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                );
              } else {
                return Loader();
              }
            },
          );
        } else {
          return Loader();
        }
      },
    );
  }

  void _showZoomImage(BuildContext context, String link) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
              body: Stack(
                children: [
                  Loader(),
                  Hero(
                    tag: '',
                    child: PhotoView(
                      imageProvider: NetworkImage(link),
                      maxScale: 10.0,
                    ),
                  ),
                ],
              ),
            )));
  }
}

class CloudStorageService {
  StorageReference reference = FirebaseStorage.instance.ref();

  Future deleteImage(String image) async {
    final StorageReference reference =
        FirebaseStorage.instance.ref().child(image);
    try {
      await reference.delete();
    } catch (e) {
      return e.toString();
    }
  }

  Future downloadImage(String picture) async {
    try {
      String downloadAddress =
          await reference.child('images/${picture}.png').getDownloadURL();
      return downloadAddress;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future downloadStatus(String picture) async {
    try {
      String downloadAddress =
          await reference.child('status/${picture}.png').getDownloadURL();
      return downloadAddress;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
