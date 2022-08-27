import 'package:flutter/material.dart';
import 'package:memon_friend/screens/home/HomeFeed.dart';
import 'package:memon_friend/services/database.dart';
import 'package:memon_friend/widgets/loader.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {


    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return StreamBuilder<List<UsersData>>(
      stream: DatabaseService().usersData,
      builder: (context,snapshot){
        if(snapshot.hasData){

          List<UsersData> usersData = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text('Friends',style: TextStyle(fontWeight: FontWeight.bold),),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.add,color: Color(0xFFE39999)),
                  onPressed: (){

                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz,color: Color(0xFFE39999)),
                  onPressed: (){

                  },
                ),
              ],
            ),
            body: Container(
              height: h,
              width: w,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 15, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Friends Request',style: TextStyle(fontSize: h*0.018,fontWeight: FontWeight.bold,color: Colors.black45),),
                        FlatButton(
                          child: Text('Show all',style: TextStyle(fontSize: h*0.015,fontWeight: FontWeight.bold,color: Colors.black45),),
                          onPressed: (){

                          },
                        ),
                      ],
                    ),
                    Container(
                      height: h*0.365,
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context,index){
                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  //radius: 20.0,
                                  backgroundImage:
                                  AssetImage('assets/user.png'),
                                ),
                                title: Text('User Name',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: h*0.02),),
                                subtitle: Text('7 mutual friends',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: h*0.014),),
                                trailing: Container(
                                  height: h*.1,
                                  width: w*0.24,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.check_circle,size: 25,color: Color(0xFFE39999),),
                                        onPressed: (){

                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.cancel,size: 25,color: Colors.black45,),
                                        onPressed: (){

                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Suggest Friends',style: TextStyle(fontSize: h*0.018,fontWeight: FontWeight.bold,color: Colors.black45),),
                        FlatButton(
                          child: Text('Show all',style: TextStyle(fontSize: h*0.015,fontWeight: FontWeight.bold,color: Colors.black45),),
                          onPressed: (){

                          },
                        ),
                      ],
                    ),
                    Container(
                      height: h*0.349,
                      child: ListView.builder(
                        itemCount: usersData.length,
                        itemBuilder: (context,index){
                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  //radius: 20.0,
                                  backgroundImage:
                                  NetworkImage(usersData[index].pic == '' ? 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png' : usersData[index].pic),
                                ),
                                title: Text(usersData[index].name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: h*0.02),),
                                subtitle: Text(usersData[index].email,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: h*0.014),),
                                trailing: OutlineButton(
                                  onPressed:  (){
                                    // _showAddTeacher();
                                  },
                                  child: Text(
                                    "Follow",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Color(0xFFE39999)
                                    ),
                                  ),
                                  shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                                  borderSide: BorderSide(width: 1.0, color: Color(0xFFE39999)),
                                  splashColor: Color(0xFFE39999),
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        },
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
