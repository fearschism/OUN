import 'dart:ffi';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/app_color.dart';
import '../../../core/app_extension.dart';
import '../../../core/app_style.dart';
import '../../controller/office_furniture_controller.dart';
import '../../view/widget/counter_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../model/furniture.dart';
import '../widget/color_picker.dart';
import '../widget/rating_bar.dart';
import 'home_screen.dart';

var CategorySelected;
final GlobalKey<FormState> _keyVal = GlobalKey<FormState>();

class OfficeFurnitureDetailScreen extends StatelessWidget {
  final Furniture furniture;

  const OfficeFurnitureDetailScreen({Key? key, required this.furniture})
      : super(key: key);

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryLightColor,
      actions: [
        GetBuilder(
          builder: (OfficeFurnitureController controller) {
            return IconButton(
              iconSize: 35,
              onPressed: () async {
                // bool didReport = FirebaseFirestore.instance.collection('violations')
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        animType: AnimType.rightSlide,
                        headerAnimationLoop: false,
                        showCloseIcon: true,
                        body: Center(
                            child: Form(
                          key: _keyVal,
                          child: DropdownButtonFormField<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null) {
                                return 'Category is required';
                              }
                            },
                            decoration: InputDecoration(
                                prefixIcon:
                                    Icon(FontAwesomeIcons.circleQuestion),
                                prefixIconColor: Colors.white70,
                                fillColor: kPrimaryLightColor,
                                border: textFieldStyle,
                                hintText: "Please choose your Reason"),
                            items: <String>[
                              'For Sexual Purposes',
                              'For Harrasment Purposes',
                              'For Ilegallity Purposes',
                              'For Spam Purposes',
                              'For Scam Purposes',
                              'For Personal Purposes'
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
                        )),
                        btnOkOnPress: () async {
                          if (_keyVal.currentState!.validate()) {
                            if (furniture.author !=
                                FirebaseAuth.instance.currentUser!.uid) {
                              //another if(HasReported == false) if true show error message the user already reported.[WIP] rewrite tomorow.
                              await FirebaseFirestore.instance
                                  .collection("violations")
                                  .add({
                                'task': furniture.id,
                                'reporter':
                                    FirebaseAuth.instance.currentUser!.uid,
                                'reason': CategorySelected
                              }).whenComplete(() {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.rightSlide,
                                        headerAnimationLoop: false,
                                        autoHide: Duration(seconds: 3),
                                        title: "Report Recorded!",
                                        desc: "Thank you for making Oun Clean!")
                                    .show();
                              });
                            } else {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      headerAnimationLoop: false,
                                      autoHide: Duration(seconds: 3),
                                      title: "An Error Occured",
                                      desc: "You cannot Report Your Own Task")
                                  .show();
                            }
                          }
                        },
                        btnOkText: "Submit",
                        btnOkColor: kPrimaryColor,
                        btnOkIcon: FontAwesomeIcons.locationArrow)
                    .show();
              },
              icon: const Icon(Icons.error, color: Colors.redAccent),
            );
          },
        )
      ],
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          controller.currentPageViewItemIndicator.value = 0;
          Navigator.pop(context);
        },
      ),
      title: Text(
        furniture.title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color.fromARGB(255, 114, 147, 244),
          shadows: <Shadow>[
            Shadow(
              offset: Offset(5.0, 5.0),
              blurRadius: 2.0,
              color: ButtonsColors,
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                child: Text('Price',
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              SizedBox(child: Text("\$${furniture.price}", style: h2Style))
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.lightBlack,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              controller.addToCart(furniture);
            },
            child: const Text("Add to cart"),
          )
        ],
      ),
    ).fadeAnimation(1.3);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        controller.currentPageViewItemIndicator.value = 0;
        return Future.value(true);
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      avatar: Icon(FontAwesomeIcons.circleUser,
                          color: kPrimaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: kPrimaryColor, width: 2),
                      ),
                      backgroundColor: ButtonsColors,
                      padding: const EdgeInsets.all(5.0),
                      label: Text(
                        furniture.city,
                        style: TextStyle(
                          fontSize: 14.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    Chip(
                      avatar: Icon(FontAwesomeIcons.locationDot,
                          color: kPrimaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: kPrimaryColor, width: 2),
                      ),
                      backgroundColor: ButtonsColors,
                      padding: const EdgeInsets.all(5.0),
                      label: Text(
                        furniture.city,
                        style: TextStyle(
                          fontSize: 14.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    Chip(
                      avatar: Icon(FontAwesomeIcons.solidMoneyBill1,
                          color: kPrimaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          width: 2,
                          color: kPrimaryColor,
                        ),
                      ),
                      backgroundColor: ButtonsColors,
                      padding: const EdgeInsets.all(5.0),
                      label: Text(
                        furniture.price,
                        style: TextStyle(
                          fontSize: 14.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: const Text("Title",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 114, 147, 244),
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 2.0,
                                color: ButtonsColors,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.end)
                      .fadeAnimation(0.6),
                ),
                Text(furniture.title,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Center(),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: const Text("Description",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 114, 147, 244),
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 2.0,
                                color: ButtonsColors,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.end)
                      .fadeAnimation(0.6),
                ),
                Text(furniture.description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54))
                    .fadeAnimation(0.8),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Price :",
                        style: h2Style, textAlign: TextAlign.end),
                    Expanded(child: Text(furniture.price)),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                        left: 10,
                        right: 10,
                      ),
                      child: ElevatedButton.icon(
                          onPressed: () {
                            //OnPressed Logic
                          },
                          icon: const Icon(Icons.check),
                          label: const Text("OFFER")),
                    ))
                  ],
                ).fadeAnimation(1.0),
                Row(children: <Widget>[
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                  Text(
                    "OFFERS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 114, 147, 244),
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(5.0, 5.0),
                          blurRadius: 2.0,
                          color: ButtonsColors,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
