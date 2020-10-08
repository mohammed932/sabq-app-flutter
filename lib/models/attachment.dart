class Attachment {
  num id;
  String path, type;
  Attachment({this.id, this.type, this.path});
  factory Attachment.fromJson(json) {
    return Attachment(id: json['id'], path: json['path'], type: json['type']);
  }
}
