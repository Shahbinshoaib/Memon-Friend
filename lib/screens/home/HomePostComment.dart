
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:file/local.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memon_friend/models/user.dart';
import 'package:memon_friend/services/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:audio_recorder/audio_recorder.dart';

class HomePostComment extends StatefulWidget {
  final HomePagePost homePagePost;
  final LocalFileSystem localFileSystem;

  HomePostComment({localFileSystem,this.homePagePost})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _HomePostCommentState createState() => _HomePostCommentState();
}

class _HomePostCommentState extends State<HomePostComment> {

  var msgController = TextEditingController();
  String _comment;
  bool _isComment = false;
  bool _showComment = false;
  bool _isRecording = false;
  String _count;
  bool isRecording = false;

  getPermission()async{
    bool hasPermissions = await AudioRecorder.hasPermissions;
  }

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy.MM.dd').format(now);
    dynamic currentTime = DateFormat.Hms().format(DateTime.now());
    String _date = '$formattedDate-$currentTime';

    Future<void> _showRecording() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: CircularCountDownTimer(
              // Countdown duration in Seconds
              duration: 10,

              // Width of the Countdown Widget
              width: MediaQuery.of(context).size.width / 2,

              // Height of the Countdown Widget
              height: MediaQuery.of(context).size.height / 2,

              // Default Color for Countdown Timer
              color: Colors.white,

              // Filling Color for Countdown Timer
              fillColor: Colors.red,

              // Border Thickness of the Countdown Circle
              strokeWidth: 5.0,

              // Text Style for Countdown Text
              textStyle: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),

              // true for reverse countdown (max to 0), false for forward countdown (0 to max)
              isReverse: false,

