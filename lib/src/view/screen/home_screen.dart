import 'package:flutter/material.dart';
import 'package:flutter_auth/profile/pages/profile_page.dart';
import 'package:get/get.dart';
import '../../../core/app_color.dart';
import '../../../core/app_data.dart';
import '../../view/screen/cart_screen.dart';
import '../../view/screen/favorite_screen.dart';
import '../../view/screen/office_furniture_list_screen.dart';
import '../../view/screen/profile_screen.dart';
import '../../controller/office_furniture_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants.dart';

final OfficeFurnitureController controller =
    Get.put(OfficeFurnitureController());

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<Widget> screens = const [
    OfficeFurnitureListScreen(),
    ServiceRequestPageWidget(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () {
          return BottomNavigationBar(
            backgroundColor: kPrimaryColor.withOpacity(0.75),
            unselectedItemColor: Color.fromARGB(255, 99, 99, 99),
            currentIndex: controller.currentBottomNavItemIndex.value,
            showUnselectedLabels: true,
            onTap: controller.switchBetweenBottomNavigationItems,
            fixedColor: ButtonsColors,
            items: AppData.bottomNavigationItems
                .map(
                  (element) => BottomNavigationBarItem(
                      icon: element.icon, label: element.label),
                )
                .toList(),
          );
        },
      ),
      body: Obx(() => screens[controller.currentBottomNavItemIndex.value]),
    );
  }
}
