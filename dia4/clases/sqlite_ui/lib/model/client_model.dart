class Client {
  int id;
  String name;
  String phone;

  Client({required this.id, required this.name, required this.phone});

  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "phone": phone,
      };

  //para recibir los datos necesitamos pasarlo de Map a json
  factory Client.fromMap(Map<String, dynamic> json) => Client(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
      );
}
