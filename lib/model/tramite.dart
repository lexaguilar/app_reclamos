class Tramite {
  final int id;
  final int tramiteId;
  final String username;
  final String cnpoliza;

  Tramite({this.id, this.tramiteId, this.username, this.cnpoliza});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tramiteId': tramiteId,
      'username': username,
      'cnpoliza': cnpoliza,
    };
  }

  factory Tramite.fromJson(Map<String, dynamic> json) {
    return Tramite(
      username: json['username'],
      cnpoliza: json['cnpoliza'],
      tramiteId: json['tramiteId'],
    );
  }
}
