class Attendant {
  final int attendantId;
  final String attendantName;
  final String attendantPhone;
  final String attendantNID;
  final String attendantPhotoURL;

  Attendant(
      {this.attendantId,
      this.attendantName,
      this.attendantPhone,
      this.attendantNID,
      this.attendantPhotoURL});

  factory Attendant.fromJson(Map<String, dynamic> json) {
    return Attendant(
        attendantId: json["ATTENDANT_ID"],
        attendantName: json["ATTENDANT_NAME"],
        attendantPhone: '${json["ATTENDANT_PHONE"]}',
        attendantNID: '${json["ATTENDANT_NID"]}',
        attendantPhotoURL: json["ATTENDANT_PHOTO"]);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ATTENDANT_ID"] = attendantId;
    map["ATTENDANT_NAME"] = attendantName;
    map["ATTENDANT_PHONE"] = attendantPhone;
    map["ATTENDANT_NID"] = attendantNID;
    map["ATTENDANT_PHOTO"] = attendantPhotoURL;

    return map;
  }

  String toJsonString() {
    return "{'ATTENDANT_ID':$attendantId,"
        "'ATTENDANT_NAME':'$attendantName',"
        "'ATTENDANT_PHONE':'$attendantPhone',"
        "'ATTENDANT_NID':'$attendantNID',"
        "'ATTENDANT_PHOTO':'$attendantPhotoURL'}";
  }
}
