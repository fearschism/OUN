import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/src/view/widget/empty_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../../core/app_color.dart';
import '../../../core/app_extension.dart';
import '../../../core/app_style.dart';
import '../../controller/office_furniture_controller.dart';
import '../../view/widget/counter_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../model/furniture.dart';
import '../widget/color_picker.dart';
import '../widget/furniture_list_view.dart';
import '../widget/rating_bar.dart';
import 'home_screen.dart';

var CategorySelected;
final GlobalKey<FormState> _keyVal1 = GlobalKey<FormState>();
final GlobalKey<FormState> _keyPal1 = GlobalKey<FormState>();
final TextEditingController textcon = TextEditingController();
String provider = "";

class OfficeFurnitureDetailScreen extends StatefulWidget {
  final Furniture furniture;
  const OfficeFurnitureDetailScreen({Key? key, required this.furniture})
      : super(key: key);
  @override
  State<OfficeFurnitureDetailScreen> createState() =>
      _OfficeFurnitureDetailScreenState();
}

class _OfficeFurnitureDetailScreenState
    extends State<OfficeFurnitureDetailScreen> {
  bool? _done;

  @override
  initState() {
    super.initState();
    _done = false;
  }

  @override
  void dispose() {
    super.dispose();
    textcon.clear();
  }

  //No Reported: Checks whether the user(Non-Author) has already reported or not.
  Future<bool> noReported() async {
    //int count: counts the users that already reported initial at 0
    int count = 0;
    //Task: gets the violations of the task all of them...
    QuerySnapshot task = await FirebaseFirestore.instance
        .collection("violations")
        .where('task-id', isEqualTo: widget.furniture.id)
        .get();
    //checks if the user has already reported.
    for (int i = 0; i < task.docs.length; i++) {
      if (task.docs[i]['reporter'] == FirebaseAuth.instance.currentUser!.uid) {
        count++;
      }
    }

    return count ==
        0; //returns a bool if count ==0? if yes return [true] and if NO returns [false]
  }

  Future<bool> HasOffered() async {
    //int count: counts the users that already reported initial at 0
    int count = 0;
    //Task: gets the violations of the task all of them...
    QuerySnapshot task = await FirebaseFirestore.instance
        .collection("offers")
        .where('task', isEqualTo: widget.furniture.id)
        .get();
    //checks if the user has already reported.
    for (int i = 0; i < task.docs.length; i++) {
      if (task.docs[i]['Provider'] == FirebaseAuth.instance.currentUser!.uid) {
        count++;
      }
    }

    return count ==
        0; //returns a bool if count ==0? if yes return [true] and if NO returns [false]
  }

  Future<bool> isAccepted() async {
    int count = 0;
    QuerySnapshot task = await FirebaseFirestore.instance
        .collection("notifs")
        .where('task', isEqualTo: widget.furniture.id)
        .get();
    for (int i = 0; i < task.docs.length; i++) {
      if (task.docs[i]['status'].toString().trim() == "accepted") {
        provider = task.docs[i]['user'].toString().trim();
        count++;
      }
    }

    return count == 1;
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryLightColor,
      actions: [
        GetBuilder(
          builder: (OfficeFurnitureController controller) {
            return IconButton(
              iconSize: 35,
              onPressed: () async {
                if (widget.furniture.author !=
                    FirebaseAuth.instance.currentUser!.uid) {
                  if (await noReported()) {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            animType: AnimType.rightSlide,
                            headerAnimationLoop: false,
                            showCloseIcon: true,
                            body: Center(
                                child: Form(
                              key: _keyVal1,
                              child: DropdownButtonFormField<String>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Category is required';
                                  }
                                },
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        FontAwesomeIcons.circleQuestion),
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
                              if (_keyVal1.currentState!.validate()) {
                                await FirebaseFirestore.instance
                                    .collection("violations")
                                    .add({
                                  'task-title': widget.furniture.title,
                                  'task-id': widget.furniture.id,
                                  'reporter':
                                      FirebaseAuth.instance.currentUser!.uid,
                                  'reason': CategorySelected,
                                }).whenComplete(() {
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.rightSlide,
                                          headerAnimationLoop: false,
                                          autoHide: const Duration(seconds: 3),
                                          title: "Report Recorded!",
                                          desc:
                                              "Thank you for making Oun Clean!")
                                      .show();
                                });
                              }
                            },
                            btnOkText: "Submit",
                            btnOkColor: kPrimaryColor,
                            btnOkIcon: FontAwesomeIcons.locationArrow)
                        .show();
                  } else {
                    //Displays if the user already Reported this Task!
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            headerAnimationLoop: false,
                            autoHide: const Duration(seconds: 3),
                            title: "An Error Occured",
                            desc: "You Have Already Reported This Task!")
                        .show();
                  }
                } else {
                  //Displays if author of Task is also the Current user!
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          headerAnimationLoop: false,
                          autoHide: const Duration(seconds: 3),
                          title: "An Error Occured",
                          desc: "You cannot Report Your Own Task")
                      .show();
                }
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
        widget.furniture.title.toUpperCase(),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                child: Text('Price',
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              SizedBox(
                  child: Text("\$${widget.furniture.price}", style: h2Style))
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
              controller.addToCart(widget.furniture);
            },
            child: const Text("Add to cart"),
          )
        ],
      ),
    ).fadeAnimation(1.3);
  }

  var username = "";
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
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FutureBuilder(
                        future: fetchName(),
                        builder: (context, snapshot) {
                          return Chip(
                              avatar: const Icon(FontAwesomeIcons.circleUser,
                                  color: kPrimaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                    color: kPrimaryColor, width: 2),
                              ),
                              backgroundColor: ButtonsColors,
                              padding: const EdgeInsets.all(5.0),
                              label: Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ));
                        }),
                    Chip(
                      avatar: const Icon(FontAwesomeIcons.locationDot,
                          color: kPrimaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: kPrimaryColor, width: 2),
                      ),
                      backgroundColor: ButtonsColors,
                      padding: const EdgeInsets.all(5.0),
                      label: Text(
                        widget.furniture.city,
                        style: const TextStyle(
                          fontSize: 14.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    FutureBuilder<bool>(
                      future: isAccepted(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data! == true) {
                            return Chip(
                              avatar: const Icon(FontAwesomeIcons.check,
                                  color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.all(5.0),
                              label: Text(
                                "Accepted",
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        }
                        return Offstage(
                          offstage: true,
                          child: Text('test'),
                        );
                      },
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
                Text(widget.furniture.title,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const Center(),
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
                Text(widget.furniture.description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54))
                    .fadeAnimation(0.8),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (FirebaseAuth.instance.currentUser!.uid !=
                        widget.furniture.author) ...[
                      FutureBuilder<bool>(
                          future: isAccepted(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data! == false) {
                                return Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: ElevatedButton.icon(
                                      onPressed: () async {
                                        //future<bool> hasoffered() TODO:
                                        /*
                                              AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.error,
                                                      animType:
                                                          AnimType.rightSlide,
                                                      headerAnimationLoop:
                                                          false,
                                                      autoHide: const Duration(
                                                          seconds: 3),
                                                      title: "An Error Occured",
                                                      desc:
                                                          "You have Already Offered!")
                                                  .show();
                                                  error message for an Already offered! user
                                                  */
                                        if (widget.furniture.author ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid) {
                                          AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.error,
                                                  animType: AnimType.rightSlide,
                                                  headerAnimationLoop: false,
                                                  autoHide: const Duration(
                                                      seconds: 3),
                                                  title: "An Error Occured",
                                                  desc:
                                                      "You cannot Offer your own Task!")
                                              .show();
                                        } else {
                                          if (await HasOffered()) {
                                            //Equals to 0>?
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.noHeader,
                                              animType: AnimType.rightSlide,
                                              showCloseIcon: true,
                                              body: Form(
                                                  key: _keyPal1,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 25),
                                                            child: Text(
                                                              "ADD AN OFFER",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        114,
                                                                        147,
                                                                        244),
                                                                shadows: <
                                                                    Shadow>[
                                                                  Shadow(
                                                                    offset:
                                                                        Offset(
                                                                            5.0,
                                                                            5.0),
                                                                    blurRadius:
                                                                        2.0,
                                                                    color:
                                                                        ButtonsColors,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 25,
                                                                bottom: 25),
                                                        child: TextFormField(
                                                          validator: ((value) {
                                                            String pat =
                                                                r'(10[0-9]|1[1-9]\d|[2-9]\d\d|[1-9]\d\d\d|[1-9]\d\d\d\d|[5-9]\d)$';
                                                            RegExp reg = RegExp(
                                                                pat); //not finished...
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Price cannot be Empty!';
                                                            } else if (!reg
                                                                .hasMatch(
                                                                    value))
                                                              return "between 50-99999 only'";
                                                            else {
                                                              return null;
                                                            }
                                                          }),
                                                          controller: textcon,
                                                          decoration:
                                                              const InputDecoration(
                                                            prefixIcon: Icon(
                                                                FontAwesomeIcons
                                                                    .moneyBill),
                                                            hintText: "SAR",
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton.icon(
                                                            onPressed: (() {
                                                              if (_keyPal1
                                                                  .currentState!
                                                                  .validate()) {
                                                                FirebaseFirestore.instance.collection("offers").add({
                                                                  'task': widget
                                                                      .furniture
                                                                      .id,
                                                                  'Provider':
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid,
                                                                  'task-owner': widget
                                                                      .furniture
                                                                      .author,
                                                                  'price':
                                                                      textcon
                                                                          .text,
                                                                }).whenComplete(() => AwesomeDialog(
                                                                        context:
                                                                            context,
                                                                        dialogType:
                                                                            DialogType
                                                                                .success,
                                                                        animType:
                                                                            AnimType
                                                                                .rightSlide,
                                                                        headerAnimationLoop:
                                                                            false,
                                                                        title:
                                                                            "OFFER SENT 😄",
                                                                        desc:
                                                                            "Your offer is sent!, Thanks for Offering! 🥰")
                                                                    .show());
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "notifs")
                                                                    .add({
                                                                  'user': widget
                                                                      .furniture
                                                                      .author,
                                                                  'new': true,
                                                                  'task': widget
                                                                      .furniture
                                                                      .id,
                                                                  'status':
                                                                      "added"
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              } else {
                                                                print(
                                                                    "Not validated");
                                                              }
                                                            }), //OnPressed Logic OFFER[saad]
                                                            icon:
                                                                Icon(Icons.add),
                                                            label: const Text(
                                                                "ADD"),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                            ).show();
                                          } else {
                                            AwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.error,
                                                    animType:
                                                        AnimType.rightSlide,
                                                    headerAnimationLoop: false,
                                                    autoHide: const Duration(
                                                        seconds: 1),
                                                    title: "An Error Occured",
                                                    desc:
                                                        "You have Already Offered!")
                                                .show();
                                          }
                                        }
                                      },
                                      icon: const Icon(Icons.add_box_sharp),
                                      label: const Text("OFFER")),
                                ));
                              }
                            }
                            return Offstage(
                              offstage: true,
                              child: Text('test'),
                            );
                          })
                    ]
                  ],
                ).fadeAnimation(1.4),
                if (FirebaseAuth.instance.currentUser!.uid ==
                    widget.furniture.author) ...[
                  Row(children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: const Divider(
                            color: Colors.black,
                            height: 36,
                          )),
                    ),
                    FutureBuilder(
                        future: isAccepted(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data! == false) {
                              return const Text(
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
                              );
                            } else {
                              return const Text(
                                "Offer Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: kPrimaryColor,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(5.0, 5.0),
                                      blurRadius: 2.0,
                                      color: ButtonsColors,
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                          return Offstage(
                            offstage: true,
                            child: Text("off"),
                          );
                        })),
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: const Divider(
                            color: Colors.black,
                            height: 36,
                          )),
                    ),
                  ]),
                  FutureBuilder(
                      future: isAccepted(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            if (snapshot.data! == true) {
                              print(provider);
                              return FutureBuilder<List>(
                                  future: Future.wait([
                                    _FetchUsername(provider),
                                    _FetchRate(provider),
                                    _FetchPhone(provider),
                                    _FetchPrice(provider)
                                  ]),
                                  builder: ((context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        List lst = snapshot.data!;
                                        //lst[0] is the name of the provider.
                                        //lst[1] is his/her ratings.
                                        //lst[2] is his/her phone number.
                                        //lst[3] is his/her offered price.
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Text(
                                                "Offer's Information",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  0,
                                                                  69,
                                                                  172)
                                                              .withOpacity(0.5),

                                                      spreadRadius: 2,
                                                      blurRadius: 3,
                                                      offset: const Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Chip(
                                                          avatar: const Icon(
                                                              FontAwesomeIcons
                                                                  .circleUser,
                                                              color:
                                                                  ButtonsColors),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2),
                                                          ),
                                                          backgroundColor:
                                                              kPrimaryColor,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          label: Text(
                                                            lst[0],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              height: 1.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  ButtonsColors,
                                                            ),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Chip(
                                                          avatar: const Text(
                                                            "SAR",
                                                            style: TextStyle(
                                                                color:
                                                                    ButtonsColors,
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2),
                                                          ),
                                                          backgroundColor:
                                                              kPrimaryColor,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          label: Text(
                                                            lst[3],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              height: 1.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  ButtonsColors,
                                                            ),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Chip(
                                                          avatar: const Icon(
                                                              FontAwesomeIcons
                                                                  .star,
                                                              color:
                                                                  ButtonsColors),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2),
                                                          ),
                                                          backgroundColor:
                                                              kPrimaryColor,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          label: Text(
                                                            lst[1],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              height: 1.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  ButtonsColors,
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Text(
                                                "Contact Information",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color.fromARGB(
                                                            255, 0, 69, 172)
                                                        .withOpacity(0.5),

                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Chip(
                                                        avatar: const Icon(
                                                            FontAwesomeIcons
                                                                .phone,
                                                            color:
                                                                ButtonsColors),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2),
                                                        ),
                                                        backgroundColor:
                                                            kPrimaryColor,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        label: Text(
                                                          lst[2],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.0,
                                                            height: 1.4,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                ButtonsColors,
                                                          ),
                                                        )),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      var phone = lst[2];
                                                      var price = lst[3];
                                                      final link =
                                                          WhatsAppUnilink(
                                                        phoneNumber:
                                                            '00966$phone',
                                                        text:
                                                            "Hey! i accepted your offer of SAR $price in OUN ",
                                                      );

                                                      await launchUrl(Uri.parse(
                                                          link.toString()));
                                                    },
                                                    icon: Icon(
                                                      FontAwesomeIcons.whatsapp,
                                                      color: Colors.green,
                                                      size: 30,
                                                    ),
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll<
                                                                    Color>(
                                                                Colors.green)),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      } else {
                                        return Offstage(
                                          offstage: false,
                                          child: Text("Not data"),
                                        );
                                      }
                                    } else {
                                      return LinearProgressIndicator();
                                    }
                                  }));
                            } else if (snapshot.data! == false) {
                              return SizedBox(
                                height: height,
                                child: ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [GetOffers(context)],
                                ),
                              );
                            }
                          }
                        }
                        return LinearProgressIndicator();
                      }))
                ],

                // GetOffers(),
              ],
              //TODO: A Listview of Offers
              //TODo
            ),
          ),
        ),
      ),
    );
  }

  fetchName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.furniture.author)
        .get()
        .then((ud) {
      username = ud.get('name').toString();
    });
  }

  Future<String> _FetchUsername(String prov) async {
    String s = "";
    var ud =
        await FirebaseFirestore.instance.collection('users').doc(prov).get();

    return s = ud.get('name').toString();
  }

  Future<String> _FetchRate(String prov) async {
    String r = "";
    var ud =
        await FirebaseFirestore.instance.collection('users').doc(prov).get();

    return r = ud.get('rate').toString();
  }

  Future<String> _FetchPhone(String prov) async {
    String r = "";
    var ud =
        await FirebaseFirestore.instance.collection('users').doc(prov).get();

    return r = ud.get('phone').toString();
  }

  Future<String> _FetchPrice(String prov) async {
    String r = "NO DATA";
    var ud = await FirebaseFirestore.instance
        .collection('offers')
        .where('task', isEqualTo: widget.furniture.id)
        .get();
    for (int i = 0; i < ud.docs.length; i++) {
      if (ud.docs[i]['Provider'] == provider) {
        return ud.docs[i]['price'].toString();
      }
    }
    return r;
  }

  Widget GetOffers(BuildContext ctx) {
    if (FirebaseAuth.instance.currentUser!.uid == widget.furniture.author) {
      //returns offers with accept or deny button, because the owner of the task is the current user of the program.
      return FurnitureListView(
        isHorizontal: true,
        cat: "a",
        offer: true,
        author_id: widget.furniture.author,
        Task_id: widget.furniture.id,
        refresh: () {
          setState(() {});
          print("hello lolol");
        },
      );
    } else {
      return Text("");
    }
  }
}
