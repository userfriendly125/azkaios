// ignore_for_file: use_build_context_synchronously
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/purchase%20return/purchase_return_pdf.dart';
import 'package:mobile_pos/const_commas.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/printer_provider.dart';
import '../../constant.dart' as mainConstant;
import '../../currency.dart';
import '../../invoice_constant.dart';
import '../../model/personal_information_model.dart';
import '../../model/transition_model.dart';
import '../Home/home.dart';

class PurchaseReturnDetails extends StatefulWidget {
  const PurchaseReturnDetails({super.key, required this.transitionModel, required this.personalInformationModel});

  final PurchaseTransactionModel transitionModel;
  final PersonalInformationModel personalInformationModel;

  @override
  State<PurchaseReturnDetails> createState() => _PurchaseReturnDetailsState();
}

class _PurchaseReturnDetailsState extends State<PurchaseReturnDetails> {
  double totalPurchaseAmount({required PurchaseTransactionModel transactions}) {
    double amount = 0;

    for (var element in transactions.productList!) {
      amount = amount + double.parse(element.productPurchasePrice.toString()) * double.parse(element.productStock.toString());
    }

    return double.parse(amount.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      ref.refresh(productProvider);
      final printerData = ref.watch(printerProviderNotifier);
      return SafeArea(
        child: PopScope(
          onPopInvokedWithResult: (isPop, result) async {
            Navigator.pop(context);
          },
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
                          lang.S.of(context).supplier,
                          // 'Supplier',
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.transitionModel.customerName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat.yMMMd().format(DateTime.parse(widget.transitionModel.purchaseDate)),
                          textAlign: TextAlign.end,
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
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
                          '',
                          style: kTextStyle.copyWith(color: kTitleColor),
                        ),
                        const Spacer(),
                        Text(
                          '${lang.S.of(context).seller}: ${widget.transitionModel.customerName.isEmptyOrNull ? lang.S.of(context).admin : widget.transitionModel.customerName}',
                          style: kTextStyle.copyWith(color: kTitleColor),
                        ),
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
                                maxLines: 2,
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                lang.S.of(context).quantity,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                lang.S.of(context).unitPrice,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                lang.S.of(context).totalPrice,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                            ),
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
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '$currency ${myFormat.format(int.tryParse(widget.transitionModel.productList![i].productPurchasePrice) ?? 0)}',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '$currency ${myFormat.format(double.parse(widget.transitionModel.productList![i].productPurchasePrice) * double.parse(widget.transitionModel.productList![i].productStock))}',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                              )
                            ]);
                          })),
                    ),
                    // SizedBox(
                    //   width: context.width(),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       SizedBox(
                    //         width: context.width() / 2.4,
                    //         child: Text(
                    //           lang.S.of(context).product,
                    //           maxLines: 2,
                    //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                    //         child: Text(
                    //           lang.S.of(context).quantity,
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
                    //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                    //         child: Text(
                    //           lang.S.of(context).unitPrice,
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
                    //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                    //         child: Text(
                    //           lang.S.of(context).totalPrice,
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
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
                    //             crossAxisAlignment: CrossAxisAlignment.start,
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
                    //               // const Spacer(),
                    //               SizedBox(
                    //                 width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                    //                 child: Text(
                    //                   widget.transitionModel.productList![i].productStock.toString(),
                    //                   maxLines: 1,
                    //                   textAlign: TextAlign.center,
                    //                   overflow: TextOverflow.ellipsis,
                    //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                    //                 child: Text(
                    //                   '$currency ${myFormat.format(int.tryParse(widget.transitionModel.productList![i].productPurchasePrice) ?? 0)}',
                    //                   maxLines: 1,
                    //                   textAlign: TextAlign.center,
                    //                   overflow: TextOverflow.ellipsis,
                    //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                    //                 child: Text(
                    //                   '$currency ${myFormat.format(double.parse(widget.transitionModel.productList![i].productPurchasePrice) * double.parse(widget.transitionModel.productList![i].productStock))}',
                    //                   maxLines: 1,
                    //                   textAlign: TextAlign.center,
                    //                   overflow: TextOverflow.ellipsis,
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
                          lang.S.of(context).returnAmount,
                          //  'Return Amount',
                          maxLines: 1,
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                        const SizedBox(width: 20.0),
                        SizedBox(
                          width: 120,
                          child: Text(
                            myFormat.format(double.tryParse(totalPurchaseAmount(transactions: widget.transitionModel).toString()) ?? 0),
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
                          lang.S.of(context).serviceShipping,
                          // 'Service/Shipping',
                          maxLines: 1,
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                        const SizedBox(width: 20.0),
                        SizedBox(
                          width: 120,
                          child: Text(
                            '$currency ${0}',
                            maxLines: 2,
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Divider(color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          lang.S.of(context).totalReturnAmount,
                          //'Total Return Amount',
                          maxLines: 1,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 20.0),
                        SizedBox(
                          width: 120,
                          child: Text(
                            myFormat.format(double.tryParse(widget.transitionModel.totalAmount.toString()) ?? 0),
                            maxLines: 2,
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(children: [
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
                            size: 20,
                          ),
                          Text(
                            lang.S.of(context).cacel,
                            style: const TextStyle(
                              fontSize: 16,
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
                      await PurchaseReturn().generatePurchaseReturnDocument(widget.personalInformationModel, widget.transitionModel, context);
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
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      sharePurchaseReturnPDF(
                        transactions: widget.transitionModel,
                        personalInformation: widget.personalInformationModel,
                        context: context,
                      );
                      // GeneratePdf().generateSaleDocument(widget.transitionModel, widget.personalInformationModel, context, share: true);
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
              ]),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
        ),
      );
    });
  }
}
