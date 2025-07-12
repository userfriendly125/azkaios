import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart.dart';
import '../../Provider/seles_report_provider.dart';
import '../../currency.dart';

class PaymentCompleted extends StatefulWidget {
  const PaymentCompleted({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentCompletedState createState() => _PaymentCompletedState();
}

class _PaymentCompletedState extends State<PaymentCompleted> {
  var cart = FlutterCart();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      ref.refresh(salesReportProvider);
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            lang.S.of(context).paymentComplete,
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
          child: Column(
            children: [
              const Center(
                child: Image(
                  image: AssetImage('images/complete.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 5.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              lang.S.of(context).total,
                              style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              providerData.getTotalAmount().toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                color: kGreyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: SizedBox(
                          height: 50.0,
                          width: 1.0,
                          child: Container(
                            color: kGreyTextColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              lang.S.of(context).retur,
                              style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '$currency 00.00',
                              style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                color: kGreyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(
                  Icons.payment,
                  color: kGreyTextColor,
                ),
                title: Text('${lang.S.of(context).invoice}: #121342'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: kGreyTextColor,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.payment,
                  color: kGreyTextColor,
                ),
                title: Text(lang.S.of(context).sendEmail),
                trailing: const Icon(
                  Icons.email,
                  color: kGreyTextColor,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.payment,
                  color: kGreyTextColor,
                ),
                title: Text(lang.S.of(context).sendSms),
                trailing: const Icon(
                  Icons.message_outlined,
                  color: kGreyTextColor,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.payment,
                  color: kGreyTextColor,
                ),
                title: Text(lang.S.of(context).recivedThePin),
                trailing: const Icon(
                  Icons.local_print_shop,
                  color: kGreyTextColor,
                ),
              ),
              ButtonGlobalWithoutIcon(
                buttontext: lang.S.of(context).startNewSale,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () {
                  providerData.clearCart();
                  providerData.clearDiscount();

                  const Home().launch(context);
                },
                buttonTextColor: Colors.white,
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.payment,
              //     color: kGreyTextColor,
              //   ),
              //   title: Text(lang.S.of(context).recivedThePin),
              //   trailing: const Icon(
              //     Icons.local_print_shop,
              //     color: kGreyTextColor,
              //   ),
              // ),
              // ButtonGlobalWithoutIcon(
              //   buttontext: lang.S.of(context).startNewSale,
              //   buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
              //   onPressed: () {
              //     providerData.clearCart();
              //     providerData.clearDiscount();
              //
              //     const Home().launch(context);
              //   },
              //   buttonTextColor: Colors.white,
              // ),
            ],
          ),
        ),
      );
    });
  }
}
