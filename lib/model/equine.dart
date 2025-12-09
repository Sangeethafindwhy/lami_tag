class Equine {
  String id;
  String breed;
  String creatorId;
  String equineName;
  String height;
  String imageURL;
  String type;
  String unit;
  int createdOn;


  Equine({
    required this.id,
    required this.breed,
    required this.creatorId,
    required this.equineName,
    required this.height,
    required this.imageURL,
    required this.type,
    required this.unit,
    required this.createdOn,

  });

  factory Equine.fromJson(Map<String, dynamic> json, String documentId) {
    return Equine(
      id: documentId,
      breed: json['breed'] as String,
      creatorId: json['creator_id'] as String,
      equineName: json['equine_name'] as String,
      height: json['height'] as String,
      imageURL: json['imageURL'] ?? '',
      type: json['type'] as String,
      unit: json['unit'] as String,
      createdOn: json['created_on'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'breed': breed,
      'creator_id': creatorId,
      'equine_name': equineName,
      'imageURL': imageURL,
      'height': height,
      'type': type,
      'unit': unit,
      'created_on': createdOn,
    };
  }
}
