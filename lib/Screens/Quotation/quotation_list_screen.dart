import 'dart:convert';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/printer_provider.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Customers/Model/customer_model.dart';
import 'package:mobile_pos/Screens/Quotation/sales_contact.dart';
import 'package:mobile_pos/Screens/Sales/add_sales.dart';
import 'package:mobile_pos/const_commas.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../currency.dart';
import '../../empty_screen_widget.dart';
import '../../generate_pdf.dart';
import '../../model/transition_model.dart';
import '../../pdf/sales_pdf.dart';
import '../Home/home.dart';
import '../invoice_details/sales_invoice_details_screen.dart';

class QuotationListScreen extends StatefulWidget {
  const QuotationListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuotationListScreenState createState() => _QuotationListScreenState();
}

class _QuotationListScreenState extends State<QuotationListScreen> {
  String? invoiceNumber;
  final String _selectedItem = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await const Home().launch(context, isNewTask: true);
      },
      child: Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          title: Text(
            "Quotation List",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: kMainColor,
          elevation: 0.0,
        ),
        body: Consumer(builder: (context, consumerRef, __) {
          final providerData = consumerRef.watch(quotationProvider);
          final profile = consumerRef.watch(profileDetailsProvider);
          final printerData = consumerRef.watch(printerProviderNotifier);
          final cart = consumerRef.watch(cartNotifier);
          return Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NUMBER,
                          onChanged: (value) {
                            setState(() {
                              invoiceNumber = value;
                            });
                          },
                          decoration: InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.never, labelText: lang.S.of(context).invoiceNumber, hintText: lang.S.of(context).enterInvoiceNumber, border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.search)),
                        ),
                      ),
                      providerData.when(data: (transaction) {
                        final reTransaction = transaction.reversed.toList();
                        return reTransaction.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reTransaction.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (finalUserRoleModel.salesListView == false) {
                                        toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                                        return;
                                      }
                                      SalesInvoiceDetails(
                                        transitionModel: reTransaction[index],
                                        personalInformationModel: profile.value!,
                                        isFromQuotation: true,
                                      ).launch(context);
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          width: context.width(),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      reTransaction[index].customerName.isNotEmpty ? reTransaction[index].customerName : reTransaction[index].customerPhone,
                                                      style: const TextStyle(fontSize: 16),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10.0),
                                                  Text(
                                                    '#${reTransaction[index].invoiceNumber}',
                                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${lang.S.of(context).total} : $currency ${myFormat.format(reTransaction[index].totalAmount)}',
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        DateFormat.yMMMd().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                        style: const TextStyle(color: Colors.grey),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        DateFormat.jm().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                        style: const TextStyle(color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (finalUserRoleModel.salesListEdit == false) {
                                                        toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                                                        return;
                                                      }
                                                      cart.clearCart();
                                                      if (reTransaction[index].productList != null) {
                                                        for (var element in reTransaction[index].productList!) {
                                                          cart.addToCartRiverPod(element);
                                                        }
                                                      }

                                                      AddSalesScreen(
                                                        transitionModel: reTransaction[index],
                                                        customerModel: CustomerModel(reTransaction[index].customerName, reTransaction[index].customerPhone, reTransaction[index].customerType, "", "", reTransaction[index].customerAddress, (reTransaction[index].dueAmount ?? 0).toString(), "", "", "", gst: reTransaction[index].customerGst),
                                                      ).launch(context);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(4))),
                                                      child: Text(
                                                        "Convert to Sale",
                                                        style: TextStyle(color: kMainColor),
                                                      ),
                                                    ),
                                                  ),
                                                  profile.when(data: (data) {
                                                    return Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () async {
                                                              await printerData.getBluetooth();
                                                              PrintTransactionModel model = PrintTransactionModel(transitionModel: reTransaction[index], personalInformationModel: data);
                                                              connected
                                                                  ? printerData.printTicket(
                                                                      printTransactionModel: model,
                                                                      productList: model.transitionModel!.productList,
                                                                    )
                                                                  : showDialog(
                                                                      context: context,
                                                                      builder: (_) {
                                                                        return PopScope(
                                                                          canPop: false,
                                                                          child: Dialog(
                                                                            child: SizedBox(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  ListView.builder(
                                                                                    shrinkWrap: true,
                                                                                    itemCount: printerData.availableBluetoothDevices.isNotEmpty ? printerData.availableBluetoothDevices.length : 0,
                                                                                    itemBuilder: (context, index) {
                                                                                      return ListTile(
                                                                                        onTap: () async {
                                                                                          BluetoothInfo select = printerData.availableBluetoothDevices[index];
                                                                                          bool isConnect = await printerData.setConnect(select.macAdress);
                                                                                          // ignore: use_build_context_synchronously
                                                                                          isConnect
                                                                                              // ignore: use_build_context_synchronously
                                                                                              ? finish(context)
                                                                                              //: toast('Try Again');
                                                                                              : toast(lang.S.of(context).tryAgain);
                                                                                        },
                                                                                        title: Text(printerData.availableBluetoothDevices[index].name),
                                                                                        subtitle: Text(lang.S.of(context).clickToConnect),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                                                                                    child: Text(
                                                                                      lang.S.of(context).pleaseConnectYourBluttothPrinter,
                                                                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 10),
                                                                                  Container(height: 1, width: double.infinity, color: Colors.grey),
                                                                                  const SizedBox(height: 15),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        lang.S.of(context).cacel,
                                                                                        style: const TextStyle(color: kMainColor),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 15),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                            },
                                                            icon: const Icon(
                                                              FeatherIcons.printer,
                                                              color: Colors.grey,
                                                            )),
                                                        PopupMenuButton(
                                                          offset: const Offset(0, 30),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(4.0),
                                                          ),
                                                          padding: EdgeInsets.zero,
                                                          itemBuilder: (BuildContext bc) => [
                                                            PopupMenuItem(
                                                              child: GestureDetector(
                                                                onTap: () async => await GeneratePdf1().generateQuotationDocument(
                                                                  reTransaction[index],
                                                                  data,
                                                                  context,
                                                                  // share: false,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons.picture_as_pdf,
                                                                      color: Colors.grey,
                                                                    ),
                                                                    const SizedBox(width: 10.0),
                                                                    Text(
                                                                      lang.S.of(context).pdfView,
                                                                      //'Pdf View',
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  shareQuotationPDF(
                                                                    transactions: reTransaction[index],
                                                                    personalInformation: data,
                                                                    context: context,
                                                                  );
                                                                  // GeneratePdf().generateSaleDocument(transaction[index], data, context, share: true);
                                                                  finish(context);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      CommunityMaterialIcons.share,
                                                                      color: Colors.grey,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10.0,
                                                                    ),
                                                                    Text(
                                                                      lang.S.of(context).share,
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            ///________Sale List Delete_______________________________
                                                            // PopupMenuItem(
                                                            //   child: GestureDetector(
                                                            //     onTap: () => showDialog(
                                                            //         context: context,
                                                            //         builder: (context2) => AlertDialog(
                                                            //               title: const Text('Are you sure to delete this sale?'),
                                                            //               content: const Text(
                                                            //                 'The sale will be deleted and all the data will be deleted about this sale.Are you sure to delete this?',
                                                            //                 maxLines: 5,
                                                            //               ),
                                                            //               actions: [
                                                            //                 const Text('Cancel').onTap(() => Navigator.pop(context2)),
                                                            //                 Padding(
                                                            //                   padding: const EdgeInsets.all(20.0),
                                                            //                   child: const Text('Yes, Delete Forever').onTap(() async {
                                                            //                     for (var element in reTransaction[index].productList!) {
                                                            //                       increaseStock(element.productId, element.quantity);
                                                            //                     }
                                                            //                     getSpecificCustomersDueUpdate(
                                                            //                       phoneNumber: reTransaction[index].customerPhone,
                                                            //                       isDuePaid: false,
                                                            //                       due: reTransaction[index].dueAmount ?? 0,
                                                            //                     );
                                                            //                     updateFromShopRemainBalance(
                                                            //                         isFromPurchase: false,
                                                            //                         paidAmount: (reTransaction[index].totalAmount ?? 0) - (reTransaction[index].dueAmount ?? 0),
                                                            //                         t: consumerRef);
                                                            //                     DatabaseReference ref =
                                                            //                         FirebaseDatabase.instance.ref("$constUserId/Sales Transition/${reTransaction[index].key}");
                                                            //                     ref.keepSynced(true);
                                                            //                     await ref.remove();
                                                            //                     consumerRef.refresh(transitionProvider);
                                                            //                     consumerRef.refresh(productProvider);
                                                            //                     consumerRef.refresh(customerProvider);
                                                            //                     consumerRef.refresh(profileDetailsProvider);
                                                            //                     // ignore: use_build_context_synchronously
                                                            //                     Navigator.pop(context2);
                                                            //                     Navigator.pop(bc);
                                                            //                   }),
                                                            //                 ),
                                                            //               ],
                                                            //             )),
                                                            //     child: Row(
                                                            //       children: [
                                                            //         const Icon(
                                                            //           CommunityMaterialIcons.delete,
                                                            //           color: Colors.grey,
                                                            //         ),
                                                            //         const SizedBox(
                                                            //           width: 10.0,
                                                            //         ),
                                                            //         Text(
                                                            //           'Delete',
                                                            //           style: kTextStyle.copyWith(color: kGreyTextColor),
                                                            //         ),
                                                            //       ],
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                            ///________Sale List Delete_______________________________
                                                            PopupMenuItem(
                                                              child: GestureDetector(
                                                                onTap: () => finalUserRoleModel.salesListDelete == false
                                                                    ? toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService)
                                                                    : showDialog(
                                                                        context: context,
                                                                        builder: (context2) => AlertDialog(
                                                                              title: Text('${lang.S.of(context).areYouSureToDeleteThisSale}?'),
                                                                              content: Text(
                                                                                '${lang.S.of(context).theSaleWillBeDeletedAndAllTheDataWillSale}?',
                                                                                maxLines: 5,
                                                                              ),
                                                                              actions: [
                                                                                Text(lang.S.of(context).cancel).onTap(() => Navigator.pop(context2)),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(20.0),
                                                                                  child: Text(lang.S.of(context).yesDeleteForever).onTap(() async {
                                                                                    EasyLoading.show();

                                                                                    await FirebaseDatabase.instance.ref(constUserId).child('Sales Quotation').orderByKey().get().then((value) {
                                                                                      for (var element in value.children) {
                                                                                        SalesTransitionModel transitionzModel = SalesTransitionModel.fromJson(jsonDecode(jsonEncode(element.value)));
                                                                                        if (element.key != null && transitionzModel.invoiceNumber == reTransaction[index].invoiceNumber) {
                                                                                          //delete the qqoutation
                                                                                          FirebaseDatabase.instance.ref(constUserId).child('Sales Quotation').child(element.key!).remove();
                                                                                        }
                                                                                      }
                                                                                    });
                                                                                    consumerRef.refresh(transitionProvider);
                                                                                    consumerRef.refresh(productProvider);
                                                                                    consumerRef.refresh(customerProvider);
                                                                                    consumerRef.refresh(quotationProvider);
                                                                                    // consumerRef.refresh(dailyTransactionProvider);
                                                                                    //EasyLoading.showSuccess('Done');
                                                                                    EasyLoading.showSuccess(lang.S.of(context).done);
                                                                                    // ignore: use_build_context_synchronously
                                                                                    Navigator.pop(context2);
                                                                                    Navigator.pop(bc);
                                                                                  }),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons.delete,
                                                                      color: kGreyTextColor,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10.0,
                                                                    ),
                                                                    Text(
                                                                      lang.S.of(context).delete,
                                                                      //'Delete',
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                          onSelected: (value) {
                                                            Navigator.pushNamed(context, '$value');
                                                          },
                                                          child: const Icon(
                                                            FeatherIcons.moreVertical,
                                                            color: kGreyTextColor,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }, error: (e, stack) {
                                                    return Text(e.toString());
                                                  }, loading: () {
                                                    return Text(lang.S.of(context).loading);
                                                  }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          width: context.width(),
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ).visible(invoiceNumber.isEmptyOrNull ? true : reTransaction[index].invoiceNumber.toString().contains(invoiceNumber!));
                                },
                              )
                            : const Padding(
                                padding: EdgeInsets.only(top: 60),
                                child: EmptyScreenWidget(),
                              );
                      }, error: (e, stack) {
                        return Text(e.toString());
                      }, loading: () {
                        return const Center(child: CircularProgressIndicator());
                      }),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (finalUserRoleModel.saleEdit == false) {
                      toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                      return;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SalesContact(isFromHome: false)));
                  },
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kMainColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add Quotation",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
