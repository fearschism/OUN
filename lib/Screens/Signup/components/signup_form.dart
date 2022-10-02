import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/login_form.dart';
import 'package:flutter_auth/src/view/screen/home_screen.dart';
import 'package:get/route_manager.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

/*
Changlog:

-[SAAD] {
  -Added Signup form Validation to all textboxes
  -Added Signup to firebase.
  -Added a Colection {'users'} to firestore so we can have all user-
  information in the dashboard
}
*/
TextEditingController emailController = new TextEditingController();
TextEditingController PasswordController = new TextEditingController();
TextEditingController ConPasswordController = new TextEditingController();
TextEditingController nameController = new TextEditingController();
TextEditingController IDController = new TextEditingController();
TextEditingController PhoneController = new TextEditingController();
final GlobalKey<FormState> _key = GlobalKey<FormState>();

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: nameController,
              obscureText: false,
              cursorColor: Color.fromARGB(255, 219, 219, 219),
              decoration: InputDecoration(
                hintText: "Your name",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
              validator: (value) {
                //Validates if the input is empty or || the name is not Correct
                //For Example
                //Input = "" empty
                //Input = "s44d 4l4g33l" has number so not correct.
                if (value!.isEmpty ||
                    !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                  return "The name Format is not Correct!";
                } else {
                  return null;
                }
              },
            ),
          ),
          TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: Color.fromARGB(255, 219, 219, 219),
              onSaved: (email) {},
              decoration: InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
              validator: ((value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value!))
                  return 'Enter Valid Email';
                else
                  return null;
              })),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: IDController,
              textInputAction: TextInputAction.done,
              obscureText: false,
              cursorColor: Color.fromARGB(255, 219, 219, 219),
              decoration: InputDecoration(
                hintText: "Your ID number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.numbers),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || value.length < 10 || value.length > 10) {
                  return "please enter a correct, 10 digit ID";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: PhoneController,
              textInputAction: TextInputAction.done,
              obscureText: false,
              cursorColor: Color.fromARGB(255, 219, 219, 219),
              decoration: InputDecoration(
                hintText: "Your phone number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.numbers),
                ),
              ),
              validator: (value) {
                //رمز سعودي
                String pattern =
                    r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$';
                RegExp regExp = RegExp(pattern);
                if (value!.isEmpty) {
                  //تاكيد اذا الرقم فاضي في الخانة
                  return 'Please enter a Saudi mobile number';
                } else if (!regExp.hasMatch(value)) {
                  //اذا الرقم السعودي غلط
                  return 'Please enter a valid Saudi mobile number';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: PasswordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: Color.fromARGB(255, 219, 219, 219),
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
              validator: (value) {
                if (value!.length < 8) {
                  return "password must be atleast 8 characters long";
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: ConPasswordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: Color.fromARGB(255, 219, 219, 219),
              decoration: InputDecoration(
                hintText: "repeat your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
              validator: (value) {
                if (value! != PasswordController.text) {
                  return "Passwords must match";
                } else {
                  return null;
                }
              },
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () async {
              if (_key.currentState!.validate()) {
                try {
                  Signup(context);
                } catch (e) {
                  //  print("catched");
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text(e.toString()),
                          ));
                }
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  //Saudi number Validation [SAAD]
  //Checks if the number is a real Saudi number with prefixes and format
  //Examples
  //05[2]4394956 /FALSE -PREFIX[2] is not real.
  //0542367894 /TRUE real number.
  String? validateMobile(String? value) {
    //رمز سعودي
    String pattern =
        r'/^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$/';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      //تاكيد اذا الرقم فاضي في الخانة
      return 'Please enter a Saudi mobile number';
    } else if (!regExp.hasMatch(value)) {
      //اذا الرقم السعودي غلط
      return 'Please enter a valid Saudi mobile number';
    }
    return null;
  }

  // regex method to validate email[SAAD]
  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value!))
      return 'Enter Valid Email';
    else
      return null;
  }

  //Repeat password Validator.[SAAD]
  String? PasswordMatch() {
    if (ConPasswordController.text == PasswordController.text) {
      return null;
    } else {
      return "Password doesn't Match!";
    }
  }

//Signup to firebase with form-Auth/Validation [SAAD]
  Future Signup(BuildContext context) async {
    try {
      //Creates User using Email and Password and then adds it to the users collection then it adds all the extra information of the user
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: PasswordController.text.trim())
          .then((data) {
        FirebaseFirestore.instance.collection("users").doc(data.user!.uid).set({
          'ID': IDController.text,
          'email': emailController.text,
          'name': nameController.text,
          'password': PasswordController.text,
          'phone': PhoneController.text,
        });
      });
    } catch (e) {
      print("catched");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text(e.toString()),
              ));
    }
    // dispose();
  }

  @override
  void dispose() {
    emailController.dispose();
    PasswordController.dispose();
    ConPasswordController.dispose();
    IDController.dispose();
    PhoneController.dispose();
  }
}
