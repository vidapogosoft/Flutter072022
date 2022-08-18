class ClientModel {
  int idClient;
  String name;
  String codStore;
  double monthlySale;
  int daysMonth;
  String token;

  ClientModel({
    required this.idClient,
    required this.name,
    required this.codStore,
    this.monthlySale = 0.0,
    this.daysMonth = 0,
    this.token = '',
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
        idClient: json['id_client'],
        name: json['name'],
        codStore: json['user_cod_store'],
        monthlySale: json['monthly_sale'],
        daysMonth: json['days_month'],
        token: json['token']);
  }

  Map<String, dynamic> toMap() => {
        'id_client': idClient,
        'name': name,
        'cod_store': codStore,
        'monthly_sale': monthlySale,
        'days_month': daysMonth,
        'token': token
      };
}
