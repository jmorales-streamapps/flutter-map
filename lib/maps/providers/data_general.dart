import 'package:flutter_maps_creator_v3/maps/models/prediction.dart';

class DataGeneral {
  static final DataGeneral _instancia = DataGeneral._internal();

  DataGeneral._internal();

  factory DataGeneral() {
    return _instancia;
  }

  List<Prediction> previusSelected = [];

  orderPredictions(String placeName) {
    placeName = placeName.toLowerCase();
    previusSelected.sort((a, b) {
      String aDescription = a.description.toLowerCase();
      String bDescription = b.description.toLowerCase();
      if (aDescription.contains(placeName) &&
          !bDescription.contains(placeName)) {
        return -1;
      } else if (!aDescription.contains(placeName) &&
          bDescription.contains(placeName)) {
        return 1;
      } else {
        return -1;
        // log('a.description.compareTo(b.description);: ${a.description.compareTo(b.description)}');
        // return aDescription.toLowerCase().compareTo(bDescription.toLowerCase());
      }
    });
  }
}
