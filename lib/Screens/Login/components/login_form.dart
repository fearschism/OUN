import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Signup/components/signup_form.dart';
import 'package:flutter_auth/core/app_style.dart';
import 'package:flutter_auth/src/view/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
//add comments please...!

final _auth = FirebaseAuth.instance;
TextEditingController LEmailController = new TextEditingController();
TextEditingController LPasswordController = new TextEditingController();
final GlobalKey<FormState> __key = GlobalKey<FormState>();

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            validator: ((value) {
              if (value!.isEmpty) {
                return 'Please enter Email';
              } else {
                return null;
              }
            }),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: Color.fromARGB(255, 219, 219, 219),
            controller: LEmailController,
            decoration: InputDecoration(
              border: textFieldStyle,
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              validator: ((value) {
                if (value!.isEmpty) {
                  return 'Please enter Password';
                } else
                  return null;
              }),
              controller: LPasswordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: Color.fromARGB(255, 219, 219, 219),
              decoration: InputDecoration(
                border: textFieldStyle,
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                try {
                  if (LPasswordController.text.isNotEmpty &&
                      LEmailController.text.isNotEmpty) {
                    final u = await _auth
                        .signInWithEmailAndPassword(
                            email: LEmailController.text.trim(),
                            password: LPasswordController.text.trim())
                        .catchError(
                            (ee) => {showAlertDialog(context, ee.toString())});
                    if (u != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                         (Route<dynamic> route) => false,
                      );
                    }
                  } else {
                    showAlertDialog(
                        context, "Please enter Email and Password Correctly");
                  }
                } catch (e) {
                  //print(LEmailController.text);
                  print(e);
                  print(__key.currentState.toString());
                }
                LEmailController.clear();
                LPasswordController.clear();
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, String e) {
    // set up the buttons
    Widget cancelButton = IconButton(
      icon: Icon(Icons.close),
      color: kPrimaryColor,
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error!"),
      content: Text(e),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
