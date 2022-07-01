import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:collapsible_sidebar/collapsible_sidebar.dart';

import 'package:manabisnis/pages/website/login.dart';
import 'package:manabisnis/modules/fire_auth.dart';

class WebDashboardPage extends StatefulWidget {
  final User user;

  const WebDashboardPage({required this.user});

  @override
  _WebDashboardPageState createState() => _WebDashboardPageState();
}

class _WebDashboardPageState extends State<WebDashboardPage> {
  bool _isSigningOut = false;
  bool _isSideBarCollapsed = true;

  bool _isOpenDash = true;
  bool _isOpenPurc = false;
  bool _isOpenSale = false;
  bool _isOpenFinc = false;
  bool _isOpenInvt = false;
  bool _isOpenHuRe = false;
  bool _isOpenCuRe = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late User _currentUser;
  String _menuVal = "Toko Utama";

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const bpTablet = 800.0;
    const bpPhones = 600.0;

    //MediaQuery.of(context).size.shortestSide < 600 ? return dashSmaller(context) : return dashWider(context);
    if (screenWidth > bpTablet) { // Desktop
      return dashWider(context);
      //} else if (screenWidth > bpPhones && screenWidth <= bpTablet) { // Tablet
      //  return dashTablet(context);
    } else { //if (screenWidth <= bpPhones) { // Phones
      return dashSmaller(context);
    }
  }

  Widget dashSmaller(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      /*
      appBar: AppBar(
        title: Text('Dashboard - Phones',style: TextStyle(color: Colors.black),),
        //leading: FlutterLogo(size:16),
        foregroundColor: Colors.black,
        backgroundColor: Color.fromRGBO(252, 252, 252, 1),
      ),
      */
      body:
      Column(children: [
        appBarSmaller(context),
        Expanded(
          child: ListView(children: [
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              color: Theme.of(context).backgroundColor,
              child: Text("CONTAINER"),
            ),
          ],),
        ),
      ],),

      /*
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NAME: ${_currentUser.displayName}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            Text(
              'EMAIL: ${_currentUser.email}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            _currentUser.emailVerified
                ? Text(
              'Email verified',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.green),
            )
                : Text(
              'Email not verified',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.red),
            ),
            SizedBox(height: 16.0),
            _isSendingVerification
                ? CircularProgressIndicator()
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isSendingVerification = true;
                    });
                    await _currentUser.sendEmailVerification();
                    setState(() {
                      _isSendingVerification = false;
                    });
                  },
                  child: Text('Verify email'),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    User? user = await FireAuth.refreshUser(_currentUser);

                    if (user != null) {
                      setState(() {
                        _currentUser = user;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _isSigningOut
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => WebLoginPage(),
                  ),
                );
              },
              child: Text('Sign out'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
       */

      drawer: drawerSmaller(context),
    );
  }
  Widget appBarSmaller(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.color,
        border: Border(bottom:BorderSide(
          color: Colors.black45, style: BorderStyle.solid,
        )),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(children: [
          Container(
            height: 50,
            padding: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.center,
              child: InkWell(
                child: Icon(Icons.menu, color: Theme.of(context).iconTheme.color, size: 40,),
                mouseCursor: SystemMouseCursors.click,
                onTap: () {
                  setState(() {
                    if (_scaffoldKey.currentState!.isDrawerOpen) {
                      _scaffoldKey.currentState!.openEndDrawer();
                    } else {
                      _scaffoldKey.currentState!.openDrawer();
                    }
                  });
                },
              ),
            ),
          ),
          Text('Dashboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child:Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          popupBar(context),
        ],),
      ),
    );
  }
  Widget drawerSmaller(BuildContext context) {
    return Drawer(
      child: Column(children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.lightGreen,
          ),
          child: Stack(children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  child: FlutterLogo(size: 48,)
              ),
            ),
            Positioned(
              bottom: 0,
              left: 5.0,
              width: 250,
              child: DropdownButton<String>(
                items: <String>['Toko Utama', 'Branch A', 'Toko C', 'Toko D'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _menuVal = value!;
                  });
                },
                icon: Icon(Icons.card_travel_outlined, color: Theme.of(context).iconTheme.color,),
                value: _menuVal,
                //style: TextStyle(
                //  color: Colors.black,
                //),
              ),
            ),
          ]),
        ),
        Expanded(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: Icon(Icons.shopping_cart_outlined, color: Theme.of(context).iconTheme.color,),
                title: Text('Purchasing'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.stacked_line_chart, color: Theme.of(context).iconTheme.color,),
                title: Text('Sales'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.monetization_on_outlined, color: Theme.of(context).iconTheme.color,),
                title: Text('Finance'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.inventory_2_outlined, color: Theme.of(context).iconTheme.color,),
                title: Text('Inventory'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.supervisor_account_outlined, color: Theme.of(context).iconTheme.color,),
                title: Text('Human Resources'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.group_outlined, color: Theme.of(context).iconTheme.color,),
                title: Text('Customer Relation'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        /*
        Container(
          child:
          _isSigningOut
              ? CircularProgressIndicator()
              : ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              setState(() {
                _isSigningOut = true;
              });
              await FirebaseAuth.instance.signOut();
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => WebLoginPage(),
                ),
              );
            },
          ),
          /*
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => WebLoginPage(),
                  ),
                );
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            */
        ),
        */

      ],),

    );
  }

  Widget dashWider(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text('Dashboard - Desktop',style: TextStyle(color: Colors.black),),
        //leading: FlutterLogo(size:16),
        backgroundColor: Color.fromRGBO(252, 252, 252, 1),
        actions: [
          Padding(
            padding: EdgeInsets.only(right:15),
            child: PopupMenuButton(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Profile'),
                    mouseCursor: SystemMouseCursors.click,
                  ),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: Icon(Icons.message),
                    title: Text('Messages'),
                    mouseCursor: SystemMouseCursors.click,
                  ),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                PopupMenuItem(child: PopupMenuDivider(height: 2,),height: 2,enabled: false,),
                PopupMenuItem(
                  value: 3,
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    mouseCursor: SystemMouseCursors.click,
                  ),
                  onTap: () async {
                    _isSigningOut
                        ? CircularProgressIndicator()
                        :
                    setState(() {
                      _isSigningOut = true;
                    });
                    await FirebaseAuth.instance.signOut();
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => WebLoginPage(),
                      ),
                    );
                  },
                ),
              ]
            ),
          ),
        ],
      ),
      */
      body: Row(children: [
        sideBar(context),
        Expanded(
          child: Column(children: [
            appBarWider(context),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  color: Theme.of(context).backgroundColor,
                  child: _isOpenDash ?
                  Container(child: Text("DASHBOARD"))
                      : _isOpenPurc ?
                  Container(child: Text("PURCHASING"))
                      : _isOpenSale ?
                  Container(child: Text("SALES"))
                      : _isOpenFinc ?
                  Container(child: Text("FINANCE"))
                      : _isOpenInvt ?
                  Container(child: Text("INVENTORY"))
                      : _isOpenHuRe ?
                  Container(child: Text("HUMAN RESOURCES"))
                      : _isOpenCuRe ?
                  Container(child: Text("CUSTOMER RESOURCES"))
                      :
                  Container(child: Text("BLANK"))
              ),
            ),
          ],),
        )
        /*
        SizedBox(
          height: double.infinity, width: 350,
          child: GridView.extent(
            maxCrossAxisExtent: 175,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true, // You won't see infinite size error
            padding: EdgeInsets.all(10),
            physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width:1, color:Colors.black54), //border width and color
                  padding: EdgeInsets.all(10),
                  primary: Colors.white,
                  minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                ),
                onPressed: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined,size: 32,color: Colors.black,),
                    SizedBox(height: 10,),
                    Text(
                      'Purchasing'.toUpperCase(),
                      style: TextStyle(color: Colors.black,),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width:1, color:Colors.black54), //border width and color
                  padding: EdgeInsets.all(10),
                  primary: Colors.white,
                  minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                ),
                onPressed: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stacked_line_chart,size: 32,color: Colors.black,),
                    SizedBox(height: 10,),
                    Text(
                      'sales'.toUpperCase(),
                      style: TextStyle(color: Colors.black,),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width:1, color:Colors.black54), //border width and color
                  padding: EdgeInsets.all(10),
                  primary: Colors.white,
                  minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                ),
                onPressed: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monetization_on_outlined,size: 32,color: Colors.black,),
                    SizedBox(height: 10,),
                    Text(
                      'Finance'.toUpperCase(),
                      style: TextStyle(color: Colors.black,),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width:1, color:Colors.black54), //border width and color
                  padding: EdgeInsets.all(10),
                  primary: Colors.white,
                  minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                ),
                onPressed: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined,size: 32,color: Colors.black,),
                    SizedBox(height: 10,),
                    Text(
                      'Inventory'.toUpperCase(),
                      style: TextStyle(color: Colors.black,),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width:1, color:Colors.black54), //border width and color
                  padding: EdgeInsets.all(10),
                  primary: Colors.white,
                  minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                ),
                onPressed: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.supervisor_account_outlined,size: 32,color: Colors.black,),
                    SizedBox(height: 10,),
                    Text(
                      'Human Resource'.toUpperCase(),
                      style: TextStyle(color: Colors.black,),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width:1, color:Colors.black54), //border width and color
                  padding: EdgeInsets.all(10),
                  primary: Colors.white,
                  minimumSize: Size(double.infinity, 40), // double.infinity is the width and 30 is the height
                onPressed: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group_outlined,size: 32,color: Colors.black,),
                    SizedBox(height: 10,),
                    Text(
                      'Customer Relation'.toUpperCase(),
                      style: TextStyle(color: Colors.black,),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text("TITLE",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
              SizedBox(height:10),
              Text("Description",style: TextStyle(fontSize: 14),textAlign: TextAlign.start,)
            ],),
          ),
        )

         */
      ],),
      /*
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NAME: ${_currentUser.displayName}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            Text(
              'EMAIL: ${_currentUser.email}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            _currentUser.emailVerified
                ? Text(
              'Email verified',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.green),
            )
                : Text(
              'Email not verified',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.red),
            ),
            SizedBox(height: 16.0),
            _isSendingVerification
                ? CircularProgressIndicator()
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isSendingVerification = true;
                    });
                    await _currentUser.sendEmailVerification();
                    setState(() {
                      _isSendingVerification = false;
                    });
                  },
                  child: Text('Verify email'),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    User? user = await FireAuth.refreshUser(_currentUser);

                    if (user != null) {
                      setState(() {
                        _currentUser = user;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _isSigningOut
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => WebLoginPage(),
                  ),
                );
              },
              child: Text('Sign out'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
       */

    );
  }
  Widget appBarWider(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.color
        //border: Border(bottom:BorderSide(
        //  color: Colors.black45, style: BorderStyle.solid,
        //)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(children: [
          Text('Dashboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(child:Container()),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                ),
              ),
            ),
          ),
          popupBar(context),
        ],),
      ),
    );
  }
  Widget sideBar(BuildContext context) {
    return _isSideBarCollapsed
        ? Container( // Side Bar closed
        width: 60,
        height: double.infinity,
        color: Theme.of(context).appBarTheme.foregroundColor,
        child: Column(children: [
          Container(
            height: 50,
            child: Align(
              alignment: Alignment.center,
              child: InkWell(
                child: Icon(Icons.menu,
                  color: Theme.of(context).iconTheme.color,
                  size: 40,
                ),
                mouseCursor: SystemMouseCursors.click,
                onTap: () {
                  setState(() {
                    _isSideBarCollapsed = false;
                  });
                  //print("SBC: " + _isSideBarCollapsed.toString());
                },
              ),
            ),
          ),
          Expanded(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                Tooltip(
                  message: "Purchasing",
                  child: ListTile(
                    mouseCursor: SystemMouseCursors.click,
                    leading: Icon(Icons.shopping_cart_outlined, color: Theme.of(context).iconTheme.color,),
                    onTap: () {
                      setState(() {
                        _isOpenPurc = true;
                        _isOpenDash = _isOpenSale = _isOpenFinc = _isOpenInvt = _isOpenHuRe = _isOpenCuRe = false;
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: "Sales",
                  child: ListTile(
                    mouseCursor: SystemMouseCursors.click,
                    leading: Icon(Icons.stacked_line_chart, color: Theme.of(context).iconTheme.color,),
                    onTap: () {
                      setState(() {
                        _isOpenSale = true;
                        _isOpenDash = _isOpenPurc = _isOpenFinc = _isOpenInvt = _isOpenHuRe = _isOpenCuRe = false;
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: "Finance",
                  child: ListTile(
                    mouseCursor: SystemMouseCursors.click,
                    leading: Icon(Icons.monetization_on_outlined, color: Theme.of(context).iconTheme.color,),
                    onTap: () {
                      setState(() {
                        _isOpenFinc = true;
                        _isOpenDash = _isOpenPurc = _isOpenSale = _isOpenInvt = _isOpenHuRe = _isOpenCuRe = false;
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: "Inventory",
                  child: ListTile(
                    mouseCursor: SystemMouseCursors.click,
                    leading: Icon(Icons.inventory_2_outlined, color: Theme.of(context).iconTheme.color,),
                    onTap: () {
                      setState(() {
                        _isOpenInvt = true;
                        _isOpenDash = _isOpenPurc = _isOpenSale = _isOpenFinc = _isOpenHuRe = _isOpenCuRe = false;
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: "Human Resources",
                  child: ListTile(
                    mouseCursor: SystemMouseCursors.click,
                    leading: Icon(Icons.supervisor_account_outlined, color: Theme.of(context).iconTheme.color,),
                    onTap: () {
                      setState(() {
                        _isOpenHuRe = true;
                        _isOpenDash = _isOpenPurc = _isOpenSale = _isOpenFinc = _isOpenInvt = _isOpenCuRe = false;
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: "Customer Relation",
                  child: ListTile(
                    mouseCursor: SystemMouseCursors.click,
                    leading: Icon(Icons.group_outlined, color: Theme.of(context).iconTheme.color,),
                    onTap: () {
                      setState(() {
                        _isOpenCuRe = true;
                        _isOpenDash = _isOpenPurc = _isOpenSale = _isOpenFinc = _isOpenInvt = _isOpenHuRe = false;
                      });
                    },
                  ),
                ),
              ],),
          ),
        ],)
    )
        : Container( // Side Bar open
        width: 250,
        height: double.infinity,
        color: Theme.of(context).appBarTheme.foregroundColor,
        child: Column(children: [
          Row(children: [
            Container(
              //color: Colors.white,
              height: 50,
              width: 200,
              child: Padding(
                padding: EdgeInsets.only(left:20),
                child: DropdownButton<String>(
                  items: <String>['Toko Utama', 'Branch A', 'Toko C', 'Toko D'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _menuVal = value!;
                    });
                  },
                  icon: Icon(Icons.card_travel_outlined, color: Theme.of(context).iconTheme.color,),
                  value: _menuVal,
                  //style: TextStyle(
                  //  color: Colors.black,
                  //),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                child: Icon(Icons.menu_open,
                  color: Theme.of(context).iconTheme.color,
                  size: 40,
                ),
                mouseCursor: SystemMouseCursors.click,
                onTap: () {
                  setState(() {
                    _isSideBarCollapsed = true;
                  });
                  //print("SBC: " + _isSideBarCollapsed.toString());
                },
              ),
            ),
          ],),
          Expanded(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  mouseCursor: SystemMouseCursors.click,
                  leading: Icon(Icons.shopping_cart_outlined, color: Theme.of(context).iconTheme.color,),
                  title: Text('Purchasing'.toUpperCase()),
                  onTap: () {
                    setState(() {
                      _isOpenPurc = true;
                      _isOpenDash = _isOpenSale = _isOpenFinc = _isOpenInvt = _isOpenHuRe = _isOpenCuRe = false;
                    });
                  },
                ),
                ListTile(
                  mouseCursor: SystemMouseCursors.click,
                  leading: Icon(Icons.stacked_line_chart, color: Theme.of(context).iconTheme.color,),
                  title: Text('Sales'.toUpperCase()),
                  onTap: () {
                    setState(() {
                      _isOpenSale = true;
                      _isOpenDash = _isOpenPurc = _isOpenFinc = _isOpenInvt = _isOpenHuRe = _isOpenCuRe = false;
                    });
                  },
                ),
                ListTile(
                  mouseCursor: SystemMouseCursors.click,
                  leading: Icon(Icons.monetization_on_outlined, color: Theme.of(context).iconTheme.color,),
                  title: Text('Finance'.toUpperCase()),
                  onTap: () {
                    setState(() {
                      _isOpenFinc = true;
                      _isOpenDash = _isOpenPurc = _isOpenSale = _isOpenInvt = _isOpenHuRe = _isOpenCuRe = false;
                    });
                  },
                ),
                ListTile(
                  mouseCursor: SystemMouseCursors.click,
                  leading: Icon(Icons.inventory_2_outlined, color: Theme.of(context).iconTheme.color,),
                  title: Text('Inventory'.toUpperCase()),
                  onTap: () {
                    setState(() {
                      _isOpenInvt = true;
                      _isOpenDash = _isOpenPurc = _isOpenSale = _isOpenFinc = _isOpenHuRe = _isOpenCuRe = false;
                    });
                  },
                ),
                ListTile(
                  mouseCursor: SystemMouseCursors.click,
                  leading: Icon(Icons.supervisor_account_outlined, color: Theme.of(context).iconTheme.color,),
                  title: Text('Human Resources'.toUpperCase()),
                  onTap: () {
                    setState(() {
                      _isOpenHuRe = true;
                      _isOpenDash = _isOpenPurc = _isOpenSale = _isOpenFinc = _isOpenInvt = _isOpenCuRe = false;
                    });
                  },
                ),
                ListTile(
                  mouseCursor: SystemMouseCursors.click,
                  leading: Icon(Icons.group_outlined, color: Theme.of(context).iconTheme.color,),
                  title: Text('Customer Relation'.toUpperCase()),
                  onTap: () {
                    setState(() {
                      _isOpenCuRe = true;
                      _isOpenDash = _isOpenPurc = _isOpenSale = _isOpenFinc = _isOpenInvt = _isOpenHuRe = false;
                    });
                  },
                ),
              ],),
          ),
        ],)
    );
  }

  Widget popupBar(BuildContext context) {
    return PopupMenuButton(
        child: CircleAvatar(
          backgroundColor: Theme.of(context).backgroundColor,
          child: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: ListTile(
              leading: Icon(Icons.account_circle, color: Theme.of(context).iconTheme.color),
              title: Text('Profile'),
              mouseCursor: SystemMouseCursors.click,
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          PopupMenuItem(
            value: 2,
            child: ListTile(
              leading: Icon(Icons.message, color: Theme.of(context).iconTheme.color),
              title: Text('Messages'),
              mouseCursor: SystemMouseCursors.click,
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          PopupMenuItem(child: PopupMenuDivider(height: 2,),height: 2,enabled: false,),
          PopupMenuItem(
            value: 3,
            child: ListTile(
              leading: Icon(Icons.logout, color: Theme.of(context).iconTheme.color),
              title: Text('Logout'),
              mouseCursor: SystemMouseCursors.click,
            ),
            onTap: () async {
              _isSigningOut
                  ? CircularProgressIndicator()
                  :
              setState(() {
                _isSigningOut = true;
              });
              await FirebaseAuth.instance.signOut();
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => WebLoginPage(),
                ),
              );
            },
          ),
        ]
    );
  }
}
