import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_draw_route/directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'directions_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Demo",
      theme: ThemeData(primaryColor: Colors.black),
      home: _MapScreen(),
    );
  }
}


class _MapScreen extends StatefulWidget {
  @override
  __MapScreenState createState() => __MapScreenState();
}

class __MapScreenState extends State<_MapScreen> {


  String chosenValue = 'driving';

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(41.017901, 28.847953),
    zoom: 16.5, //genellikle max 21 kullanilir.
  );

  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }



  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;
  Directions _info;

  BitmapDescriptor pinLocationIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/marker1.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: false,
        title: const Text("Waste Management"),
        actions: [

          // Origin butonu tıklayınca origine gidiyor.
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin.position,
                    zoom: 16.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text("ORIGIN"),
            ),

          // Hedef butonu tıklayınca hedefe gidiyor
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination.position,
                    zoom: 16.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text("DESTINATION"),
            ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              _googleMapController = controller;
              controller.setMapStyle(Utils.mapStyle);
            },
            markers: {

              // Null değil ise kaynak ve hedefi marker olarak ekliyor.
              if (_origin != null) _origin,
              if (_destination != null) _destination,
            },
            polylines: {
              if (_info != null)
                Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.orange,
                    width: 5,
                    points: _info.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList())
            },

            // Uzun basışta addMarker fonksiyonunu çağırır.
            onLongPress: _addMarker,
          ),

          Positioned(
            bottom: 20,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  )
                ],
              ),
              padding: const EdgeInsets.all(0.0),
              child: Center(
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey,
                  value: chosenValue,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white,fontSize: 20),

                  items: <String>[
                    'driving',
                    'walking',
                    'bicycling',
                    'transit',

                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text(
                    "Mod",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      chosenValue = value;
                    });
                  },
                ),
              ),
            ),
          ),


          // Bilgi boş değilse süreyi ve mesafeyi gösterir.
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                height: 45.0,
                width: MediaQuery.of(context).size.width / 1.5,
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    '${_info.totalDistance}, ${_info.totalDuration}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        onPressed: () => _googleMapController.animateCamera(_info != null
            ? CameraUpdate.newLatLngBounds(_info.bounds, 100.0)
            : CameraUpdate.newCameraPosition(_initialCameraPosition)),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  // Marker ekleme fonksiyonu
  void _addMarker(LatLng pos) async {

    // İki durum vardır birincisi hiç marker yok.
    // 2. si ise iki marker da var.
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'Origin'),
            icon: pinLocationIcon,
            position: pos);
        _destination = null;

        // Hedef olmadığı için bilgi gösterilmez
        _info = null;
      });
    } else {
      // Origin zaten varsa
      // Hedefi işaretle
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon:pinLocationIcon,
          position: pos,
        );
      });
      // Yönlendirmeyi al
      final directions = await DirectionsRepository()
          .getDirections(mode :chosenValue, origin: _origin.position, destination: pos);

      // Ekranı yeniliyoruz
      setState(() {
        _info = directions;
      });
    }
  }
}

// Map için stil fonksiyonu.
class Utils {
  static String mapStyle = '''
  [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]
  
  
  ''';
}
