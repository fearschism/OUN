import 'dart:html';

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

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var notifyHelper;
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
      body: SingleChildScrollView(
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
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'Please enter A Title';
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
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'Please Fill The Description';
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
                onChanged: (_) {},
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              DropdownButtonFormField<String>(
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
                onChanged: (_) {},
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              TextFormField(
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'The Maximum Amount Of Money You Can Pay...';
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
