class Note {
  int? id;
  String name;
  String description;

  Note({
    this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}