import 'dart:ffi';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/core/app_asset.dart';
import 'package:flutter_auth/src/model/furniture_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app_extension.dart';
import '../../view/widget/rating_bar.dart';
import '../../../core/app_style.dart';
import '../../model/furniture.dart';

class FurnitureListView extends StatelessWidget {
  final bool isHorizontal;
  final Function(Furniture furniture)? onTap;
  final String? cat;
  final bool? offer;

  const FurnitureListView({
    Key? key,
    this.isHorizontal = true,
    this.onTap,
    this.cat,
    this.offer,
  }) : super(key: key);

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
                        Text(furniture.title, style: h4Style)
                            .fadeAnimation(0.1),
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
                                furniture.price,
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
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Colors.green))))),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    print("X");
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
                                  width: 2,
                                  color: kPrimaryColor,
                                ),
                              ),
                              backgroundColor: kPrimaryColor,
                              padding: const EdgeInsets.all(4.0),
                              label: Text(
                                furniture.price,
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold,
                                  color: ButtonsColors,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Chip(
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
                            ))
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
                if (snapshot.data!.docs.length > 0) {
                  print("data is here");
                  Furniture furniture = Furniture(
                      id: snapshot.data!.docs[index].id,
                      title: snapshot.data!.docs[index]['title'],
                      description: snapshot.data!.docs[index]['description'],
                      price: snapshot.data!.docs[index]['price'],
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
          .collection('tasks')
          .where('price', isEqualTo: '100')
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('tasks')
          .where('category', isEqualTo: cat!.trim())
          .snapshots();
    }
  }
}
