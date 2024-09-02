/// id : 44
/// name : null
/// comments : null
/// deleted : false
/// created_at : "2024-07-22T14:50:54.352644Z"
/// updated_at : "2024-07-22T14:50:54.352713Z"
/// creator : 1

class ServiceProvider {
  ServiceProvider({
    int? id,
    String? name,
    String? comments,
    bool? deleted,
    String? createdAt,
    String? updatedAt,
    num? creator,
  }) {
    _id = id;
    _name = name;
    _comments = comments;
    _deleted = deleted;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _creator = creator;
  }

  ServiceProvider.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _comments = json['comments'];
    _deleted = json['deleted'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _creator = json['creator'];
  }

  int? _id;
  String? _name;
  String? _comments;
  bool? _deleted;
  String? _createdAt;
  String? _updatedAt;
  num? _creator;

  ServiceProvider copyWith({
    int? id,
    String? name,
    String? comments,
    bool? deleted,
    String? createdAt,
    String? updatedAt,
    num? creator,
  }) =>
      ServiceProvider(
        id: id ?? _id,
        name: name ?? _name,
        comments: comments ?? _comments,
        deleted: deleted ?? _deleted,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        creator: creator ?? _creator,
      );

  int? get id => _id;

  String? get name => _name;
  set name(String? value) {
    _name = value;
  }

  String? get comments => _comments;
  set comments(String? value) {
    _comments = value;
  }

  bool? get deleted => _deleted;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  num? get creator => _creator;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['comments'] = _comments;
    map['deleted'] = _deleted;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['creator'] = _creator;
    return map;
  }
}
