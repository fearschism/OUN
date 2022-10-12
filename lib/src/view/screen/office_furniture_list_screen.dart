import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/src/view/screen/NewTask.dart';
import 'package:flutter_auth/src/view/screen/Search_screen.dart';
import '../../../Screens/Welcome/welcome_screen.dart';
import '../../../core/app_data.dart';
import '../../../core/app_style.dart';
import '../../model/furniture.dart';
import '../../view/screen/office_furniture_detail_screen.dart';
import '../widget/furniture_list_view.dart';

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

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: kPrimaryLightColor,
      elevation: 0,
      title: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (FirebaseAuth.instance.currentUser != null) ...[
                    FutureBuilder(
                        future: _fetchName(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const LinearProgressIndicator();
                          } else {
                            return Text(
                              "Hello, " +
                                  username.toString() +
                                  " ❤️"
                                      "\n Welcome to Oun",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
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
                          }
                        }))
                  ] else ...[
                    const LoginScreen()
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: TabBar(
          isScrollable: true,
          controller: tabc,
          // unselectedLabelColor: Colors.black.withOpacity(0.3),
          indicatorColor: ButtonsColors,
          indicator: BoxDecoration(
            color: ButtonsColors,
            borderRadius: BorderRadius.circular(10),
          ),
          unselectedLabelColor: Colors.grey.withOpacity(0.6),
          labelColor: kPrimaryColor,
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
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
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
            hintText: 'Search for Tasks...',
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            contentPadding: const EdgeInsets.all(20),
            border: textFieldStyle,
            focusedBorder: textFieldStyle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  يفتح تاسك بيج
    Future<Widget?> _navigate(Furniture furniture) {
      return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OfficeFurnitureDetailScreen(furniture: furniture)),
      );
    }

    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            _searchBar(context),
            const Text("Tasks", style: h2Style),
            FurnitureListView(
              furnitureList: AppData.furnitureList,
              isHorizontal: false,
              onTap: _navigate,
            ),
          ],
        ),
      ),
    );
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
