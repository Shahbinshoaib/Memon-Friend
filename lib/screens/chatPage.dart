import 'package:flutter/material.dart';
import 'package:memon_friend/models/user.dart';
import 'package:memon_friend/screens/chatPage2.dart';
import 'package:memon_friend/services/database.dart';
import 'package:memon_friend/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class ChatPage extends StatefulWidget {
  final UsersData usersData;

  const ChatPage({Key key, this.usersData}) : super(key: key);


  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  String _btnEmail;

  String image;
  final _formkey = GlobalKey<FormState>();
  String _message = '';
  String msgNo ;
  String count;
  double height;
  bool loader = false;

  var msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM').format(now);
    dynamic currentTime = DateFormat.jms().format(DateTime.now());
    dynamic currentTime2 = DateFormat.Hms().format(DateTime.now());
    String _date = '$currentTime - $formattedDate';

    // String filePath = 'images/${user.email}-${currentTime2}.png';


    // Future<void> _showAddImageDialog() async {
    //   return showDialog<void>(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         elevation: 0,
    //         backgroundColor: Colors.transparent,
    //         content: SingleChildScrollView(
    //           child: Column(
    //             children: <Widget>[
    //               Container(
    //                 color: Colors.transparent,
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: <Widget>[
    //                     FlatButton(
    //                       child: Image.asset('assets/camera.png',height: h*0.1,),
    //                       splashColor: Colors.white,
    //                       highlightColor: Colors.white,
    //                       onPressed: (){
    //                         Navigator.of(context).pop();
    //                         _pickImage(ImageSource.camera);
    //                       },
    //                     ),
    //                     FlatButton(
    //                       child: Image.asset('assets/upload2.png',height: h*0.1,),
    //                       splashColor: Colors.white,
    //                       highlightColor: Colors.white,
    //                       onPressed: (){
    //                         Navigator.of(context).pop();
    //                         _pickImage(ImageSource.gallery);
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }
    //

    return StreamBuilder<List<Chat>>(
      stream: DatabaseService(gmail: widget.usersData.email).chatData,
      builder: (context,snapshot){
        if(snapshot.hasData){

          List<Chat> chat = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.phone,color: Color(0xFFE39999),),
                  onPressed: (){
                    launch(
                        "tel://${03000000000}");
                  },
                ),
              ],
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.usersData.pic),
                  ),
                  SizedBox(width: 5,),
                  Container(
                      width: w*0.35,
                      child: Text(widget.usersData.name,style: TextStyle(fontSize: 16))),
                ],
              ),
            ),
            body: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height:  h*0.8,
                          width: w,
                          child: ListView.builder(
                            itemCount: chat.length,
                            reverse: true,
                            itemBuilder: (context,index){
                              return ChatPage2(chat: chat[index],);
                            },
                          ),
                        ),
                        Container(
                          height: h*0.0895,
                          width: w,
                        ),
                      ],
                    ),
                  ),

                  Align(
                      alignment: Alignment.bottomCenter,
                      child:  Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(95.0),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 60,
                          width: w,
                          // color: Colors.white,
                          child: Form(
                            key: _formkey,
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 20,),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration.collapsed(
                                        hintText: 'Type something'
                                    ),
                                    controller: msgController,
                                    textCapitalization: TextCapitalization.sentences,
                                    onChanged: (value){
                                      setState(() {
                                        _message =  value;
                                      });
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.send),
                                  iconSize: 25,
                                  color: Color(0xFFE39999),
                                  onPressed: ( _message == '') ? null : () async{
                                    Vibration.vibrate(amplitude: 50,duration: 40);
                                    // if(eTalkChat.length <= 9) {
                                    //   msgNo = '0000000'+eTalkChat.length.toString();
                                    // }else if(eTalkChat.length <= 99){
                                    //   msgNo = '000000'+eTalkChat.length.toString();
                                    // }else if(eTalkChat.length <= 999){
                                    //   msgNo = '00000'+eTalkChat.length.toString();
                                    // }else if(eTalkChat.length <= 9999){
                                    //   msgNo = '0000'+eTalkChat.length.toString();
                                    // }else if(eTalkChat.length <= 99999){
                                    //   msgNo = '000'+eTalkChat.length.toString();
                                    // }else if(eTalkChat.length <= 999999){
                                    //   msgNo = '00'+eTalkChat.length.toString();
                                    // }else if(eTalkChat.length <= 9999999){
                                    //   msgNo = '0'+eTalkChat.length.toString();
                                    // }else if(eTalkChat.length <= 99999999){
                                    //   msgNo = eTalkChat.length.toString();
                                    // }
                                    // if(int.parse(chatCounter.count) <= 8) {
                                    //   count = '000000000'+(int.parse(chatCounter.count)+1).toString();
                                    // }else if(int.parse(chatCounter.count) <= 98){
                                    //   count = '00000000'+(int.parse(chatCounter.count)+1).toString();
                                    // }else if(int.parse(chatCounter.count) <= 998){
                                    //   count = '0000000'+(int.parse(chatCounter.count)+1).toString();
                                    // }else if(int.parse(chatCounter.count) <= 9998){
                                    //   count = '000000'+(int.parse(chatCounter.count)+1).toString();
                                    // }else if(int.parse(chatCounter.count) <= 99998){
                                    //   count = '00000'+(int.parse(chatCounter.count)+1).toString();
                                    // }else if(int.parse(chatCounter.count) <= 999998){
                                    //   count = '0000'+(int.parse(chatCounter.count)+1).toString();
                                    // }else if(int.parse(chatCounter.count) <= 9999998){
                                    //   count = '000'+(int.parse(chatCounter.count)+1).toString();
                                    // }else if(int.parse(chatCounter.count) <= 99999998){
                                    //   count = '00'+(int.parse(chatCounter.count)+1).toString();
                                    // }else if(int.parse(chatCounter.count) <= 999999998){
                                    //   count = '0'+(int.parse(chatCounter.count)+1).toString();
                                    // }else if(int.parse(chatCounter.count) <= 9999999998){
                                    //   count = (int.parse(chatCounter.count)+1).toString();
                                    // }
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      msgController.clear();
                                    });
                                    await DatabaseService().updateChatData(_message, formattedDate, currentTime, widget.usersData.email, false, user.email, user.username);
                                    //await DatabaseService().updateChatData(_message, formattedDate, currentTime, student.gmail, widget.teacher, false, msgNo,user.email,student.name,'');
                                    setState(() {
                                      msgController.clear();
                                    });
                                    //await DatabaseService().updateChatCounter(count);
                                    //await DatabaseService().updateETalkStudentList(student.gmail, student.name, student.course, widget.teacher, student.pic, _date,count);
                                  },
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(95),
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        }else{
          return Loader();
        }
      },
    );
    // return StreamBuilder<ChatCounter>(
    //   stream: DatabaseService().chatCounterData,
    //   builder: (context,snapshot){
    //     if(snapshot.hasData){
    //       ChatCounter chatCounter = snapshot.data;
    //       return StreamBuilder<Student>(
    //         stream: DatabaseService(gmail: widget.teachergmail).studentData,
    //         builder: (context,snapshot){
    //           if(snapshot.hasData){
    //             Student teacher = snapshot.data;
    //             return StreamBuilder<Student>(
    //               stream: DatabaseService(gmail: widget.gmail).studentData,
    //               builder: (context,snapshot){
    //                 if(snapshot.hasData){
    //                   Student student = snapshot.data;
    //                   return StreamBuilder<List<ETalkChat>>(
    //                     stream: DatabaseService(gmail: widget.gmail).eTalkChatData,
    //                     builder: (context,snapshot){
    //                       if(snapshot.hasData){
    //                         List<ETalkChat> eTalkChat2 = snapshot.data;
    //                         final eTalkChat = eTalkChat2.reversed;
    //                         if(eTalkChat.length > 0){
    //                           return loader ? Loader() :
    //                         }else{
    //                           return Scaffold(
    //                             appBar: AppBar(
    //                               flexibleSpace: Container(
    //                                 decoration: BoxDecoration(
    //                                     gradient: LinearGradient(
    //                                         begin: Alignment.topLeft,
    //                                         end: Alignment.bottomRight,
    //                                         colors: <Color>[
    //                                           Colors.lightBlue,
    //                                           Colors.teal,
    //                                         ])
    //                                 ),
    //                               ),
    //                               actions: <Widget>[
    //                                 CircleAvatar(
    //                                   backgroundImage: AssetImage('assets/${image}',),
    //                                 ),
    //                                 SizedBox(width: 10,),
    //                               ],
    //                               leading: IconButton(
    //                                 icon: Icon(Icons.arrow_back_ios),
    //                                 onPressed: (){
    //                                   Navigator.pop(context);
    //                                 },
    //                               ),
    //                               title: Text(widget.teacher,),
    //                             ),
    //                             body: Container(
    //                               child: Column(
    //                                 mainAxisAlignment: MainAxisAlignment.end,
    //                                 children: <Widget>[
    //                                   Card(
    //                                     elevation: 10,
    //                                     shape: RoundedRectangleBorder(
    //                                       borderRadius: BorderRadius.circular(95.0),
    //                                     ),
    //                                     child: Container(
    //                                       padding: EdgeInsets.symmetric(horizontal: 8),
    //                                       height: 60,
    //                                       // color: Colors.white,
    //                                       child: Form(
    //                                         key: _formkey,
    //                                         child: Row(
    //                                           children: <Widget>[
    //                                             SizedBox(width: 20,),
    //                                             Expanded(
    //                                               child: TextFormField(
    //                                                 decoration: InputDecoration.collapsed(
    //                                                     hintText: student.isChatAllowed ? 'Send a message..' : 'You have been Blocked by Admin'
    //                                                 ),
    //                                                 controller: msgController,
    //                                                 textCapitalization: TextCapitalization.sentences,                                                          onChanged: (value){
    //                                                 setState(() {
    //                                                   _message =  value;
    //                                                 });
    //                                               },
    //                                               ),
    //                                             ),
    //                                             IconButton(
    //                                               icon: Icon(Icons.send),
    //                                               iconSize: 25,
    //                                               color: Colors.teal,
    //                                               onPressed: ( _message == '' && _imageFile == null) || (!student.isChatAllowed) ? null : () async{
    //                                                 Vibration.vibrate(amplitude: 128,duration: 100);
    //                                                 if(int.parse(chatCounter.count) <= 8) {
    //                                                   count = '000000000'+(int.parse(chatCounter.count)+1).toString();
    //                                                 }else if(int.parse(chatCounter.count) <= 98){
    //                                                   count = '00000000'+(int.parse(chatCounter.count)+1).toString();
    //                                                 }else if(int.parse(chatCounter.count) <= 998){
    //                                                   count = '0000000'+(int.parse(chatCounter.count)+1).toString();
    //                                                 }else if(int.parse(chatCounter.count) <= 9998){
    //                                                   count = '000000'+(int.parse(chatCounter.count)+1).toString();
    //                                                 }else if(int.parse(chatCounter.count) <= 99998){
    //                                                   count = '00000'+(int.parse(chatCounter.count)+1).toString();
    //                                                 }else if(int.parse(chatCounter.count) <= 999998){
    //                                                   count = '0000'+(int.parse(chatCounter.count)+1).toString();
    //                                                 }else if(int.parse(chatCounter.count) <= 9999998){
    //                                                   count = '000'+(int.parse(chatCounter.count)+1).toString();
    //                                                 }else if(int.parse(chatCounter.count) <= 99999998){
    //                                                   count = '00'+(int.parse(chatCounter.count)+1).toString();
    //                                                 }else if(int.parse(chatCounter.count) <= 999999998){
    //                                                   count = '0'+(int.parse(chatCounter.count)+1).toString();
    //                                                 }else if(int.parse(chatCounter.count) <= 9999999998){
    //                                                   count = (int.parse(chatCounter.count)+1).toString();
    //                                                 }
    //                                                 setState(() {
    //                                                   msgController.clear();
    //                                                 });
    //                                                 await DatabaseService().updateETalkChatData(_message, formattedDate, currentTime, student.gmail, widget.teacher, false, '00000000',user.email,student.name,'');
    //                                                 setState(() {
    //                                                   _message = '';
    //                                                 });
    //                                                 await DatabaseService().updateETalkStudentList(student.gmail, student.name, student.course, widget.teacher, student.pic, _date,count);
    //                                                 await DatabaseService().updateChatCounter(count);
    //                                               },
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       decoration: BoxDecoration(
    //                                         borderRadius: BorderRadius.circular(95),
    //                                         color: Colors.white,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                           );
    //                         }
    //                       }else{
    //                         return Loader();
    //                       }
    //                     },
    //                   );
    //                 }else{
    //                   return Loader();
    //                 }
    //               },
    //             );
    //           }else{
    //             return Loader();
    //           }
    //         },
    //       );
    //     }else{
    //       return Loader();
    //     }
    //   },
    // );
  }

// void _showZoomImage(BuildContext context){
//   Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (ctx) => Scaffold(
//           body: Hero(
//             tag: '',
//             child: PhotoView(
//               imageProvider: FileImage(_imageFile),
//               maxScale: 10.0,
//             ),
//             //child: Image.file(_imageFile),
//           ),
//         ),
//       )
//   );
// }


}
