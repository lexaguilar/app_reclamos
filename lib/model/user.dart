class User {
  final String username;
  final String nombre;
  final int numero;
  final String token;

  User({this.username, this.nombre, this.numero, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      nombre: json['nombre'],
      numero: json['numero'],
      token: json['jwt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'nombre': nombre,
      'numero': numero,
      'token': token,
    };
  }
}
