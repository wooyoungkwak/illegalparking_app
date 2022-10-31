// ignore_for_file: prefer_initializing_formals

class ImageGPS {
  double latitude, longitude;
  String address;

  ImageGPS({
    required double latitude,
    required double longitude,
    required String address,
  })  : latitude = latitude,
        longitude = longitude,
        address = address;
}
