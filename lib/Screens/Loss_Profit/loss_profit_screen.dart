// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/all_expanse_provider.dart';
import 'package:mobile_pos/Provider/printer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Loss_Profit/single_loss_profit_screen.dart';
import 'package:mobile_pos/const_commas.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../currency.dart';
import '../../empty_screen_widget.dart';
import '../Home/home.dart';

class LossProfitScreen extends StatefulWidget {
  const LossProfitScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LossProfitScreenState createState() => _LossProfitScreenState();
}

class _LossProfitScreenState extends State<LossProfitScreen> {
  TextEditingController fromDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime(2021)));
  TextEditingController toDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  DateTime fromDate = DateTime(2021);
  DateTime toDate = DateTime.now();
  double totalProfit = 0;
  double totalExpense = 0;
  double totalLoss = 0;

  bool isPicked = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await const Home().launch(context, isNewTask: true);
      },
      child: Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kWhite),
          title: Text(
            lang.S.of(context).lossOrProfit,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: kMainColor,
          elevation: 0.0,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer(builder: (context, ref, __) {
                  final providerData = ref.watch(transitionProvider);
                  final expenseData = ref.watch(expenseProvider);
                  final printerData = ref.watch(printerProviderNotifier);
                  final personalData = ref.watch(profileDetailsProvider);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20, bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  textFieldType: TextFieldType.NAME,
                                  readOnly: true,
                                  controller: fromDateTextEditingController,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: lang.S.of(context).formDate,
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
                                          fromDateTextEditingController.text = DateFormat.yMMMd().format(picked ?? DateTime.now());
                                          fromDate = picked!;
                                          totalLoss = 0;
                                          totalProfit = 0;
                                          isPicked = true;
                                        });
                                      },
                                      icon: const Icon(FeatherIcons.calendar),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: AppTextField(
                                  textFieldType: TextFieldType.NAME,
                                  readOnly: true,
                                  controller: toDateTextEditingController,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: lang.S.of(context).toDate,
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        final DateTime? picked = await showDatePicker(
                                          initialDate: toDate,
                                          firstDate: DateTime(2015, 8),
                                          lastDate: DateTime(2101),
                                          context: context,
                                        );

                                        setState(() {
                                          toDateTextEditingController.text = DateFormat.yMMMd().format(picked ?? DateTime.now());
                                          picked!.isToday ? toDate = DateTime.now() : toDate = picked;
                                          totalLoss = 0;
                                          totalProfit = 0;
                                          isPicked = true;
                                        });
                                      },
                                      icon: const Icon(FeatherIcons.calendar),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        providerData.when(data: (transaction) {
                          totalProfit = 0;
                          totalLoss = 0;
                          final reTransaction = transaction.reversed.toList();
                          for (var element in reTransaction) {
                            if (!isPicked) {
                              if (DateTime.parse(element.purchaseDate).month == DateTime.now().month && DateTime.parse(element.purchaseDate).year == DateTime.now().year) {
                                element.lossProfit!.isNegative ? totalLoss = totalLoss + element.lossProfit!.abs() : totalProfit = totalProfit + element.lossProfit!;
                              }
                            } else {
                              if ((fromDate.isBefore(DateTime.parse(element.purchaseDate)) || DateTime.parse(element.purchaseDate).isAtSameMomentAs(fromDate)) && (toDate.isAfter(DateTime.parse(element.purchaseDate)) || DateTime.parse(element.purchaseDate).isAtSameMomentAs(toDate))) {
                                element.lossProfit!.isNegative ? totalLoss = totalLoss + element.lossProfit!.abs() : totalProfit = totalProfit + element.lossProfit!;
                              }
                            }
                          }
                          expenseData.when(data: (transaction) {
                            totalExpense = 0;
                            final reTransaction = transaction.reversed.toList();
                            for (var element in reTransaction) {
                              if (!isPicked) {
                                if (DateTime.parse(element.expenseDate).month == DateTime.now().month && DateTime.parse(element.expenseDate).year == DateTime.now().year) {
                                  totalExpense = totalExpense + (num.tryParse(element.amount) ?? 0);
                                }
                              } else {
                                if ((fromDate.isBefore(DateTime.parse(element.expenseDate)) || DateTime.parse(element.expenseDate).isAtSameMomentAs(fromDate)) && (toDate.isAfter(DateTime.parse(element.expenseDate)) || DateTime.parse(element.expenseDate).isAtSameMomentAs(toDate))) {
                                  totalExpense = totalExpense + (num.tryParse(element.amount) ?? 0);
                                  // element.lossProfit!.isNegative ? totalLoss = totalLoss + element.lossProfit!.abs() : totalProfit = totalProfit + element.lossProfit!;
                                }
                              }
                            }

                            return Container();
                          }, error: (e, stack) {
                            return Text(e.toString());
                          }, loading: () {
                            return const Center(child: CircularProgressIndicator());
                          });

                          return reTransaction.isNotEmpty
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Container(
                                        height: 180,
                                        width: double.infinity,
                                        decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), border: Border.all(width: 1, color: kMainColor), borderRadius: const BorderRadius.all(Radius.circular(15))),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width / 2 - 30,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        currency + myFormat.format(totalProfit),
                                                        style: const TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Text(
                                                        lang.S.of(context).profit,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 1,
                                                  height: 60,
                                                  color: kMainColor,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width / 2 - 30,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        currency + myFormat.format(totalLoss),
                                                        style: const TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Text(
                                                        lang.S.of(context).loss,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  currency + myFormat.format(totalExpense),
                                                  style: const TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  lang.S.of(context).expense,
                                                  //'Expense',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: reTransaction.length,
                                      itemBuilder: (context, index) {
                                        return (fromDate.isBefore(DateTime.parse(reTransaction[index].purchaseDate)) || DateTime.parse(reTransaction[index].purchaseDate).isAtSameMomentAs(fromDate)) && (toDate.isAfter(DateTime.parse(reTransaction[index].purchaseDate)) || DateTime.parse(reTransaction[index].purchaseDate).isAtSameMomentAs(toDate))
                                            ? GestureDetector(
                                                onTap: () {
                                                  SingleLossProfitScreen(
                                                    transactionModel: reTransaction[index],
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
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                              Text(
                                                                '#${reTransaction[index].invoiceNumber}',
                                                                style: const TextStyle(color: Colors.black),
                                                              ),
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
                                                                  const SizedBox(height: 5),
                                                                  Text(
                                                                    DateFormat.jm().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                                    style: const TextStyle(color: Colors.grey),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                Text(
                                                                  '${lang.S.of(context).total} : $currency ${myFormat.format(reTransaction[index].totalAmount)}',
                                                                  style: const TextStyle(color: Colors.grey),
                                                                ),
                                                                const SizedBox(height: 5),
                                                                Text(
                                                                  '${lang.S.of(context).profit} : $currency ${myFormat.format(reTransaction[index].lossProfit)}',
                                                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                                                ).visible(!reTransaction[index].lossProfit!.isNegative),
                                                                Text(
                                                                  '${lang.S.of(context).loss}: $currency ${myFormat.format(reTransaction[index].lossProfit!.abs())}',
                                                                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                                                ).visible(reTransaction[index].lossProfit!.isNegative),
                                                              ]),
                                                              personalData.when(data: (data) {
                                                                return Row(
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed: () async {
                                                                          totalProfit = 0;
                                                                          totalLoss = 0;
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
                                                                                                      isConnect ? finish(context) : toast(lang.S.of(context).tryAgain);
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
                                                                    IconButton(
                                                                        onPressed: () => toast('Coming Soon'),
                                                                        icon: const Icon(
                                                                          FeatherIcons.share,
                                                                          color: Colors.grey,
                                                                        )).visible(false),
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
                                              )
                                            : Container();
                                      },
                                    ),
                                  ],
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
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
