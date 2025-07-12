import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/shop_category_model.dart';
import '../repository/shop_category_repo.dart';

ShopCategoryRepo categoryRepo = ShopCategoryRepo();
final shopCategoryProvider = FutureProvider<List<ShopCategoryModel>>((ref) => categoryRepo.getAllCategory());
