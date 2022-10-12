import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/core/app_asset.dart';
import 'package:flutter_auth/src/model/furniture_color.dart';
import '../../../core/app_extension.dart';
import '../../view/widget/rating_bar.dart';
import '../../../core/app_style.dart';
import '../../model/furniture.dart';

class Searched extends StatelessWidget {
  final bool isHorizontal;
  final Function(Furniture furniture)? onTap;
  final List<Furniture> furnitureList;
  final String searched;

  const Searched(
      {Key? key,
      this.isHorizontal = true,
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
              Text(furniture.price)
            ],
          )
        : Row(
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
                      const SizedBox(height: 5),
                      //   _furnitureScore(furniture),
                      Text(furniture.city),
                      const SizedBox(height: 5),
                      Text(
                        furniture.description,
                        style: h5Style.copyWith(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).fadeAnimation(1.4),
                      const SizedBox(height: 5),
                      Text(furniture.price)
                    ],
                  ),
                ),
              ),
            ],
          );

    return GestureDetector(
      onTap: () => onTap?.call(furniture),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    //l.retainWhere((str) => str.split(' ').any((word) => word.startsWith('some')));

    return isHorizontal == true
        ? StreamBuilder(
            stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      String pat = r'\b' + searched.trim() + r'\b';
                      RegExp reg = RegExp(pat, caseSensitive: false);
                      if (reg.hasMatch(snapshot.data!.docs[index]['title'])) {
                        Furniture furniture = Furniture(
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
                        return _listViewItem(furniture, index);
                      } else
                        return Text("");
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
        : Column();
  }
}
