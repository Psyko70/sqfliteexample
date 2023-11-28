class User {
  String id;
  String name;

  User({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      '_Name': name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      name: map['_Name'],
    );
  }
}