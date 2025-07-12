// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/generated/l10n.dart' as l;
import 'package:mobile_pos/model/due_transaction_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../model/personal_information_model.dart';
import '../model/transition_model.dart';
import 'Screens/Pdf/pdf_view.dart';
import 'const_commas.dart';
import 'constant.dart';

class GeneratePdf1 {
  Future<void> generatePurchaseDocument(PurchaseTransactionModel transactions, PersonalInformationModel personalInformation, BuildContext context) async {
    final pw.Document doc = pw.Document();
    double totalPurchaseAmount({required PurchaseTransactionModel transactions}) {
      double amount = 0;

      for (var element in transactions.productList!) {
        amount = amount + double.parse(element.productPurchasePrice.toString()) * double.parse(element.productStock.toString());
      }

      return double.parse(amount.toStringAsFixed(2));
    }

    final englishFont = pw.Font.ttf(await rootBundle.load('images/Roboto-Regular.ttf'));
    final banglaFont = pw.Font.ttf(await rootBundle.load('images/siyam_rupali_ansi.ttf'));
    final arabicFont = pw.Font.ttf(await rootBundle.load('images/Amiri-Regular.ttf'));
    final hindiFont = pw.Font.ttf(await rootBundle.load('images/Hind-Regular.ttf'));
    final frenchFont = pw.Font.ttf(await rootBundle.load('images/GFSDidot-Regular.ttf'));

    getFont() {
      if (currentLanguage == 'en') {
        return englishFont;
      } else if (currentLanguage == 'bn') {
        return banglaFont;
      } else if (currentLanguage == 'ar') {
        return arabicFont;
      } else if (currentLanguage == 'hi') {
        return hindiFont;
      } else if (currentLanguage == 'fr') {
        return frenchFont;
      } else {
        return englishFont;
      }
    }

    final localContext = context;
    doc.addPage(
      pw.MultiPage(
        // pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        //theme: pw.ThemeData.withFont(base: banglaFont),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 5),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                ///________Company_Name_________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Center(
                    child: pw.Text(
                      personalInformation.companyName ?? '',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 22.0, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ),

                ///______Phone________________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(1.0),
                  child: pw.Center(
                    child: getLocalizedPdfText(
                        '${l.S.of(localContext).phone}: ${personalInformation.phoneNumber}',
                        pw.Theme.of(context).defaultTextStyle.copyWith(
                              color: PdfColors.black,
                              fontSize: 14.0,
                              font: getFont(),
                            )),
                  ),
                ),

                ///______Address________________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(1.0),
                  child: pw.Center(
                    child: pw.Text(
                      '${l.S.of(localContext).address}: ${personalInformation.countryName}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                    ),
                  ),
                ),

                ///______Shop_GST________________________________________________________________
                personalInformation.gst.trim().isNotEmpty
                    ? pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.all(1.0),
                        child: pw.Center(
                          child: pw.Text(
                            '${l.S.of(localContext).shopGST}: ${personalInformation.gst}',
                            style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                          ),
                        ),
                      )
                    : pw.Container(),

                ///________Bill/Invoice_________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Center(
                      child: pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black, width: 0.5),
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                          ),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 2.0, bottom: 2, left: 5, right: 5),
                            child: pw.Text(
                              l.S.of(localContext).billInvoice,
                              style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 16.0, fontWeight: pw.FontWeight.bold),
                            ),
                          ))),
                ),

                ///___________price_section_____________________________________________________
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  ///_________Left_Side__________________________________________________________
                  pw.Column(children: [
                    ///_____Name_______________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).customer,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Phone_______________________________________
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).phone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerPhone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Address_______________________________________
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).address,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Party GST_______________________________________
                    pw.SizedBox(height: transactions.customerGst.trim().isNotEmpty ? 2 : 0),
                    transactions.customerGst.trim().isNotEmpty
                        ? pw.Row(children: [
                            pw.SizedBox(
                              width: 60.0,
                              child: pw.Text(
                                l.S.of(localContext).partyGST,
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                            pw.SizedBox(
                              width: 10.0,
                              child: pw.Text(
                                ':',
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                            pw.SizedBox(
                              width: 140.0,
                              child: pw.Text(
                                transactions.customerGst,
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                          ])
                        : pw.Container(),

                    ///_____Remarks_______________________________________
                    // pw.SizedBox(height: 2),
                    // pw.Row(children: [
                    //   pw.SizedBox(
                    //     width: 60.0,
                    //     child: pw.Text(
                    //       'Remarks',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    //   pw.SizedBox(
                    //     width: 10.0,
                    //     child: pw.Text(
                    //       ':',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    //   pw.SizedBox(
                    //     width: 140.0,
                    //     child: pw.Text(
                    //       '',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    // ]),
                  ]),

                  ///_________Right_Side___________________________________________________________
                  pw.Column(children: [
                    ///______invoice_number_____________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).invoice,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          '#${transactions.invoiceNumber}',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///_________Sells By________________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).sellsBy,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          l.S.of(localContext).admin,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///______Date__________________________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).date,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.Container(
                        width: 125.0,
                        child: pw.Text(
                          '${DateFormat.yMMMd('en_US').format(DateTime.parse(transactions.purchaseDate))}, ${DateFormat.jm('en_US').format(DateTime.parse(transactions.purchaseDate))}',
                          // DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: AmericanDateTimeFormats.),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///______Status____________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).status,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          transactions.isPaid! ? l.S.of(localContext).paid : l.S.of(localContext).due,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 1.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      l.S.of(localContext).signatureOfCustomer,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.black,
                            fontSize: 11,
                          ),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 1.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      l.S.of(localContext).authorizedSignature,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.black,
                            fontSize: 11,
                          ),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              decoration: pw.BoxDecoration(border: pw.Border.all(width: 1, color: PdfColors.black)),
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Column(children: [
                pw.Text('${l.S.of(localContext).shopAddress}: ${personalInformation.countryName}',
                    maxLines: 3,
                    style: const pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 11,
                    )),
              ]),
              // child: pw.Center(child: ),
            ),
            pw.SizedBox(height: 5),
            pw.Text('${l.S.of(localContext).poweredBy} $appName', style: const pw.TextStyle(fontSize: 10, color: PdfColors.black)),
          ]);
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                ///___________Table__________________________________________________________
                pw.Table.fromTextArray(
                  context: context,
                  border: const pw.TableBorder(
                    left: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    right: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    bottom: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    top: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    verticalInside: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    horizontalInside: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                  ),
                  // headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#D5D8DC')),
                  columnWidths: <int, pw.TableColumnWidth>{
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(6),
                    2: const pw.FlexColumnWidth(1.5),
                    3: const pw.FlexColumnWidth(1.5),
                    4: const pw.FlexColumnWidth(1.7),
                    5: const pw.FlexColumnWidth(1.5),
                  },
                  headerStyle: pw.TextStyle(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                  rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                  // oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  headerAlignments: <int, pw.Alignment>{
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.centerRight,
                    5: pw.Alignment.centerRight,
                  },
                  cellAlignments: <int, pw.Alignment>{
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.centerRight,
                    5: pw.Alignment.centerRight,
                  },
                  data: <List<String>>[
                    <String>[l.S.of(localContext).SL, l.S.of(localContext).productDescription, l.S.of(localContext).warranty, l.S.of(localContext).quantity, l.S.of(localContext).unitPrice, l.S.of(localContext).price],
                    for (int i = 0; i < transactions.productList!.length; i++)
                      <String>[
                        ('${i + 1}'),
                        ("${transactions.productList!.elementAt(i).productName.toString()}\n${transactions.productList!.elementAt(i).serialNumber.isEmpty ? '' : transactions.productList!.elementAt(i).serialNumber.toString()}"),
                        // (transactions.productList!.elementAt(i).productName.toString()),
                        (''),
                        (myFormat.format(double.tryParse(transactions.productList!.elementAt(i).productStock.toString()) ?? 0)),
                        (myFormat.format(double.tryParse(transactions.productList!.elementAt(i).productPurchasePrice.toString()) ?? 0)),
                        (myFormat.format(double.tryParse((double.parse(transactions.productList!.elementAt(i).productPurchasePrice) * double.parse(transactions.productList!.elementAt(i).productStock)).toStringAsFixed(2)) ?? 0))
                      ],
                  ],
                ),
                // pw.SizedBox(width: 5),
                pw.Paragraph(text: ""),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(
                        "${l.S.of(localContext).paymentMethod}: ${transactions.paymentType}",
                        style: const pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 11,
                        ),
                      ),
                      pw.SizedBox(height: 10.0),
                      pw.Container(
                        width: 300,
                        child: pw.Text(
                          "${l.S.of(localContext).inWord}: ${amountToWords(transactions.totalAmount!.toInt())}",
                          maxLines: 3,
                          style: pw.TextStyle(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                        ),
                      )
                    ]),
                    pw.SizedBox(
                      width: 250.0,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Column(children: [
                            ///________Total_Amount_____________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).totalAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(totalPurchaseAmount(transactions: transactions).toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________vat_______________________________________________
                            // pw.Row(children: [
                            //   pw.SizedBox(
                            //     width: 100.0,
                            //     child: pw.Text(
                            //       'Vat',
                            //       style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            //             color: PdfColors.black,
                            //             fontSize: 11,
                            //           ),
                            //     ),
                            //   ),
                            //   pw.Container(
                            //     alignment: pw.Alignment.centerRight,
                            //     width: 150.0,
                            //     child: pw.Text(
                            //       '0',
                            //       style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            //             color: PdfColors.black,
                            //             fontSize: 11,
                            //           ),
                            //     ),
                            //   ),
                            // ]),
                            // pw.SizedBox(height: 2),

                            ///________Service/Shipping__________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).serviceShipping,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  '0',
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________Sub Total Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).subTotal,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(transactions.totalAmount.toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________Discount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).discount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  '- ${myFormat.format(double.tryParse(transactions.discountAmount.toString()) ?? 0)}',
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________payable_Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 150.0,
                                child: pw.Text(
                                  l.S.of(localContext).netPayableAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 100.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(transactions.totalAmount.toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________Received_Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).receivedAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse((transactions.totalAmount! - transactions.dueAmount!).toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________Received_Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).dueAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              // pw.SizedBox(
                              //   width: 10.0,
                              //   child: pw.Text(
                              //     ':',
                              //     style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              //   ),
                              // ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(transactions.dueAmount!.toString())),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );
    if (Platform.isIOS) {
      EasyLoading.show(status: l.S.of(localContext).generatingPDF);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${'${invoiceName}_purchase_${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess(l.S.of(localContext).done);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'${invoiceName}_purchase_${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );
        // OpenFile.open("${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
    }

    if (Platform.isAndroid) {
      EasyLoading.show(status: l.S.of(localContext).generatingPDF);
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      final file = File('${dir.path}/${'${invoiceName}_purchase_${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess(l.S.of(localContext).createdAndSaved);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'${invoiceName}_purchase_${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );
        // OpenFile.open("/storage/emulated/0/download/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
    }
  }

  Future<void> generateSaleDocument(SalesTransitionModel transactions, PersonalInformationModel personalInformation, BuildContext context) async {
    final pw.Document doc = pw.Document();
    double totalAmount({required SalesTransitionModel transactions}) {
      double amount = 0;

      for (var element in transactions.productList!) {
        amount = amount + double.parse(element.subTotal) * double.parse(element.quantity.toString());
      }

      return double.parse(amount.toStringAsFixed(2));
    }

    final localContext = context;

    doc.addPage(
      pw.MultiPage(
        // pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 5),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                ///________Company_Name_________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Center(
                    child: pw.Text(
                      personalInformation.companyName ?? '',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 22.0, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ),

                ///______Phone________________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: pw.EdgeInsets.all(1.0),
                  child: pw.Center(
                    child: pw.Text(
                      '${l.S.of(localContext).phone}:  ${personalInformation.phoneNumber}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                    ),
                  ),
                ),

                ///______Address________________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(1.0),
                  child: pw.Center(
                    child: pw.Text(
                      '${l.S.of(localContext).address}: ${personalInformation.countryName}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                    ),
                  ),
                ),

                ///______Shop_GST________________________________________________________________
                personalInformation.gst.trim().isNotEmpty
                    ? pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.all(1.0),
                        child: pw.Center(
                          child: pw.Text(
                            '${l.S.of(localContext).shopGST}: ${personalInformation.gst}',
                            style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                          ),
                        ),
                      )
                    : pw.Container(),

                ///________Bill/Invoice_________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Center(
                      child: pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black, width: 0.5),
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                          ),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 2.0, bottom: 2, left: 5, right: 5),
                            child: pw.Text(
                              // 'Bill/Invoice',
                              l.S.of(localContext).billInvoice,
                              style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 16.0, fontWeight: pw.FontWeight.bold),
                            ),
                          ))),
                ),

                ///___________price_section_____________________________________________________
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  ///_________Left_Side__________________________________________________________
                  pw.Column(children: [
                    ///_____Name_______________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).customer,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Phone_______________________________________
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          // 'Phone',
                          l.S.of(localContext).phone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerPhone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Address_______________________________________
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).address,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Party GST_______________________________________
                    pw.SizedBox(height: transactions.customerGst.trim().isNotEmpty ? 2 : 0),
                    transactions.customerGst.trim().isNotEmpty
                        ? pw.Row(children: [
                            pw.SizedBox(
                              width: 60.0,
                              child: pw.Text(
                                // 'Party GST',
                                l.S.of(localContext).partyGST,
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                            pw.SizedBox(
                              width: 10.0,
                              child: pw.Text(
                                ':',
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                            pw.SizedBox(
                              width: 140.0,
                              child: pw.Text(
                                transactions.customerGst,
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                          ])
                        : pw.Container(),

                    ///_____Remarks_______________________________________
                    // pw.SizedBox(height: 2),
                    // pw.Row(children: [
                    //   pw.SizedBox(
                    //     width: 60.0,
                    //     child: pw.Text(
                    //       'Remarks',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    //   pw.SizedBox(
                    //     width: 10.0,
                    //     child: pw.Text(
                    //       ':',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    //   pw.SizedBox(
                    //     width: 140.0,
                    //     child: pw.Text(
                    //       '',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    // ]),
                  ]),

                  ///_________Right_Side___________________________________________________________
                  pw.Column(children: [
                    ///______invoice_number_____________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          // 'Invoice',
                          l.S.of(localContext).invoice,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          '#${transactions.invoiceNumber}',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///_________Sells By________________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          // 'Sells By',
                          l.S.of(localContext).sellsBy,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          l.S.of(localContext).admin,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///______Date__________________________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).date,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.Container(
                        width: 125.0,
                        child: pw.Text(
                          '${DateFormat.yMMMd('en_US').format(DateTime.parse(transactions.purchaseDate))}, ${DateFormat.jm('en_US').format(DateTime.parse(transactions.purchaseDate))}',
                          // DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: AmericanDateTimeFormats.),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///______Status____________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).status,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          transactions.isPaid! ? l.S.of(localContext).paid : l.S.of(localContext).due,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 1.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      l.S.of(localContext).signatureOfCustomer,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.black,
                            fontSize: 11,
                          ),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 1.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      l.S.of(localContext).authorizedSignature,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.black,
                            fontSize: 11,
                          ),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              decoration: pw.BoxDecoration(border: pw.Border.all(width: 1, color: PdfColors.black)),
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Column(children: [
                pw.Text('${l.S.of(localContext).shopAddress}: ${personalInformation.countryName}',
                    maxLines: 3,
                    style: const pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 11,
                    )),
              ]),
              // child: pw.Center(child: ),
            ),
            pw.SizedBox(height: 5),
            pw.Text('${l.S.of(localContext).poweredBy} $appName', style: const pw.TextStyle(fontSize: 10, color: PdfColors.black)),
          ]);
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                ///___________Table__________________________________________________________
                pw.Table.fromTextArray(
                  context: context,
                  border: const pw.TableBorder(
                    left: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    right: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    bottom: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    top: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    verticalInside: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    horizontalInside: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                  ),
                  // headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#D5D8DC')),
                  columnWidths: <int, pw.TableColumnWidth>{
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(4.5),
                    2: const pw.FlexColumnWidth(1.5),
                    3: const pw.FlexColumnWidth(1.5),
                    4: const pw.FlexColumnWidth(1.7),
                    5: const pw.FlexColumnWidth(1.5),
                    6: const pw.FlexColumnWidth(1.5),
                  },
                  headerStyle: pw.TextStyle(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                  rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                  // oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  headerAlignments: <int, pw.Alignment>{
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.centerRight,
                    5: pw.Alignment.centerRight,
                    6: pw.Alignment.centerRight,
                  },
                  cellAlignments: <int, pw.Alignment>{
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.centerRight,
                    5: pw.Alignment.centerRight,
                    6: pw.Alignment.centerRight,
                  },
                  data: <List<String>>[
                    <String>[l.S.of(localContext).SL, l.S.of(localContext).productDescription, l.S.of(localContext).warranty, l.S.of(localContext).quantity, l.S.of(localContext).unitPrice, l.S.of(localContext).tax, l.S.of(localContext).price],
                    for (int i = 0; i < transactions.productList!.length; i++) <String>[('${i + 1}'), ("${transactions.productList!.elementAt(i).productName.toString()}\n"), (''), (myFormat.format(double.tryParse(transactions.productList!.elementAt(i).quantity.toString()) ?? 0)), (myFormat.format(double.tryParse(transactions.productList!.elementAt(i).subTotal.toString()) ?? 0)), (calculateProductVat(product: transactions.productList!.elementAt(i))), (myFormat.format(double.tryParse((double.parse(transactions.productList!.elementAt(i).subTotal) * transactions.productList!.elementAt(i).quantity.toInt()).toStringAsFixed(2)) ?? 0))],
                  ],
                ),
                // pw.SizedBox(width: 5),
                pw.Paragraph(text: ""),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(
                        "${l.S.of(localContext).paymentMethod}: ${transactions.paymentType}",
                        style: const pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 11,
                        ),
                      ),
                      pw.SizedBox(height: 10.0),
                      pw.Container(
                        width: 300,
                        child: pw.Text(
                          "${l.S.of(localContext).inWord}: ${amountToWords(transactions.totalAmount!.toInt())}",
                          maxLines: 3,
                          style: pw.TextStyle(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                        ),
                      )
                    ]),
                    pw.SizedBox(
                      width: 250.0,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Column(children: [
                            ///________Total_Amount_____________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).totalAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(totalAmount(transactions: transactions).toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________vat_______________________________________________
                            pw.ListView.builder(
                              itemCount: getAllTaxFromCartList(cart: transactions.productList ?? []).length,
                              itemBuilder: (context, index) {
                                return pw.Row(children: [
                                  pw.SizedBox(
                                    width: 100.0,
                                    child: pw.Text(
                                      getAllTaxFromCartList(cart: transactions.productList ?? [])[index].name,
                                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                            color: PdfColors.black,
                                            fontSize: 11,
                                          ),
                                    ),
                                  ),
                                  pw.Container(
                                    alignment: pw.Alignment.centerRight,
                                    width: 150.0,
                                    child: pw.Text(
                                      '${getAllTaxFromCartList(cart: transactions.productList ?? [])[index].taxRate.toString()}%',
                                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                            color: PdfColors.black,
                                            fontSize: 11,
                                          ),
                                    ),
                                  ),
                                ]);
                              },
                            ),

                            ///________Service/Shipping__________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  // "Service/Shipping",
                                  l.S.of(localContext).serviceShipping,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(transactions.serviceCharge.toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________Sub Total Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).subTotal,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse((transactions.vat!.toDouble() + transactions.serviceCharge!.toDouble() + totalAmount(transactions: transactions)).toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________Discount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).discount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  '- ${myFormat.format(double.tryParse(transactions.discountAmount.toString()) ?? 0)}',
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________payable_Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 150.0,
                                child: pw.Text(
                                  // 'Net Payable Amount',
                                  l.S.of(localContext).netPayableAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 100.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(transactions.totalAmount.toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________Received_Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  // 'Received Amount',
                                  l.S.of(localContext).receivedAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse((transactions.totalAmount! - transactions.dueAmount!).toString())),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________Received_Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).dueAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              // pw.SizedBox(
                              //   width: 10.0,
                              //   child: pw.Text(
                              //     ':',
                              //     style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              //   ),
                              // ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(transactions.dueAmount!.toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );
    if (Platform.isIOS) {
      EasyLoading.show(status: l.S.of(localContext).generatingPDF);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${'${invoiceName}_sale${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess(l.S.of(localContext).done);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'${invoiceName}_sale${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );
        // OpenFile.open("${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
    }

    if (Platform.isAndroid) {
      EasyLoading.show(status: l.S.of(localContext).generatingPDF);
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      final file = File('${dir.path}/${'${invoiceName}_sale_${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess(l.S.of(localContext).createdAndSaved);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'${invoiceName}_Sale_${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );
        // OpenFile.open("/storage/emulated/0/download/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
      // var status = await Permission.storage.status;
      // if (status != PermissionStatus.granted) {
      //   status = await Permission.storage.request();
      // }
      // if (status.isGranted) {
      //
      // }
    }
  }

  Future<void> generateQuotationDocument(SalesTransitionModel transactions, PersonalInformationModel personalInformation, BuildContext context) async {
    final pw.Document doc = pw.Document();
    double totalAmount({required SalesTransitionModel transactions}) {
      double amount = 0;

      for (var element in transactions.productList!) {
        amount = amount + double.parse(element.subTotal) * double.parse(element.quantity.toString());
      }

      return double.parse(amount.toStringAsFixed(2));
    }

    final localContext = context;

    doc.addPage(
      pw.MultiPage(
        // pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 5),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                ///________Company_Name_________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Center(
                    child: pw.Text(
                      personalInformation.companyName ?? '',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 22.0, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ),

                ///______Phone________________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(1.0),
                  child: pw.Center(
                    child: pw.Text(
                      '${l.S.of(localContext).phone}: ${personalInformation.phoneNumber}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                    ),
                  ),
                ),

                ///______Address________________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(1.0),
                  child: pw.Center(
                    child: pw.Text(
                      '${l.S.of(localContext).address}: ${personalInformation.countryName}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                    ),
                  ),
                ),

                ///______Shop_GST________________________________________________________________
                personalInformation.gst.trim().isNotEmpty
                    ? pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.all(1.0),
                        child: pw.Center(
                          child: pw.Text(
                            '${l.S.of(localContext).shopGST}: ${personalInformation.gst}',
                            style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                          ),
                        ),
                      )
                    : pw.Container(),

                ///________Bill/Invoice_________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Center(
                      child: pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black, width: 0.5),
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                          ),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 2.0, bottom: 2, left: 5, right: 5),
                            child: pw.Text(
                              l.S.of(localContext).billInvoice,
                              style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 16.0, fontWeight: pw.FontWeight.bold),
                            ),
                          ))),
                ),

                ///___________price_section_____________________________________________________
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  ///_________Left_Side__________________________________________________________
                  pw.Column(children: [
                    ///_____Name_______________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).customer,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Phone_______________________________________
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).phone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerPhone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Address_______________________________________
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).address,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Party GST_______________________________________
                    pw.SizedBox(height: transactions.customerGst.trim().isNotEmpty ? 2 : 0),
                    transactions.customerGst.trim().isNotEmpty
                        ? pw.Row(children: [
                            pw.SizedBox(
                              width: 60.0,
                              child: pw.Text(
                                l.S.of(localContext).partyGST,
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                            pw.SizedBox(
                              width: 10.0,
                              child: pw.Text(
                                ':',
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                            pw.SizedBox(
                              width: 140.0,
                              child: pw.Text(
                                transactions.customerGst,
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                          ])
                        : pw.Container(),

                    ///_____Remarks_______________________________________
                    // pw.SizedBox(height: 2),
                    // pw.Row(children: [
                    //   pw.SizedBox(
                    //     width: 60.0,
                    //     child: pw.Text(
                    //       'Remarks',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    //   pw.SizedBox(
                    //     width: 10.0,
                    //     child: pw.Text(
                    //       ':',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    //   pw.SizedBox(
                    //     width: 140.0,
                    //     child: pw.Text(
                    //       '',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    // ]),
                  ]),

                  ///_________Right_Side___________________________________________________________
                  pw.Column(children: [
                    ///______invoice_number_____________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).invoice,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          '#${transactions.invoiceNumber}',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///_________Sells By________________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).sellsBy,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          l.S.of(localContext).admin,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///______Date__________________________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).date,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.Container(
                        width: 125.0,
                        child: pw.Text(
                          '${DateFormat.yMMMd('en_US').format(DateTime.parse(transactions.purchaseDate))}, ${DateFormat.jm('en_US').format(DateTime.parse(transactions.purchaseDate))}',
                          // DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: AmericanDateTimeFormats.),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///______Status____________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).status,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          transactions.isPaid! ? l.S.of(localContext).paid : l.S.of(localContext).due,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 1.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      l.S.of(localContext).signatureOfCustomer,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.black,
                            fontSize: 11,
                          ),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 1.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      l.S.of(localContext).authorizedSignature,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.black,
                            fontSize: 11,
                          ),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              decoration: pw.BoxDecoration(border: pw.Border.all(width: 1, color: PdfColors.black)),
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Column(children: [
                pw.Text('${l.S.of(localContext).shopAddress}: ${personalInformation.countryName}',
                    maxLines: 3,
                    style: const pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 11,
                    )),
              ]),
              // child: pw.Center(child: ),
            ),
            pw.SizedBox(height: 5),
            pw.Text('${l.S.of(localContext).poweredBy} $appName', style: const pw.TextStyle(fontSize: 10, color: PdfColors.black)),
          ]);
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                ///___________Table__________________________________________________________
                pw.Table.fromTextArray(
                  context: context,
                  border: const pw.TableBorder(
                    left: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    right: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    bottom: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    top: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    verticalInside: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    horizontalInside: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                  ),
                  // headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#D5D8DC')),
                  columnWidths: <int, pw.TableColumnWidth>{
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(4.5),
                    2: const pw.FlexColumnWidth(1.5),
                    3: const pw.FlexColumnWidth(1.5),
                    4: const pw.FlexColumnWidth(1.7),
                    5: const pw.FlexColumnWidth(1.5),
                    6: const pw.FlexColumnWidth(1.5),
                  },
                  headerStyle: pw.TextStyle(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                  rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                  // oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  headerAlignments: <int, pw.Alignment>{
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.centerRight,
                    5: pw.Alignment.centerRight,
                    6: pw.Alignment.centerRight,
                  },
                  cellAlignments: <int, pw.Alignment>{
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.centerRight,
                    5: pw.Alignment.centerRight,
                    6: pw.Alignment.centerRight,
                  },
                  data: <List<String>>[
                    <String>[l.S.of(localContext).SL, l.S.of(localContext).productDescription, l.S.of(localContext).warranty, l.S.of(localContext).quantity, l.S.of(localContext).unitPrice, l.S.of(localContext).tax, l.S.of(localContext).price],
                    for (int i = 0; i < transactions.productList!.length; i++) <String>[('${i + 1}'), ("${transactions.productList!.elementAt(i).productName.toString()}\n"), (''), (myFormat.format(double.tryParse(transactions.productList!.elementAt(i).quantity.toString()) ?? 0)), (myFormat.format(double.tryParse(transactions.productList!.elementAt(i).subTotal.toString()) ?? 0)), (calculateProductVat(product: transactions.productList!.elementAt(i))), (myFormat.format(double.tryParse((double.parse(transactions.productList!.elementAt(i).subTotal) * transactions.productList!.elementAt(i).quantity.toInt()).toStringAsFixed(2)) ?? 0))],
                  ],
                ),
                // pw.SizedBox(width: 5),
                pw.Paragraph(text: ""),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(
                        "${l.S.of(localContext).paymentMethod}: ${transactions.paymentType}",
                        style: const pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 11,
                        ),
                      ),
                      pw.SizedBox(height: 10.0),
                      pw.Container(
                        width: 300,
                        child: pw.Text(
                          "${l.S.of(localContext).inWord}: ${amountToWords(transactions.totalAmount!.toInt())}",
                          maxLines: 3,
                          style: pw.TextStyle(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                        ),
                      )
                    ]),
                    pw.SizedBox(
                      width: 250.0,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Column(children: [
                            ///________Total_Amount_____________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).totalAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(totalAmount(transactions: transactions).toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________vat_______________________________________________
                            pw.ListView.builder(
                              itemCount: getAllTaxFromCartList(cart: transactions.productList ?? []).length,
                              itemBuilder: (context, index) {
                                return pw.Row(children: [
                                  pw.SizedBox(
                                    width: 100.0,
                                    child: pw.Text(
                                      getAllTaxFromCartList(cart: transactions.productList ?? [])[index].name,
                                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                            color: PdfColors.black,
                                            fontSize: 11,
                                          ),
                                    ),
                                  ),
                                  pw.Container(
                                    alignment: pw.Alignment.centerRight,
                                    width: 150.0,
                                    child: pw.Text(
                                      '${getAllTaxFromCartList(cart: transactions.productList ?? [])[index].taxRate.toString()}%',
                                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                            color: PdfColors.black,
                                            fontSize: 11,
                                          ),
                                    ),
                                  ),
                                ]);
                              },
                            ),

                            ///________Service/Shipping__________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).serviceShipping,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(transactions.serviceCharge.toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________Sub Total Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).subTotal,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse((transactions.vat!.toDouble() + transactions.serviceCharge!.toDouble() + totalAmount(transactions: transactions)).toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________Discount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).discount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  '- ${myFormat.format(double.tryParse(transactions.discountAmount.toString()) ?? 0)}',
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________payable_Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 150.0,
                                child: pw.Text(
                                  l.S.of(localContext).netPayableAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 100.0,
                                child: pw.Text(
                                  myFormat.format(double.tryParse(transactions.totalAmount.toString()) ?? 0),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );
    if (Platform.isIOS) {
      EasyLoading.show(status: l.S.of(localContext).generatingPDF);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${'${invoiceName}_sale${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess(l.S.of(localContext).done);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'${invoiceName}_sale${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );
        // OpenFile.open("${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
    }

    if (Platform.isAndroid) {
      EasyLoading.show(status: l.S.of(localContext).generatingPDF);
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      final file = File('${dir.path}/${'${invoiceName}_sale_${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess(l.S.of(localContext).createdAndSaved);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'${invoiceName}_Sale_${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );
        // OpenFile.open("/storage/emulated/0/download/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
      // var status = await Permission.storage.status;
      // if (status != PermissionStatus.granted) {
      //   status = await Permission.storage.request();
      // }
      // if (status.isGranted) {
      //
      // }
    }
  }

  Future<void> generateDueDocument(DueTransactionModel transactions, PersonalInformationModel personalInformation, BuildContext context) async {
    final pw.Document doc = pw.Document();
    final localContext = context;
    doc.addPage(
      pw.MultiPage(
        // pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 5),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                ///________Company_Name_________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Center(
                    child: pw.Text(
                      personalInformation.companyName ?? '',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 22.0, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ),

                ///______Phone________________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(1.0),
                  child: pw.Center(
                    child: pw.Text(
                      '${l.S.of(localContext).phone}: ${personalInformation.phoneNumber}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                    ),
                  ),
                ),

                ///______Address________________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(1.0),
                  child: pw.Center(
                    child: pw.Text(
                      '${l.S.of(localContext).address}: ${personalInformation.countryName}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                    ),
                  ),
                ),

                ///______Shop_GST________________________________________________________________
                personalInformation.gst.trim().isNotEmpty
                    ? pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.all(1.0),
                        child: pw.Center(
                          child: pw.Text(
                            '${l.S.of(localContext).shopGST}: ${personalInformation.gst}',
                            style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 14.0),
                          ),
                        ),
                      )
                    : pw.Container(),

                ///________Bill/Invoice_________________________________________________________
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Center(
                      child: pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black, width: 0.5),
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                          ),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 2.0, bottom: 2, left: 5, right: 5),
                            child: pw.Text(
                              l.S.of(localContext).billInvoice,
                              style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 16.0, fontWeight: pw.FontWeight.bold),
                            ),
                          ))),
                ),

                ///___________price_section_____________________________________________________
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  ///_________Left_Side__________________________________________________________
                  pw.Column(children: [
                    ///_____Name_______________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).customer,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Phone_______________________________________
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).phone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerPhone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Address_______________________________________
                    pw.SizedBox(height: 2),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 60.0,
                        child: pw.Text(
                          l.S.of(localContext).address,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 140.0,
                        child: pw.Text(
                          transactions.customerAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),

                    ///_____Party GST_______________________________________
                    pw.SizedBox(height: transactions.customerGst.trim().isNotEmpty ? 2 : 0),
                    transactions.customerGst.trim().isNotEmpty
                        ? pw.Row(children: [
                            pw.SizedBox(
                              width: 60.0,
                              child: pw.Text(
                                l.S.of(localContext).partyGST,
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                            pw.SizedBox(
                              width: 10.0,
                              child: pw.Text(
                                ':',
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                            pw.SizedBox(
                              width: 140.0,
                              child: pw.Text(
                                transactions.customerGst,
                                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              ),
                            ),
                          ])
                        : pw.Container(),

                    ///_____Remarks_______________________________________
                    // pw.SizedBox(height: 2),
                    // pw.Row(children: [
                    //   pw.SizedBox(
                    //     width: 60.0,
                    //     child: pw.Text(
                    //       'Remarks',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    //   pw.SizedBox(
                    //     width: 10.0,
                    //     child: pw.Text(
                    //       ':',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    //   pw.SizedBox(
                    //     width: 140.0,
                    //     child: pw.Text(
                    //       '',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    // ]),
                  ]),

                  ///_________Right_Side___________________________________________________________
                  pw.Column(children: [
                    ///______invoice_number_____________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).invoice,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          '#${transactions.invoiceNumber}',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///_________Sells By________________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).sellsBy,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          l.S.of(localContext).admin,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///______Date__________________________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).date,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.Container(
                        width: 125.0,
                        child: pw.Text(
                          '${DateFormat.yMMMd('en_US').format(DateTime.parse(transactions.purchaseDate))}, ${DateFormat.jm('en_US').format(DateTime.parse(transactions.purchaseDate))}',
                          // DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: AmericanDateTimeFormats.),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 2),

                    ///______Status____________________________________________
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 50.0,
                        child: pw.Text(
                          l.S.of(localContext).status,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 125.0,
                        child: pw.Text(
                          transactions.isPaid! ? l.S.of(localContext).paid : l.S.of(localContext).due,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 1.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      l.S.of(localContext).signatureOfCustomer,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.black,
                            fontSize: 11,
                          ),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 1.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      l.S.of(localContext).authorizedSignature,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.black,
                            fontSize: 11,
                          ),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              decoration: pw.BoxDecoration(border: pw.Border.all(width: 1, color: PdfColors.black)),
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Column(children: [
                pw.Text('${l.S.of(localContext).shopAddress}: ${personalInformation.countryName}',
                    maxLines: 3,
                    style: const pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 11,
                    )),
              ]),
              // child: pw.Center(child: ),
            ),
            pw.SizedBox(height: 5),
            pw.Text('${l.S.of(localContext).poweredBy} $appName', style: const pw.TextStyle(fontSize: 10, color: PdfColors.black)),
          ]);
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                ///___________Table__________________________________________________________
                pw.Table.fromTextArray(
                  context: context,
                  border: const pw.TableBorder(
                    left: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    right: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    bottom: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    top: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    verticalInside: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                    horizontalInside: pw.BorderSide(
                      color: PdfColors.grey600,
                    ),
                  ),
                  // headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#D5D8DC')),
                  columnWidths: <int, pw.TableColumnWidth>{
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(6),
                    2: const pw.FlexColumnWidth(2),
                  },
                  headerStyle: pw.TextStyle(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                  rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                  // oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  headerAlignments: <int, pw.Alignment>{
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                  },
                  cellAlignments: <int, pw.Alignment>{
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                  },
                  data: <List<String>>[
                    <String>[l.S.of(localContext).SL, l.S.of(localContext).dueDescription, l.S.of(localContext).dueAmount],
                    <String>[('${1}'), ('Previous Due'), (transactions.totalDue.toString())],
                  ],
                ),
                // pw.SizedBox(width: 5),
                pw.Paragraph(text: ""),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(
                        "${l.S.of(localContext).paymentMethod}: ${transactions.paymentType}",
                        style: const pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 11,
                        ),
                      ),
                      pw.SizedBox(height: 10.0),
                      pw.Container(
                        width: 300,
                        child: pw.Text(
                          "${l.S.of(localContext).paymentMethod}: ${amountToWords(transactions.payDueAmount!.toInt())}",
                          maxLines: 3,
                          style: pw.TextStyle(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                        ),
                      )
                    ]),
                    pw.SizedBox(
                      width: 250.0,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Column(children: [
                            ///________Total_Amount_____________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).totalDue,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  transactions.totalDue.toString(),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________vat_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).vat,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  '0',
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________Service/Shipping__________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).serviceShipping,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  '0',
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________Sub Total Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).subTotal,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  transactions.totalDue.toString(),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________Discount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).discount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  '- 0',
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________payable_Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 150.0,
                                child: pw.Text(
                                  l.S.of(localContext).netPayableAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 100.0,
                                child: pw.Text(
                                  transactions.totalDue.toString(),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///________Received_Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).receivedAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  "${transactions.payDueAmount}",
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),

                            ///_________divider__________________________________________
                            pw.Divider(thickness: .5, height: 0.5, color: PdfColors.black),
                            pw.SizedBox(height: 2),

                            ///________Received_Amount_______________________________________________
                            pw.Row(children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  l.S.of(localContext).dueAmount,
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              // pw.SizedBox(
                              //   width: 10.0,
                              //   child: pw.Text(
                              //     ':',
                              //     style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                              //   ),
                              // ),
                              pw.Container(
                                alignment: pw.Alignment.centerRight,
                                width: 150.0,
                                child: pw.Text(
                                  transactions.dueAmountAfterPay!.toString(),
                                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                                        color: PdfColors.black,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 2),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );
    if (Platform.isIOS) {
      EasyLoading.show(status: l.S.of(localContext).generatingPDF);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${'${invoiceName}_due${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess(l.S.of(localContext).done);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'${invoiceName}_due${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );
        // OpenFile.open("${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
    }

    if (Platform.isAndroid) {
      EasyLoading.show(status: l.S.of(localContext).generatingPDF);
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      final file = File('${dir.path}/${'${invoiceName}_due_${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess(l.S.of(localContext).createdAndSaved);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'${invoiceName}_due_${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );
        // OpenFile.open("/storage/emulated/0/download/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
    }
  }

  Future<void> viewLossProfitPDf(PersonalInformationModel personalInformationModel, List<SalesTransitionModel> saleTransactionModel, fromDate, toDate, saleAmount, profit, loss, BuildContext? context) async {
    final pw.Document doc = pw.Document();
    final localContext = context!;
    double totalAmount({required SalesTransitionModel transactions}) {
      double amount = 0;
      for (var element in transactions.productList!) {
        amount = amount + double.parse(element.subTotal) * double.parse(element.quantity.toString());
      }

      return double.parse(amount.toStringAsFixed(2));
    }

    doc.addPage(
      pw.MultiPage(
        // pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: const pw.EdgeInsets.all(14.0),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              ///________Company_Name_________________________________________________________
              pw.Center(
                child: pw.Text(
                  personalInformationModel.companyName.toString(),
                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  '${l.S.of(localContext).address}: ${personalInformationModel.companyName}, ${l.S.of(localContext).phoneNumber}:${personalInformationModel.phoneNumber}',
                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 11.0),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Container(
                    padding: const pw.EdgeInsets.only(bottom: 2.0),
                    decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black))),
                    child: pw.Text(
                      l.S.of(localContext).lossProfitReport,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 16.0, fontWeight: pw.FontWeight.bold),
                    )),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                  child: pw.Text(
                '${l.S.of(localContext).duration}: ${l.S.of(localContext).from} ${DateFormat.yMd().format(DateTime.parse(fromDate))} to ${DateFormat.yMd().format(DateTime.parse(toDate))}',
                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 11.0),
              ))
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Divider(color: PdfColors.grey600),
            pw.Center(child: pw.Text('${l.S.of(localContext).poweredBy} $appName', style: const pw.TextStyle(fontSize: 10, color: PdfColors.black))),
          ]);
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(
            children: [
              pw.SizedBox(height: 20),

              ///___________Table__________________________________________________________
              pw.Table.fromTextArray(
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                context: context,
                border: const pw.TableBorder(
                  left: pw.BorderSide(
                    color: PdfColors.grey600,
                  ),
                  right: pw.BorderSide(
                    color: PdfColors.grey600,
                  ),
                  bottom: pw.BorderSide(
                    color: PdfColors.grey600,
                  ),
                  top: pw.BorderSide(
                    color: PdfColors.grey600,
                  ),
                  verticalInside: pw.BorderSide(
                    color: PdfColors.grey600,
                  ),
                  horizontalInside: pw.BorderSide(
                    color: PdfColors.grey600,
                  ),
                ),
                // headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#D5D8DC')),
                columnWidths: <int, pw.TableColumnWidth>{
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(5.0),
                  4: const pw.FlexColumnWidth(2.0),
                  5: const pw.FlexColumnWidth(1.7),
                  6: const pw.FlexColumnWidth(1.7),
                },
                headerStyle: pw.TextStyle(color: PdfColors.black, fontSize: 11, fontWeight: pw.FontWeight.bold),
                rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                // oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                headerAlignments: <int, pw.Alignment>{
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.centerLeft,
                  4: pw.Alignment.center,
                  5: pw.Alignment.center,
                  6: pw.Alignment.center,
                },
                cellAlignments: <int, pw.Alignment>{
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.centerLeft,
                  4: pw.Alignment.center,
                  5: pw.Alignment.center,
                  6: pw.Alignment.center,
                },
                data: <List<String>>[
                  <String>['SL', 'Date', 'Invoice', 'Party Name', 'Sale Amount', 'Profit', 'Loss'],
                  for (int i = 0; i < saleTransactionModel.length; i++)
                    <String>[
                      ('${i + 1}'),
                      (DateFormat.yMd().format(DateTime.parse(saleTransactionModel.elementAt(i).purchaseDate))),
                      (saleTransactionModel.elementAt(i).invoiceNumber),
                      (saleTransactionModel.elementAt(i).customerName),
                      (myFormat.format(double.tryParse(saleTransactionModel.elementAt(i).totalAmount.toString()) ?? 0)),
                      (myFormat.format(double.tryParse(saleTransactionModel.elementAt(i).lossProfit!.isNegative ? ' 0' : saleTransactionModel.elementAt(i).lossProfit!.toStringAsFixed(2)) ?? 0)),
                      (myFormat.format(double.tryParse(saleTransactionModel.elementAt(i).lossProfit!.isNegative ? saleTransactionModel.elementAt(i).lossProfit!.toStringAsFixed(2) : ' 0') ?? 0)),
                    ],
                  <String>['', '', '', '${l.S.of(localContext).subTotal}:', (saleAmount.toString()), (profit.toString()), (loss.toString())],
                ],
              ),
            ],
          ),
        ],
      ),
    );
    if (Platform.isIOS) {
      EasyLoading.show(status: l.S.of(localContext).generatingPDF);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${'${invoiceName}_sale${personalInformationModel.companyName}-${saleTransactionModel.first.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess(l.S.of(localContext).done);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'${invoiceName}_sale${personalInformationModel.companyName}'}.pdf'),
          ),
        );
        // OpenFile.open("${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
    }

    if (Platform.isAndroid) {
      EasyLoading.show(status: l.S.of(localContext).generatingPDF);
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      final file = File('${dir.path}/${'Loss_Profit_${personalInformationModel.companyName}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess(l.S.of(localContext).createdAndSaved);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'Loss_Profit_${personalInformationModel.companyName}'}.pdf'),
          ),
        );
        // OpenFile.open("/storage/emulated/0/download/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
      // var status = await Permission.storage.status;
      // if (status != PermissionStatus.granted) {
      //   status = await Permission.storage.request();
      // }
      // if (status.isGranted) {
      //
      // }
    }
  }
} // import 'dart:io';

String amountToWords(int amount) {
  final List<String> units = ['', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
  final List<String> tens = ['', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];
  final List<String> teens = ['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];

  if (amount == 0) {
    return 'zero';
  }

  String words = '';
  if ((amount ~/ 1000) > 0) {
    words += '${amountToWords(amount ~/ 1000)} thousand ';
    amount %= 1000;
  }
  if ((amount ~/ 100) > 0) {
    words += '${units[amount ~/ 100]} hundred ';
    amount %= 100;
  }
  if (amount > 0) {
    if (words.isNotEmpty) {
      words += 'and ';
    }
    if (amount < 10) {
      words += units[amount];
    } else if (amount < 20) {
      words += teens[amount - 10];
    } else {
      words += '${tens[amount ~/ 10]} ${units[amount % 10]}';
    }
  }

  return words.trim();
}
