import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FullMapPage extends StatefulWidget {
  final LatLng initialPosition;
  final double initialZoom;
  final List<Marker>? markers;

  const FullMapPage({
    super.key,
    required this.initialPosition,
    required this.initialZoom,
    this.markers,
  });

  @override
  State<FullMapPage> createState() => _FullMapPageState();
}

class _FullMapPageState extends State<FullMapPage> {
  final TextEditingController _searchController = TextEditingController();
  late MapController _mapController;
  List<Marker> _searchMarkers = []; // Liste pour les marqueurs de recherche

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(widget.initialPosition, widget.initialZoom);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _searchPlace(String query) async {
    if (query.isNotEmpty) {
      final String nominatimUrl =
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1';

      try {
        final response = await http.get(Uri.parse(nominatimUrl));

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            final double latitude = double.parse(data[0]['lat']);
            final double longitude = double.parse(data[0]['lon']);
            final LatLng searchedLocation = LatLng(latitude, longitude);

            _mapController.move(searchedLocation, 15.0);

            setState(() {
              _searchMarkers = [
                Marker(
                  point: searchedLocation,
                  width: 30,
                  height: 30,
                  child: const Icon(Icons.location_pin, color: Colors.blue),
                ),
              ];
            });
          } else {
            _showSnackBar('Aucun résultat trouvé pour "$query"');
          }
        } else {
          _showSnackBar('Erreur lors de la récupération des résultats de recherche');
        }
      } catch (e) {
        _showSnackBar('Une erreur est survenue : $e');
      }
    } else {
      setState(() {
        _searchMarkers.clear(); // Effacer les marqueurs de recherche si la requête est vide
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Carte Complète'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: widget.initialPosition,
              zoom: widget.initialZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (widget.markers != null)
                MarkerLayer(
                  markers: widget.markers!,
                ),
              MarkerLayer(
                markers: _searchMarkers, // Afficher les marqueurs de recherche
              ),
            ],
          ),
          Positioned(
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: _searchPlace,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un lieu...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchMarkers.clear();
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
