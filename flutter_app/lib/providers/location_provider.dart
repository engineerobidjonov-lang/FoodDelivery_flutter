import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  LatLng _deliveryPosition = const LatLng(41.3111, 69.2797); // Example: Tashkent Center
  bool _isArrivingSoon = true;

  LatLng get deliveryPosition => _deliveryPosition;
  bool get isArrivingSoon => _isArrivingSoon;

  void updatePosition(LatLng newPos) {
    _deliveryPosition = newPos;
    notifyListeners();
  }

  void setArrivingSoon(bool value) {
    _isArrivingSoon = value;
    notifyListeners();
  }
}
