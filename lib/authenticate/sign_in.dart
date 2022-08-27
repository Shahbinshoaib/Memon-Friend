
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:memon_friend/authenticate/sign_up.dart';
import 'package:memon_friend/services/auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:memon_friend/widgets/loader.dart';
import 'package:page_transition/page_transition.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _controller = TextEditingController();
  final AuthService _auth = AuthService();
  bool loader = false;

  final _formkey = GlobalKey<FormState>();
  String _validateName(String value) {
    if (value.isEmpty)
      return 'This is required';
  }

  //text field state
  String email ;
  String password;
  String error = '';


  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return loader ? Loader() : Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/memon1.jpg',height: h,),
            Container(
             height: h,
              width: w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: h*0.15,),
                  Text(
                    'Sign In',
                    style: TextStyle(
                        color: Color(0xFFE39999),
                        fontSize: h*0.07,
                      fontStyle: FontStyle.italic
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: h*0.03,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(w*0.1, 0, w*0.1, 0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: _validateName,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              icon: Icon(Icons.confirmation_number),
                              labelText: 'Email',
                            ),
                            onChanged: (value){
                              setState(() {
                               email = value;
                              });
                            },
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            validator: _validateName,
                            obscureText: true,
                            keyboardType: TextInputType.text,
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
                          SizedBox(height: h*0.03,),
                          //Text('Forgot your Password?'),
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
                                 dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                 if (result == null){
                                   setState(() {
                                     error = 'Incorrect credentials';
                                   });
                                 } else{
                                 }
                                 setState(() {
                                   loader = false;
                                 });
                               }
                              },
                            ),
                          ),
                          SizedBox(height: h*0.01,),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: h*0.08,),
                  TextButton(
                    child: Text('Create a New Account',style: TextStyle(fontSize: 25,fontStyle: FontStyle.italic),),
                    onPressed: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SignUpPage()));
                    },
                  ),
                  SizedBox(height: h*0.1,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

