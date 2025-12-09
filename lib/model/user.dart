class UserProfile {
  String id;
  String email;
  String name;
  String role;
  String imageURL;
  int createdOn;


  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.imageURL,
    required this.createdOn,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json, String documentId) {
    return UserProfile(
      id: documentId,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      imageURL: json['imageURL'] ?? '',
      createdOn: json['created_on'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'imageURL': imageURL,
      'created_on': createdOn,
    };
  }
}
