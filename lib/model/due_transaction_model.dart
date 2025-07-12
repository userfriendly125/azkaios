class DueTransactionModel {
  late String customerName, customerPhone, customerAddress, customerType, invoiceNumber, purchaseDate, customerGst;
  double? totalDue;
  double? dueAmountAfterPay;
  double? payDueAmount;
  bool? isPaid;
  String? paymentType;
  bool? sendWhatsappMessage;

  DueTransactionModel({
    required this.customerName,
    required this.customerType,
    required this.customerPhone,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.purchaseDate,
    required this.customerGst,
    this.dueAmountAfterPay,
    this.totalDue,
    this.payDueAmount,
    this.isPaid,
    this.paymentType,
    this.sendWhatsappMessage,
  });

  DueTransactionModel.fromJson(Map<dynamic, dynamic> json) {
    customerName = json['customerName'] as String;
    customerPhone = json['customerPhone'].toString();
    customerAddress = json['customerAddress'] ?? '';
    customerGst = json['customerGst'] ?? '';
    invoiceNumber = json['invoiceNumber'].toString();
    customerType = json['customerType'].toString();
    purchaseDate = json['purchaseDate'].toString();
    totalDue = double.parse(json['totalDue'].toString());
    sendWhatsappMessage = json['sendWhatsappMessage'] ?? false;
    dueAmountAfterPay = double.parse(json['dueAmountAfterPay'].toString());
    payDueAmount = double.parse(json['payDueAmount'].toString());
    isPaid = json['isPaid'];
    paymentType = json['paymentType'].toString();
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerAddress': customerAddress,
        'customerGst': customerGst,
        'customerType': customerType,
        'invoiceNumber': invoiceNumber,
        'purchaseDate': purchaseDate,
        'totalDue': totalDue,
        'dueAmountAfterPay': dueAmountAfterPay,
        'payDueAmount': payDueAmount,
        'isPaid': isPaid,
        'sendWhatsappMessage': sendWhatsappMessage ?? false,
        'paymentType': paymentType,
      };
}
