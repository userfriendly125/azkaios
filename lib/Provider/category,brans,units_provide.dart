// ignore_for_file: file_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/GlobalComponents/Model/category_model.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart';
import 'package:mobile_pos/repository/category,brans,units_repo.dart';

import '../Screens/Products/Model/unit_model.dart';

CategoryRepo categoryRepo = CategoryRepo();
final categoryProvider = FutureProvider<List<CategoryModel>>((ref) => categoryRepo.getAllCategory());

BrandsRepo brandsRepo = BrandsRepo();
final brandsProvider = FutureProvider<List<BrandsModel>>((ref) => brandsRepo.getAllBrand());

PaymentTypeRepo paymentTypeRepo = PaymentTypeRepo();
final paymentTypeProvider = FutureProvider<List<PaymentTypesModel>>((ref) => paymentTypeRepo.getAllPaymentType());

ManufacturerRepo manufacturerRepo = ManufacturerRepo();
final manufacturerProvider = FutureProvider<List<ManufacturerModel>>((ref) => manufacturerRepo.getAllManufacturer());

UnitsRepo unitsRepo = UnitsRepo();
final unitsProvider = FutureProvider<List<UnitModel>>((ref) => unitsRepo.getAllUnits());
