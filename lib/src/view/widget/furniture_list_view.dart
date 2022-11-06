import 'dart:ffi';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/core/app_asset.dart';
import 'package:flutter_auth/src/model/furniture_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:skeletons/skeletons.dart';
import '../../../core/app_extension.dart';
import '../../view/widget/rating_bar.dart';
import '../../../core/app_style.dart';
import '../../model/furniture.dart';

var username = "";
var rating = 0.00;
var price = "";
var Provider = "";
Furniture? f = null;

class FurnitureListView extends StatelessWidget {
  final bool isHorizontal;
  final Function(Furniture furniture)? onTap;
  final String? cat;
  final bool? offer;
  final String? author_id;
  final String? Task_id;
  final void Function()? refresh;

  const FurnitureListView(
      {Key? key,
      this.isHorizontal = true,
      this.refresh,
      this.onTap,
      this.cat,
      this.offer,
      this.Task_id,
      this.author_id})
      : super(key: key);

  /*Widget _furnitureScore(Furniture furniture) {
    return Row(
      children: [
        StarRatingBar(score: furniture.score),
        const SizedBox(width: 10),
        Text(furniture.score.toString(), style: h4Style),
      ],
    ).fadeAnimation(1.0);
  }*/

  Widget _furnitureImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image(
        image: AssetImage(image),
        width: 150,
        height: 150,
      ),
    ).fadeAnimation(0.1);
  }

  Widget _listViewItem(Furniture furniture, int index) {
    Widget widget;
    widget = isHorizontal == true
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 69, 172).withOpacity(0.5),

                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(username, style: h4Style).fadeAnimation(0.1),
                        const SizedBox(height: 5),
                        //   _furnitureScore(furniture),

                        Row(
                          children: [
                            Chip(
                              avatar: const Text("SAR",
                                  style: TextStyle(
                                    fontSize: 9.0,
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                    color: ButtonsColors,
                                  )),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(
                                  width: 1,
                                  color: kPrimaryColor,
                                ),
                              ),
                              backgroundColor: kPrimaryColor,
                              padding: const EdgeInsets.all(4.0),
                              label: Text(
                                price,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold,
                                  color: ButtonsColors,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 145,
                            ),
                            Row(
                              children: [
                                TextButton.icon(
                                    onPressed: () {
                                      print("Check");
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.check,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Accept",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.green),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Colors.green))))),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    refresh;
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.x,
                                    color: Colors.red,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.red),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ), //your widget here
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 69, 172).withOpacity(0.5),

                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _furnitureImage(furniture.images[0]),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(furniture.title, style: h4Style)
                            .fadeAnimation(0.1),
                        const SizedBox(height: 5),
                        //   _furnitureScore(furniture),

                        const SizedBox(height: 5),
                        Text(
                          furniture.description,
                          style: h5Style.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).fadeAnimation(0.1),
                        Row(
                          children: [
                            Chip(
                              avatar: const Icon(
                                FontAwesomeIcons.locationDot,
                                color: kPrimaryColor,
                                size: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(
                                  width: 0,
                                  color: kPrimaryColor,
                                ),
                              ),
                              backgroundColor: ButtonsColors,
                              padding: const EdgeInsets.all(4.0),
                              label: Text(
                                furniture.city,
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ), //your widget here
          );

    return GestureDetector(
      onTap: () => onTap?.call(furniture),
      child: widget,
    );
  }

  Widget listoffers(String pri, String user, String rate, String prov,
      BuildContext context, String offer_id) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 69, 172).withOpacity(0.5),

            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(user,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700))
                        .fadeAnimation(0.1),
                    Text(Provider),
                    Spacer(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            avatar: Icon(
                              FontAwesomeIcons.star,
                              color: kPrimaryLightColor,
                              size: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: const BorderSide(
                                width: 0,
                                color: kPrimaryColor,
                              ),
                            ),
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.all(4.0),
                            label: Text(
                              rate.toString(),
                              style: const TextStyle(
                                fontSize: 14.0,
                                height: 1.4,
                                fontWeight: FontWeight.bold,
                                color: ButtonsColors,
                              ),
                            ),
                          ),
                        ]),
                  ]),
                  const SizedBox(height: 5),
                  //   _furnitureScore(furniture),

                  Row(
                    children: [
                      Chip(
                        avatar: const Text("SAR",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1,
                              fontWeight: FontWeight.bold,
                              color: ButtonsColors,
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: const BorderSide(
                            width: 0,
                            color: kPrimaryColor,
                          ),
                        ),
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.all(4.0),
                        label: Text(
                          pri,
                          style: const TextStyle(
                            fontSize: 25.0,
                            height: 1.4,
                            fontWeight: FontWeight.bold,
                            color: ButtonsColors,
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.noHeader,
                                  dismissOnTouchOutside: false,
                                  dismissOnBackKeyPress: false,
                                  headerAnimationLoop: false,
                                  titleTextStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.green),
                                  title: "Accept Offer?",
                                  desc: "SAR $pri from $user \n Rating: $rate",
                                  btnCancelText: "No",
                                  btnOkText: "Yes",
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    var documents = await FirebaseFirestore
                                        .instance
                                        .collection("offers")
                                        .where('task', isEqualTo: Task_id)
                                        .get();
                                    for (int i = 0;
                                        i < documents.docs.length;
                                        i++) {
                                      if (documents.docs[i].id != offer_id) {
                                        FirebaseFirestore.instance
                                            .collection("offers")
                                            .doc(documents.docs[i].id)
                                            .delete();
                                        FirebaseFirestore.instance
                                            .collection("notifs")
                                            .add({
                                          'user': documents.docs[i]['Provider'],
                                          'task': Task_id,
                                          'status': 'rejected',
                                          'new': true
                                        });
                                      } else {
                                        FirebaseFirestore.instance
                                            .collection("notifs")
                                            .add({
                                          'user': prov,
                                          'task': Task_id,
                                          'status': 'accepted',
                                          'new': true
                                        });
                                      }
                                    }
                                    await AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.noHeader,
                                      dismissOnTouchOutside: false,
                                      dismissOnBackKeyPress: false,
                                      headerAnimationLoop: false,
                                      titleTextStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.green),
                                      title: "Offer Accepted!",
                                      desc:
                                          "SAR $pri from $user \n Rating: $rate",
                                      btnOkOnPress: () => refresh!(),
                                    ).show();
                                  },
                                ).show();
                              },
                              icon: Icon(
                                FontAwesomeIcons.check,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Colors.green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: BorderSide(
                                              width: 5,
                                              color: Colors.green))))),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                headerAnimationLoop: false,
                                title: "Reject Offer?",
                                titleTextStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.red),
                                desc: "SAR $pri from $user",
                                btnCancelText: "No",
                                btnOkText: "Yes",
                                btnCancelOnPress: () => refresh!(),
                                btnOkOnPress: () async {
                                  await FirebaseFirestore.instance
                                      .collection("offers")
                                      .doc(offer_id)
                                      .delete();
                                  await FirebaseFirestore.instance
                                      .collection("notifs")
                                      .add({
                                    'user': prov,
                                    'task': Task_id,
                                    'status': 'rejected',
                                    'new': true
                                  });
                                },
                              ).show();
                            },
                            icon: Icon(
                              FontAwesomeIcons.x,
                              color: Colors.red,
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.red),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ), //your widget here
    );
  }

  /*

  */
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Mainstream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              reverse: true,
              physics: const PageScrollPhysics(),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                if (snapshot.data!.docs.length > 0 && offer == null) {
                  print("data1 is here");
                  Furniture furniture = Furniture(
                      id: snapshot.data!.docs[index].id,
                      title: snapshot.data!.docs[index]['title'],
                      description: snapshot.data!.docs[index]['description'],
                      price: '',
                      city: snapshot.data!.docs[index]['city'],
                      author: snapshot.data!.docs[index]['author'],
                      images: [
                        AppAsset.IMGtoJPG(
                            snapshot.data!.docs[index]['category'])
                      ],
                      colors: <FurnitureColor>[
                        FurnitureColor(
                            color: const Color(0xFF616161), isSelected: true),
                        FurnitureColor(color: const Color(0xFF424242)),
                      ]);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 10),
                    child: _listViewItem(furniture, index),
                  );
                } else if (snapshot.data!.docs.length > 0 && offer == true) {
                  print("OFFER");
                  var price1 = snapshot.data!.docs[index]['price'];
                  var prov = snapshot.data!.docs[index]['Provider'];
                  var id = snapshot.data!.docs[index].id;

                  double rate = 0.0;
                  return FutureBuilder<List>(
                      future:
                          Future.wait([_FetchRate(prov), _FetchUsername(prov)]),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          List lst = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15, top: 10),
                            child: listoffers(
                                price1, lst[1], lst[0], prov, context, id),
                          );
                        } else {
                          return SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                                lines: 10,
                                spacing: 6,
                                lineStyle: SkeletonLineStyle(
                                  randomLength: true,
                                  height: 10,
                                  borderRadius: BorderRadius.circular(8),
                                  minLength:
                                      MediaQuery.of(context).size.width / 2,
                                )),
                          );
                        }
                      }));
                } else {
                  print("no data avaliable");
                  return Column(children: const [
                    Text(
                      "No Tasks Avaliable",
                      style: TextStyle(fontSize: 35, color: Colors.blue),
                    ),
                  ]);
                }
              },
            );
          } else {
            return const LinearProgressIndicator(
              backgroundColor: kPrimaryColor,
            );
          }
        });
  }

  Stream<QuerySnapshot> Mainstream() {
    //gets all categories into a mainstream
    if (this.cat == null) {
      return FirebaseFirestore.instance.collection('tasks').snapshots();
      //What Category  (cat) is it? will return the list with the category = Cat.trim() O(1) O(n+3)
    } else if (offer == true) {
      return FirebaseFirestore.instance
          .collection('offers')
          .where('task', isEqualTo: Task_id)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('tasks')
          .where('category', isEqualTo: cat!.trim())
          .snapshots();
    }
  }
}
