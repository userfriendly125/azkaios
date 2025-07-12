import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Products/add_category.dart';
import 'package:mobile_pos/Screens/Purchase/purchase_details.dart';
import 'package:mobile_pos/Screens/Sales/sales_screen.dart';
import 'package:mobile_pos/const_commas.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../currency.dart';

// ignore: must_be_immutable
class PurchaseScreen extends StatefulWidget {
  PurchaseScreen({super.key, @required this.catName});

  // ignore: prefer_typing_uninitialized_variables
  var catName;

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  String dropdownValue = '';
  var cart = FlutterCart();
  String total = 'Cart Is Empty';
  int items = 0;

  @override
  void initState() {
    widget.catName == null ? dropdownValue = 'Fashion' : dropdownValue = widget.catName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(productProvider);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            lang.S.of(context).purchase,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                // const PopupMenuItem(value: "/addPromoCode", child: Text('Add Promo Code')),
                // const PopupMenuItem(value: "/addDiscount", child: Text('Add Discount')),
                // const PopupMenuItem(value: "/settings", child: Text('Cancel All Product')),
                // const PopupMenuItem(value: "/settings", child: Text('Vat Doesn\'t Apply')),

                PopupMenuItem(value: "/addPromoCode", child: Text(lang.S.of(context).addPromoCode)),
                PopupMenuItem(value: "/addDiscount", child: Text(lang.S.of(context).addDiscount)),
                PopupMenuItem(value: "/settings", child: Text(lang.S.of(context).cancelAllProduct)),
                PopupMenuItem(value: "/settings", child: Text(lang.S.of(context).vatDoesNotApply)),
              ],
              onSelected: (value) {
                Navigator.pushNamed(context, value);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 60.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: kMainColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Image(
                              image: AssetImage('images/selected.png'),
                            ),
                            Text(
                              items.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '${lang.S.of(context).total}: $currency${myFormat.format(int.tryParse(total) ?? 0)}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width - 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: kGreyTextColor),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            //EasyLoading.showInfo('Will be Added Soon');
                            EasyLoading.showInfo(lang.S.of(context).willBeAddedSoon);
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(dropdownValue),
                              const Spacer(),
                              const Icon(Icons.keyboard_arrow_down),
                              const SizedBox(
                                width: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          const AddCategory().launch(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: kGreyTextColor),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: kGreyTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                providerData.when(data: (products) {
                  return ListView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            cartModel:
                            CartModel(
                              productId: items.toString(),
                              productName: products[index].productName,
                              variants: [],
                              productDetails: '',
                            );

                            //cart.addToCart(productId: items, unitPrice: products[index].productSalePrice.toInt(), productName: products[index].productName);
                            EasyLoading.showSuccess(lang.S.of(context).addedToCart, duration: const Duration(milliseconds: 1000));
                            setState(() {
                              // total = cart.getTotalAmount().toString();
                              total = cart.total.toString();

                              items++;
                            });
                          },
                          child: ProductCard(
                            productTitle: products[index].productName,
                            productDescription: products[index].brandName,
                            productPrice: products[index].productSalePrice,
                            productImage: products[index].productPicture,
                            stock: products[index].productStock,
                            productId: products[index].productCode,
                            warehouseName: products[index].warehouseName,
                          ),
                        );
                      });
                }, error: (e, stack) {
                  return Text(e.toString());
                }, loading: () {
                  return const Center(child: CircularProgressIndicator());
                }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ButtonGlobal(
          iconWidget: Icons.arrow_forward,
          buttontext: lang.S.of(context).purchaseList,
          iconColor: Colors.white,
          buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
          onPressed: () {
            // ignore: missing_required_param
            PurchaseDetails().launch(context);
          },
        ),
      );
    });
  }
}
