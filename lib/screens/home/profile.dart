import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memon_friend/models/user.dart';
import 'package:memon_friend/services/auth.dart';
import 'package:memon_friend/services/database.dart';
import 'package:memon_friend/widgets/loader.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final AuthService _auth = AuthService();
  File imageFile;


  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile.path);
  }

  /// Crop Image
  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
  }

  static const menuItems = <String>[
    'Logout',
  ];
  final List<PopupMenuItem<String>> _popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
           child: Text(value),
    ),
  ).toList();

  String _btnEmail;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return StreamBuilder<UsersData>(
      stream: DatabaseService(gmail: user.email).usersIndividualData,
      builder: (context,snapshot){
        if (snapshot.hasData){

          UsersData usersData = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                // IconButton(
                //   icon: Icon(Icons.add,color: Color(0xFFE39999)),
                //   onPressed: (){
                //
                //   },
                // ),
                PopupMenuButton<String>(
                  onSelected: (String newValue) async {
                    _btnEmail = newValue;
                    if (_btnEmail == 'Logout') {
                      await _auth.signOut();
                    } else {
                    }
                    print(_btnEmail);
                  },
                  itemBuilder: (BuildContext context) =>
                  _popUpMenuItems,
                ),
              ],
            ),
            body: Container(
              height: h,
              width: w,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Profile',style: TextStyle(fontSize: h*0.05,fontWeight: FontWeight.bold),)),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: h*0.1,
                            backgroundImage:
                           NetworkImage(usersData.pic == '' ? 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png' : usersData.pic),
                          ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt,color: Color(0xFFE39999),size: 35,),
                              onPressed: (){
                                _getFromGallery();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(usersData.name,style: TextStyle(fontSize: h*0.024,fontWeight: FontWeight.bold),),
                    SizedBox(height: h*0.01,),
                    Text(usersData.email,style: TextStyle(fontSize: h*0.02,color: Colors.black),),
                    SizedBox(height: h*0.01,),
                    Divider(),
                    SizedBox(height: h*0.01,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.person,color: Color(0xFFE39999),),
                              SizedBox(width: 15,),
                              Text('Father Name: ',style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(usersData.fName,style: TextStyle(fontSize: h*0.02,color: Colors.black),),
                            ],
                          ),
                          SizedBox(height: h*0.02,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.person,color: Color(0xFFE39999)),
                              SizedBox(width: 15,),
                              Text('G. Father Name: ',style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(usersData.gFName,style: TextStyle(fontSize: h*0.02,color: Colors.black),),
                            ],
                          ),
                          SizedBox(height: h*0.02,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.person,color: Color(0xFFE39999)),
                              SizedBox(width: 15,),
                              Text('Surname: ',style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(usersData.surname,style: TextStyle(fontSize: h*0.02,color: Colors.black),),
                            ],
                          ),

                          SizedBox(height: h*0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.phone,color: Color(0xFFE39999)),
                              SizedBox(width: 15,),
                              Text('Phone Number: ',style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(usersData.phone,style: TextStyle(fontSize: h*0.02,color: Colors.black),),
                            ],
                          ),
                          SizedBox(height: h*0.02,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.home,color: Color(0xFFE39999)),
                              SizedBox(width: 15,),
                              Text('Membership #: ',style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(usersData.member,style: TextStyle(fontSize: h*0.02,color: Colors.black),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }else{
          return Loader();
        }
      },
    );
  }
}
