import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:manabisnis/modules/env.dart';
import 'package:manabisnis/modules/fire_auth.dart';
import 'package:manabisnis/modules/validation.dart';

import 'package:manabisnis/pages/website/dashboard.dart';
import 'package:manabisnis/pages/website/login.dart';

class WebRegisterPage extends StatefulWidget {
  @override
  _WebRegisterPageState createState() => _WebRegisterPageState();
}

class _WebRegisterPageState extends State<WebRegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final breakpoint = 900.0;

  final _nameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusCPhone = FocusNode();
  final _focusPhone = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusConfirmPassword = FocusNode();

  bool _isProcessing = false;

  String _cphoneValue = "+62";

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [Image(image: AssetImage('./assets/images/png/id.png'), width: 20,height: 16,), SizedBox(width: 5), Text("+62")]) ,value: "+62"),
      DropdownMenuItem(child: Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [Image(image: AssetImage('assets/images/png/my.png'), width: 20,height: 16,), SizedBox(width: 5), Text("+60")]) ,value: "+60"),
      DropdownMenuItem(child: Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [Image(image: AssetImage('assets/images/png/sg.png'), width: 20,height: 16,), SizedBox(width: 5), Text("+65")]) ,value: "+65"),
    ];
    return menuItems;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameTextController.dispose();
    _phoneTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    super.dispose();
  }

  void doRegister() async {
    _focusEmail.unfocus();
    _focusPassword.unfocus();
    _focusConfirmPassword.unfocus();
    _focusName.unfocus();
    _focusPhone.unfocus();

    setState(() {
      _isProcessing = true;
    });

    if (_registerFormKey.currentState!
        .validate()) {

      User? user = await FireAuth
          .registerUsingEmailPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
        name: _nameTextController.text,
        phone: _cphoneValue + _phoneTextController.text,
      );

      if (user != null) {
        Navigator.of(context)
            .pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                WebDashboardPage(user: user),
          ),
          ModalRoute.withName('/'),
        );

      }
    }
    setState(() {
      _isProcessing = false;
    });

  }

  bool _secureText = true;
  bool _confirmSecureText = true;

  showHidePassword() {
    setState(() {
      _secureText = !_secureText;
    });
  }
  showHideConfirmPassword() {
    setState(() {
      _confirmSecureText = !_confirmSecureText;
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Start Page'),),
      body: Container(
        height: double.infinity, // < 600 ? double.infinity : (double.infinity ),
        width: double.infinity,
        decoration: BoxDecoration(
          //color: Colors.black,
        ),
        child: MediaQuery.of(context).size.width < breakpoint ? registerSmaller(context) : registerWider(context),
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


  Widget registerSmaller(BuildContext context) {
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
              height: MediaQuery.of(context).size.height, // < 600 ? double.infinity : (double.infinity ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
              ),
              child: Form(
                key: _registerFormKey,
                child: Column(children: [
                  SizedBox(height: 35.0),
                  Text("REGISTER",style: TextStyle(fontSize: 32)),
                  SizedBox(height: 25.0),
                  TextFormField(
                    controller: _nameTextController,
                    focusNode: _focusName,
                    validator: (value) => Validation.validateName(
                      name: value,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                      hintText: "Your Full Name",
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
                    controller: _emailTextController,
                    focusNode: _focusEmail,
                    validator: (value) => Validation.validateEmail(
                      email: value,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Theme.of(context).iconTheme.color),
                      hintText: "Email Address",
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(children: [

                    SizedBox(
                      width: 125,
                      child: DropdownButtonFormField<String>(
                        //controller: _phoneTextController,
                        focusNode: _focusCPhone,
                        decoration: InputDecoration(
                          icon: Icon(Icons.phone, color: Theme.of(context).iconTheme.color),
                        ),

                        value: _cphoneValue,
                        items: dropdownItems.toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _cphoneValue = newValue!;
                          });
                        },
                      ),
                    ),

                    Flexible(
                      child: TextFormField(
                        controller: _phoneTextController,
                        focusNode: _focusPhone,
                        validator: (value) => Validation.validatePhone(
                          phone: value,
                        ),
                        decoration: InputDecoration(
                          //icon: Icon(Icons.phone),
                          hintText: "8123456789",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],),

                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordTextController,
                    focusNode: _focusPassword,
                    obscureText: _secureText,
                    validator: (value) => Validation.validatePassword(
                      password: value,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.password, color: Theme.of(context).iconTheme.color),
                      hintText: "Password",
                      suffixIcon: IconButton(
                        onPressed: showHidePassword,
                        icon: Icon(_secureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                            color: Theme.of(context).iconTheme.color),
                      ),
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
                    controller: _confirmPasswordTextController,
                    focusNode: _focusConfirmPassword,
                    obscureText: _confirmSecureText,
                    validator: (value) => Validation.confirmPassword(
                      password1: _passwordTextController.text,
                      password2: value,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.password, color: Theme.of(context).iconTheme.color),
                      hintText: "Confirm Password",
                      suffixIcon: IconButton(
                        onPressed: showHideConfirmPassword,
                        icon: Icon(_confirmSecureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                            color: Theme.of(context).iconTheme.color),
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
                  _isProcessing
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                    ),
                    onPressed: () async { doRegister(); },
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 15.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          //'/login',
                          MaterialPageRoute(builder: (context) => WebLoginPage())
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                ],),
              ),
            )
        ),

        SizedBox(
          width: double.infinity, height: double.infinity,
          child: Container(
            padding: EdgeInsets.all(50),
            height: MediaQuery.of(context).size.shortestSide, // < 600 ? double.infinity : (double.infinity ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
            ),
            child: Column(children: [
              Center(child: Text("BISNISKU",style: TextStyle(fontSize: 32, color: Colors.white)),),
              SizedBox(height: 25.0),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    height: 120,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor
                    ),
                    child: Row(children: [
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
                        color: Theme.of(context).primaryColor
                    ),
                    child: Row(children: [
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
                        color: Theme.of(context).primaryColor
                    ),
                    child: Row(children: [
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
                        color: Theme.of(context).primaryColor
                    ),
                    child: Row(children: [
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

  Widget registerWider(BuildContext context) {
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
              height: MediaQuery.of(context).size.width, // < 600 ? double.infinity : (double.infinity ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Form(
                key: _registerFormKey,
                child: Column(children: [
                  SizedBox(height: 35.0),
                  Text("REGISTER",style: TextStyle(fontSize: 32)),
                  SizedBox(height: 25.0),
                  TextFormField(
                    controller: _nameTextController,
                    focusNode: _focusName,
                    validator: (value) => Validation.validateName(
                      name: value,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                      hintText: "Your Full Name",
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
                    controller: _emailTextController,
                    focusNode: _focusEmail,
                    validator: (value) => Validation.validateEmail(
                      email: value,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Theme.of(context).iconTheme.color),
                      hintText: "Email Address",
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(children: [

                    SizedBox(
                      width: 125,
                      child: DropdownButtonFormField<String>(
                        focusNode: _focusCPhone,
                        decoration: InputDecoration(
                          icon: Icon(Icons.phone, color: Theme.of(context).iconTheme.color),
                        ),
                        hint: Text('+62'),
                        value: _cphoneValue,
                        items: dropdownItems.toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _cphoneValue = newValue!;
                          });
                        },
                      ),
                    ),

                    Flexible(
                      child: TextFormField(
                        controller: _phoneTextController,
                        focusNode: _focusPhone,// + _focusCPhone,
                        validator: (value) => Validation.validatePhone(
                          phone: value,
                        ),
                        decoration: InputDecoration(
                          //icon: Icon(Icons.phone),
                          hintText: "8123456789",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],),

                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordTextController,
                    focusNode: _focusPassword,
                    obscureText: _secureText,
                    validator: (value) => Validation.validatePassword(
                      password: value,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.password, color: Theme.of(context).iconTheme.color),
                      hintText: "Password",
                      suffixIcon: IconButton(
                        onPressed: showHidePassword,
                        icon: Icon(_secureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                            color: Theme.of(context).iconTheme.color),
                      ),
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
                    controller: _confirmPasswordTextController,
                    focusNode: _focusConfirmPassword,
                    obscureText: _confirmSecureText,
                    validator: (value) => Validation.confirmPassword(
                      password1: _passwordTextController.text,
                      password2: value,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.password, color: Theme.of(context).iconTheme.color),
                      hintText: "Confirm Password",
                      suffixIcon: IconButton(
                        onPressed: showHideConfirmPassword,
                        icon: Icon(_confirmSecureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                            color: Theme.of(context).iconTheme.color),
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
                  _isProcessing
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                    ),
                    onPressed: () async { doRegister(); },
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 15.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                      //primary: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          //'/login',
                          MaterialPageRoute(builder: (context) => WebLoginPage())
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                ],),
              ),
            )
        ),
      ],
    );

  }

}