import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
import 'package:mobile_pos/const_commas.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../Provider/print_purchase_provider.dart';
// ignore: library_prefixes
import '../../constant.dart' as mainConstant;
import '../../currency.dart';
import '../../invoice_constant.dart';
import '../../model/personal_information_model.dart';
import '../../model/print_transaction_model.dart';
import '../../model/transition_model.dart';
import '../../pdf/purchase_pdf.dart';

class PurchaseInvoiceDetails extends StatefulWidget {
  const PurchaseInvoiceDetails({super.key, required this.transitionModel, required this.personalInformationModel});

  final PurchaseTransactionModel transitionModel;
  final PersonalInformationModel personalInformationModel;

  @override
  State<PurchaseInvoiceDetails> createState() => _PurchaseInvoiceDetailsState();
}

class _PurchaseInvoiceDetailsState extends State<PurchaseInvoiceDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final printerData = ref.watch(printerPurchaseProviderNotifier);
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/logo1.png'),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.personalInformationModel.companyName.toString(),
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.personalInformationModel.countryName.toString(),
                          style: kTextStyle.copyWith(
                            color: kGreyTextColor,
                          ),
                        ),
                        Text(
                          widget.personalInformationModel.phoneNumber.toString(),
                          style: kTextStyle.copyWith(
                            color: kGreyTextColor,
                          ),
                        ),
                        Text(
                          '${lang.S.of(context).shopGST}: ${widget.personalInformationModel.gst}',
                          style: kTextStyle.copyWith(
                            color: kGreyTextColor,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                  Divider(
                    thickness: 1.0,
                    color: kGreyTextColor.withOpacity(0.1),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text(
                        lang.S.of(context).billTo,
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${lang.S.of(context).invoice}# ${widget.transitionModel.invoiceNumber}',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        widget.transitionModel.customerName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat.yMMMd().format(DateTime.parse(widget.transitionModel.purchaseDate)),
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       child: Text(
                  //         widget.transitionModel.customerName,
                  //         maxLines: 2,
                  //         overflow: TextOverflow.ellipsis,
                  //         style: kTextStyle.copyWith(color: kGreyTextColor),
                  //       ),
                  //     ),
                  //     const Spacer(),
                  //     Text(
                  //       DateFormat.yMMMd().format(DateTime.parse(widget.transitionModel.purchaseDate)),
                  //       style: kTextStyle.copyWith(color: kGreyTextColor),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        widget.transitionModel.customerPhone,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat.jm().format(
                          DateTime.parse(widget.transitionModel.purchaseDate),
                        ),
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${lang.S.of(context).partyGST}: ${widget.transitionModel.customerGst}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      const Text(''),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  // Divider(
                  //   thickness: 1.0,
                  //   color: kGreyTextColor.withOpacity(0.1),
                  // ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        headingRowColor: WidgetStatePropertyAll(kGreyTextColor.withOpacity(0.1)),
                        border: TableBorder.all(color: kBorderColorTextField),
                        dataRowMinHeight: 40,
                        dataRowMaxHeight: 40,
                        headingRowHeight: 40,
                        columns: [
                          DataColumn(
                            label: Text(
                              lang.S.of(context).product,
                              maxLines: 1,
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              lang.S.of(context).quantity,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              lang.S.of(context).unitPrice,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                              label: Text(
                            lang.S.of(context).totalPrice,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          )),
                        ],
                        rows: List.generate(widget.transitionModel.productList!.length, (i) {
                          return DataRow(cells: [
                            DataCell(
                              Text(
                                widget.transitionModel.productList![i].productName.toString(),
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                            DataCell(
                              Text(
                                widget.transitionModel.productList![i].productStock.toString(),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                            DataCell(
                              Text(
                                '$currency ${myFormat.format(double.tryParse(widget.transitionModel.productList![i].productPurchasePrice)?.round() ?? 0)}',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                            DataCell(
                              Text(
                                '$currency ${myFormat.format(double.parse(widget.transitionModel.productList![i].productPurchasePrice) * double.parse(widget.transitionModel.productList![i].productStock))}',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(color: kTitleColor),
                              ),
                            )
                          ]);
                        })),
                  ),
                  // SizedBox(
                  //   width: context.width(),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       SizedBox(
                  //         width: context.width() / 2.4,
                  //         child: Text(
                  //           lang.S.of(context).product,
                  //           maxLines: 1,
                  //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                  //         child: Text(
                  //           lang.S.of(context).quantity,
                  //           maxLines: 1,
                  //           textAlign: TextAlign.center,
                  //           overflow: TextOverflow.ellipsis,
                  //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                  //         child: Text(
                  //           lang.S.of(context).unitPrice,
                  //           overflow: TextOverflow.ellipsis,
                  //           maxLines: 1,
                  //           textAlign: TextAlign.center,
                  //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                  //         child: Text(
                  //           lang.S.of(context).totalPrice,
                  //           maxLines: 1,
                  //           overflow: TextOverflow.ellipsis,
                  //           textAlign: TextAlign.center,
                  //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Divider(
                  //   thickness: 1.0,
                  //   color: kGreyTextColor.withOpacity(0.1),
                  // ),
                  const SizedBox(height: 10.0),
                  // ListView.builder(
                  //     shrinkWrap: true,
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: widget.transitionModel.productList!.length,
                  //     itemBuilder: (_, i) {
                  //       return Padding(
                  //         padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  //         child: SizedBox(
                  //           width: context.width(),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               SizedBox(
                  //                 width: context.width() / 2.4,
                  //                 child: Text(
                  //                   widget.transitionModel.productList![i].productName.toString(),
                  //                   maxLines: 2,
                  //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                  //                 child: Text(
                  //                   widget.transitionModel.productList![i].productStock.toString(),
                  //                   maxLines: 1,
                  //                   textAlign: TextAlign.center,
                  //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                  //                 child: Text(
                  //                   '$currency ${myFormat.format(double.tryParse(widget.transitionModel.productList![i].productPurchasePrice)?.round() ?? 0)}',
                  //                   maxLines: 1,
                  //                   textAlign: TextAlign.center,
                  //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                  //                 child: Text(
                  //                   '$currency ${myFormat.format(double.parse(widget.transitionModel.productList![i].productPurchasePrice) * double.parse(widget.transitionModel.productList![i].productStock))}',
                  //                   maxLines: 1,
                  //                   textAlign: TextAlign.center,
                  //                   style: kTextStyle.copyWith(color: kTitleColor),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     }),
                  // Divider(
                  //   thickness: 1.0,
                  //   color: kGreyTextColor.withOpacity(0.1),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).subTotal,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${myFormat.format(widget.transitionModel.totalAmount!.toDouble() + widget.transitionModel.discountAmount!.toDouble())}',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Text(
                  //       lang.S.of(context).totalVat,
                  //       maxLines: 1,
                  //       style: kTextStyle.copyWith(color: kGreyTextColor),
                  //     ),
                  //     const SizedBox(width: 20.0),
                  //     SizedBox(
                  //       width: 120,
                  //       child: Text(
                  //         '$currency 0.00',
                  //         maxLines: 2,
                  //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //         textAlign: TextAlign.end,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).discount,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${myFormat.format(widget.transitionModel.discountAmount)}',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).deliveryCharge,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency 0.00',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).totalPayable,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${myFormat.format(widget.transitionModel.totalAmount)}',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).paid,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${myFormat.format(widget.transitionModel.totalAmount! - widget.transitionModel.dueAmount!.toDouble())}',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).due,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${myFormat.format(widget.transitionModel.dueAmount)}',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.0,
                    color: kGreyTextColor.withOpacity(0.1),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      lang.S.of(context).thankYouForYourPurchase,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          Text(
                            lang.S.of(context).cacel,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).onTap(() => const Home().launch(context)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await printerData.getBluetooth();
                      PrintPurchaseTransactionModel model = PrintPurchaseTransactionModel(purchaseTransitionModel: widget.transitionModel, personalInformationModel: widget.personalInformationModel);
                      mainConstant.connected
                          ? printerData.printTicket(
                              printTransactionModel: model,
                              productList: model.purchaseTransitionModel!.productList,
                            )
                          : showDialog(
                              context: context,
                              builder: (_) {
                                return PopScope(
                                  canPop: false,
                                  child: Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

                                                  // String name = list[0];

                                                  bool isConnect = await printerData.setConnect(select.macAdress);
                                                  // ignore: use_build_context_synchronously
                                                  isConnect ? finish(context) : toast(lang.S.of(context).tryAgain);
                                                },
                                                title: Text(printerData.availableBluetoothDevices[index].name),
                                                subtitle: Text(lang.S.of(context).clickToConnect),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          if (printerData.availableBluetoothDevices.isEmpty)
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                lang.S.of(context).pleaseConnectYourBluttothPrinter,
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          Container(height: 1, width: double.infinity, color: Colors.grey),
                                          const SizedBox(height: 10),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Center(
                                              child: Text(
                                                lang.S.of(context).cacel,
                                                style: const TextStyle(color: mainConstant.kMainColor, fontWeight: FontWeight.w600),
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
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: mainConstant.kMainColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.print,
                              color: Colors.white,
                            ),
                            Text(
                              lang.S.of(context).print,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
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
                    onTap: () {
                      sharePurchasePDF(transactions: widget.transitionModel, personalInformation: widget.personalInformationModel, context: context);
                      // GeneratePdf().generatePurchaseDocument(widget.transitionModel, widget.personalInformationModel, context, share: true);
                    },
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CommunityMaterialIcons.share,
                              color: Colors.white,
                            ),
                            Text(
                              lang.S.of(context).share,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      );
    });
  }
}
