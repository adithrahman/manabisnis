import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:manabisnis/modules/env.dart';
import 'package:manabisnis/modules/fire_auth.dart';
import 'package:manabisnis/modules/validation.dart';

import 'package:manabisnis/pages/website/dashboard.dart';
import 'package:manabisnis/pages/website/register.dart';

class WebLoginPage extends StatefulWidget {
  @override
  _WebLoginPageState createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final double breakpoint = 900.0;

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  bool _isLoginError = false;


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  void doLogin() async {
    _focusEmail.unfocus();
    _focusPassword.unfocus();

    if (_loginFormKey.currentState!
        .validate()) {
      setState(() {
        _isProcessing = true;
        _isLoginError = false;
      });

      User? user = await FireAuth
          .signInUsingEmailPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      setState(() {
        _isProcessing = false;
      });

      if (user != null) {
        Navigator//.of(context)
            .pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (context) =>
                  WebDashboardPage(user: user),
            ),
                (Route<dynamic> route) => false
        );
      } else { // wrong email or password
        setState(() {
          _isLoginError = true;
        });
      }
    }
  }

  bool _secureText = true;

  showHidePassword() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  build(BuildContext context) {
    //print("media:"+MediaQuery.of(context).size.width.toString());

    return Scaffold(
      //appBar: AppBar(title: Text('Start Page'),),
      body: Container(
        height: double.infinity, // < 600 ? double.infinity : (double.infinity ),
        width: double.infinity,
        decoration: BoxDecoration(
          //color: Colors.black,
        ),
        child: MediaQuery.of(context).size.width < breakpoint ? loginSmaller(context) : loginWider(context),
      ),

      bottomSheet: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10,top:10),
              child: Text(Env.COPYRIGHT),
            ),
          ],),
      ),

    );
  }

  Widget loginSmaller(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width < breakpoint ? 1 : 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.7,
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      children: <Widget>[
        SizedBox(
          width: double.infinity, height: double.infinity,
          child: Container(
            padding: EdgeInsets.all(25),
            height: MediaQuery.of(context).size.width, // < 600 ? double.infinity : (double.infinity ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Form(
              key: _loginFormKey,
              child: Column(children: [
                SizedBox(height: 35.0),
                Text("LOGIN",style: TextStyle(fontSize: 32)),
                _isLoginError
                    ? Padding(
                  padding: EdgeInsets.only(top:15,bottom:10),
                  child: Text('Email or Password is wrong !',style: TextStyle(color:Colors.red),),
                )
                    : SizedBox(height: 25.0),
                TextFormField(
                  controller: _emailTextController,
                  focusNode: _focusEmail,
                  validator: (value) => Validation.validateEmail(
                    email: value,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(Icons.login, color: Theme.of(context).iconTheme.color),
                    hintText: "Your email or phone number",
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordTextController,
                  focusNode: _focusPassword,
                  obscureText: _secureText,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) => { doLogin() },
                  validator: (value) => Validation.validatePassword(
                    password: value,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(Icons.password, color: Theme.of(context).iconTheme.color,),
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: showHidePassword,
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                        color: Theme.of(context).iconTheme.color,),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
                SizedBox(height: 15.0),
                _isProcessing
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                  ),
                  onPressed: () async { doLogin(); },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                SizedBox(height: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        //'/register',
                        MaterialPageRoute(builder: (context) => WebRegisterPage())
                    );
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              ],),
            ),
          ),
        ),

        SizedBox(
          width: double.infinity, height: double.infinity,
          child: Container(
            padding: EdgeInsets.all(50),
            height: MediaQuery.of(context).size.width, // < 600 ? double.infinity : (double.infinity ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
            ),
            child: Column(children: [
              Center(child: Text("BISNISKU",style: TextStyle(fontSize: 32, color: Colors.white)),),
              SizedBox(height: 25.0),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        children: [
                          FlutterLogo(size: 48,),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: Column(children: [
                              Text("Judul", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10.0),
                              Container(
                                  child:Text(
                                    "deskripsi balkhnodjlhajidfuaherflhwhafodup;ahfhpewaihrfauowi;ehfu;shf",
                                    style: TextStyle(fontSize: 12,),
                                    overflow: TextOverflow.fade,
                                  )
                              ),
                            ],),
                          ),
                        ],),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        children: [
                          FlutterLogo(size: 48,),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: Column(children: [
                              Text("Judul", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10.0),
                              Container(
                                  child:Text(
                                    "deskripsi balkhnodjlhajidfuaherflhwhafodup;ahfhpewaihrfauowi;ehfu;shf",
                                    style: TextStyle(fontSize: 12,),
                                    overflow: TextOverflow.fade,
                                  )
                              ),
                            ],),
                          ),
                        ],),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        children: [
                          FlutterLogo(size: 48,),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: Column(children: [
                              Text("Judul", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10.0),
                              Container(
                                  child:Text(
                                    "deskripsi balkhnodjlhajidfuaherflhwhafodup;ahfhpewaihrfauowi;ehfu;shf",
                                    style: TextStyle(fontSize: 12,),
                                    overflow: TextOverflow.fade,
                                  )
                              ),
                            ],),
                          ),
                        ],),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        children: [
                          FlutterLogo(size: 48,),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: Column(children: [
                              Text("Judul", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10.0),
                              Container(
                                  child:Text(
                                    "deskripsi balkhnodjlhajidfuaherflhwhafodup;ahfhpewaihrfauowi;ehfu;shf",
                                    style: TextStyle(fontSize: 12,),
                                    overflow: TextOverflow.fade,
                                  )
                              ),
                            ],),
                          ),
                        ],),
                    ),
                  ],),
              ),
            ],),
          ),
        ),

      ],
    );

  }

  Widget loginWider(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width < breakpoint ? 1 : 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: (MediaQuery.of(context).size.aspectRatio *0.6),
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      children: <Widget>[
        SizedBox(
          width: double.infinity, height: double.infinity,
          child: Container(
            padding: EdgeInsets.all(50),
            height: MediaQuery.of(context).size.width, // < 600 ? double.infinity : (double.infinity ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
            ),
            child: Column(children: [
              Center(child: Text("BISNISKU",style: TextStyle(fontSize: 32, color: Colors.white)),),
              SizedBox(height: 25.0),
              GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width < breakpoint ? 1 : 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height ) / 1.4,
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(children: [
                        FlutterLogo(size: 48,),
                        SizedBox(height: 15.0),
                        Text("Judul", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10.0),
                        Container(
                            child:Text(
                              "deskripsi balkhnodjlhajidfuaherflhwhafodup ahfhpewaihrfauowi;ehfu;shf afasdsrgsrfsdfse",
                              style: TextStyle(fontSize: 12,),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                            )
                        ),
                      ],)
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],),
          ),
        ),

        SizedBox(
          width: double.infinity, height: double.infinity,
          child: Container(
            padding: EdgeInsets.all(25),
            height: MediaQuery.of(context).size.height, // < 600 ? double.infinity : (double.infinity ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Form(
              key: _loginFormKey,
              child: Column(children: [
                SizedBox(height: 35.0),
                Text("LOGIN",style: TextStyle(fontSize: 32)),
                _isLoginError
                    ? Padding(
                  padding: EdgeInsets.only(top:15,bottom:10),
                  child: Text('Email or Password is wrong !',style: TextStyle(color:Colors.red),),
                )
                    : SizedBox(height: 25.0),
                TextFormField(
                  controller: _emailTextController,
                  focusNode: _focusEmail,
                  validator: (value) => Validation.validateEmail(
                    email: value,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(Icons.login, color: Theme.of(context).iconTheme.color,),
                    hintText: "Your email or phone number",
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordTextController,
                  focusNode: _focusPassword,
                  obscureText: _secureText,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) => { doLogin() },
                  validator: (value) => Validation.validatePassword(
                    password: value,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(Icons.password, color: Theme.of(context).iconTheme.color,),
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: showHidePassword,
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                        color: Theme.of(context).iconTheme.color,),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
                SizedBox(height: 15.0),
                _isProcessing
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                  ),
                  onPressed: () async { doLogin(); },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                SizedBox(height: 15.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        //'/register',
                        MaterialPageRoute(builder: (context) => WebRegisterPage())
                    );
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              ],),
            ),
          ),
        ),
      ],
    );

  }


}