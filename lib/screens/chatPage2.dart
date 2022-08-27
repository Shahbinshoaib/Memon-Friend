import 'package:flutter/material.dart';
import 'package:memon_friend/models/user.dart';
import 'package:memon_friend/services/database.dart';

import 'package:provider/provider.dart';

class ChatPage2 extends StatefulWidget {
  final Chat chat;

  const ChatPage2({Key key, this.chat}) : super(key: key);

  @override
  _ChatPage2State createState() => _ChatPage2State();
}

class _ChatPage2State extends State<ChatPage2> {

  //dynamic result;
  // final CloudStorageService _cloudStorageService = CloudStorageService();

  @override
  Widget build(BuildContext context) {


    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);

      if(user.email == widget.chat.msgBy){
        // if(widget.eTalkChat.msg == ''){
        //   getImage(widget.eTalkChat.image);
        // }
        //result =  _cloudStorageService.downloadImage(widget.eTalkChat.image);
        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(w*0.2, h*0.005, 10, h*0.005),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Card(
                    color: Color(0xFFE39999),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),),
                    elevation:  0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(widget.chat.msg,style: TextStyle(color: Colors.white,fontSize: h*0.02)),
                        )
                        //     : Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: GestureDetector(
                        //     child: Hero(
                        //       tag: '2',
                        //       child: Image.network(result.toString(),
                        //       ),
                        //     ),
                        //     onTap: () => _showZoomImage2(context),
                        //   ),
                        // ),
                      ],
                    )
                ),
                SizedBox(height: h*0.004,),
                Text(widget.chat.time,style: TextStyle(color: Colors.black45,fontSize: h*0.012),),
              ],
            ),
          ),
        );

      }else{
        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, h*0.005, w*0.2, h*0.005),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),),
                    elevation: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(widget.chat.msg,style: TextStyle(color: Colors.black,fontSize: h*0.02,)),
                        )
                        //     : GestureDetector(
                        //   child: Hero(
                        //     tag: '2',
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Image.network(result.toString(),
                        //       ),
                        //     ),
                        //   ),
                        //   onTap: () => _showZoomImage2(context),
                        // ),
                      ],
                    )
                ),
                SizedBox(height: h*0.004,),
                Text(widget.chat.time,style: TextStyle(color: Colors.black45,fontSize: h*0.012),),
              ],
            ),
          ),
        );
      }
  }

// void _showZoomImage2(BuildContext context){
//   Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (ctx) => Scaffold(
//           body: Hero(
//             tag: '2',
//             child: PhotoView(
//               imageProvider: NetworkImage(result.toString()),
//               maxScale: 10.0,
//             ),
//             //child: Image.file(_imageFile),
//           ),
//         ),
//       )
//   );
// }
}
