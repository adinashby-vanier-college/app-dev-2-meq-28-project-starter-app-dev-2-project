import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopAroundScreen extends StatefulWidget {
  const ShopAroundScreen({super.key});

  @override
  State<ShopAroundScreen> createState() => _ShopAroundScreenState();
}

class _ShopAroundScreenState extends State<ShopAroundScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool showGroceries = true;
  bool showSupermarkets = true;
  LatLng? _currentLocation;
  bool _isLoading = false;

  // Replace with your actual Google Places API key
  static const String _googleApiKey = 'AIzaSyBMqhWiKWbINSLWQLPTPeZYVb42YY6ZOb8';

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await requestLocationPermission();
    await _getCurrentLocation();
    if (_currentLocation != null) {
      await _loadNearbyPlaces();
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      debugPrint('✅ Location permission granted');
    } else if (status.isDenied) {
      debugPrint('❌ Location permission denied');
    } else if (status.isPermanentlyDenied) {
      debugPrint('⚠️ Location permission permanently denied. Opening app settings...');
      await openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
      });

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Move camera to current location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentLocation!),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() {
        _isLoading = false;
        // Fallback to Toronto coordinates
        _currentLocation = const LatLng(43.6532, -79.3832);
      });
    }
  }

  Future<void> _loadNearbyPlaces() async {
    if (_currentLocation == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final List<Marker> markers = [];

      // Get groceries if selected
      if (showGroceries) {
        final groceryMarkers = await _searchPlaces('grocery_or_supermarket');
        markers.addAll(groceryMarkers);
      }

      // Get supermarkets if selected (and not already included in grocery search)
      if (showSupermarkets && !showGroceries) {
        final supermarketMarkers = await _searchPlaces('supermarket');
        markers.addAll(supermarketMarkers);
      }

      setState(() {
        _markers = markers.toSet();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading places: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Marker>> _searchPlaces(String type) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${_currentLocation!.latitude},${_currentLocation!.longitude}'
        '&radius=2000'
        '&type=$type'
        '&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Marker> markers = [];

        if (data['status'] == 'OK') {
          final results = data['results'] as List;

          for (int i = 0; i < results.length && i < 20; i++) { // Limit to 20 results
            final place = results[i];
            final location = place['geometry']['location'];
            final name = place['name'] ?? 'Unknown Place';
            final rating = place['rating']?.toString() ?? 'No rating';
            final vicinity = place['vicinity'] ?? '';

            markers.add(
              Marker(
                markerId: MarkerId(place['place_id']),
                position: LatLng(
                  location['lat'].toDouble(),
                  location['lng'].toDouble(),
                ),
                infoWindow: InfoWindow(
                  title: name,
                  snippet: 'Rating: $rating\n$vicinity',
                ),
                icon: type == 'grocery_or_supermarket'
                    ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
                    : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
            );
          }
        }
        return markers;
      } else {
        debugPrint('Places API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error calling Places API: $e');
      return [];
    }
  }

  void _onCheckboxChanged(String type, bool value) {
    setState(() {
      if (type == 'groceries') showGroceries = value;
      if (type == 'supermarkets') showSupermarkets = value;
    });
    _loadNearbyPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD1E8E5), Color(0xFFA7E9D0), Color(0xFF6BB3A8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1E3D36),
                        size: 28,
                      ),
                    ),
                    const Text(
                      'Shop Around',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3D36),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Checkboxes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: showGroceries,
                      onChanged: (value) =>
                          _onCheckboxChanged('groceries', value!),
                    ),
                    const Text('Groceries'),
                    const SizedBox(width: 16),
                    Checkbox(
                      value: showSupermarkets,
                      onChanged: (value) =>
                          _onCheckboxChanged('supermarkets', value!),
                    ),
                    const Text('Supermarkets'),
                  ],
                ),
              ),

              // Loading indicator or Google Map
              Expanded(
                child: _isLoading
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading nearby places...'),
                    ],
                  ),
                )
                    : _currentLocation == null
                    ? const Center(
                  child: Text('Unable to get location'),
                )
                    : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}