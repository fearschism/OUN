import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/core/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../common/kimber_theme.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import '../../../profile/pages/edit_description.dart';
import '../../../profile/pages/edit_image.dart';
import '../../../profile/user/Duser.dart';
import '../../../profile/widgets/display_image_widget.dart';
import '../../../profile/user/user_data.dart';
import 'package:flutter_auth/Screens/Login/components/login_form.dart';

TextEditingController TitleCo = new TextEditingController();
TextEditingController DescCo = new TextEditingController();
TextEditingController MoneyCo = new TextEditingController();
final GlobalKey<FormState> _keyValidation = GlobalKey<FormState>();

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var notifyHelper;
  var CitySelected;
  var CategorySelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double _currentSliderValue = 0;
  @override
  Widget build(BuildContext context) {
    final user = UserData.myUser;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // <-- SEE HERE
        ),
        centerTitle: true,
        backgroundColor: kPrimaryLightColor,
        elevation: 1,
        title: Text(
          'Add Task',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(5.0, 5.0),
                blurRadius: 2.0,
                color: ButtonsColors,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: kPrimaryLightColor,
      body: Form(
        key: _keyValidation,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kPrimaryLightColor,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: defaultPadding,
              ),
              TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: TitleCo,
                  validator: ((value) {
                    if (value!.isEmpty || value.length < 10) {
                      return 'The Title Must be at least 10 characters Long';
                    } else {
                      return null;
                    }
                  }),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      prefixIconColor: Colors.white70,
                      fillColor: kPrimaryLightColor,
                      border: textFieldStyle,
                      hintText: "Give Your Task A Title")),
              const SizedBox(
                height: defaultPadding,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: DescCo,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 10) {
                    return 'The Description Must be at least 50 characters Long';
                  } else {
                    return null;
                  }
                }),
                autofocus: true,
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 8,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    prefixIconColor: Colors.white70,
                    fillColor: kPrimaryLightColor,
                    border: textFieldStyle,
                    hintText:
                        "Enter a brief description of your desired service..",
                    hintStyle: TextStyle()),
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null) {
                    return 'City is required';
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_city),
                    prefixIconColor: Colors.white70,
                    fillColor: kPrimaryLightColor,
                    border: textFieldStyle,
                    hintText: "Please choose your city..."),
                items:
                    <String>['Riyadh', 'Jeddah', 'Dammam'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  CitySelected = value;
                },
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null) {
                    return 'Category is required';
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.category),
                    prefixIconColor: Colors.white70,
                    fillColor: kPrimaryLightColor,
                    border: textFieldStyle,
                    hintText: "Please choose your Desired Category"),
                items: <String>[
                  'maintenance',
                  'Food',
                  'Errands',
                  'Construction',
                  'Computers and IT',
                  'Transport',
                  'Other Tasks'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (val) {
                  CategorySelected = val;
                },
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: MoneyCo,
                  maxLength: 5,
                  validator: ((value) {
                    String pat = r'^[0-9]{5}$'; //not finished...
                    if (value!.isEmpty) {
                      return 'Enter The Maximum Amount Of Money You Can Pay... between 10-99999';
                    } else {
                      return null;
                    }
                  }),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.money),
                      prefixIconColor: Colors.white70,
                      fillColor: kPrimaryLightColor,
                      border: textFieldStyle,
                      hintText: "The Maximum Amount Of Money You Can Pay...")),
              const SizedBox(
                height: defaultPadding,
              ),
              Center(
                  child: Padding(
                padding: EdgeInsets.only(bottom: 20, left: 30, right: 20),
                child: ElevatedButton.icon(
                    onPressed: () {
                      if (_keyValidation.currentState!.validate()) {
                        SendNewTask(context, CitySelected, CategorySelected);
                      }
                      //OnPressed Logic
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("ADD TASK")),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

SendNewTask(BuildContext context, String city, String Categ) async {
  Widget cancelButton = IconButton(
    icon: Icon(Icons.close),
    color: kPrimaryColor,
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget Check = IconButton(
    icon: Icon(Icons.check),
    color: kPrimaryColor,
    onPressed: () {
      Navigator.pop(context);
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text("Error!"),
    content: Text("Something went wrong!"),
    actions: [
      cancelButton,
    ],
  );

  AlertDialog suc = AlertDialog(
    title: Text("Success!"),
    content: Text("Task is Added"),
    actions: [
      Check,
    ],
  );
  await FirebaseFirestore.instance
      .collection('tasks')
      .add({
        'author': FirebaseAuth.instance.currentUser!.uid.toString(),
        'title': TitleCo.text,
        'description': DescCo.text,
        'city': city,
        'category': Categ,
        'price': MoneyCo.text
      })
      .then((value) => null)
      .onError((error, stackTrace) => showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          ))
      .whenComplete(() => showDialog(
          context: context,
          builder: (BuildContext context) {
            return suc;
          }));
}
