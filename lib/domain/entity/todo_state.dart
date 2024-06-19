class TodoState {
  int? id;
  String? body;

  TodoState({this.id, this.body});

  // fromJSON
  factory TodoState.fromJson(Map<String, dynamic> json) {
    return TodoState(
      id: json['id'],
      body: json['body'],
    );
  }

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
    };
  }
}