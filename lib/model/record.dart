class EquineRecord {
  String id;
  int reading;
  int createdOn;


  EquineRecord({
    required this.id,
    required this.reading,
    required this.createdOn,

  });

  factory EquineRecord.fromJson(Map<String, dynamic> json, String documentId) {
    return EquineRecord(
      id: documentId,
      reading: json['reading'] as int,
      createdOn: json['created_on'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reading': reading,
      'created_on': createdOn,
    };
  }
}
