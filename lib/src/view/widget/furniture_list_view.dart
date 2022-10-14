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
  final List<Furniture> furnitureList;
  final String? cat;

  const FurnitureListView(
      {Key? key,
      this.isHorizontal = true,
      this.onTap,
      this.cat,
      required this.furnitureList})
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
    ).fadeAnimation(0.4);
  }

  Widget _listViewItem(Furniture furniture, int index) {
    Widget widget;
    widget = isHorizontal == true
        ? Column(
            children: [
              Hero(tag: index, child: _furnitureImage(furniture.images[0])),
              const SizedBox(height: 10),
              Text(furniture.title.addOverFlow, style: h4Style)
                  .fadeAnimation(0.8),
              //_furnitureScore(furniture),
              Text(furniture.city),
            ],
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withBlue(100).withOpacity(0.5),

                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
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
                            .fadeAnimation(0.8),
                        const SizedBox(height: 5),
                        //   _furnitureScore(furniture),

                        const SizedBox(height: 5),
                        Text(
                          furniture.description,
                          style: h5Style.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).fadeAnimation(1.4),
                        Row(
                          children: [
                            Chip(
                              avatar: Text("SAR",
                                  style: TextStyle(
                                    fontSize: 9.0,
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  )),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                  width: 2,
                                  color: kPrimaryColor,
                                ),
                              ),
                              backgroundColor: ButtonsColors,
                              padding: const EdgeInsets.all(4.0),
                              label: Text(
                                furniture.price,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Chip(
                              avatar: Icon(
                                FontAwesomeIcons.locationDot,
                                color: kPrimaryColor,
                                size: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                  width: 2,
                                  color: kPrimaryColor,
                                ),
                              ),
                              backgroundColor: ButtonsColors,
                              padding: const EdgeInsets.all(4.0),
                              label: Text(
                                furniture.city,
                                style: TextStyle(
                                  fontSize: 10.0,
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
    return isHorizontal == true
        ? SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: furnitureList.length,
              itemBuilder: (_, index) {
                Furniture furniture = furnitureList[index];
                return _listViewItem(furniture, index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Padding(
                  padding: EdgeInsets.only(left: 15),
                );
              },
            ),
          )
        : StreamBuilder(
            stream: Mainstream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data!.docs.length > 0) {
                      Furniture furniture = Furniture(
                          id: snapshot.data!.docs[index].id,
                          title: snapshot.data!.docs[index]['title'],
                          description: snapshot.data!.docs[index]
                              ['description'],
                          price: snapshot.data!.docs[index]['price'],
                          city: snapshot.data!.docs[index]['city'],
                          author: snapshot.data!.docs[index]['author'],
                          images: [
                            AppAsset.IMGtoJPG(
                                snapshot.data!.docs[index]['category'])
                          ],
                          colors: <FurnitureColor>[
                            FurnitureColor(
                                color: const Color(0xFF616161),
                                isSelected: true),
                            FurnitureColor(color: const Color(0xFF424242)),
                          ]);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 10),
                        child: _listViewItem(furniture, index),
                      );
                    } else {
                      return const Center(
                          child: Text(
                        "No Tasks in this Category",
                        style: TextStyle(fontSize: 35, color: kPrimaryColor),
                      ));
                    }
                  },
                );
              } else {
                return LinearProgressIndicator(
                  backgroundColor: kPrimaryColor,
                );
              }
            });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? Mainstream() {
    //gets all categories into a mainstream
    if (this.cat == null) {
      return FirebaseFirestore.instance.collection('tasks').snapshots();
      //What Category  (cat) is it? will return the list with the category = Cat.trim() O(1) O(n+3)
    } else {
      return FirebaseFirestore.instance
          .collection('tasks')
          .where('category', isEqualTo: cat!.trim())
          .snapshots();
    }
  }
}
