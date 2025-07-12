// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:convert';
import 'dart:core';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Purchase/purchase_products.dart';
import 'package:mobile_pos/Widget/utils.dart';
import 'package:mobile_pos/const_commas.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:mobile_pos/model/transition_model.dart';
import 'package:mobile_pos/repository/category,brans,units_repo.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../Provider/add_to_cart_purchase.dart';
import '../../Provider/print_purchase_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/purchase_report_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/DailyTransactionModel.dart';
import '../../pdf/print_pdf.dart';
import '../../subscription.dart';
import '../Customers/Model/customer_model.dart';
import '../Home/home.dart';
import '../invoice_details/purchase_invoice_details.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({super.key, required this.customerModel});

  final CustomerModel customerModel;

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  bool saleButtonClicked = false;
  TextEditingController paidText = TextEditingController();
  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double dueAmount = 0;
  double subTotal = 0;
  String? dropdownValue = 'Cash';
  List<String> paymentsTypesList = [];
  TextEditingController dateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));

  double calculateSubtotal({required double total}) {
    subTotal = total - discountAmount;
    return total - discountAmount;
  }

  double calculateReturnAmount({required double total}) {
    returnAmount = total - paidAmount;
    return paidAmount <= 0 || paidAmount <= subTotal ? 0 : total - paidAmount;
  }

  double calculateDueAmount({required double total}) {
    if (total < 0) {
      dueAmount = 0;
    } else {
      dueAmount = subTotal - paidAmount;
    }
    return returnAmount <= 0 ? 0 : subTotal - paidAmount;
  }

  late PurchaseTransactionModel transitionModel = PurchaseTransactionModel(
    customerName: widget.customerModel.customerName,
    customerAddress: widget.customerModel.customerAddress,
    customerPhone: widget.customerModel.phoneNumber,
    customerType: widget.customerModel.type,
    customerGst: widget.customerModel.gst,
    sendWhatsappMessage: widget.customerModel.receiveWhatsappUpdates ?? false,
    invoiceNumber: invoice.toString(),
    purchaseDate: DateTime.now().toString(),
  );

  @override
  void initState() {
    getPaymentsTypeList();
    super.initState();
  }

  getPaymentsTypeList() async {
    await PaymentTypeRepo().getAllPaymentType().then((value) {
      paymentsTypesList.clear();
      for (var element in value) {
        paymentsTypesList.add(element.paymentTypeName);
      }
    });
    if (paymentsTypeList.isEmpty) {
      paymentsTypesList.add('Cash');
    }
    dropdownValue = paymentsTypesList.isNotEmpty ? paymentsTypesList.first : 'Cash';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifierPurchase);
      final printerData = consumerRef.watch(printerPurchaseProviderNotifier);
      final personalData = consumerRef.watch(profileDetailsProvider);
      return personalData.when(data: (data) {
        invoice = data.purchaseInvoiceCounter ?? 1;
        return Scaffold(
          backgroundColor: kMainColor,
          appBar: AppBar(
            backgroundColor: kMainColor,
            title: Text(
              lang.S.of(context).addPurchase,
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0.0,
          ),
          body: Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            initialValue: data.purchaseInvoiceCounter.toString(),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).invNo,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            controller: dateTextEditingController,
                            // initialValue: DateFormat.yMMMd().format(selectedDate),

                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).date,
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime(2101),
                                    context: context,
                                  );
                                  setState(() {
                                    dateTextEditingController.text = DateFormat.yMMMd().format(picked ?? DateTime.now());

                                    transitionModel.purchaseDate = picked.toString();
                                  });
                                },
                                icon: const Icon(FeatherIcons.calendar),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(lang.S.of(context).dueAmount),
                            Text(
                              widget.customerModel.dueAmount == '' ? '$currency 0' : '$currency${myFormat.format(int.tryParse(widget.customerModel.dueAmount) ?? 0)}',
                              style: const TextStyle(color: Color(0xFFFF8C34)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          initialValue: widget.customerModel.customerName.isNotEmpty ? widget.customerModel.customerName : widget.customerModel.phoneNumber,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).supplierName,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ///_______Added_ItemS__________________________________________________
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        border: Border.all(width: 1, color: const Color(0xffEAEFFA)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xffEAEFFA),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  width: context.width() / 1.35,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        lang.S.of(context).itemAdded,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        lang.S.of(context).quantity,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: providerData.cartItemPurchaseList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(providerData.cartItemPurchaseList[index].productName.toString()),
                                    subtitle: Text('${providerData.cartItemPurchaseList[index].productStock} X ${myFormat.format(int.tryParse(providerData.cartItemPurchaseList[index].productPurchasePrice) ?? 0)} = ${myFormat.format(double.parse(providerData.cartItemPurchaseList[index].productStock) * providerData.cartItemPurchaseList[index].productPurchasePrice.toDouble())}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  providerData.quantityDecrease(index);
                                                },
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: const BoxDecoration(
                                                    color: kMainColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      '-',
                                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                providerData.cartItemPurchaseList[index].productStock,
                                                style: GoogleFonts.poppins(
                                                  color: kGreyTextColor,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              GestureDetector(
                                                onTap: () {
                                                  providerData.quantityIncrease(index);
                                                },
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: const BoxDecoration(
                                                    color: kMainColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  ),
                                                  child: const Center(
                                                      child: Text(
                                                    '+',
                                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            providerData.deleteToCart(index);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            color: Colors.red.withOpacity(0.1),
                                            child: const Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ).visible(providerData.cartItemPurchaseList.isNotEmpty),
                    ),
                    const SizedBox(height: 20),

                    ///_______Add_Button__________________________________________________
                    GestureDetector(
                      onTap: () {
                        PurchaseProducts(
                          catName: null,
                          customerModel: widget.customerModel,
                        ).launch(context);
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: Center(
                            child: Text(
                          lang.S.of(context).addItems,
                          style: const TextStyle(color: kMainColor, fontSize: 20),
                        )),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ///_____Total______________________________
                    Container(
                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.grey.shade300, width: 1)),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Color(0xffEAEFFA), borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lang.S.of(context).subTotal,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  myFormat.format(providerData.getTotalAmount()),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lang.S.of(context).discount,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  width: context.width() / 4,
                                  child: TextField(
                                    controller: paidText,
                                    onChanged: (value) {
                                      if (value == '') {
                                        setState(() {
                                          discountAmount = 0;
                                        });
                                      } else {
                                        if (value.toInt() <= providerData.getTotalAmount()) {
                                          setState(() {
                                            discountAmount = double.parse(value);
                                          });
                                        } else {
                                          paidText.clear();
                                          setState(() {
                                            discountAmount = 0;
                                          });
                                          //EasyLoading.showError('Enter a valid Discount');
                                          EasyLoading.showError(lang.S.of(context).enterAValidDiscount);
                                        }
                                      }
                                    },
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(
                                      hintText: '0',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lang.S.of(context).total,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  myFormat.format(calculateSubtotal(total: providerData.getTotalAmount())),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lang.S.of(context).paidAmount,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  width: context.width() / 4,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value == '') {
                                        setState(() {
                                          paidAmount = 0;
                                        });
                                      } else {
                                        setState(() {
                                          paidAmount = double.parse(value);
                                        });
                                      }
                                    },
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(hintText: '0'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lang.S.of(context).returnAMount,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  myFormat.format(calculateReturnAmount(total: subTotal).abs()),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lang.S.of(context).dueAmount,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  myFormat.format(calculateDueAmount(total: subTotal)),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).paymentType,
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.wallet,
                              color: Colors.green,
                            )
                          ],
                        ),
                        DropdownButton(
                          value: dropdownValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: paymentsTypesList.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValue = newValue.toString();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).describtion,
                              hintText: lang.S.of(context).addNote,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                            height: 60,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.grey.shade200),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    FeatherIcons.camera,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    lang.S.of(context).image,
                                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ).visible(false),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            // if (providerData.cartItemPurchaseList.isNotEmpty) {
                            //   try {
                            //     EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                            //
                            //     final userId = FirebaseAuth.instance.currentUser!.uid;
                            //     DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/Purchase Transition");
                            //
                            //     dueAmount <= 0 ? transitionModel.isPaid = true : transitionModel.isPaid = false;
                            //     dueAmount <= 0 ? transitionModel.dueAmount = 0 : transitionModel.dueAmount = dueAmount;
                            //     returnAmount < 0 ? transitionModel.returnAmount = returnAmount.abs() : transitionModel.returnAmount = 0;
                            //     transitionModel.discountAmount = discountAmount;
                            //     transitionModel.totalAmount = subTotal;
                            //     transitionModel.productList = providerData.cartItemPurchaseList;
                            //
                            //     transitionModel.paymentType = dropdownValue;
                            //     transitionModel.invoiceNumber = invoice.toString();
                            //     await ref.push().set(transitionModel.toJson());
                            //
                            //     ///__________StockMange_________________________________________________
                            //
                            //     for (var element in providerData.cartItemPurchaseList) {
                            //       increaseStock(productCode: element.productCode, productModel: element);
                            //     }
                            //
                            //     ///_______invoice_Update_____________________________________________
                            //     final DatabaseReference personalInformationRef =
                            //         // ignore: deprecated_member_use
                            //         FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid).child('Personal Information');
                            //
                            //     await personalInformationRef.update({'invoiceCounter': invoice + 1});
                            //
                            //     ///________Subscription_____________________________________________________
                            //     Subscription.decreaseSubscriptionLimits(itemType: 'purchaseNumber',context: context);
                            //
                            //     ///_________DueUpdate______________________________________________________
                            //     getSpecificCustomers(phoneNumber: widget.customerModel.phoneNumber, due: transitionModel.dueAmount!.toInt());
                            //
                            //     ///________Print_______________________________________________________
                            //     if (isPrintEnable) {
                            //       await printerData.getBluetooth();
                            //       PrintPurchaseTransactionModel model =
                            //           PrintPurchaseTransactionModel(purchaseTransitionModel: transitionModel, personalInformationModel: data);
                            //       if (connected) {
                            //         await printerData.printTicket(printTransactionModel: model, productList: providerData.cartItemPurchaseList);
                            //         providerData.clearCart();
                            //         consumerRef.refresh(customerProvider);
                            //         consumerRef.refresh(productProvider);
                            //         consumerRef.refresh(purchaseReportProvider);
                            //         consumerRef.refresh(purchaseTransitionProvider);
                            //         consumerRef.refresh(profileDetailsProvider);
                            //
                            //         EasyLoading.showSuccess('Added Successfully');
                            //         Future.delayed(const Duration(milliseconds: 500), () {
                            //           const PurchaseReportScreen().launch(context);
                            //         });
                            //       } else {
                            //         // ignore: use_build_context_synchronously
                            //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            //           content: Text("Please Connect The Printer First"),
                            //         ));
                            //         showDialog(
                            //             context: context,
                            //             builder: (_) {
                            //               return WillPopScope(
                            //                 onWillPop: () async => false,
                            //                 child: Dialog(
                            //                   child: SizedBox(
                            //                     child: Column(
                            //                       mainAxisSize: MainAxisSize.min,
                            //                       children: [
                            //                         ListView.builder(
                            //                           shrinkWrap: true,
                            //                           itemCount:
                            //                               printerData.availableBluetoothDevices.isNotEmpty ? printerData.availableBluetoothDevices.length : 0,
                            //                           itemBuilder: (context, index) {
                            //                             return ListTile(
                            //                               onTap: () async {
                            //                                 String select = printerData.availableBluetoothDevices[index];
                            //                                 List list = select.split("#");
                            //                                 // String name = list[0];
                            //                                 String mac = list[1];
                            //                                 bool isConnect = await printerData.setConnect(mac);
                            //                                 if (isConnect) {
                            //                                   await printerData.printTicket(
                            //                                       printTransactionModel: model, productList: transitionModel.productList);
                            //                                   providerData.clearCart();
                            //                                   consumerRef.refresh(customerProvider);
                            //                                   consumerRef.refresh(productProvider);
                            //                                   consumerRef.refresh(purchaseReportProvider);
                            //                                   consumerRef.refresh(purchaseTransitionProvider);
                            //                                   consumerRef.refresh(profileDetailsProvider);
                            //                                   EasyLoading.showSuccess('Added Successfully');
                            //                                   Future.delayed(const Duration(milliseconds: 500), () {
                            //                                     const Home().launch(context);
                            //                                   });
                            //                                 }
                            //                               },
                            //                               title: Text('${printerData.availableBluetoothDevices[index]}'),
                            //                               subtitle: const Text("Click to connect"),
                            //                             );
                            //                           },
                            //                         ),
                            //                         const SizedBox(height: 10),
                            //                         Container(
                            //                           height: 1,
                            //                           width: double.infinity,
                            //                           color: Colors.grey,
                            //                         ),
                            //                         const SizedBox(height: 15),
                            //                         GestureDetector(
                            //                           onTap: () {
                            //                             consumerRef.refresh(customerProvider);
                            //                             consumerRef.refresh(productProvider);
                            //                             consumerRef.refresh(purchaseReportProvider);
                            //                             consumerRef.refresh(purchaseTransitionProvider);
                            //                             consumerRef.refresh(profileDetailsProvider);
                            //                             const Home().launch(context);
                            //                           },
                            //                           child: const Center(
                            //                             child: Text(
                            //                               'Cancel',
                            //                               style: TextStyle(color: kMainColor),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         const SizedBox(height: 15),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ),
                            //               );
                            //             });
                            //         EasyLoading.showSuccess('Added Successfully');
                            //       }
                            //     } else {
                            //       providerData.clearCart();
                            //       consumerRef.refresh(customerProvider);
                            //       consumerRef.refresh(productProvider);
                            //       consumerRef.refresh(purchaseReportProvider);
                            //       consumerRef.refresh(purchaseTransitionProvider);
                            //       consumerRef.refresh(profileDetailsProvider);
                            //       EasyLoading.showSuccess('Added Successfully');
                            //       Future.delayed(const Duration(milliseconds: 500), () {
                            //         const Home().launch(context);
                            //       });
                            //     }
                            //   } catch (e) {
                            //     EasyLoading.dismiss();
                            //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                            //   }
                            // } else {
                            //   EasyLoading.showError('Add Product first');
                            // }
                            const Home().launch(context);
                          },
                          child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Center(
                              child: Text(
                                lang.S.of(context).cancel,
                                //'Cancel',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: saleButtonClicked
                                ? () {}
                                : () async {
                                    if (providerData.cartItemPurchaseList.isNotEmpty) {
                                      try {
                                        setState(() {
                                          saleButtonClicked = true;
                                        });
                                        EasyLoading.show(status: '${lang.S.of(context).loading}...', dismissOnTap: false);

                                        dueAmount <= 0 ? transitionModel.isPaid = true : transitionModel.isPaid = false;
                                        dueAmount <= 0 ? transitionModel.dueAmount = 0 : transitionModel.dueAmount = dueAmount;
                                        returnAmount < 0 ? transitionModel.returnAmount = returnAmount.abs() : transitionModel.returnAmount = 0;
                                        transitionModel.discountAmount = discountAmount;
                                        transitionModel.totalAmount = subTotal;
                                        transitionModel.productList = providerData.cartItemPurchaseList;
                                        transitionModel.paymentType = dropdownValue;
                                        transitionModel.invoiceNumber = invoice.toString();
                                        DatabaseReference ref = FirebaseDatabase.instance.ref("$constUserId/Purchase Transition");
                                        ref.keepSynced(true);
                                        ref.push().set(transitionModel.toJson());
                                        await GeneratePdfAndPrint().uploadPurchaseInvoice(personalInformationModel: data, purchaseTransactionModel: transitionModel);

                                        var subData = await Subscription.subscriptionEnabledChecker();
                                        if (subData && (transitionModel.sendWhatsappMessage ?? false)) {
                                          try {
                                            EasyLoading.show(status: '${lang.S.of(context).sendingMessage}...', dismissOnTap: true);
                                            await sendPurchaseSms(transitionModel);
                                            EasyLoading.dismiss();
                                          } catch (e) {
                                            EasyLoading.dismiss();
                                          }
                                        }

                                        ///__________StockMange_________________________________________________-

                                        for (var element in providerData.cartItemPurchaseList) {
                                          increaseStock(productCode: element.productCode, productModel: element);
                                        }

                                        ///_______invoice_Update_____________________________________________
                                        final DatabaseReference personalInformationRef =
                                            // ignore: deprecated_member_use
                                            FirebaseDatabase.instance.ref().child(constUserId).child('Personal Information');
                                        personalInformationRef.keepSynced(true);
                                        personalInformationRef.update({'purchaseInvoiceCounter': invoice + 1});

                                        ///________Subscription_____________________________________________________
                                        Subscription.decreaseSubscriptionLimits(itemType: 'purchaseNumber', context: context);

                                        ///_________DueUpdate______________________________________________________
                                        getSpecificCustomers(phoneNumber: widget.customerModel.phoneNumber, due: transitionModel.dueAmount!.toInt());

                                        ///________daily_transactionModel_________________________________________________________________________

                                        DailyTransactionModel dailyTransaction = DailyTransactionModel(
                                          name: transitionModel.customerName,
                                          date: transitionModel.purchaseDate,
                                          type: 'Purchase',
                                          total: transitionModel.totalAmount!.toDouble(),
                                          paymentIn: 0,
                                          paymentOut: transitionModel.totalAmount!.toDouble() - transitionModel.dueAmount!.toDouble(),
                                          remainingBalance: transitionModel.totalAmount!.toDouble() - transitionModel.dueAmount!.toDouble(),
                                          id: transitionModel.invoiceNumber,
                                          purchaseTransactionModel: transitionModel,
                                        );
                                        postDailyTransaction(dailyTransactionModel: dailyTransaction);

                                        ///________Print_______________________________________________________
                                        if (isPrintEnable) {
                                          await printerData.getBluetooth();
                                          PrintPurchaseTransactionModel model = PrintPurchaseTransactionModel(purchaseTransitionModel: transitionModel, personalInformationModel: data);
                                          if (connected) {
                                            await printerData.printTicket(printTransactionModel: model, productList: providerData.cartItemPurchaseList);
                                            consumerRef.refresh(customerProvider);
                                            consumerRef.refresh(productProvider);
                                            consumerRef.refresh(purchaseReportProvider);
                                            consumerRef.refresh(purchaseTransitionProvider);
                                            consumerRef.refresh(profileDetailsProvider);

                                            EasyLoading.dismiss();
                                            await Future.delayed(const Duration(milliseconds: 500)).then((value) => PurchaseInvoiceDetails(
                                                  transitionModel: transitionModel,
                                                  personalInformationModel: data,
                                                ).launch(context));
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            // EasyLoading.showError("Please Connect The Printer First");
                                            EasyLoading.showError(lang.S.of(context).pleaseConnectThePrinterFirst);
                                            showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return WillPopScope(
                                                    onWillPop: () async => false,
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
                                                                    if (isConnect) {
                                                                      await printerData.printTicket(printTransactionModel: model, productList: transitionModel.productList);

                                                                      consumerRef.refresh(customerProvider);
                                                                      consumerRef.refresh(productProvider);
                                                                      consumerRef.refresh(purchaseReportProvider);
                                                                      consumerRef.refresh(purchaseTransitionProvider);
                                                                      consumerRef.refresh(profileDetailsProvider);
                                                                      EasyLoading.dismiss();
                                                                      await Future.delayed(const Duration(milliseconds: 500)).then((value) => PurchaseInvoiceDetails(
                                                                            transitionModel: transitionModel,
                                                                            personalInformationModel: data,
                                                                          ).launch(context));
                                                                    }
                                                                  },
                                                                  title: Text(printerData.availableBluetoothDevices[index].name),
                                                                  subtitle: Text(lang.S.of(context).clickToConnect),
                                                                );
                                                              },
                                                            ),
                                                            const SizedBox(height: 10),
                                                            Container(
                                                              height: 1,
                                                              width: double.infinity,
                                                              color: Colors.grey,
                                                            ),
                                                            const SizedBox(height: 15),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                consumerRef.refresh(customerProvider);
                                                                consumerRef.refresh(productProvider);
                                                                consumerRef.refresh(purchaseReportProvider);
                                                                consumerRef.refresh(purchaseTransitionProvider);
                                                                consumerRef.refresh(profileDetailsProvider);
                                                                await Future.delayed(const Duration(milliseconds: 500)).then((value) => PurchaseInvoiceDetails(
                                                                      transitionModel: transitionModel,
                                                                      personalInformationModel: data,
                                                                    ).launch(context));
                                                              },
                                                              child: Center(
                                                                child: Text(
                                                                  lang.S.of(context).cancel,
                                                                  //'Cancel',
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
                                            EasyLoading.dismiss();
                                          }
                                        } else {
                                          consumerRef.refresh(customerProvider);
                                          consumerRef.refresh(productProvider);
                                          consumerRef.refresh(purchaseReportProvider);
                                          consumerRef.refresh(purchaseTransitionProvider);
                                          consumerRef.refresh(profileDetailsProvider);
                                          EasyLoading.dismiss();
                                          await Future.delayed(const Duration(milliseconds: 500)).then((value) => PurchaseInvoiceDetails(
                                                transitionModel: transitionModel,
                                                personalInformationModel: data,
                                              ).launch(context));
                                        }
                                      } catch (e) {
                                        setState(() {
                                          saleButtonClicked = false;
                                        });
                                        EasyLoading.showError(e.toString());
                                      }
                                    } else {
                                      //EasyLoading.showError('Add product first');
                                      EasyLoading.showError(lang.S.of(context).addProductFirst);
                                    }
                                  },
                            child: Container(
                              height: 60,
                              decoration: const BoxDecoration(
                                color: kMainColor,
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Center(
                                child: Text(
                                  lang.S.of(context).save,
                                  //'Save',
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }, error: (e, stack) {
        return Center(
          child: Text(e.toString()),
        );
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      });
    });
  }

  void increaseStock({required String productCode, required ProductModel productModel}) async {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Products');
    ref.keepSynced(true);

    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'] == productCode) {
          String? key = element.key;
          num previousStock = num.tryParse(element.child('productStock').value.toString()) ?? 0;
          print(previousStock);
          num remainStock = previousStock + (num.tryParse(productModel.productStock) ?? 0);
          ref.child(key!).update({
            'productSalePrice': productModel.productSalePrice,
            'productPurchasePrice': productModel.productPurchasePrice,
            'productWholeSalePrice': productModel.productWholeSalePrice,
            'productDealerPrice': productModel.productDealerPrice,
            'productStock': '$remainStock',
          });
        }
      }
    });
  }

  void getSpecificCustomers({required String phoneNumber, required int due}) async {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Customers');
    ref.keepSynced(true);
    String? key;

    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'] == phoneNumber) {
          key = element.key;
          int previousDue = element.child('due').value.toString().toInt();
          print(previousDue);
          int totalDue = previousDue + due;
          ref.child(key!).update({'due': '$totalDue'});
        }
      }
    });
  }
}
