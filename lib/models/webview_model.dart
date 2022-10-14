class MapInfo {
  Map<String, dynamic>? map;
  String type;
  dynamic data;

  MapInfo(this.type, this.data);

  static MapInfo fromJson(Map<String, dynamic> json) {
    return MapInfo(json["type"], json["data"]);
  }

  String getPkName() {
    return data!["pkName"];
  }

  String getPkAddr() {
    return data!["pkAddr"];
  }

  String getPkPrice() {
    return data!["pkPice"];
  }

  String getPkOper() {
    return data!["pkOper"];
  }

  String getPkCount() {
    return data!["pkCount"];
  }

  String getPkTime() {
    return data!["pkTime"];
  }

  String getPmName() {
    return data!["pmName"];
  }

  String getPmPrice() {
    return data!["pmPrice"];
  }

  String getPmTime() {
    return data!["pmTimer"];
  }
}
