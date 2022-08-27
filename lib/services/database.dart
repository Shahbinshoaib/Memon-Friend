import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String course;
  final String date;
  final String gmail;

  final CollectionReference usersCollection = Firestore.instance.collection('Users');
  final CollectionReference statusCollection = Firestore.instance.collection('All Status');
  final CollectionReference homePagePostCollection = Firestore.instance.collection('HomePage Posts');


  DatabaseService({this.course,this.date,this.gmail,});


  Future updateUsersData(String name, String fName, String gFName, String surname, String email, String phone, String member, String password,String pic) async{
    return await usersCollection.document(email).setData({
      'Name' : name,
      'Father Name' : fName,
      'G. Father Name' : gFName,
      'Surname' : surname,
      'Email' : email,
      'Phone' : phone,
      'Member' : member,
      'Password' : password,
      'Pic' : pic,
    });
  }
  Future updateChatData(String msg, String date, String time, String email, bool seen, String msgBy,String name,) async{
    return await usersCollection.document(email).collection('chat').document(date+'-'+time).setData({
      'Message' : msg,
      'Date' : date,
      'Time' : time,
      'Gmail' : gmail,
      'Seen' : seen,
      'MsgBy': msgBy,
      'Name' : name,
    });
  }
  Future updateMyStatusData(String userName, String gmail, String pic,String status,String count) async{
    return await statusCollection.document(status).setData({
      'User Name' : userName,
      'Gmail' : gmail,
      'Pic' : pic,
      'Status' : status,
      'Count' : count
    });
  }
  Future updateHomePagePost(String postText,String date, String email, String name, String pic, String image, String username,String count) async{
    return await homePagePostCollection.document(date+email).setData({
      'Post Text' : postText,
      'Date' : date,
      'Email' : email,
      'Name' : name,
      'Pic':pic,
      'Image' : image,
      'Username' : username,
      'Count' : count,
    });
  }
  Future updateHomePostDetails(String date, String email, int likes) async{
    return await homePagePostCollection.document(date+email).collection('Likes').document('Likes').setData({
      'Likes' :likes,
    });
  }
  Future updateHomePostComments(String date, String email, String comment,String user,String count,String commentDate,String pic) async{
    return await homePagePostCollection.document(date+email).collection('Comments').document(date+comment).setData({
      'Comment' :comment,
      'User':user,
      'Date':date,
      'Email':email,
      'Count':count,
      'Comment Date':commentDate,
      'Pic':pic,
    });
  }




  List<UsersData> _usersListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return UsersData(
        name: doc.data['Name'] ?? '',
        fName: doc.data['Father Name'] ?? '',
        gFName: doc.data['G. Father Name'] ?? '',
        surname: doc.data['Surname'] ?? '',
        email: doc.data['Email'] ?? 'i',
        phone: doc.data['Phone'] ?? '',
        member: doc.data['Member'] ?? '',
        password: doc.data['Password'] ?? '',
        pic: doc.data['Pic'] ?? 'https://www.pavilionweb.com/wp-content/uploads/2017/03/man.png'
      );
    }).toList();
  }

  UsersData _userFromSnapshot(DocumentSnapshot snapshot){
    return UsersData(
        name: snapshot.data['Name'] ?? '',
        fName: snapshot.data['Father Name'] ?? '',
        gFName: snapshot.data['G. Father Name'] ?? '',
        surname: snapshot.data['Surname'] ?? '',
        email: snapshot.data['Email'] ?? 'h',
        phone: snapshot.data['Phone'] ?? '',
        member: snapshot.data['Member'] ?? '',
        password: snapshot.data['Password'] ?? '',
        pic: snapshot.data['Pic'] ?? 'https://www.pavilionweb.com/wp-content/uploads/2017/03/man.png'

    );
  }

  List<Chat> _ChatListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Chat(
        msg: doc.data['Message'] ?? '',
        date: doc.data['Date'] ?? '',
        time: doc.data['Time'] ?? '',
        gmail: doc.data['Gmail'] ?? '',
        seen : doc.data['Seen'] ?? '',
        msgBy: doc.data['MsgBy'] ?? '',
        name: doc.data['Name'] ?? '',
      );
    }).toList();
  }
  List<HomePagePost> _homePagePostListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return HomePagePost(
        postText: doc.data['Post Text'] ?? '',
        date: doc.data['Date'] ?? '',
        email: doc.data['Email'] ?? '',
        name: doc.data['Name'] ?? '',
        pic : doc.data['Pic'] ?? '',
        image: doc.data['Image'] ?? '',
        username: doc.data['Username'] ?? '',
        count: doc.data['Count'] ?? ''
      );
    }).toList();
  }
  List<Status> _statusListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Status(
          userName: doc.data['User Name'] ?? '',
          gmail: doc.data['Gmail'] ?? '',
          pic : doc.data['Pic'] ?? '',
          status: doc.data['Status'] ?? '',
          count: doc.data['Count'] ?? ''
      );
    }).toList();
  }
  Likes _likesFromSnapshot(DocumentSnapshot snapshot){
    return Likes(
        likes: snapshot.data['Likes'] ?? 0,
    );
  }
  List<Comment> _commentListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Comment(
          user: doc.data['User'] ?? '',
          comment: doc.data['Comment'] ?? '',
          date : doc.data['Date'] ?? '',
          email: doc.data['Email'] ?? '',
          count: doc.data['Count'] ?? '',
          commentDate: doc.data['Comment Date'] ?? '',
          pic: doc.data['Pic'] ?? 'https://www.pavilionweb.com/wp-content/uploads/2017/03/man.png',
      );
    }).toList();
  }

  // }
  Stream<List<UsersData>> get usersData {
    return usersCollection.snapshots()
        .map(_usersListFromSnapshot);
  }
  Stream<UsersData> get usersIndividualData {
    return usersCollection.document(gmail).snapshots()
        .map(_userFromSnapshot);
  }
  Stream<List<Chat>> get chatData{
    return usersCollection.document(gmail).collection('chat').snapshots()
        .map(_ChatListFromSnapshot);
  }
  Stream<List<HomePagePost>> get homePagePostData{
    return homePagePostCollection.orderBy('Count',descending: true).snapshots()
        .map(_homePagePostListFromSnapshot);
  }
  Stream<List<Status>> get statusData{
    return statusCollection.orderBy('Count',descending: true).snapshots()
        .map(_statusListFromSnapshot);
  }
  Stream<Likes> get likesData {
    return homePagePostCollection.document(date+gmail).collection('Likes').document('Likes').snapshots()
        .map(_likesFromSnapshot);
  }
  Stream<List<Comment>> get commentData{
    return homePagePostCollection.document(date+gmail).collection('Comments').orderBy('Count',descending: true).snapshots()
        .map(_commentListFromSnapshot);
  }

}


