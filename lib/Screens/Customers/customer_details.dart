import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/print_purchase_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Customers/edit_customer.dart';
import 'package:mobile_pos/const_commas.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../GlobalComponents/button_global.dart';
import '../../Provider/printer_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../currency.dart';
import '../../model/print_transaction_model.dart';
import '../invoice_details/purchase_invoice_details.dart';
import '../invoice_details/sales_invoice_details_screen.dart';
import 'Model/customer_model.dart';

// ignore: must_be_immutable
class CustomerDetails extends StatefulWidget {
  CustomerDetails({super.key, required this.customerModel});

  CustomerModel customerModel;

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  late String customerKey;
  String buttonsSelected = '';

  void getCustomerKey(String phoneNumber) async {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Customers');
    ref.keepSynced(true);
    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'].toString() == phoneNumber) {
          customerKey = element.key.toString();
        }
      }
    });
  }

  @override
  void initState() {
    getCustomerKey(widget.customerModel.phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, cRef, __) {
      final providerData = cRef.watch(transitionProvider);
      final providerDataPurchase = cRef.watch(purchaseTransitionProvider);
      final printerData = cRef.watch(printerProviderNotifier);
      final printerDataPurchase = cRef.watch(printerPurchaseProviderNotifier);
      final personalData = cRef.watch(profileDetailsProvider);
      return Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text(
            lang.S.of(context).customerDetails,
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (finalUserRoleModel.partiesEdit == false) {
                  toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                  return;
                }
                EditCustomer(customerModel: widget.customerModel).launch(context);
              },
              icon: const Icon(
                FeatherIcons.edit2,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (dontext) => AlertDialog(
                        // title: const Text('Are you sure to delete this user?'),
                        title: Text(' ${lang.S.of(context).areYouSureToDeleteThisUser}?'),
                        //content: const Text('The user will be deleted and all the data will be deleted from your account.Are you sure to delete this?',maxLines: 5,),
                        content: Text(
                          '${lang.S.of(context).theUserWillBeDeletedAndAllTheData}?',
                          maxLines: 5,
                        ),
                        actions: [
                          const Text('Cancel').onTap(() => Navigator.pop(dontext)),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            // child:  Text('Yes, Delete Forever').onTap((){
                            child: Text(lang.S.of(context).yesDeleteForever).onTap(() {
                              if (finalUserRoleModel.partiesDelete == false) {
                                toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                                return;
                              }
                              DatabaseReference ref = FirebaseDatabase.instance.ref("$constUserId/Customers/$customerKey");
                              ref.keepSynced(true);
                              ref.remove();
                              cRef.refresh(customerProvider);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(dontext);
                              Navigator.pop(context);
                            }),
                          ),
                        ],
                      )),
              icon: const Icon(
                FeatherIcons.trash2,
                color: Colors.white,
              ),
            ),
          ],
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0.0,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120.0,
                          width: 120.0,
                          child: CircleAvatar(
                            foregroundColor: Colors.blue,
                            backgroundColor: kMainColor,
                            radius: 70.0,
                            child: ClipOval(
                              child: Text(
                                widget.customerModel.customerName.isNotEmpty ? widget.customerModel.customerName.substring(0, 1) : '',
                                style: const TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        //   width: 120,
                        //   height: 120,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(90),
                        //     image: DecorationImage(
                        //       image: NetworkImage(widget.customerModel.profilePicture),
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        //   child: ,
                        // ),
                        const SizedBox(height: 20),
                        Text(
                          widget.customerModel.customerName,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        // const SizedBox(height: 5),
                        Text(
                          widget.customerModel.phoneNumber,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse('tel:${widget.customerModel.phoneNumber}');

                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }

                            setState(() {
                              buttonsSelected = 'Call';
                            });
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(color: buttonsSelected == 'Call' ? kMainColor : kMainColor.withOpacity(0.10), borderRadius: const BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FeatherIcons.phone,
                                    size: 25,
                                    color: buttonsSelected == 'Call' ? Colors.white : Colors.black,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    lang.S.of(context).call,
                                    // 'Call',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: buttonsSelected == 'Call' ? Colors.white : Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse('sms:${widget.customerModel.phoneNumber}');

                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                            setState(() {
                              buttonsSelected = 'Message';
                            });
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: buttonsSelected == 'Message' ? kMainColor : kMainColor.withOpacity(0.10),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FeatherIcons.messageSquare,
                                    size: 25,
                                    color: buttonsSelected == 'Message' ? Colors.white : Colors.black,
                                  ),
                                  Text(
                                    lang.S.of(context).message,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: buttonsSelected == 'Message' ? Colors.white : Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              buttonsSelected = 'Email';
                            });
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(color: buttonsSelected == 'Email' ? kMainColor : kMainColor.withOpacity(0.10), borderRadius: const BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FeatherIcons.mail,
                                    size: 25,
                                    color: buttonsSelected == 'Email' ? Colors.white : Colors.black,
                                  ),
                                  Text(
                                    lang.S.of(context).email,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: buttonsSelected == 'Email' ? Colors.white : Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    lang.S.of(context).aboutUs,
                    style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor, fontSize: 18),
                  ),
                  Text(
                    widget.customerModel.note,
                    style: kTextStyle.copyWith(color: kGreyTextColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    lang.S.of(context).recentTransactions,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.customerModel.type != 'Supplier'
                      ? providerData.when(data: (transaction) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transaction.length,
                            itemBuilder: (context, index) {
                              final reTransaction = transaction.reversed.toList();
                              return reTransaction[index].customerPhone == widget.customerModel.phoneNumber
                                  ? GestureDetector(
                                      onTap: () {
                                        SalesInvoiceDetails(
                                          personalInformationModel: personalData.value!,
                                          transitionModel: reTransaction[index],
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
                                                    Text(
                                                      // "Total Products : ${reTransaction[index].productList!.length.toString()}",
                                                      "${lang.S.of(context).totalProducts} : ${reTransaction[index].productList!.length.toString()}",
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                    Text('#${reTransaction[index].invoiceNumber}'),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(color: reTransaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d).withOpacity(0.1) : const Color(0xFFED1A3B).withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                      child: Text(
                                                        reTransaction[index].dueAmount! <= 0 ? lang.S.of(context).paid : lang.S.of(context).unpaid,
                                                        style: TextStyle(color: reTransaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          DateFormat.yMMMd().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                          style: const TextStyle(color: Colors.grey),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          DateFormat.jm().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                          style: const TextStyle(color: Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text(
                                                        //   'Total : $currency ${reTransaction[index].totalAmount.toString()}',
                                                        //   style: const TextStyle(color: Colors.grey),
                                                        // ),
                                                        const SizedBox(height: 3),
                                                        Text(
                                                          '${lang.S.of(context).paid} : $currency ${myFormat.format(int.tryParse('${reTransaction[index].totalAmount!.toDouble() - reTransaction[index].dueAmount!.toDouble()}') ?? 0)}',
                                                          style: const TextStyle(color: Colors.grey),
                                                        ),
                                                        const SizedBox(height: 3),
                                                        Text(
                                                          '${lang.S.of(context).due}: $currency ${myFormat.format(int.tryParse(reTransaction[index].dueAmount.toString()) ?? 0)}',
                                                          style: const TextStyle(fontSize: 16),
                                                        ).visible(reTransaction[index].dueAmount!.toInt() != 0),
                                                      ],
                                                    ),
                                                    personalData.when(data: (data) {
                                                      return Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
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
                                                                              return Dialog(
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
                                                                              );
                                                                            });
                                                                  },
                                                                  icon: const Icon(
                                                                    FeatherIcons.printer,
                                                                    color: Colors.grey,
                                                                  )),
                                                              IconButton(
                                                                  onPressed: () {},
                                                                  icon: const Icon(
                                                                    FeatherIcons.share,
                                                                    color: Colors.grey,
                                                                  )).visible(false),
                                                            ],
                                                          )
                                                        ],
                                                      );
                                                    }, error: (e, stack) {
                                                      return Text(e.toString());
                                                    }, loading: () {
                                                      //return const Text('Loading');
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
                                    )
                                  : Container();
                            },
                          );
                        }, error: (e, stack) {
                          return Text(lang.S.of(context).noTransactionFound);
                        }, loading: () {
                          return const Center(child: CircularProgressIndicator());
                        })
                      : providerDataPurchase.when(data: (transaction) {
                          final reTransaction = transaction.reversed.toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reTransaction.length,
                            itemBuilder: (context, index) {
                              return reTransaction[index].customerPhone == widget.customerModel.phoneNumber
                                  ? GestureDetector(
                                      onTap: () {
                                        PurchaseInvoiceDetails(
                                          transitionModel: reTransaction[index],
                                          personalInformationModel: personalData.value!,
                                        ).launch(context);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            // padding: const EdgeInsets.all(20),
                                            width: context.width(),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${lang.S.of(context).totalProducts} : ${reTransaction[index].productList!.length.toString()}",
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                    Text('#${reTransaction[index].invoiceNumber}'),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(color: reTransaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d).withOpacity(0.1) : const Color(0xFFED1A3B).withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                      child: Text(
                                                        reTransaction[index].dueAmount! <= 0 ? lang.S.of(context).paid : lang.S.of(context).unpaid,
                                                        style: TextStyle(color: reTransaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                                      ),
                                                    ),
                                                    Text(
                                                      reTransaction[index].purchaseDate.substring(0, 10),
                                                      style: const TextStyle(color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${lang.S.of(context).total} : $currency ${myFormat.format(reTransaction[index].totalAmount)}',
                                                          style: const TextStyle(color: Colors.grey),
                                                        ),
                                                        const SizedBox(height: 3),
                                                        Text(
                                                          '${lang.S.of(context).paid} : $currency ${myFormat.format(reTransaction[index].totalAmount!.toDouble() - reTransaction[index].dueAmount!.toDouble())}',
                                                          style: const TextStyle(color: Colors.grey),
                                                        ),
                                                        const SizedBox(height: 3),
                                                        Text(
                                                          '${lang.S.of(context).due}: $currency ${myFormat.format(reTransaction[index].dueAmount)}',
                                                          style: const TextStyle(fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                    personalData.when(data: (data) {
                                                      return Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () async {
                                                                await printerData.getBluetooth();
                                                                PrintPurchaseTransactionModel model = PrintPurchaseTransactionModel(
                                                                  personalInformationModel: data,
                                                                  purchaseTransitionModel: reTransaction[index],
                                                                );
                                                                connected
                                                                    ? printerDataPurchase.printTicket(
                                                                        printTransactionModel: model,
                                                                        productList: model.purchaseTransitionModel!.productList,
                                                                      )
                                                                    : showDialog(
                                                                        context: context,
                                                                        builder: (_) {
                                                                          return Dialog(
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

                                                                                              /// : toast('Try Again');
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
                                                                          );
                                                                        });
                                                              },
                                                              icon: const Icon(
                                                                FeatherIcons.printer,
                                                                color: Colors.grey,
                                                              )),
                                                          IconButton(
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                FeatherIcons.share,
                                                                color: Colors.grey,
                                                              )).visible(false),
                                                          IconButton(
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                FeatherIcons.moreVertical,
                                                                color: Colors.grey,
                                                              )).visible(false),
                                                        ],
                                                      );
                                                    }, error: (e, stack) {
                                                      return Text(e.toString());
                                                    }, loading: () {
                                                      // return const Text('Loading');
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
                                    )
                                  : Container();
                            },
                          );
                        }, error: (e, stack) {
                          return Text(lang.S.of(context).noTransactionFound);
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
            iconWidget: null,
            buttontext: lang.S.of(context).viewAll,
            iconColor: Colors.white,
            buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
            onPressed: () {},
          ),
        ).visible(false),
      );
    });
  }
}
