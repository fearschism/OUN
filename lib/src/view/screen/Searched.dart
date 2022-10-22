import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/core/app_asset.dart';
import 'package:flutter_auth/src/model/furniture_color.dart';
import 'package:flutter_auth/src/view/widget/empty_widget.dart';
import '../../../core/app_extension.dart';
import '../../view/widget/rating_bar.dart';
import '../../../core/app_style.dart';
import '../../model/furniture.dart';
import 'office_furniture_detail_screen.dart';

class Searched extends StatelessWidget {
  final bool isHorizontal;
  final Function(Furniture furniture)? onTap;
  final List<Furniture> furnitureList;
  final String searched;

  const Searched(
      {Key? key,
      this.isHorizontal = false,
      this.onTap,
      required this.searched,
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
      child: Image.asset(
        image,
        width: 100,
        height: 100,
      ),
    ).fadeAnimation(0.4);
  }

  Widget _listViewItem(Furniture furniture, int index) {
    Widget widget = Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 69, 172).withOpacity(0.5),

              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2), // changes position of shadow
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
                    Text(furniture.title, style: h4Style).fadeAnimation(0.8),
                    const SizedBox(height: 2),
                    //   _furnitureScore(furniture),
                    Text(furniture.city),
                    const SizedBox(height: 3),
                    Text(
                      furniture.description,
                      style: h5Style.copyWith(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).fadeAnimation(1.4),
                  ],
                ),
              ),
            ),
          ],
        ));
    return GestureDetector(
      onTap: () => onTap?.call(furniture),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    //l.retainWhere((str) => str.split(' ').any((word) => word.startsWith('some')));

    return isHorizontal == false
        ? StreamBuilder(
            stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      //searching Algorithm search if title contains word or desc contains word
                      String pat = r'\b' + searched.trim() + r'\b';
                      RegExp reg = RegExp(pat, caseSensitive: false);
                      if (reg.hasMatch(snapshot.data!.docs[index]['title']) ||
                          reg.hasMatch(
                              snapshot.data!.docs[index]['description'])) {
                        Furniture furniture = Furniture(
                            id: snapshot.data!.docs[index].id,
                            author: snapshot.data!.docs[index]['author'],
                            title: snapshot.data!.docs[index]['title'],
                            description: snapshot.data!.docs[index]
                                ['description'],
                            price: snapshot.data!.docs[index]['price'],
                            city: snapshot.data!.docs[index]['city'],
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
                            padding: EdgeInsets.all(10),
                            child: _listViewItem(furniture, index));
                      } else
                        return SizedBox.shrink();
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 15),
                      );
                    },
                  ),
                );
              } else {
                return CircularProgressIndicator(
                  color: kPrimaryColor,
                );
              }
            },
          )
        : Text("no ROW");
  }
}
