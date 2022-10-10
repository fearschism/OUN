import 'package:flutter/material.dart';
import 'package:flutter_auth/src/view/screen/Searched.dart';
import 'package:flutter_auth/src/view/screen/home_screen.dart';
import 'package:flutter_auth/src/view/screen/office_furniture_list_screen.dart';

import '../../../constants.dart';
import '../../../core/app_data.dart';
import '../../../core/app_style.dart';

class searchScreen extends StatelessWidget {
  final String searched;

  const searchScreen({Key? key, required this.searched}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }),
        iconTheme: IconThemeData(
          color: Colors.black, // <-- SEE HERE
        ),
        centerTitle: true,
        backgroundColor: kPrimaryLightColor,
        elevation: 1,
        title: Text(
          'Search',
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            /*const Text("waiting for responce", style: h2Style),
            FurnitureListView(
              furnitureList: AppData.furnitureList,
              // onTap: _navigate,
            ),*/
            const Text(
              'Results',
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
            const SizedBox(
              height: defaultPadding,
            ),
            Searched(
              furnitureList: AppData.furnitureList,
              isHorizontal: true,
              searched: searched,
              //onTap: _navigate,
            ),
          ],
        ),
      ),
    );
  }
}
