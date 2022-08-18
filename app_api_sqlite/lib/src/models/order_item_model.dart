class OrderItemModel{
  int idOrderItem;
  int idOrder;
  int idDispo;
  int amount;
  String sku;
  String status;
  String creationDate;

  OrderItemModel({
    required this.idOrderItem,
    required this.idOrder,
    required this.idDispo,
    required this.sku,
    required this.amount,
    required this.status,
    required this.creationDate,
  });
}