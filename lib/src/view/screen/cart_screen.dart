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
import 'package:buttons_tabbar/buttons_tabbar.dart';
import '../../../common/kimber_theme.dart';
import '../../../common/kimber_util.dart';
import '../../../common/kimber_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_style.dart';
import 'office_furniture_detail_screen.dart';

class ServiceRequestPageWidget extends StatefulWidget {
  const ServiceRequestPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ServiceRequestPageWidgetState createState() =>
      _ServiceRequestPageWidgetState();
}

class _ServiceRequestPageWidgetState extends State<ServiceRequestPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void test() {}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        
        length: 2,
        child: Scaffold(
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
                fontWeight: FontWeight.w900,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(5.0, 5.0),
                    blurRadius: 2.0,
                    color: ButtonsColors,
                  ),
                ],
              ),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text('MyTasks',style: TextStyle(
                color: kPrimaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(5.0, 5.0),
                    blurRadius: 2.0,
                    color: ButtonsColors,
                  ),
                ],
              ),),
                  
                ),
                Tab(
                   child: Text('MyOffers',style: TextStyle(
                color: kPrimaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(5.0, 5.0),
                    blurRadius: 2.0,
                    color: ButtonsColors,
                  ),
                ],
              ),),
                )
              ],
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
            label:
                const Text("Add Task", style: TextStyle(color: Colors.black)),
          ),
          backgroundColor: kPrimaryLightColor,
          body: 
              TabBarView(children: [ SingleChildScrollView( child:
            Column(mainAxisSize: MainAxisSize.max, children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [const Spacer(), const Divider()],
              ),
              Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('tasks')
                          .where('author',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                                    FurnitureColor(
                                        color: const Color(0xFF424242)),
                                  ]);
                              return Padding(
                                  padding: EdgeInsets.all(10),
                                  child:
                                      _listViewItem(furniture, index, context));
                            },
                          );
                        } else {
                          return CircularProgressIndicator(
                            color: kPrimaryColor,
                          );
                        }
                      })),
            ])),
            // for the offer page (needs backend modification)-------------------------------------------------------------------------
            SingleChildScrollView( child:
            Column(mainAxisSize: MainAxisSize.max, children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [const Spacer(), const Divider()],
              ),
              Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('tasks')
                          .where('author',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                                    FurnitureColor(
                                        color: const Color(0xFF424242)),
                                  ]);
                              return Padding(
                                  padding: EdgeInsets.all(10),
                                  child:
                                      _listViewItem(furniture, index, context));
                            },
                          );
                        } else {
                          return CircularProgressIndicator(
                            color: kPrimaryColor,
                          );
                        }
                      })),
            ])),
          //---------------------------------------------------------------------------------------------------------------------------
      ])),
        );
  }

  Widget _listViewItem(Furniture furniture, int index, BuildContext context) {
    Future _navigate(Furniture furniture) {
      return Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OfficeFurnitureDetailScreen(furniture: furniture);
      }));
    }

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
      onTap: () {
        _navigate(furniture);
      },
      child: widget,
    );
  }

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
}