class UsersData{

  final String name;
  final String fName;
  final String gFName;
  final String surname;
  final String email;
  final String phone;
  final String member;
  final String password;
  final String pic;

  UsersData({this.name, this.fName, this.gFName, this.surname, this.email, this.phone, this.member, this.password,this.pic});


}

class Chat{

  final String msg;
  final String date;
  final String time;
  final String gmail;
  final bool seen;
  final String msgBy;
  final String name;

  Chat({this.msg, this.date, this.time, this.gmail, this.seen,this.msgBy,this.name,});
}

class HomePagePost{

  final String postText;
  final String date;
  final String email;
  final String name;
  final String pic;
  final String image;
  final String username;
  final String count;

  HomePagePost({this.postText, this.date, this.email, this.name, this.pic, this.image,this.username,this.count,});
}

class Status{

  final String userName;
  final String gmail;
  final String pic;
  final String status;
  final String count;

  Status({this.userName, this.gmail, this.pic, this.status,this.count});
}

class Likes{

  final int likes;

  Likes({this.likes});
}

class Comment{

  final String comment;
  final String user;
  final String date;
  final String email;
  final String count;
  final String commentDate;
  final String pic;

  Comment({this.comment, this.user, this.date, this.email,this.count,this.commentDate,this.pic});

}