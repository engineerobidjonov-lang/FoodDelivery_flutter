import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    const Color brandOrange = Color(0xFFF97316);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1. Google Map Background
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: locationData.deliveryPosition,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('delivery_person'),
                position: locationData.deliveryPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                infoWindow: const InfoWindow(title: 'Delivery Person'),
              ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // 2. Stack Overlay (Arriving Soon Message)
          if (locationData.isArrivingSoon)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.delivery_dining, color: brandOrange, size: 30),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Your order will arrive soon',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            'Estimated time: 10-15 mins',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 3. Center Delivery Icon (Centered visual element)
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: const Icon(
                Icons.person_pin_circle,
                color: brandOrange,
                size: 50,
              ),
            ),
          ),
          
          // Bottom Navigation UI
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: brandOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