              // Function which will execute when the Countdown Ends
              onComplete: () {
                // Here, do whatever you want
                print('Countdown Ended');
              },
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.stop_circle),
                    color: Colors.red[800],
                    onPressed: (){

                    },
                  ),
                  Text('Are you sure you want to logout?'),
                ],
              ),
            ),
          );
        },
      );
    }


    return StreamBuilder(
      stream: DatabaseService(gmail: user.email).usersIndividualData,
      builder: (context,snapshot){
        if(snapshot.hasData){

          UsersData userData = snapshot.data;

          return StreamBuilder<List<Comment>>(
            stream: DatabaseService(date: widget.homePagePost.date,gmail: widget.homePagePost.email).commentData,
            builder: (context,snapshot){
              if(snapshot.hasData){

                List<Comment> comment = snapshot.data;

                return StreamBuilder<Likes>(
                  stream: DatabaseService(date: widget.homePagePost.date,gmail: widget.homePagePost.email).likesData,
                  builder: (context,snapshot){
                    if(5==5){

                      Likes likes = snapshot.data;

                      return Container(
                        child: Column(
                          children: [
                            Container(
                              height: h * 0.06,
                              width: w,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 12, 10, 12),
                                        child: GestureDetector(
                                          child: Card(child: Image.asset('assets/heart.jpg'),color: Colors.transparent,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(255)),),
                                          onTap: ()async{
                                            await DatabaseService().updateHomePostDetails(widget.homePagePost.date, widget.homePagePost.email,likes == null ? 1: likes.likes+1);
                                          },
                                        ),
                                      ),
                                      likes == null ? Container() :
                                      Text(
                                        likes.likes.toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.comment),
                                        color: Colors.black45,
                                        onPressed: (){
                                          setState(() {
                                            _showComment = !_showComment;
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 12, 0),
                                        child: Text(
                                          comment.length.toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            comment.length == 0 || !_showComment ? Container() : Divider(),
                            _showComment ? (
                                Container(
                              height: comment.length > 3 ? h*0.4 :h*0.11*comment.length,
                              child: ListView.builder(
                                itemCount: comment.length,
                                reverse: true,
                                itemBuilder: (context,index){
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                    child: ListTile(
                                      leading: comment[index].pic == '' ? Image.network('https://www.pavilionweb.com/wp-content/uploads/2017/03/man.png',height: 30,) : Image.network(comment[index].pic,height: 30,),
                                      title: Card(
                                        color: Colors.grey[100],
                                        elevation:0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(comment[index].user,style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                                              SizedBox(height: h*0.001,),
                                              Text('${comment[index].commentDate}',style: TextStyle(fontSize: 9)),
                                              SizedBox(height: h*0.01,),
                                              Text('${comment[index].comment}',style: TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )) : Container(),
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 1,
                              color: Colors.grey[100],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.mic,color: isRecording ? Colors.red : Color(0xFFE39999),),
                                      onPressed: ()async{
                                        isRecording = await AudioRecorder.isRecording;
                                        if(isRecording){
                                         // Recording recording = await AudioRecorder.stop();
                                         // print("Path : ${recording.path},  Format : ${recording.audioOutputFormat},  Duration : ${recording.duration},  Extension : ${recording.extension},");
                                        }else{
                                          String dir = (await getExternalStorageDirectory()).absolute.path + "/$_date";
                                          await AudioRecorder.start(path: dir, audioOutputFormat: AudioOutputFormat.AAC);
                                          _showRecording();
                                        }
                                      },
                                    ),
                                    Container(
                                      width: w*0.64,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        keyboardType: TextInputType.multiline,
                                        controller: msgController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          //icon: Icon(Icons.confirmation_number),
                                          hintText: 'Write a comment...',
                                        ),
                                        onChanged: (value){
                                          setState(() {
                                            _isComment =true;
                                            _comment = value;
                                          });
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.send,color: Color(0xFFE39999),),
                                      onPressed: _isComment ? () async{
                                        if(comment.length <= 9) {
                                          _count = '00000000000'+comment.length.toString();
                                        }else if(comment.length <= 99999999){
                                          _count = '0000000000'+comment.length.toString();
                                        }else if(comment.length <= 999999999){
                                          _count = '000000000'+comment.length.toString();
                                        }else if(comment.length <= 9999999999){
                                          _count = '00000000'+comment.length.toString();
                                        }else if(comment.length <= 99999999999){
                                          _count = '0000000'+comment.length.toString();
                                        }else if(comment.length <= 999999999999){
                                          _count = '000000'+comment.length.toString();
                                        }else if(comment.length <= 9999999999999){
                                          _count = '00000'+comment.length.toString();
                                        }else if(comment.length <= 99999999999999){
                                          _count = '0000'+comment.length.toString();
                                        }else if(comment.length <= 999999999999999){
                                          _count = '000'+comment.length.toString();
                                        }else if(comment.length <= 9999999999999999){
                                          _count = '00'+comment.length.toString();
                                        }else if(comment.length <= 99999999999999999){
                                          _count = '0'+comment.length.toString();
                                        }else if(comment.length <= 99999999999999999){
                                          _count = comment.length.toString();
                                        }
                                        await DatabaseService().updateHomePostComments(widget.homePagePost.date, widget.homePagePost.email, _comment, userData.name, _count,_date,userData.pic);
                                        setState(() {
                                          _comment = '';
                                          _isComment =false;
                                          msgController.clear();
                                        });
                                      } : null,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // Expanded(
                            //   flex: 4,
                            //   child: references == null
                            //       ? Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(horizontal: 40),
                            //         child: LinearProgressIndicator(),
                            //       ),
                            //       Text('Fetching records from Firebase')
                            //     ],
                            //   )
                            //       : references.isEmpty
                            //       ? Center(
                            //     child: Text('No File uploaded yet'),
                            //   )
                            //       : CloudRecordListView(
                            //     references: references,
                            //   ),
                            // ),
                            // Expanded(
                            //   flex: 2,
                            //   child: FeatureButtonsView(
                            //     onUploadComplete: _onUploadComplete,
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    }else{
                      return LinearProgressIndicator();
                    }
                  },
                );
              }else{
                return LinearProgressIndicator();
              }
            },
          );
        }else{
          return LinearProgressIndicator();
        }
      },
    );
  }
  // Future<void> _onUploadComplete() async {
  //   FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  //   ListResult listResult =
  //   await firebaseStorage.ref().child('upload-voice-firebase').list();
  //   setState(() {
  //     references = listResult.items;
  //   });
  // }
}
