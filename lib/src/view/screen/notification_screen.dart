import 'package:flutter/material.dart';
import 'package:flutter_auth/src/view/screen/Searched.dart';
import 'package:flutter_auth/src/view/screen/home_screen.dart';
import 'package:flutter_auth/src/view/screen/office_furniture_list_screen.dart';
import 'package:flutter_auth/src/view/widget/notification.dart';

import '../../../constants.dart';
import '../../../core/app_data.dart';
import '../../../core/app_style.dart';
import '../../model/furniture.dart';
import 'office_furniture_detail_screen.dart';

class notification extends StatelessWidget {
  const notification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future _navigate(Furniture furniture) {
      return Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OfficeFurnitureDetailScreen(furniture: furniture);
      }));
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, // <-- SEE HERE
          ),
          centerTitle: true,
          backgroundColor: kPrimaryLightColor,
          elevation: 1,
          title: Text(
            'Notifications',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 22,
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                /*const Text("waiting for responce", style: h2Style),
            FurnitureListView(
              furnitureList: AppData.furnitureList,
              // onTap: _navigate,
            ),*/

                notification_result(_navigate),
              ],
            ),
          ),
        ));
  }
}

Widget notification_result(dynamic Function(Furniture)? nav) {
  return notifi(
    furnitureList: AppData.furnitureList,
    isHorizontal: false,
    onTap: nav,
  );
}
