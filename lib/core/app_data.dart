import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/components/background.dart';

import 'package:flutter/material.dart';
import './app_asset.dart';
import '../src/model/furniture.dart';
import '../src/model/furniture_color.dart';
import '../src/model/bottom_navigation_item.dart';

class AppData {
  const AppData._();


  static const dummyText =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

  static List<Furniture> furnitureList = [
    Furniture(
      quantity: 1,
      isFavorite: false,
      title: 'moving furniture',
      description: '',
      price: '469.99',
      //score: 3.5,
      city: 'Riyadh',
      images: [AppAsset.noimg],
      colors: <FurnitureColor>[
        FurnitureColor(color: const Color(0xFF616161), isSelected: true),
        FurnitureColor(color: const Color(0xFF424242)),
      ],
    ),
    Furniture(
      quantity: 1,
      isFavorite: false,
      title: 'Waiting in line (jarir book store)',
      description: '',
      price: '349.99',
      //score: 2.5,
      city: 'Riyadh',
      images: [
        AppAsset.noimg,
      ],
      colors: <FurnitureColor>[
        FurnitureColor(color: const Color(0xFF455a64), isSelected: true),
        FurnitureColor(color: const Color(0xFF263238)),
      ],
    ),
  ];

  static List<BottomNavigationItem> bottomNavigationItems = [
    BottomNavigationItem(const Icon(Icons.home), 'Home'),
    BottomNavigationItem(const Icon(Icons.task), 'My Tasks'),
    BottomNavigationItem(const Icon(Icons.person), 'Profile')
  ];
}
