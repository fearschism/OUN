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

String? cu = "";
String Cuser() {
  if (FirebaseAuth.instance.currentUser != null)
    return cu = FirebaseAuth.instance.currentUser!.uid;
  else
    return "";
}

final snapshot = FirebaseFirestore.instance;
Future<String> getUserNameFromUID() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: Cuser())
      .get();
  return snapshot.docs.first['name'];
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
                    Text(
                      "Hello " + "\n Welcome to Oun",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )
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
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: const Icon(Icons.menu, color: Colors.grey),
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
