import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_maps_creator_v3/maps/models/prediction.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiClienteHttp {
  final HttpClient _httpClient = HttpClient();
  final String baseUrl = 'https://maps.googleapis.com/maps/api';

  Future<String?> getDirectionFromCoords(LatLng coords) async {
    var response = await get('geocode/json', params: {
      "language": "es-419",
      "latlng": "${coords.latitude},${coords.longitude}",
    });
    Map<String, dynamic> jsonMap = json.decode(response);

    return jsonMap['results'][0]['formatted_address'];

    // log('_getDirectionFromCoords:::: $request');
  }

  Future<List<Prediction>> getPredictions(String text) async {
    Predictions pred = Predictions();
    pred.searchText = text;

    // log('getLocation(String text) async {');
    String response =
        await get('place/autocomplete/json', params: {'input': text});
    // log(response);
    if (response.isNotEmpty) {
      Map<String, dynamic> jsonMap = json.decode(response);
      pred.toModel(jsonMap);
    }

    return pred.predictions;
  }

  Future<Map<String, dynamic>> getDetailsByIdPlace(String placeId) async {
    Map<String, dynamic> jsonMap = {};
    String response =
        await get('place/details/json', params: {'placeid': placeId});
    // log('getDetailsByIdPlace(String placeId) async {');
    // log(response);
    if (response.isNotEmpty) {
      jsonMap = json.decode(response);
    }
    return jsonMap;
  }

  Future<Map<String, dynamic>> getRoutes(
      {required LatLng origin, required LatLng destination}) async {
    Map<String, dynamic> jsonMap = {};
    final response = await get(
      "directions/json",
      params: {
        "language": "es-419",
        "origin": '${origin.latitude}, ${origin.longitude}',
        "destination": '${destination.latitude}, ${destination.longitude}',
      },
    );
    if (response.isNotEmpty) {
      jsonMap = json.decode(response);
    }
    return jsonMap;
  }

  /*
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
   */
  Future<String> get(String url, {Map<String, dynamic>? params}) async {
    params ??= {};
    params['key'] = Platform.isAndroid
        ? "AIzaSyBCoP5uyue_O8pMJtZOi60mAxKYkP-Ym3w"
        : "AIzaSyANNtmicoTqQf_ClrECNCI1KnKDrjRLxls";
    //
    log(Uri.parse('$baseUrl/$url').replace(queryParameters: params).toString());
    HttpClientRequest request = await _httpClient
        .getUrl(Uri.parse('$baseUrl/$url').replace(queryParameters: params));
    try {
      HttpClientResponse response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        return await response.transform(utf8.decoder).join();
      } else {
        throw Exception('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      log('Error');
      log(e.toString());
      // throw Exception('Error en la petición: ${e.toString()}');
      return '';
    }
  }
}
