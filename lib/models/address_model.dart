class ImageGPS {
  double latitude;
  double longitude;
  String address;

  ImageGPS({
    required double latitude,
    required double longitude,
    required String address,
  })  : this.latitude = latitude,
        this.longitude = longitude,
        this.address = address;
}
