import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/core/app_asset.dart';
import 'package:flutter_auth/core/app_extension.dart';
import 'package:flutter_auth/src/model/furniture.dart';
import 'package:flutter_auth/src/model/furniture_color.dart';
import 'package:flutter_auth/src/view/screen/NewTask.dart';
import 'package:flutter_auth/src/view/screen/home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../../common/kimber_theme.dart';
import '../../../common/kimber_util.dart';
import '../../../common/kimber_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_style.dart';

class ServiceRequestPageWidget extends StatefulWidget {
  const ServiceRequestPageWidget({Key? key}) : super(key: key);

  @override
  _ServiceRequestPageWidgetState createState() =>
      _ServiceRequestPageWidgetState();
}

class _ServiceRequestPageWidgetState extends State<ServiceRequestPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void test() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        automaticallyImplyLeading: false,
        actions: [],
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Tasks',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddTask();
              },
            ),
          );
        },
        backgroundColor: ButtonsColors,
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        label: const Text("Add Task", style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: kPrimaryLightColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [const Spacer(), const Divider()],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Color(0x4D757575),
                          ),
                        ),
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('tasks')
                                .where('author',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  reverse: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    Furniture furniture = Furniture(
                                        id: snapshot.data!.docs[index].id,
                                        title: snapshot.data!.docs[index]
                                            ['title'],
                                        description: snapshot.data!.docs[index]
                                            ['description'],
                                        price: snapshot.data!.docs[index]
                                            ['price'],
                                        city: snapshot.data!.docs[index]
                                            ['city'],
                                        author: snapshot.data!.docs[index]
                                            ['author'],
                                        images: [
                                          AppAsset.IMGtoJPG(snapshot
                                              .data!.docs[index]['category'])
                                        ],
                                        colors: <FurnitureColor>[
                                          FurnitureColor(
                                              color: const Color(0xFF616161),
                                              isSelected: true),
                                          FurnitureColor(
                                              color: const Color(0xFF424242)),
                                        ]);
                                    return _listViewItem(furniture, index);
                                  },
                                );
                              } else {
                                return CircularProgressIndicator(
                                  color: kPrimaryColor,
                                );
                              }
                            })
                        /*  //future Row Parsing[Sprint 3].
                      Row(
              
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: KimberTheme.primaryColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: _furnitureImage(furniture.images[0])
                                  ,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            furniture.title,
                                            style:
                                                KimberTheme.bodyText2.override(
                                              fontFamily: 'NatoSansKhmer',
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts: false,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 2, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          furniture.city,
                                          style: KimberTheme.bodyText1.override(
                                            fontFamily: 'NatoSansKhmer',
                                            color: Color(0x80303030),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      */
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _listViewItem(Furniture furniture, int index) {
    return Row(
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
              ],
            ),
          ),
        ),
      ],
    );
  }

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
}
