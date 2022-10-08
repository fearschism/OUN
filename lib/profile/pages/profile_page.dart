import 'dart:async';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/constants.dart';
import './edit_description.dart';
import './edit_email.dart';
import './edit_image.dart';
import './edit_name.dart';
import './edit_phone.dart';
import '../widgets/display_image_widget.dart';

String FetchName = "";
String FetchPhone = "";
String FetchEmail = "";

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: kPrimaryLightColor,
            elevation: 1,
            title: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  'Profile',
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(5.0, 5.0),
                        blurRadius: 2.0,
                        color: ButtonsColors,
                      ),
                    ],
                    color: kPrimaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                )),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          InkWell(
              onTap: () {
                navigateSecondPage(EditImagePage());
              },
              child: DisplayImage(
                imagePath:
                    "../../screenshots/cart_screen.png", //path from firestore,
                onPressed: () {},
              )),
          FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              } else {
                return buildUserInfoDisplay(
                    FetchName, 'Name', EditNameFormPage());
              }
            },
          ),
          FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              } else {
                return buildUserInfoDisplay(
                    FetchPhone, 'Phone', EditPhoneFormPage());
              }
            },
          ),
          FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              } else {
                return buildUserInfoDisplay(
                    FetchEmail, 'Email', EditEmailFormPage());
              }
            },
          ),
          Divider(),
          const SizedBox(
            height: defaultPadding,
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 20, left: 100, right: 100),
              child: ElevatedButton.icon(
                label: Text(
                  'LOGOUT',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(ButtonsColors)),
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
              ))
        ],
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              navigateSecondPage(editPage);
                            },
                            child: Text(
                              //the value data
                              getValue,
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ))),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                      size: 40.0,
                    )
                  ]))
            ],
          ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  _fetch() async {
    final firebaseuser = await FirebaseAuth.instance.currentUser;
    if (firebaseuser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseuser.uid)
          .get()
          .then((ud) {
        FetchEmail = ud.get('email');
        FetchName = ud.get('name');
        FetchPhone = ud.get('phone');
      });
    }
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
