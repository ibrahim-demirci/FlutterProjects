import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '.env.dart';
import 'directions_model.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  // +'origin=2R8X%2BR4%20Bahçelievler%20İstanbul&destination=2R8W%2BX7%20Bahçelievler%20İstanbul' +
  // '&waypoints=via:2RCW%2B26%20Bahçelievler%20İstanbul|via:2RGW%2BF4%20Bağcılar%20İstanbul|via:2RJQ%2B4C%20Bağcılar%20İstanbul' +
  // '&key=${googleAPIKey}';

  final Dio _dio;
  DirectionsRepository({Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    @required bool alternative,
    @required LatLng origin,
    @required LatLng destination,
    @required String mode,
  }) async {
    log(origin.latitude.toString());

    final wayStr = '41.016842,28.847062|41.018249,28.842318';

    final response = await _dio.get(_baseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'mode': '$mode',
      //'departure_time':'now',
      // 'waypoints':'${waypoints}',
      'waypoints': wayStr,
      'alternatives': alternative ? 'true' : 'false',
      'key': googleAPIKey,
    });

    if (response.statusCode == 200) {
      log(response.data.toString());
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
