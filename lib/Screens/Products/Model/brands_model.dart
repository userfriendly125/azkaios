class BrandsModel {
  late String brandName;

  BrandsModel(this.brandName);

  BrandsModel.fromJson(Map<dynamic, dynamic> json) : brandName = json['brandName'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'brandName': brandName,
      };
}

class ManufacturerModel {
  late String manufacturerName;

  ManufacturerModel(this.manufacturerName);

  ManufacturerModel.fromJson(Map<dynamic, dynamic> json) : manufacturerName = json['manufacturerName'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'manufacturerName': manufacturerName,
      };
}

class PaymentTypesModel {
  String id;
  String paymentTypeName;

  PaymentTypesModel({required this.id, required this.paymentTypeName});

  PaymentTypesModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        paymentTypeName = json['paymentTypeName'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': id,
        'paymentTypeName': paymentTypeName,
      };
}
