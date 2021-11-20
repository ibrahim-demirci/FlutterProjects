import 'dart:developer';
import 'read_xml.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'directions_model.dart';
import 'map_style.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String chosenValue = 'driving';

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(41.017901, 28.847953),
    zoom: 16.5,
  );

  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  bool _alternativeChecked;
  bool _kmlChecked;
  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;
  Marker _kmlMarker;
  Directions _info;
  Set<Polyline> _polyLines = {};
  Set<Marker> _markers = {};

  BitmapDescriptor pinLocationIcon;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMapPin();
    _alternativeChecked = false;
    _kmlChecked = false;
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker1.png');
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
            markers: _markers,


            // {
            //   if (_origin != null) _origin,
            //   if (_destination != null) _destination,
            // },
            polylines: _polyLines,

            // {
            //   if (_info != null)
            //     Polyline(
            //         polylineId: const PolylineId('overview_polyline'),
            //         color: Colors.orange,
            //         width: 5,
            //         points: _info.polylinePoints
            //             .map((e) => LatLng(e.latitude, e.longitude))
            //             .toList())
            // },

            // Uzun basışta addMarker fonksiyonunu çağırır.
            onLongPress: _addMarker,
          ),
          buildDropDownMenu(context),

          buildAlternativesCheckBox(),
          buildKMLCheckBox(),
          buildClearButton(),

          // If info is not null this build info container
          if (_info != null) buildDurationAndDistanceContainer(context),
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

  Positioned buildAlternativesCheckBox() {
    return Positioned(
      left: 10,
      bottom: 20,
      child: Column(
        children: [
          Text(
            'ALTERNATIVES',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              checkColor: Colors.green,
              activeColor: Colors.transparent,
              value: _alternativeChecked,
              onChanged: (bool value) {
                setState(() {
                  _alternativeChecked = value;
                });
              }),
        ],
      ),
    );
  }

  Positioned buildKMLCheckBox() {
    return Positioned(
      left: 35,
      bottom: 80,
      child: Column(
        children: [
          Text(
            'KML',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              checkColor: Colors.green,
              activeColor: Colors.transparent,
              value: _kmlChecked,
              onChanged: (bool value) {
                setState(() {
                  _kmlChecked = value;
                });

                setState(() {
                  if (_kmlChecked == true)
                    drawRouteFromKML();
                  else
                    _polyLines.clear();
                    _markers.clear();
                });
              }),
        ],
      ),
    );
  }

  Positioned buildClearButton() {
    return Positioned(
      left: 20,
      bottom: 150,
      child: Column(
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),



            ),
            onPressed: () {
              setState(() {
                _info = null;
                _polyLines.clear();
                _origin = null;
                _destination = null;
                _markers.clear();
                _alternativeChecked = false;
                _kmlChecked = false;
              });
            },
            child: Text(
              'Clear',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),

          ),
        ],
      ),
    );
  }

  Positioned buildDropDownMenu(BuildContext context) {
    return Positioned(
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
            style: TextStyle(color: Colors.white, fontSize: 20),

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
    );
  }

  Positioned buildDurationAndDistanceContainer(BuildContext context) {
    return Positioned(
      top: 20,
      child: Column(
        children: [
          Container(
            height: 45.0,
            width: MediaQuery.of(context).size.width / 1.5,
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 12.0,
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(204, 147, 70, 140),
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
          SizedBox(
            height: 10,
          ),

          // if alternative route is available this container show.
          _info.alternativePolylinePoints != null
              ? Container(
                  height: 45.0,
                  width: MediaQuery.of(context).size.width / 1.5,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
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
                      'Alternative: ${_info.alternativeTotalDistance}, ${_info.alternativeTotalDuration}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  // Marker ekleme fonksiyonu
  void _addMarker(LatLng pos) async {


    // Set kml checkbox as unchecked
    if(_kmlChecked)
      _kmlChecked = false;



    // There are two status
    // 1 -Both markers are available
    // 2 -No marker on map


    if (_origin == null || (_origin != null && _destination != null)) {
      _markers.clear();
      setState(() {
        _origin = Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'Origin'),
            icon: pinLocationIcon,
            position: pos);
        _destination = null;
        _markers.add(_origin);

        // No information because destination is not available
        _info = null;

        // Clear lines on map
        _polyLines.clear();
      });
    } else {
      // If there is a origin add destination marker
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: pinLocationIcon,
          position: pos,
        );
        _markers.add(_destination);
      });

      // Get directions

      final directions = await DirectionsRepository().getDirections(
          mode: chosenValue,
          origin: _origin.position,
          destination: pos,
          alternative: _alternativeChecked);

      // Directions is not empty make these
      if (directions != null) {
        Polyline polyline;
        // Refresh screen
        setState(() {
          _info = directions;
          polyline = Polyline(
              polylineId: PolylineId("poly"),
              color: Color.fromARGB(204, 147, 70, 140),
              width: 6,
              points: _info.polylinePoints != null
                  ? _info.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList()
                  : null);

          _polyLines.add(polyline);
          if (_info.alternativePolylinePoints != null) {
            polyline = Polyline(
                polylineId: PolylineId("poly1"),
                color: Color.fromRGBO(255, 255, 255, 0.5),
                width: 7,
                points: _info.alternativePolylinePoints
                    .map((e) => LatLng(e.latitude, e.longitude))
                    .toList());
            _polyLines.add(polyline);
          }
        });
      }
    }
  }

  void drawRouteFromKML() async {


    // Clear routes on map if there is
    if(_markers.isNotEmpty)
      _markers.clear();
    if(_polyLines.isNotEmpty)
      _polyLines.clear();
    if(_origin != null)
      _origin = null;
    if(_destination != null)
      _destination = null;



    // Read and convert to list from kml file
    int polyNum = 0;
    final directionList = await Provider.of<KMLReader>(context, listen: false)
        .readKML(path: 'assets/path.kml');

    for (int locationNum = 0;
        locationNum < directionList.length - 1;
        locationNum += 1) {


      final org = LatLng(double.parse(directionList[locationNum][0]),
          double.parse(directionList[locationNum][1]));

      final dest = LatLng(double.parse(directionList[locationNum + 1][0]),
          double.parse(directionList[locationNum + 1][1]));


      _kmlMarker = Marker(
        markerId:  MarkerId('$locationNum'),
        infoWindow:  InfoWindow(title: '$locationNum'),
        icon: pinLocationIcon,
        position: org,
      );

      _markers.add(_kmlMarker);


      // Add finish marker
      if(locationNum == directionList.length-2){

        _markers.add(Marker(

          markerId:  MarkerId('${locationNum+1}'),
          infoWindow:  InfoWindow(title: '${locationNum+1}'),
          icon: pinLocationIcon,
          position: dest,
        ));

      }


      // final org = LatLng(
      //     double.parse(directionList[0][0]), double.parse(directionList[0][1]));
      //
      // final dest = LatLng(
      //     double.parse(directionList[1][0]), double.parse(directionList[1][1]));

      final directions = await DirectionsRepository().getDirections(
          mode: chosenValue,
          origin: org,
          destination: dest,
          alternative: _alternativeChecked);

      if (directions != null) {
        Polyline polyline;

        _info = directions;
        polyline = Polyline(
            polylineId: PolylineId("poly$polyNum"),
            color: Color.fromARGB(204, 147, 70, 140),
            width: 6,
            points: _info.polylinePoints != null
                ? _info.polylinePoints
                    .map((e) => LatLng(e.latitude, e.longitude))
                    .toList()
                : null);

        _polyLines.add(polyline);


      }
      polyNum++;
    }

    setState(() {});
  }
}
