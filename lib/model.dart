class Model {
  final String createdAt;
  final String dueDate;
  final String invoiceId;
  final String invoiceTo;
  final String status;
  final String paymentStatus;
  final String totalSum;
  Model({required this.status, required this.createdAt, required this.dueDate, required this.invoiceId, required this.invoiceTo,required this.paymentStatus,required this.totalSum});
}