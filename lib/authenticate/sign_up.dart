import 'package:flutter/material.dart';
import 'package:memon_friend/services/auth.dart';
import 'package:memon_friend/services/database.dart';
import 'package:memon_friend/widgets/loader.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final AuthService _auth = AuthService();
  bool loader = false;

  final _formkey = GlobalKey<FormState>();
  String _validateName(String value) {
    if (value.isEmpty)
      return 'This is required';
  }

  //text field state
  String email;
  String password ;
  String error ;

  String name;
  String fName;
  String gFName;
  String surname;
  String cnic;
  String phone;
  String member;



  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return loader ? Loader() : Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset('assets/memon.jpg',),
            Container(
              height: h,
              width: w,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: h*0.185,),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Color(0xFFE39999),
                          fontSize: h*0.03,
                          fontStyle: FontStyle.italic
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: h*0.0,),
                    Padding(
                      padding: EdgeInsets.fromLTRB(w*0.1, 0, w*0.1, 0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: _validateName,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.person),
                                labelText: 'Name',
                              ),
                              onChanged: (value){
                                setState(() {
                                  name = value;
                                });
                              },
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              validator: _validateName,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.person),
                                labelText: 'Father Name',
                              ),
                              onChanged: (value){
                                setState(() {
                                   fName = value;
                                });
                              },
                            ),
                            TextFormField(
                              validator: _validateName,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.person),
                                labelText: 'G. Father name',
                              ),
                              onChanged: (value){
                                setState(() {
                                   gFName = value;
                                });
                              },
                            ),
                            TextFormField(
                              validator: _validateName,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.person),
                                labelText: 'Surname',
                              ),
                              onChanged: (value){
                                setState(() {
                                   surname = value;
                                });
                              },
                            ),
                            // TextFormField(
                            //   validator: _validateName,
                            //   textCapitalization: TextCapitalization.words,
                            //   keyboardType: TextInputType.number,
                            //   decoration: InputDecoration(
                            //     border: UnderlineInputBorder(),
                            //     icon: Icon(Icons.badge),
                            //     labelText: 'CNIC Number',
                            //   ),
                            //   onChanged: (value){
                            //     setState(() {
                            //        cnic = value;
                            //     });
                            //   },
                            // ),
                            TextFormField(
                              validator: _validateName,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.mail),
                                labelText: 'Email',
                              ),
                              onChanged: (value){
                                setState(() {
                                  email = value;
                                });
                              },
                            ),
                            TextFormField(
                              validator: _validateName,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.phone),
                                labelText: 'Phone number',
                              ),
                              onChanged: (value){
                                setState(() {
                                   phone = value;
                                });
                              },
                            ),
                            TextFormField(
                              validator: _validateName,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.card_membership),
                                labelText: 'Membership #',
                              ),
                              onChanged: (value){
                                setState(() {
                                   member = value;
                                });
                              },
                            ),
                            TextFormField(
                              validator: _validateName,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.lock),
                                labelText: 'Password',
                              ),
                              onChanged: (value){
                                setState(() {
                                   password = value;
                                });
                              },
                            ),
                            SizedBox(height: h*0.02,),
                            ButtonTheme(
                              height: 45,
                              minWidth: w*0.75,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                              child: RaisedButton(
                                child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 20),),
                                color: Color(0xFFE39999),
                                onPressed: () async{
                                  if(_formkey.currentState.validate()){
                                    setState(() {
                                      loader = true;
                                    });
                                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                                    if (result == null){
                                      setState(() {
                                        error = 'Incorrect credentials';
                                      });
                                    } else{
                                      await DatabaseService().updateUsersData(name, fName, gFName, surname, email, phone, member, password,'');
                                      Navigator.of(context).pop();
                                    }
                                    setState(() {
                                      loader = false;
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: h*0.02,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
