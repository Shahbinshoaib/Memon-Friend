import 'package:flutter/material.dart';
import 'package:memon_friend/screens/chatPage.dart';
import 'package:memon_friend/services/database.dart';
import 'package:memon_friend/widgets/loader.dart';
import 'package:page_transition/page_transition.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return StreamBuilder<List<UsersData>>(
      stream: DatabaseService().usersData,
      builder: (conttext,snapshot){
        if(snapshot.hasData){

          List<UsersData> usersData = snapshot.data;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
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
                    Text('Messages',style: TextStyle(fontSize: h*0.05,fontWeight: FontWeight.bold),),
                    Container(
                      height: h*0.765,
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
                                  NetworkImage(usersData[index].pic),
                                ),
                                title: Text(usersData[index].name,style: TextStyle(color: Color(0xFFE39998),fontWeight: FontWeight.bold),),
                                subtitle: Text('Test',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                trailing: Column(
                                  children: [
                                    Text('23 min'),
                                    SizedBox(height: 8,),
                                    Container(
                                      height: 25,
                                      width: 25,
                                      child: Center(child: Text('1')),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color(0xFFE39998),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ChatPage(usersData: usersData[index],)));
                                },
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
