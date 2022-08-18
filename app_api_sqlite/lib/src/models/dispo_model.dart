class DispoModel{
  int idDispo;
  String name;

  DispoModel({required this.idDispo, required this.name});

  Map<String, dynamic> toMap() => {
    'id_dispo': idDispo,
    'name': name,
  };

  factory DispoModel.fromJson(Map<String, dynamic> json){
    return DispoModel(
      idDispo: json['id'],
      name: json['nombre'],
    );
  }  
}