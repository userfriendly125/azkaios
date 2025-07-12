import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:mobile_pos/model/transition_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../GlobalComponents/button_global.dart';
import '../Provider/print_purchase_provider.dart';
import '../Provider/profile_provider.dart';
import '../constant.dart';
import '../generated/l10n.dart' as lang;

class CustomPrintScreen extends StatefulWidget {
  const CustomPrintScreen({super.key});

  @override
  State<CustomPrintScreen> createState() => _CustomPrintScreenState();
}

class _CustomPrintScreenState extends State<CustomPrintScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Print'),
      ),
      body: Consumer(builder: (context, ref, __) {
        final printerData = ref.watch(printerPurchaseProviderNotifier);
        final personalData = ref.watch(profileDetailsProvider);
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              TextFormField(
                controller: textEditingController,
                maxLines: 5,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: "Write text here...",
                  border: OutlineInputBorder(),
                ),
              ),
              Spacer(),
              personalData.when(data: (data) {
                return ButtonGlobal(
                  iconWidget: Icons.add,
                  buttontext: "Print",
                  iconColor: Colors.white,
                  buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
                  onPressed: () async {
                    await printerData.getBluetooth();
                    if (connected) {
                      await printerData.printCustomTicket(printTransactionModel: PrintPurchaseTransactionModel(purchaseTransitionModel: PurchaseTransactionModel(customerName: "", customerGst: "", customerType: "", customerAddress: "", customerPhone: "", invoiceNumber: "", purchaseDate: ""), personalInformationModel: data), data: textEditingController.text);
                    } else {
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
                                              isConnect
                                                  // ignore: use_build_context_synchronously
                                                  ? finish(context)
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
                    }
                  },
                );
              }, error: (e, stack) {
                return Text(e.toString());
              }, loading: () {
                return const CircularProgressIndicator();
              })
            ],
          ),
        );
      }),
    );
  }
}
