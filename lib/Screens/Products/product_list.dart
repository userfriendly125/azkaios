// ignore_for_file: unused_result
import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
import 'package:mobile_pos/Screens/Products/product_details.dart';
import 'package:mobile_pos/Screens/Products/update_product.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import '../../const_commas.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../empty_screen_widget.dart';
import '../../model/product_model.dart';
import '../Warehouse/warehouse_model.dart';
import '../tax report/tax_model.dart';
import 'add_product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> with TickerProviderStateMixin {
  List<String> productCodeList = [];
  List<String> productNameList = [];
  String searchedProduct = '';
  late String categoryName = category.first;
  int count = 0;

  List<String> get category => [
        // lang.S.current.all,
        'All',
        // lang.S.current.expiring,
        'Expiring'
      ];
  TabController? tabController;

  String phoneNumber = '';
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  void deleteProduct({required String productCode, required WidgetRef updateProduct, required BuildContext context}) async {
    if (finalUserRoleModel.productDelete == false) {
      toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
      return;
    }
    EasyLoading.show(status: '${lang.S.of(context).deleting}..');
    String customerKey = '';
    await FirebaseDatabase.instance.ref(await getUserID()).child('Products').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'].toString() == productCode) {
          customerKey = element.key.toString();
        }
      }
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref("${await getUserID()}/Products/$customerKey");
    await ref.remove();
    updateProduct.refresh(categoryProvider);
    updateProduct.refresh(productProvider);
    Navigator.pop(context);
    // EasyLoading.showSuccess('Done');
    EasyLoading.showSuccess(lang.S.of(context).done);
  }

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: category.length, vsync: this);
  }

  // Added variable to keep track of the current tab index
  int i = 0;

  // //_____________________Warehouse_list____________________________________________________________________
  // WareHouseModel? selectedWareHouse;
  //
  // int j = 0;
  //
  // DropdownButton<WareHouseModel> getName({required List<WareHouseModel> list}) {
  //   // Set initial value to the first item in the list, if available
  //   // selectedWareHouse = list.isNotEmpty ? list.first : null;
  //   List<DropdownMenuItem<WareHouseModel>> dropDownItems = [];
  //   for (var element in list) {
  //     dropDownItems.add(DropdownMenuItem(
  //       alignment: AlignmentDirectional.centerEnd,
  //       value: element,
  //       child: SizedBox(
  //         width: 150,
  //         child: Text(
  //           element.warehouseName,
  //           style: kTextStyle.copyWith(color: kTitleColor, fontSize: 14),
  //           overflow: TextOverflow.ellipsis,
  //           textAlign: TextAlign.end,
  //         ),
  //       ),
  //     ));
  //     if (j == 0) {
  //       selectedWareHouse = element;
  //     }
  //     j++;
  //   }
  //
  //   return DropdownButton(
  //     icon: const Icon(
  //       Icons.keyboard_arrow_down_outlined,
  //       color: kGreyTextColor,
  //     ),
  //     items: dropDownItems,
  //     isExpanded: false,
  //     isDense: true,
  //     value: selectedWareHouse,
  //     onChanged: (WareHouseModel? value) {
  //       setState(() {
  //         selectedWareHouse = value;
  //       });
  //     },
  //   );
  // }

  bool isRegularSelected = true;

  @override
  Widget build(BuildContext context) {
    List<WarehouseBasedProductModel> warehouseBasedProductModel = [];
    List<String> allWarehouseId = [];
    return Consumer(builder: (context, ref, __) {
      final groupTax = ref.watch(groupTaxProvider);
      final providerData = ref.watch(productProvider);
      final categoryData = ref.watch(categoryProvider);
      return categoryData.when(data: (categoryList) {
        for (int i = 0; i < categoryList.length; i++) {
          category.contains(categoryList[i].categoryName) ? null : category.add(categoryList[i].categoryName);
        }
        i == 0 ? tabController = TabController(length: category.length, vsync: this) : null;
        i++;

        return DefaultTabController(
          initialIndex: 0,
          length: category.length,
          child: Scaffold(
            backgroundColor: kMainColor,
            appBar: AppBar(
              backgroundColor: kMainColor,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ).onTap(() async {
                await Future.delayed(const Duration(microseconds: 100)).then((value) => const Home().launch(context));
              }),
              title: Text(
                lang.S.of(context).productList,
                // 'Product List',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            body: WillPopScope(
              onWillPop: () async {
                await Future.delayed(const Duration(microseconds: 100)).then((value) {
                  if (mounted) {
                    const Home().launch(context);
                    return true;
                  } else {
                    return false;
                  }
                });
                return false;
              },
              child: Container(
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      TabBar(
                        controller: tabController,
                        padding: EdgeInsets.zero,
                        isScrollable: true,
                        labelColor: kMainColor,
                        unselectedLabelColor: kGreyTextColor,
                        indicatorColor: kMainColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabAlignment: TabAlignment.start,
                        indicator: UnderlineTabIndicator(
                          borderSide: const BorderSide(color: kMainColor, width: 4),
                          borderRadius: BorderRadius.only(
                            topLeft: radiusCircular(6.0),
                            topRight: radiusCircular(6.0),
                          ),
                        ),
                        tabs: category.map((String tab) {
                          return Tab(text: tab);
                        }).toList(),
                        // List.generate(
                        //   category.length,
                        //   (index) => Padding(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: Text(
                        //       category[index],
                        //       style: const TextStyle(color: kMainColor, fontSize: 18.0),
                        //     ),
                        //   ),
                        // ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              searchedProduct = value;
                            });
                          },
                          decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0), floatingLabelBehavior: FloatingLabelBehavior.never, labelText: lang.S.of(context).productName, hintText: lang.S.of(context).enterProductName, border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.search)),
                        ),
                      ),
                      providerData.when(data: (products) {
                        List<ProductModel> showAbleProducts = [];
                        for (var element in products) {
                          productNameList.add(element.productName.removeAllWhiteSpace().toLowerCase());
                          productCodeList.add(element.productCode.removeAllWhiteSpace().toLowerCase());
                          warehouseBasedProductModel.add(WarehouseBasedProductModel(element.productName, element.warehouseId));

                          allWarehouseId.add(element.warehouseId);
                          if (!isRegularSelected) {
                            if (((element.productName.removeAllWhiteSpace().toLowerCase().contains(searchedProduct.toString().toLowerCase()) || element.productName.contains(searchedProduct.toString()))) && element.expiringDate != null && ((DateTime.tryParse(element.expiringDate ?? '') ?? DateTime.now()).isBefore(DateTime.now().add(const Duration(days: 7))))) {
                              showAbleProducts.add(element);
                            }
                          } else {
                            if (searchedProduct != '' && (element.productName.removeAllWhiteSpace().toLowerCase().contains(searchedProduct.toString().toLowerCase()) || element.productName.contains(searchedProduct.toString()))) {
                              showAbleProducts.add(element);
                            } else if (searchedProduct == '') {
                              showAbleProducts.add(element);
                            }
                          }
                        }

                        return showAbleProducts.isNotEmpty
                            ? SizedBox(
                                height: showAbleProducts.length * 75,
                                child: TabBarView(
                                  controller: tabController,
                                  children: List.generate(
                                    category.length,
                                    (index) => ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: showAbleProducts.length,
                                      itemBuilder: (_, i) {
                                        productCodeList.add(showAbleProducts[i].productCode.replaceAll(' ', '').toLowerCase());
                                        productNameList.add(showAbleProducts[i].productName.replaceAll(' ', '').toLowerCase());
                                        return Column(
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ProductDetails(
                                                              productModel: showAbleProducts[i],
                                                            )));
                                                print(products[index].productName);
                                              },
                                              leading: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: kBorderColorTextField),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(showAbleProducts[i].productPicture),
                                                  ),
                                                ),
                                              ),
                                              title: Text(showAbleProducts[i].productName, maxLines: 2, overflow: TextOverflow.ellipsis),
                                              subtitle: Text("${lang.S.of(context).stocks} : ${myFormat.format(num.tryParse(showAbleProducts[i].productStock) ?? 0)} (${showAbleProducts[i].warehouseName})"),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "$currency ${myFormat.format(double.tryParse(showAbleProducts[i].productSalePrice) ?? 0)}",
                                                        // "$currency ${products[i].productSalePrice}",
                                                        style: const TextStyle(fontSize: 18),
                                                      ),
                                                      Visibility(
                                                        visible: (category[index] == 'Expiring' && products[i].expiringDate != null),
                                                        child: Text(
                                                          (DateTime.tryParse(showAbleProducts[i].expiringDate ?? '') ?? DateTime.now()).isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
                                                              // ? 'Expired'
                                                              ? lang.S.of(context).expired
                                                              : "${lang.S.of(context).willExpireAt} ${DateFormat.yMMMd().format(DateTime.tryParse(showAbleProducts[i].expiringDate ?? '') ?? DateTime.now())}",

                                                          // "$currency ${products[i].productSalePrice}",
                                                          style: const TextStyle(fontSize: 10, color: Colors.red),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                    child: PopupMenuButton(
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder: (BuildContext bc) => [
                                                        PopupMenuItem(
                                                            child: InkWell(
                                                          onTap: () {
                                                            if (finalUserRoleModel.productEdit == false) {
                                                              toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                                                              return;
                                                            }
                                                            UpdateProduct(
                                                              productModel: showAbleProducts[i],
                                                              productCodeList: productCodeList,
                                                              productNameList: productNameList,
                                                              groupTaxModel: groupTax.value ?? [],
                                                            ).launch(context);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              const Icon(FeatherIcons.edit3, size: 18.0, color: Colors.black),
                                                              const SizedBox(width: 4.0),
                                                              Text(
                                                                lang.S.of(context).edit,
                                                                style: const TextStyle(color: Colors.black),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                        PopupMenuItem(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              if (finalUserRoleModel.productEdit == false) {
                                                                toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                                                                return;
                                                              }
                                                              increseStockPopUp(context, products, i, ref);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                const Icon(Icons.add, size: 18.0, color: Colors.black),
                                                                const SizedBox(width: 4.0),
                                                                Text(
                                                                  lang.S.of(context).increaseStock,
                                                                  style: const TextStyle(color: Colors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              if (finalUserRoleModel.productDelete == false) {
                                                                toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                                                                return;
                                                              }
                                                              deleteProduct(productCode: showAbleProducts[i].productCode, updateProduct: ref, context: bc);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                const Icon(Icons.delete, size: 18.0, color: Colors.black),
                                                                const SizedBox(width: 4.0),
                                                                Text(
                                                                  lang.S.of(context).delete,
                                                                  style: const TextStyle(color: Colors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                      onSelected: (value) {
                                                        Navigator.pushNamed(context, '$value');
                                                      },
                                                      child: Center(
                                                        child: Container(
                                                            height: 18,
                                                            width: 18,
                                                            alignment: Alignment.centerRight,
                                                            child: const Icon(
                                                              Icons.more_vert_sharp,
                                                              size: 20,
                                                              color: Colors.black,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                              thickness: 1.0,
                                              color: kBorderColor.withOpacity(0.3),
                                            )
                                          ],
                                        ).visible(searchedProduct.isEmptyOrNull ? true : showAbleProducts[i].productName.toUpperCase().contains(searchedProduct!.toUpperCase())).visible(category[index] == 'All' ? true : ((category[index] == 'Expiring' && showAbleProducts[i].expiringDate != null) ? ((DateTime.tryParse(showAbleProducts[i].expiringDate ?? '') ?? DateTime.now()).isBefore(DateTime.now().add(const Duration(days: 7)))) : showAbleProducts[i].productCategory == category[index]));
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Padding(
                                padding: EdgeInsets.only(top: 60),
                                child: EmptyScreenWidget(),
                              ));
                      }, error: (e, stack) {
                        print('-------exception error :${e.toString()}--------------');
                        return Text(e.toString());
                      }, loading: () {
                        return const Center(child: CircularProgressIndicator());
                      }),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              color: Colors.white,
              child: ButtonGlobal(
                iconWidget: Icons.add,
                buttontext: lang.S.of(context).addNewProduct,
                iconColor: Colors.white,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
                onPressed: () async {
                  if (finalUserRoleModel.productEdit == false) {
                    toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                    return;
                  }
                  bool? isAdded = await AddProduct(
                    productNameList: productNameList,
                    productCodeList: productCodeList,
                    warehouseBasedProductModel: warehouseBasedProductModel,
                  ).launch(context);

                  if (isAdded ?? false) {
                    ref.refresh(categoryProvider);
                    ref.refresh(brandsProvider);
                    ref.refresh(productProvider);
                  }
                },
              ),
            ),
          ),
        );
      }, error: (e, stack) {
        return Scaffold(
          body: Center(
            child: Text(e.toString()),
          ),
        );
      }, loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
    });
  }

  Future<dynamic> increseStockPopUp(BuildContext context1, List<ProductModel> products, int i, WidgetRef pref) {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Products');
    String productKey = '';
    ref.keepSynced(true);

    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'].toString() == products[i].productCode) {
          productKey = element.key.toString();
        }
      }
    });
    return showDialog(
        context: context,
        builder: (_) {
          ProductModel tempProductModel = products[i];
          TextEditingController stockController = TextEditingController(text: tempProductModel.productStock);
          TextEditingController salePriceController = TextEditingController(text: tempProductModel.productSalePrice);
          TextEditingController purchaseController = TextEditingController(text: tempProductModel.productPurchasePrice);
          TextEditingController wholeSellerController = TextEditingController(text: tempProductModel.productWholeSalePrice);
          TextEditingController dealerController = TextEditingController(text: tempProductModel.productDealerPrice);
          return AlertDialog(
              content: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang.S.of(context).increaseStock,
                          //'Increase Stock',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: kMainColor,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[i].productName,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            products[i].brandName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            lang.S.of(context).stocks,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            tempProductModel.productStock,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: stockController,
                          textFieldType: TextFieldType.NUMBER,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).quantity,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: purchaseController,
                          keyboardType: TextInputType.number,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).purchasePrice,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          controller: salePriceController,
                          keyboardType: TextInputType.number,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).salePrice,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: wholeSellerController,
                          keyboardType: TextInputType.number,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).wholeSalePrice,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          controller: dealerController,
                          keyboardType: TextInputType.number,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).dealerPrice,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (tempProductModel.productStock != '0') {
                        DatabaseReference ref = FirebaseDatabase.instance.ref("$constUserId/Products/$productKey");
                        ref.keepSynced(true);
                        ref.update({
                          'productStock': stockController.text,
                          'productSalePrice': salePriceController.text,
                          'productPurchasePrice': purchaseController.text,
                          'productWholeSalePrice': wholeSellerController.text,
                          'productDealerPrice': dealerController.text,
                        });
                        //EasyLoading.showSuccess('Done');
                        EasyLoading.showSuccess(lang.S.of(context).done);

                        pref.refresh(categoryProvider);
                        pref.refresh(productProvider);
                        Navigator.pop(context);
                        Navigator.pop(context1);
                      } else {
                        // EasyLoading.showError('Please add quantity');
                        EasyLoading.showError(lang.S.of(context).pleaseAddQuantity);
                      }
                    },
                    child: Container(
                      height: 60,
                      width: context.width(),
                      decoration: const BoxDecoration(color: kMainColor, borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Center(
                        child: Text(
                          lang.S.of(context).save,
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
        });
  }

// //showDialogBox() => showCupertinoDialog<String>(
//       context: context,
//       builder: (BuildContext context) => CupertinoAlertDialog(
//         title: Text(lang.S.of(context).noConnection),
//         content: Text(lang.S.of(context).pleaseCheckYourInternetConnectivity),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context, lang.S.of(context).cancel);
//               setState(() => isAlertSet = false);
//               isDeviceConnected =
//                   await InternetConnection().hasInternetAccess;
//               if (!isDeviceConnected && isAlertSet == false) {
//                 //showDialogBox();
//                 setState(() => isAlertSet = true);
//               }
//             },
//             child: Text(lang.S.of(context).tryAgain),
//           ),
//         ],
//       ),
//     );
}
