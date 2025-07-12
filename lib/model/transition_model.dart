import 'package:mobile_pos/model/product_model.dart';

import 'add_to_cart_model.dart';

class SalesTransitionModel {
  late String customerName, customerPhone, customerAddress, customerType, customerGst, customerImage, invoiceNumber, purchaseDate;
  double? totalAmount;
  double? dueAmount;
  double? returnAmount;
  double? serviceCharge;
  double? vat;
  double? discountAmount;
  double? lossProfit;
  num? totalQuantity;
  bool? isPaid;
  String? paymentType;
  List<AddToCartModel>? productList;
  String? sellerName;
  String? key;
  bool? sendWhatsappMessage;

  SalesTransitionModel({
    required this.customerName,
    required this.customerType,
    required this.customerPhone,
    required this.invoiceNumber,
    required this.purchaseDate,
    required this.customerAddress,
    required this.customerImage,
    required this.customerGst,
    this.dueAmount,
    this.totalAmount,
    this.returnAmount,
    this.vat,
    this.serviceCharge,
    this.discountAmount,
    this.isPaid,
    this.paymentType,
    this.productList,
    this.lossProfit,
    this.totalQuantity,
    this.sellerName,
    this.key,
    this.sendWhatsappMessage,
  });

  SalesTransitionModel.fromJson(Map<dynamic, dynamic> json) {
    customerName = json['customerName'] as String;
    customerPhone = json['customerPhone'].toString();
    invoiceNumber = json['invoiceNumber'].toString();
    customerAddress = json['customerAddress'] ?? '';
    customerGst = json['customerGst'] ?? '';
    customerImage = json['customerImage'] ?? 'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Profile%20Picture%2Fblank-profile-picture-973460_1280.webp?alt=media&token=3578c1e0-7278-4c03-8b56-dd007a9befd3';
    customerType = json['customerType'].toString();
    purchaseDate = json['purchaseDate'].toString();
    totalAmount = double.parse(json['totalAmount'].toString());
    serviceCharge = double.parse(json['serviceCharge'].toString());
    vat = double.parse(json['vat'].toString());
    discountAmount = double.parse(json['discountAmount'].toString());
    lossProfit = double.parse(json['lossProfit'].toString());
    totalQuantity = json['totalQuantity'];
    dueAmount = double.parse(json['dueAmount'].toString());
    returnAmount = double.parse(json['returnAmount'].toString());
    isPaid = json['isPaid'];
    sellerName = json['sellerName'];
    sendWhatsappMessage = json['sendWhatsappMessage'] ?? false;
    paymentType = json['paymentType'].toString();
    if (json['productList'] != null) {
      productList = <AddToCartModel>[];
      json['productList'].forEach((v) {
        productList!.add(AddToCartModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'customerName': customerName,
        'customerGst': customerGst,
        'customerPhone': customerPhone,
        'customerType': customerType,
        'invoiceNumber': invoiceNumber,
        'purchaseDate': purchaseDate,
        'customerImage': customerImage,
        'customerAddress': customerAddress,
        'vat': vat,
        'serviceCharge': serviceCharge,
        'discountAmount': discountAmount,
        'lossProfit': lossProfit,
        'totalAmount': totalAmount,
        'dueAmount': dueAmount,
        'returnAmount': returnAmount,
        'sellerName': sellerName,
        'sendWhatsappMessage': sendWhatsappMessage ?? false,
        'totalQuantity': totalQuantity,
        'isPaid': isPaid,
        'paymentType': paymentType,
        'productList': productList?.map((e) => e.toJson()).toList(),
      };
}

class PurchaseTransactionModel {
  late String customerName, customerPhone, customerAddress, customerType, customerGst, invoiceNumber, purchaseDate;
  double? totalAmount;
  double? dueAmount;
  double? returnAmount;
  double? discountAmount;

  bool? isPaid;
  String? paymentType;
  List<ProductModel>? productList;
  String? key;
  bool? sendWhatsappMessage;

  PurchaseTransactionModel({
    required this.customerName,
    required this.customerGst,
    required this.customerType,
    required this.customerAddress,
    required this.customerPhone,
    required this.invoiceNumber,
    required this.purchaseDate,
    this.dueAmount,
    this.totalAmount,
    this.returnAmount,
    this.discountAmount,
    this.isPaid,
    this.paymentType,
    this.productList,
    this.key,
    this.sendWhatsappMessage,
  });

  PurchaseTransactionModel.fromJson(Map<dynamic, dynamic> json) {
    customerName = json['customerName'] as String;
    customerPhone = json['customerPhone'].toString();
    customerAddress = json['customerAddress'] ?? '';
    customerGst = json['customerGst'] ?? '';
    invoiceNumber = json['invoiceNumber'].toString();
    customerType = json['customerType'].toString();
    purchaseDate = json['purchaseDate'].toString();
    totalAmount = double.parse(json['totalAmount'].toString());
    discountAmount = double.parse(json['discountAmount'].toString());
    dueAmount = double.parse(json['dueAmount'].toString());
    returnAmount = double.parse(json['returnAmount'].toString());
    isPaid = json['isPaid'];
    sendWhatsappMessage = json['sendWhatsappMessage'] ?? false;
    paymentType = json['paymentType'].toString();
    if (json['productList'] != null) {
      productList = <ProductModel>[];
      json['productList'].forEach((v) {
        productList!.add(ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'customerName': customerName,
        'customerGst': customerGst,
        'customerPhone': customerPhone,
        'customerType': customerType,
        'customerAddress': customerAddress,
        'invoiceNumber': invoiceNumber,
        'purchaseDate': purchaseDate,
        'discountAmount': discountAmount,
        'totalAmount': totalAmount,
        'dueAmount': dueAmount,
        'returnAmount': returnAmount,
        'sendWhatsappMessage': sendWhatsappMessage ?? false,
        'isPaid': isPaid,
        'paymentType': paymentType,
        'productList': productList?.map((e) => e.toJson()).toList(),
      };
}
