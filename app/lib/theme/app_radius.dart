import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  // Core Radius Units
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 999.0;

  // Component Radius
  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
  static const BorderRadius input = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(full));
  static const BorderRadius avatar = BorderRadius.all(Radius.circular(full));
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius bottomSheet = BorderRadius.vertical(top: Radius.circular(xl));
  
  // Child Mode specific Component Radius (rounder)
  static const BorderRadius childCard = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius childButton = BorderRadius.all(Radius.circular(full));
}
