class SessionModel {
  int idSession;
  int idClient;
  String codStore;
  String status;
  String creationDate;
  String token;

  SessionModel({
    this.idSession = 0,
    required this.idClient,
    required this.codStore,
    required this.status,
    this.creationDate = '',
    this.token = '',
  });

  Map<String, dynamic> toMap() => {
        'id_session': idSession,
        'id_client': idClient,
        'cod_store': codStore,
        'status': status,
        'creation_date': creationDate,
        'token': token
      };
}
