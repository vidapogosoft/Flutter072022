class OrderModel{
  int idOrder;
  String codStore;
  String send;
  String status;
  String creationDate;
  String sendDate;

  OrderModel({
    required this.idOrder, 
    required this.codStore, 
    this.send = 'N',
    this.status = 'A',
    required this.creationDate,
    this.sendDate = ''
  });

  Map<String, dynamic> toMap() => {
    'id_order': idOrder, 
    'cod_store': codStore, 
    'send': send,
    'status': status,
    'creation_date': creationDate,
    'send_date': sendDate,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json){
    return OrderModel(
      idOrder: json['id'],
      codStore: json['cod_tienda'],
      send: json['enviado'],
      status: json['estado'],
      creationDate: json['estado'],
      sendDate: ''
    );
  } 
}