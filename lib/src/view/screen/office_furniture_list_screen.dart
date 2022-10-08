import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import '../../../core/app_data.dart';
import '../../../core/app_style.dart';
import '../../model/furniture.dart';
import '../../view/screen/office_furniture_detail_screen.dart';
import '../widget/furniture_list_view.dart';

String username = "";
final snapshot = FirebaseFirestore.instance;
Future getUserNameFromUID() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('uid',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
      .get();
  username = snapshot.docs.first['name'];
}

class OfficeFurnitureListScreen extends StatelessWidget {
  const OfficeFurnitureListScreen({Key? key}) : super(key: key);

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: SafeArea(
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
                                  " <3"
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
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
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
    //                                               يفتح تاسك بيج
    /*Future<Widget?> _navigate(Furniture furniture) {
      return Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (_, __, ___) =>
              OfficeFurnitureDetailScreen(furniture: furniture),
        ),
      );
    }*/

    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            _searchBar(),
            /*const Text("waiting for responce", style: h2Style),
            FurnitureListView(
              furnitureList: AppData.furnitureList,
              // onTap: _navigate,
            ),*/
            const Text("Tasks", style: h2Style),
            FurnitureListView(
              furnitureList: AppData.furnitureList,
              isHorizontal: false,
              //onTap: _navigate,
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
