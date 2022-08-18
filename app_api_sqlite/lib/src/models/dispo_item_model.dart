class DispoItemModel{
  int idDispoItem;
  String codItem;
  String description;
  int uxc;
  int pallet;
  double salesRatio;
  double price;
  int idDispo;
  int frequency;
  String current;
  String creationDate;

  DispoItemModel({
    required this.idDispoItem, 
    required this.codItem,
    required this.description,
    required this.uxc,
    required this.pallet,
    required this.salesRatio,
    required this.price,
    required this.idDispo,
    required this.frequency,
    required this.current,
    required this.creationDate
  });

  Map<String, dynamic> toMap() => {
    'id_dispo_item': idDispoItem,
    'cod_item': codItem,
    'description': description,
    'uxc': uxc,
    'pallet': pallet,
    'sales_ratio': salesRatio,
    'price': price,
    'id_dispo': idDispo,
    'frequency': frequency,
    'creation_date': creationDate,
  };

  factory DispoItemModel.fromJson(Map<String, dynamic> json){
    return DispoItemModel(
      idDispoItem: json['id_registro'] ?? 0,
      codItem: json['cod_item'] ?? '',
      description: json['descripcion'] ?? '',
      uxc: json['uxc'] ?? 0,
      pallet: json['pallet'] != null ? int.parse(json['pallet']) : 0,
      salesRatio: json['sales_ratio'] != null ? double.parse(json['sales_ratio'].replaceAll(",", ".")) : 0.0,
      price: json['precio'] != null ? double.parse(json['precio'].replaceAll(",", ".")) : 0.0,
      idDispo: json['dispo'] ?? 0,
      frequency: json['frecuencia'] ?? 0,
      current: json['current'] ?? '',
      creationDate: json['fecha_creacion'] ?? '',
    );
  }  
}