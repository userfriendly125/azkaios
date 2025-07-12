import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/due_transaction_provider.dart';
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/Widget/utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/model/transition_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/product_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../const_commas.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/DailyTransactionModel.dart';
import '../../model/personal_information_model.dart';
import '../../model/product_model.dart';
import '../../pdf/print_pdf.dart';
import '../../subscription.dart';
import '../Report/Purchase Return Report/Provider/purchase_returns_provider.dart';

// ignore: must_be_immutable
class PurchaseReturnScreen extends StatefulWidget {
  const PurchaseReturnScreen({
    super.key,
    required this.purchaseTransactionModel,
  });

  final PurchaseTransactionModel purchaseTransactionModel;

  @override
  State<PurchaseReturnScreen> createState() => _PurchaseReturnScreenState();
}

class _PurchaseReturnScreenState extends State<PurchaseReturnScreen> {
  num getTotalReturnAmount() {
    num returnAmount = 0;
    for (var element in returnList) {
      if (element.lowerStockAlert > 0) {
        returnAmount += element.lowerStockAlert * (num.tryParse(element.productPurchasePrice.toString()) ?? 0);
      }
    }
    return returnAmount;
  }

  Future<void> purchaseReturn({required PurchaseTransactionModel purchase, required PurchaseTransactionModel orginal, required WidgetRef consumerRef, required BuildContext context, required PersonalInformationModel personalInfo}) async {
    try {
      EasyLoading.show(status: '${lang.S.of(context).loading}...', dismissOnTap: false);

      ///_________Push_on_Sale_return_dataBase____________________________________________________________________________
      DatabaseReference ref = FirebaseDatabase.instance.ref("${await getUserID()}/Purchase Return");
      ref.keepSynced(true);
      ref.push().set(purchase.toJson());
      await GeneratePdfAndPrint().uploadPurchaseReturnInvoice(personalInformationModel: personalInfo, purchaseTransactionModel: purchase);

      var subData = await Subscription.subscriptionEnabledChecker();
      if (subData && (purchase.sendWhatsappMessage ?? false)) {
        try {
          EasyLoading.show(status: '${lang.S.of(context).sendingMessage}...', dismissOnTap: true);
          await sendPurchaseReturnSms(purchase);
          EasyLoading.dismiss();
        } catch (e) {
          EasyLoading.dismiss();
        }
      }

      ///__________StockMange_________________________________________________________________________________
      final stockRef = FirebaseDatabase.instance.ref('${await getUserID()}/Products/');

      for (var element in purchase.productList!) {
        stockRef.keepSynced(true);
        var data = await stockRef.orderByChild('productCode').equalTo(element.productCode).once();
        final data2 = jsonDecode(jsonEncode(data.snapshot.value));

        String productPath = data.snapshot.value.toString().substring(1, 21);

        var data1 = await stockRef.child('$productPath/productStock').once();
        int stock = int.parse(data1.snapshot.value.toString());
        int remainStock = stock - element.lowerStockAlert.round();

        stockRef.child(productPath).update({'productStock': '$remainStock'});
      }

      ///________daily_transactionModel_________________________________________________________________________

      DailyTransactionModel dailyTransaction = DailyTransactionModel(
        name: purchase.customerName,
        date: purchase.purchaseDate,
        type: 'Purchase Return',
        total: purchase.totalAmount!.toDouble(),
        paymentIn: ((orginal.totalAmount ?? 0) - (orginal.dueAmount ?? 0)) > (purchase.totalAmount ?? 0) ? (purchase.totalAmount ?? 0) : ((orginal.totalAmount ?? 0) - (orginal.dueAmount ?? 0)),
        remainingBalance: ((orginal.totalAmount ?? 0) - (orginal.dueAmount ?? 0)) > (purchase.totalAmount ?? 0) ? (purchase.totalAmount ?? 0) : ((orginal.totalAmount ?? 0) - (orginal.dueAmount ?? 0)),
        paymentOut: 0,
        id: purchase.invoiceNumber,
        purchaseTransactionModel: purchase,
      );

      postDailyTransaction(dailyTransactionModel: dailyTransaction);

      ///_________DueUpdate___________________________________________________________________________________
      if (purchase.customerName != 'Guest' && (orginal.dueAmount ?? 0) > 0) {
        final dueUpdateRef = FirebaseDatabase.instance.ref('${await getUserID()}/Customers/');
        String? key;

        await FirebaseDatabase.instance.ref(await getUserID()).child('Customers').orderByKey().get().then((value) {
          for (var element in value.children) {
            var data = jsonDecode(jsonEncode(element.value));
            if (data['phoneNumber'] == purchase.customerPhone) {
              key = element.key;
            }
          }
        });
        var data1 = await dueUpdateRef.child('$key/due').once();
        int previousDue = data1.snapshot.value.toString().toInt();

        num dueNow = (orginal.dueAmount ?? 0) - (purchase.totalAmount ?? 0);

        int totalDue = dueNow.isNegative ? 0 : previousDue - purchase.totalAmount!.toInt();
        dueUpdateRef.child(key!).update({'due': '$totalDue'});
      }

      consumerRef.refresh(customerProvider);
      consumerRef.refresh(transitionProvider);
      consumerRef.refresh(productProvider);
      consumerRef.refresh(purchaseTransitionProvider);
      consumerRef.refresh(dueTransactionProvider);
      consumerRef.refresh(profileDetailsProvider);
      consumerRef.refresh(purchaseReturnProvider);

      //EasyLoading.showSuccess('Successfully Done');
      EasyLoading.showSuccess(lang.S.of(context).successfullyDone);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  ScrollController mainScroll = ScrollController();
  String searchItem = '';

  DateTime selectedDueDate = DateTime.now();

  Future<void> _selectedDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDueDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  List<ProductModel> returnList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrentUserAndRestartApp();

    for (var element in widget.purchaseTransactionModel.productList!) {
      element.lowerStockAlert = 0;
      returnList.add(element);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final personalData = consumerRef.watch(profileDetailsProvider);
      return Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text(
            lang.S.of(context).purchaseReturn,
            //'Purchase Return',
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
                          initialValue: widget.purchaseTransactionModel.invoiceNumber,
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
                          initialValue: DateFormat.yMMMd().format(DateTime.parse(
                            widget.purchaseTransactionModel.purchaseDate,
                          )),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).date,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    readOnly: true,
                    initialValue: widget.purchaseTransactionModel.customerName.isNotEmpty ? widget.purchaseTransactionModel.customerName : widget.purchaseTransactionModel.customerPhone,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: lang.S.of(context).customerName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ///_______Added_ItemS__________________________________________________
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      border: Border.all(width: 1, color: const Color(0xffEAEFFA)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xffEAEFFA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
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
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: returnList.length,
                            itemBuilder: (context, index) {
                              int i = 0;
                              TextEditingController quantityController = TextEditingController(text: returnList[index].lowerStockAlert.toString());
                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: ListTile(
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(returnList[index].productName.toString()),
                                      const SizedBox(width: 5.0),
                                      // Text('Return QTY'),
                                      Text(lang.S.of(context).returnQTY),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${returnList[index].productStock.toString()} X ${returnList[index].productPurchasePrice} = ${myFormat.format(
                                          double.tryParse(((double.parse(returnList[index].productStock.toString()) - returnList[index].lowerStockAlert) * ((double.parse(returnList[index].productPurchasePrice.toString())))).toStringAsFixed(2)) ?? 0,
                                        )}',
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      returnList[index].lowerStockAlert > 0 ? returnList[index].lowerStockAlert-- : returnList[index].lowerStockAlert = 0;
                                                    });
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
                                                SizedBox(
                                                  width: 50,
                                                  child: TextFormField(
                                                    // initialValue: quantityController.text,
                                                    controller: quantityController,
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.phone,
                                                    onChanged: (value) {
                                                      if ((num.tryParse(returnList[index].productStock) ?? 0) < (num.tryParse(returnList[index].productStock) ?? 0)) {
                                                        //EasyLoading.showError('Out of Stock');
                                                        EasyLoading.showError(lang.S.of(context).outOfStock);
                                                        quantityController.clear();
                                                      } else if (value == '') {
                                                        returnList[index].lowerStockAlert = 1;
                                                      } else if (value == '0') {
                                                        returnList[index].lowerStockAlert = 1;
                                                      } else {
                                                        returnList[index].lowerStockAlert = value.toInt();
                                                      }
                                                    },
                                                    onFieldSubmitted: (value) {
                                                      if (value == '') {
                                                        setState(() {
                                                          returnList[index].lowerStockAlert = 1;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          returnList[index].lowerStockAlert = value.toInt();
                                                        });
                                                      }
                                                    },
                                                    decoration: const InputDecoration(border: InputBorder.none),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (returnList[index].lowerStockAlert < (num.tryParse(returnList[index].productStock) ?? 0)) {
                                                      setState(() {
                                                        returnList[index].lowerStockAlert += 1;
                                                        toast(returnList[index].lowerStockAlert.toString());
                                                      });
                                                    } else {
                                                      // EasyLoading.showError('Out of Stock');
                                                      EasyLoading.showError(lang.S.of(context).outOfStock);
                                                    }
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ).visible(returnList.isNotEmpty),
                  ),
                  const SizedBox(height: 20),

                  ///______________________Total_Return____________________________________
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xffEAEFFA),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                //'Total return amount:',
                                '${lang.S.of(context).totalReturnAmount}:',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '$currency ${myFormat.format(getTotalReturnAmount())}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Center(
                    child: Text(
                      lang.S.of(context).cacel,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              )),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (!returnList.any((element) => element.lowerStockAlert > 0)) {
                      //EasyLoading.showError('Select a product for return');
                      EasyLoading.showError(lang.S.of(context).selectAProductForReturn);
                    } else {
                      returnList.removeWhere((element) => element.lowerStockAlert <= 0);

                      ///____________Invoice_edit______________________________________
                      PurchaseTransactionModel myTransitionModel = widget.purchaseTransactionModel;
                      final userId = await getUserID();
                      (num.tryParse(getTotalReturnAmount().toString()) ?? 0) > (widget.purchaseTransactionModel.dueAmount ?? 0) ? myTransitionModel.isPaid = true : myTransitionModel.isPaid = false;
                      if ((widget.purchaseTransactionModel.dueAmount ?? 0) > 0) {
                        (num.tryParse(getTotalReturnAmount().toString()) ?? 0) >= (widget.purchaseTransactionModel.dueAmount ?? 0) ? myTransitionModel.dueAmount = 0 : myTransitionModel.dueAmount = (widget.purchaseTransactionModel.dueAmount ?? 0) - (num.tryParse(getTotalReturnAmount().toString()) ?? 0);
                      }
                      List<ProductModel> newProductList = [];
                      for (var p in widget.purchaseTransactionModel.productList!) {
                        if (returnList.any((element) => element.productCode == p.productCode)) {
                          int index = returnList.indexWhere((element) => element.productCode == p.productCode);
                          p.productStock = ((double.tryParse(p.productStock) ?? 0) - returnList[index].lowerStockAlert).toString();
                        }

                        if ((double.tryParse(p.productStock) ?? 0) > 0) newProductList.add(p);
                      }
                      myTransitionModel.productList = newProductList;

                      myTransitionModel.totalAmount = (myTransitionModel.totalAmount ?? 0) - (double.tryParse(getTotalReturnAmount().toString()) ?? 0);

                      ///________________updateInvoice___________________________________________________________ok
                      String? key;
                      await FirebaseDatabase.instance.ref(userId).child('Purchase Transition').orderByKey().get().then((value) {
                        for (var element in value.children) {
                          final t = PurchaseTransactionModel.fromJson(jsonDecode(jsonEncode(element.value)));
                          if (widget.purchaseTransactionModel.invoiceNumber == t.invoiceNumber) {
                            key = element.key;
                          }
                        }
                      });
                      if (newProductList.isEmpty) {
                        await FirebaseDatabase.instance.ref(userId).child('Purchase Transition').child(key!).remove();
                      } else {
                        FirebaseDatabase.instance.ref(userId).child('Purchase Transition').child(key!).update(myTransitionModel.toJson());
                      }
                      for (var element in returnList) {
                        element.productStock = element.lowerStockAlert.toString();
                      }
                      returnList.removeWhere((element) => element.lowerStockAlert <= 0);
                      PurchaseTransactionModel invoice = PurchaseTransactionModel(
                        customerName: widget.purchaseTransactionModel.customerName,
                        customerType: widget.purchaseTransactionModel.customerType,
                        customerPhone: widget.purchaseTransactionModel.customerPhone,
                        invoiceNumber: widget.purchaseTransactionModel.invoiceNumber,
                        purchaseDate: widget.purchaseTransactionModel.purchaseDate,
                        customerAddress: widget.purchaseTransactionModel.customerAddress,
                        customerGst: widget.purchaseTransactionModel.customerGst,
                        sendWhatsappMessage: widget.purchaseTransactionModel.sendWhatsappMessage ?? false,
                        productList: returnList,
                        totalAmount: double.tryParse(getTotalReturnAmount().toString()),
                        discountAmount: 0,
                        dueAmount: 0,
                        isPaid: false,
                        paymentType: 'Cash',
                        returnAmount: 0,
                      );
                      var data = personalData.value!;
                      await purchaseReturn(purchase: invoice, orginal: widget.purchaseTransactionModel, consumerRef: consumerRef, context: context, personalInfo: data);
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
                        lang.S.of(context).confirmReturn,
                        //'Confirm return',
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
