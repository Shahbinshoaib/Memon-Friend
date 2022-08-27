
class User{

  final String photo;
  final String uid;
  final String email;
  final String username;

  User({this.uid, this.email, this.photo, this.username});
}

class UserBioData{

  final String photo;
  final String uid;
  final String name;
  final bool maleGender;
  final String email;
  final String portalID;
  final String enroll;
  final String cri;
  final String sem;
  final String dept;
  final String uni;

  UserBioData({this.photo, this. name, this.maleGender, this.email, this.portalID, this.enroll, this.cri, this.sem, this.dept, this.uni, this.uid});
}

class CourseData{

  final String courseName;
  final int leaves;
  final String code;
  final String type;
  CourseData({this.courseName, this.leaves, this.code, this.type});
}

class TuitionData{

  final String subjects;
  final String classes;
  final String location;
  final String requirement;
  final String contact;
  final String gender;
  final String postCounter;
  final String datePosted;

  TuitionData({this.subjects, this.classes, this.location, this.requirement, this.contact, this.gender, this.postCounter, this.datePosted});
}