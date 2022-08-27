import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memon_friend/models/user.dart';
import 'package:memon_friend/services/database.dart';
import 'package:memon_friend/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class AddHomePostPage extends StatefulWidget {
  final UsersData usersData;
  final int count;

  const AddHomePostPage({Key key, this.usersData,this.count}) : super(key: key);

  @override
  _AddHomePostPageState createState() => _AddHomePostPageState();
}

class _AddHomePostPageState extends State<AddHomePostPage> {

  final _formkey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String _count;


  File _imageFile;
  String postText = '';
  bool loader = false;

  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://memon-friend.appspot.com');

  int _state = 1;
  StorageUploadTask _uploadTask;

  Future<void> _pickImage(ImageSource source) async{
    // ignore: deprecated_member_use
    File selected = await ImagePicker.pickImage(source: source,imageQuality: 40);
    setState(() {
      _imageFile = selected;
    });
  }
  void _clear(){
    setState(() {
      _imageFile = null;
    });
  }
  String _validateName(String value) {
    if (value.isEmpty)
      return 'This is required';
  }

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy.MM.dd').format(now);
    dynamic currentTime = DateFormat.Hms().format(DateTime.now());
    String _date = '$formattedDate-$currentTime';
    String filePath = 'images/${_date}-${widget.usersData.email}.png';

    final user = Provider.of<User>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    if(widget.count <= 9) {
      _count = '00000000000000000'+widget.count.toString();
    }else if(widget.count <= 99){
      _count = '0000000000000000'+widget.count.toString();
    }else if(widget.count <= 999){
      _count = '000000000000000'+widget.count.toString();
    }else if(widget.count <= 9999){
      _count = '00000000000000'+widget.count.toString();
    }else if(widget.count <= 99999){
      _count = '0000000000000'+widget.count.toString();
    }else if(widget.count <= 999999){
      _count = '000000000000'+widget.count.toString();
    }else if(widget.count <= 9999999){
      _count = '00000000000'+widget.count.toString();
    }else if(widget.count <= 99999999){
      _count = '0000000000'+widget.count.toString();
    }else if(widget.count <= 999999999){
      _count = '000000000'+widget.count.toString();
    }else if(widget.count <= 9999999999){
      _count = '00000000'+widget.count.toString();
    }else if(widget.count <= 99999999999){
      _count = '0000000'+widget.count.toString();
    }else if(widget.count <= 999999999999){
      _count = '000000'+widget.count.toString();
    }else if(widget.count <= 9999999999999){
      _count = '00000'+widget.count.toString();
    }else if(widget.count <= 99999999999999){
      _count = '0000'+widget.count.toString();
    }else if(widget.count <= 999999999999999){
      _count = '000'+widget.count.toString();
    }else if(widget.count <= 9999999999999999){
      _count = '00'+widget.count.toString();
    }else if(widget.count <= 99999999999999999){
      _count = '0'+widget.count.toString();
    }else if(widget.count <= 99999999999999999){
      _count = widget.count.toString();
    }



    return loader ? Loader() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Add a Post'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                _imageFile == null ?
            Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                   // radius: h*0.04,
                    backgroundImage:
                    NetworkImage(widget.usersData.pic == '' ? 'https://www.pavilionweb.com/wp-content/uploads/2017/03/man.png' : widget.usersData.pic),
                  ),
                  title: Text(widget.usersData.name,style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text('@${widget.usersData.email}',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 12),),
                ),
                SizedBox(height: h*0.01,),
                Form(
                  key: _formkey,
                  child: TextFormField(
                    validator: _validateName,
                    enableInteractiveSelection: true,
                    autocorrect: true,
                    enableSuggestions: true,
                    controller: this._controller,
                    maxLines: 10,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Write something...',
                      counterText: '${this._controller.text.split(' ').length} words',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value){
                      setState(() {
                        postText = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt,color: Color(0xFFE39999),),
                  title: Text('Add Image from camera'),
                  onTap: (){
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image,color: Color(0xFFE39999),),
                  title: Text('Add Image from gallery'),
                  onTap: (){
                    _pickImage(ImageSource.gallery);
                  },
                ),
                SizedBox(height: h*0.02,),
                ButtonTheme(
                  height: 45,
                  minWidth: w*0.9,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: RaisedButton(
                    child: Text('POST',style: TextStyle(color: Colors.white,fontSize: 20),),
                    color: Color(0xFFE39999),
                    onPressed: () async{
                      if(_formkey.currentState.validate()){
                        setState(() {
                          loader = true;
                        });

                        await DatabaseService().updateHomePagePost(postText, _date, user.email, widget.usersData.name, widget.usersData.pic, '',widget.usersData.email,_count,);
                        Navigator.pop(context);
                        setState(() {
                          loader = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            )
                    : Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              // radius: h*0.04,
                              backgroundImage:
                              NetworkImage(widget.usersData.pic == '' ? 'https://www.pavilionweb.com/wp-content/uploads/2017/03/man.png' : widget.usersData.pic),
                            ),
                            title: Text(widget.usersData.name,style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text('@${widget.usersData.email}',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 12),),
                          ),
                          SizedBox(height: h*0.01,),
                          Stack(
                            children: [
                              Container(
                                width: w,
                                color: Colors.black,
                                child: Image.file(_imageFile,fit: BoxFit.fitHeight, height: h * 0.3,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FloatingActionButton(
                                  heroTag: '2',
                                  child: Icon(Icons.cancel_outlined,color: Color(0xFFE39999),),
                                  mini: true,
                                  backgroundColor: Colors.white,
                                  onPressed: _clear,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: 1,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              icon: Icon(Icons.add_box),
                              labelText: 'Add a caption',
                            ),
                            onChanged: (value){
                              setState(() {
                                postText  = value;
                              });
                            },
                          ),
                          SizedBox(height: h*0.02,),
                          ButtonTheme(
                            height: 45,
                            minWidth: w*0.9,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: RaisedButton(
                              child: Text('POST IMAGE',style: TextStyle(color: Colors.white,fontSize: 20),),
                              color: Color(0xFFE39999),
                              onPressed: () async{
                                setState(() {
                                  _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
                                  loader = true;
                                });
                                await DatabaseService().updateHomePagePost(postText, _date, user.email, widget.usersData.name, widget.usersData.pic, '$_date-${widget.usersData.email}',widget.usersData.email,_count);
                                Navigator.pop(context);
                                setState(() {
                                  loader = false;
                                  _imageFile = null;
                                });
                              },
                            ),
                          ),

                        ],
                    ),
          ),
        ),
      ),
    );
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
