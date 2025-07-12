// ignore_for_file: file_names

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/GlobalComponents/Model/category_model.dart';

import '../Screens/Products/Model/brands_model.dart';
import '../Screens/Products/Model/unit_model.dart';
import '../currency.dart';

class CategoryRepo {
  Future<List<CategoryModel>> getAllCategory() async {
    List<CategoryModel> categoryList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Categories').orderByKey().get().then((value) {
      for (var element in value.children) {
        categoryList.add(CategoryModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final categoryRef = FirebaseDatabase.instance.ref(constUserId).child('Categories');
    categoryRef.keepSynced(true);
    return categoryList;
  }
}

class BrandsRepo {
  Future<List<BrandsModel>> getAllBrand() async {
    List<BrandsModel> brandsList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Brands').orderByKey().get().then((value) {
      for (var element in value.children) {
        brandsList.add(BrandsModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final brandRef = FirebaseDatabase.instance.ref(constUserId).child('Brands');
    brandRef.keepSynced(true);
    return brandsList;
  }
}

class PaymentTypeRepo {
  Future<List<PaymentTypesModel>> getAllPaymentType() async {
    List<PaymentTypesModel> brandsList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Payment Types').orderByKey().get().then((value) {
      for (var element in value.children) {
        brandsList.add(PaymentTypesModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final brandRef = FirebaseDatabase.instance.ref(constUserId).child('Payment Types');
    brandRef.keepSynced(true);
    return brandsList;
  }
}

class ManufacturerRepo {
  Future<List<ManufacturerModel>> getAllManufacturer() async {
    List<ManufacturerModel> manufacturerList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Manufacturer').orderByKey().get().then((value) {
      for (var element in value.children) {
        manufacturerList.add(ManufacturerModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final manufacturerRef = FirebaseDatabase.instance.ref(constUserId).child('Manufacturer');
    manufacturerRef.keepSynced(true);
    return manufacturerList;
  }
}

class UnitsRepo {
  Future<List<UnitModel>> getAllUnits() async {
    List<UnitModel> unitsList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Units').orderByKey().get().then((value) {
      for (var element in value.children) {
        unitsList.add(UnitModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final unitRef = FirebaseDatabase.instance.ref(constUserId).child('Units');
    unitRef.keepSynced(true);
    return unitsList;
  }
}
