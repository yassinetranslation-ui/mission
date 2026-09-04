import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> none = [];

  // Light Mode Shadows
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x0F000000), // 6% opacity
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x0F000000), // 6% opacity
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 10),
      blurRadius: 10,
      spreadRadius: -5,
    ),
  ];

  // Specific Components
  static const List<BoxShadow> card = md;
  static const List<BoxShadow> elevated = lg;
  static const List<BoxShadow> floating = xl;
  static const List<BoxShadow> bottomNav = [
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, -4),
      blurRadius: 16,
    ),
  ];

  // Dark Mode Shadows
  static const List<BoxShadow> darkMd = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];
  
  static const List<BoxShadow> darkLg = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
  ];
}
