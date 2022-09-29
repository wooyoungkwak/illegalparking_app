class Kakao {
  Map<String, dynamic> meta;
  List<dynamic> documents;

  Kakao({required this.meta, required this.documents});

  factory Kakao.fromJson(Map<String, dynamic> parsedJson) {
    return Kakao(
      meta: parsedJson['meta'],
      documents: parsedJson['documents'],
    );
  }
}

class Meta {
  int total_count;

  Meta({required this.total_count});

  factory Meta.fromJson(Map<String, dynamic> parsedJson) {
    return Meta(
      total_count: parsedJson['total_count'],
    );
  }
}

class Documents {
  Map<String, dynamic> roadaddress;
  Map<String, dynamic> address;

  Documents({required this.roadaddress, required this.address});
  factory Documents.fromJson(Map<String, dynamic> parsedJson) {
    return Documents(roadaddress: parsedJson['road_address'], address: parsedJson['address']);
  }
}

class Roadaddress {
  var address_name;
  var region_1depth_name;
  var region_2depth_name;
  var region_3depth_name;
  var road_name;
  var underground_yn;
  var main_building_no;
  var sub_building_no;
  var building_name;
  var zone_no;
  Roadaddress(
      {required this.address_name,
      required this.region_1depth_name,
      required this.region_2depth_name,
      required this.region_3depth_name,
      required this.road_name,
      required this.underground_yn,
      required this.main_building_no,
      required this.sub_building_no,
      required this.building_name,
      required this.zone_no});

  factory Roadaddress.fromJson(Map<String, dynamic> parsedJson) {
    return Roadaddress(
      address_name: parsedJson['address_name'],
      region_1depth_name: parsedJson['region_1depth_name'],
      region_2depth_name: parsedJson['region_2depth_name'],
      region_3depth_name: parsedJson['region_3depth_name'],
      road_name: parsedJson['road_name'],
      underground_yn: parsedJson['underground_yn'],
      main_building_no: parsedJson['main_building_no'],
      sub_building_no: parsedJson['sub_building_no'],
      building_name: parsedJson['building_name'],
      zone_no: parsedJson['zone_no'],
    );
  }
}

class Address {
  var address_name;
  var region_1depth_name;
  var region_2depth_name;
  var region_3depth_name;
  var mountain_yn;
  var main_address_no;
  var sub_address_no;
  var zip_code;

  Address(
      {required this.address_name,
      required this.region_1depth_name,
      required this.region_2depth_name,
      required this.region_3depth_name,
      required this.mountain_yn,
      required this.main_address_no,
      required this.sub_address_no,
      required this.zip_code});

  factory Address.fromJson(Map<String, dynamic> parsedJson) {
    return Address(
      address_name: parsedJson['address_name'],
      region_1depth_name: parsedJson['region_1depth_name'],
      region_2depth_name: parsedJson['region_2depth_name'],
      region_3depth_name: parsedJson['region_3depth_name'],
      mountain_yn: parsedJson['mountain_yn'],
      main_address_no: parsedJson['main_address_no'],
      sub_address_no: parsedJson['sub_address_no'],
      zip_code: parsedJson['zip_code'],
    );
  }
}
