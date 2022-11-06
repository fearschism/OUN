import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/src/view/screen/NewTask.dart';
import 'package:flutter_auth/src/view/screen/Search_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Screens/Welcome/welcome_screen.dart';
import '../../../core/app_data.dart';
import '../../../core/app_style.dart';
import '../../model/furniture.dart';
import '../../view/screen/office_furniture_detail_screen.dart';
import '../widget/furniture_list_view.dart';
import 'package:skeletons/skeletons.dart';

var username;
TextEditingController searchC = TextEditingController();

class OfficeFurnitureListScreen extends StatefulWidget {
  const OfficeFurnitureListScreen({Key? key}) : super(key: key);

  @override
  State<OfficeFurnitureListScreen> createState() =>
      _OfficeFurnitureListScreenState();
}

class _OfficeFurnitureListScreenState extends State<OfficeFurnitureListScreen>
    with TickerProviderStateMixin {
  late TabController tabc;
  @override
  void initState() {
    super.initState();
    tabc = new TabController(length: 8, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    tabc.dispose();
    super.dispose();
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: kPrimaryLightColor,
      elevation: 0,
      title: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, right: 25, left: 25),
          child: Row(
            children: [
              Column(
                children: [
                  if (FirebaseAuth.instance.currentUser != null) ...[
                    FutureBuilder(
                        future: _fetchName(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return SkeletonListTile();
                          } else {
                            return Text(
                              "Hello, " +
                                  username.toString() +
                                  " 💙,"
                                      " Welcome to Oun",
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontFamily: 'Noto Sans CJK SC',
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
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
                        }))
                  ] else ...[
                    const LoginScreen()
                  ],
                  // search is here
                ],
              ),
            ],
          ),
        ),
        _searchBar(context),
        const SizedBox(
          height: 4,
        )
      ]),
      bottom: TabBar(
          isScrollable: true,
          controller: tabc,
          // unselectedLabelColor: Colors.black.withOpacity(0.3),
          indicatorColor: ButtonsColors,
          indicator: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          unselectedLabelColor: Colors.grey.withOpacity(0.6),
          labelColor: ButtonsColors,
          overlayColor: MaterialStateProperty.all(kPrimaryColor),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 0.0,
          indicatorPadding: EdgeInsets.all(5),
          tabs: [
            Tab(
              child: Text('All'),
            ),
            Tab(
              child: Text('Errands'),
            ),
            Tab(
              child: Text('Computers and IT'),
            ),
            Tab(
              child: Text('Construction'),
            ),
            Tab(
              child: Text('Maintenance'),
            ),
            Tab(
              child: Text('Food'),
            ),
            Tab(
              child: Text('Transport'),
            ),
            Tab(
              child: Text('Other Tasks'),
            )
          ]),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 15),
        child: Material(
          elevation: 2.5,
          shadowColor: kPrimaryColor,
          child: TextField(
            style: TextStyle(height: 1.4),
            controller: searchC,
            onEditingComplete: () {
              if (searchC.toString() != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => searchScreen(
                            searched: searchC.text,
                          )),
                );
              }
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              hintText: 'Search for Tasks...',
              prefixIcon: const Icon(
                Icons.search,
                color: kPrimaryColor,
                size: 20,
              ),
              border: textFieldStyle,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    //  يفتح تاسك بيج
    Future _navigate(Furniture furniture) {
      return Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OfficeFurnitureDetailScreen(furniture: furniture);
      }));
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(),
        body: TabBarView(controller: tabc, children: [
          getALL(_navigate),
          getByCategory(_navigate, "Errands"),
          getByCategory(_navigate, "Computers and IT"),
          getByCategory(_navigate, "Construction"),
          getByCategory(_navigate, "maintenance"),
          getByCategory(_navigate, "Food"),
          getByCategory(_navigate, "Transport"),
          getByCategory(_navigate, "Other Tasks"),
        ]));
  }
}

_fetchName() async {
  final firebaseuser = await FirebaseAuth.instance.currentUser;
  if (firebaseuser != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseuser.uid)
        .get()
        .then((ud) {
      username = ud.get('name');
    });
  }
}

Widget getALL(dynamic Function(Furniture)? nav) {
  return ListView(children: [
    FurnitureListView(
      isHorizontal: false,
      onTap: nav,
    )
  ]);
}

Widget getByCategory(dynamic Function(Furniture)? nav, String cat) {
  return ListView(children: [
    FurnitureListView(
      isHorizontal: false,
      onTap: nav,
      cat: cat,
    )
  ]);
}
