import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class notifi extends StatelessWidget {
  final bool isHorizontal;
  final Function(Furniture furniture)? onTap;
  final List<Furniture> furnitureList;

  const notifi(
      {Key? key,
      this.isHorizontal = false,
      this.onTap,
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

  Widget _listViewItem(Furniture furniture, int index, int type) {
    Widget widget = Text("Hello");
    switch (type) {
      /*
      Case The notification is a rejection
      */
      case 0:
        widget = Container(
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
                        Text(furniture.title, style: h4Style)
                            .fadeAnimation(0.8),
                        const SizedBox(height: 2),
                        Text(
                          furniture.description,
                          style: h5Style.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).fadeAnimation(1.4),
                        const SizedBox(height: 3),
                        //   _furnitureScore(furniture),
                        Text("Your Offer has been Rejected!",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ],
            ));
        break;
      /*
      Case The notification is a Acception
      */
      case 1:
        widget = Container(
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
                        Text(furniture.title, style: h4Style)
                            .fadeAnimation(0.8),
                        const SizedBox(height: 2),
                        //   _furnitureScore(furniture),
                        Text(
                          furniture.description,
                          style: h5Style.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).fadeAnimation(1.4),
                        const SizedBox(height: 3),
                        Text("Your Offer has been Accepted!",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ],
            ));
        break;
      // Case Notification is Offer added to the current users task.
      case 2:
        widget = Container(
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
                        Text(furniture.title, style: h4Style)
                            .fadeAnimation(0.8),
                        const SizedBox(height: 2),
                        //   _furnitureScore(furniture),

                        Text(
                          furniture.description,
                          style: h5Style.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).fadeAnimation(1.4),
                        const SizedBox(height: 3),
                        Text("Someone Made An Offer!",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900))
                            .fadeAnimation(1.4)
                      ],
                    ),
                  ),
                ),
              ],
            ));
        break;
    }
    return GestureDetector(
      onTap: () => onTap?.call(furniture),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    //l.retainWhere((str) => str.split(' ').any((word) => word.startsWith('some')));
    print(FirebaseAuth.instance.currentUser!.uid);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('notifs')
          .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          print("1");
          print(snapshot.data!.docs.length);
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                var status = snapshot.data!.docs[index]['status'].toString();
                print("2");
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("tasks")
                        .doc(snapshot.data!.docs[index]['task'])
                        .snapshots(),
                    builder:
                        ((context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState != ConnectionState.waiting) {
                        if (snapshot.hasData) {
                          Furniture furniture = Furniture(
                              id: snapshot.data!.id,
                              author: snapshot.data!.get('author'),
                              title: snapshot.data!.get('title'),
                              description: snapshot.data!.get('description'),
                              price: "33",
                              city: snapshot.data!.get('city'),
                              images: [
                                AppAsset.IMGtoJPG(
                                    snapshot.data!.get('category'))
                              ],
                              colors: <FurnitureColor>[
                                FurnitureColor(color: const Color(0xFF616161)),
                                FurnitureColor(color: const Color(0xFF424242)),
                              ]);
                          if (status == "rejected") {
                            return Padding(
                                padding: EdgeInsets.all(10),
                                child: _listViewItem(furniture, index, 0));
                          } else if (status == "accepted") {
                            return Padding(
                                padding: EdgeInsets.all(10),
                                child: _listViewItem(furniture, index, 1));
                          } else if (status == "added") {
                            return Padding(
                                padding: EdgeInsets.all(10),
                                child: _listViewItem(furniture, index, 2));
                          } else {
                            return Offstage(
                              offstage: true,
                            );
                          }
                        } else {
                          return Offstage(
                            offstage: true,
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    }));
              },
            ),
          );
        } else {
          return CircularProgressIndicator(
            color: kPrimaryColor,
          );
        }
      },
    );
  }
}
