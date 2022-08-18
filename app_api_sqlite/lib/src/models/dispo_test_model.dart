class DispoTestModel{
  int idDispoTest;
  String codStore;
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

  DispoTestModel({
    required this.idDispoTest,
    required this.codStore, 
    required this.codItem,
    required this.description,
    required this.uxc,
    required this.pallet,
    required this.salesRatio,
    required this.price,
    this.idDispo = 0,
    required this.frequency,
    required this.current,
    required this.creationDate
  });

  Map<String, dynamic> toMap() => {
    'cod_store': codStore,
    'cod_item': codItem,
    'description': description,
    'uxc': uxc,
    'pallet': pallet,
    'sales_ratio': salesRatio,
    'price': price,
    'id_dispo': idDispo,
    'frequency': frequency,
    'current': current,
    'creation_date': creationDate,
  };

  factory DispoTestModel.fromJson(Map<String, dynamic> json){
    return DispoTestModel(
      idDispoTest: json['id_registro'] ?? 0,
      codStore: json['cod_tienda'],
      codItem: json['cod_item'] ?? '',
      description: json['descripcion'] ?? '',
      uxc: json['uxc'] ?? 0,
      pallet: json['pallet'] != null ? int.parse(json['pallet']) : 0,
      salesRatio: json['sales_ratio'] != null ? double.parse(json['sales_ratio'].replaceAll(",", ".")) : 0.0,
      price: json['precio'] != null ? double.parse(json['precio'].replaceAll(",", ".")) : 0.0,
      frequency: json['frecuencia'] ?? 0,
      current: json['current'] ?? 'Y',
      creationDate: json['fecha_creacion'] ?? '',
    );
  }
  
}