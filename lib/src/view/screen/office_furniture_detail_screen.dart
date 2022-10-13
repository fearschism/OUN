import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/app_color.dart';
import '../../../core/app_extension.dart';
import '../../../core/app_style.dart';
import '../../controller/office_furniture_controller.dart';
import '../../view/widget/counter_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../model/furniture.dart';
import '../widget/color_picker.dart';
import '../widget/rating_bar.dart';
import 'home_screen.dart';

class OfficeFurnitureDetailScreen extends StatelessWidget {
  final Furniture furniture;

  const OfficeFurnitureDetailScreen({Key? key, required this.furniture})
      : super(key: key);

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryLightColor,
      actions: [
        GetBuilder(
          builder: (OfficeFurnitureController controller) {
            return IconButton(
              iconSize: 35,
              onPressed: () => controller.isFavoriteFurniture(furniture),
              icon: furniture.isFavorite
                  ? const Icon(Icons.report_problem, color: Colors.black)
                  : const Icon(Icons.error, color: kPrimaryColor),
            );
          },
        )
      ],
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          controller.currentPageViewItemIndicator.value = 0;
          Navigator.pop(context);
        },
      ),
      title: Text(
        furniture.title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color.fromARGB(255, 114, 147, 244),
          shadows: <Shadow>[
            Shadow(
              offset: Offset(5.0, 5.0),
              blurRadius: 2.0,
              color: ButtonsColors,
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                child: Text('Price',
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              SizedBox(child: Text("\$${furniture.price}", style: h2Style))
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.lightBlack,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              controller.addToCart(furniture);
            },
            child: const Text("Add to cart"),
          )
        ],
      ),
    ).fadeAnimation(1.3);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        controller.currentPageViewItemIndicator.value = 0;
        return Future.value(true);
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PreferredSize(
                  preferredSize: Size.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        avatar: Icon(Icons.location_city, color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(5.0),
                        label: Text(
                          furniture.city,
                          style: TextStyle(
                            fontSize: 14.0,
                            height: 1.4,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      Chip(
                        avatar: Icon(Icons.location_city, color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(5.0),
                        label: Text(
                          furniture.city,
                          style: TextStyle(
                            fontSize: 14.0,
                            height: 1.4,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      Chip(
                        avatar: Icon(Icons.attach_money, color: kPrimaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                        ),
                        backgroundColor: ButtonsColors,
                        padding: const EdgeInsets.all(5.0),
                        label: Text(
                          furniture.price,
                          style: TextStyle(
                            fontSize: 14.0,
                            height: 1.4,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Center(),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: const Text("Synopsis",
                          style: h2Style, textAlign: TextAlign.end)
                      .fadeAnimation(0.6),
                ),
                Text(furniture.description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black45))
                    .fadeAnimation(0.8),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Color :",
                        style: h2Style, textAlign: TextAlign.end),
                    Expanded(child: ColorPicker(furniture.colors)),
                    Expanded(child: GetBuilder(
                      builder: (OfficeFurnitureController controller) {
                        return CounterButton(
                          label: furniture.quantity,
                          onIncrementSelected: () =>
                              controller.increaseItem(furniture),
                          onDecrementSelected: () =>
                              controller.decreaseItem(furniture),
                        );
                      },
                    ))
                  ],
                ).fadeAnimation(1.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
