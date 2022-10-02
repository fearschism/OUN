import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
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
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text('Add Task', style: KimberTheme.task,),
      ),
      backgroundColor: kPrimaryLightColor,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 80, horizontal: 35),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black),
            ),
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {},
                    child: DisplayImage(
                      imagePath: user.image,
                      onPressed: () {},
                    )),
                Text(
                  'Title',
                  style: KimberTheme.title1,
                ),
                const SizedBox(
                  height: 10,
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
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black))),
                ),
                Text('Description', style: KimberTheme.title1),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Description';
                    } else {
                      return null;
                    }
                  }),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black))),
                ),
                Text(
                  'City',
                  style: KimberTheme.title1,
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black))),
                  items: <String>['Riyadh', 'Jeddah', 'Dammam']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
                Text(
                  'Price',
                  style: KimberTheme.title1,
                ),
                Slider(
                  value: _currentSliderValue,
                  max: 200,
                  divisions: 20,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                  onChangeEnd: (value) {
                    //firebase to save value
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 20, left: 30, right: 20),
                    child: ElevatedButton(
                      child: Text('Create'),
                      onPressed: () {
                        //FirebaseAuth.instance.AddTask();
                        
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
