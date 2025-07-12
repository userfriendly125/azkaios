import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/model/transition_model.dart';
import 'package:mobile_pos/pdf/purchase_pdf.dart';
import 'package:mobile_pos/pdf/purchase_return_invoice_pdf.dart';
import 'package:mobile_pos/pdf/sales_pdf.dart';
import 'package:mobile_pos/pdf/sales_return_pdf.dart';

import '../model/due_transaction_model.dart';
import '../model/personal_information_model.dart';
import 'due_pdf.dart';

class GeneratePdfAndPrint {
  Future<void> uploadPdfToFirebase(var pdfData, String fileType, String invoiceNumber) async {
    // Get a reference to the Firebase Storage bucket
    // FirebaseStorage storage = FirebaseStorage.instance;
    // Reference ref = storage.ref().child('$constUserId/$fileType/invoice-$invoiceNumber.pdf');
    // bool result = await InternetConnection().hasInternetAccess;

    // Upload the PDF file
    // if (result) {
    //   try {
    //     print('---------Generate pdf step 4-----------');
    //     UploadTask uploadTask = ref.putData(pdfData, SettableMetadata(contentType: 'application/pdf'));
    //     await uploadTask.whenComplete(() {
    //       print('PDF uploaded successfully!');
    //       print('PDF Path: ${ref.fullPath}');
    //       //Print download url
    //       ref.getDownloadURL().then((value) {
    //         print('PDF Download URL: $value');
    //       });
    //     });
    //   } catch (e) {
    //     print('Error uploading PDF: $e');
    //   }
    // }
  }

  Future<void> uploadSaleInvoice({required PersonalInformationModel personalInformationModel, required SalesTransitionModel saleTransactionModel, bool? fromInventorySale}) async {
    EasyLoading.show(status: 'Generating PDF...', dismissOnTap: true);
    var pdfData = await generateSalePdf(personalInformation: personalInformationModel, transactions: saleTransactionModel);
    await uploadPdfToFirebase(pdfData, 'sale', saleTransactionModel.invoiceNumber);
    EasyLoading.dismiss();
  }

  Future<void> uploadQuotationInvoice({required PersonalInformationModel personalInformationModel, required SalesTransitionModel saleTransactionModel, bool? fromInventorySale}) async {
    EasyLoading.show(status: 'Generating PDF...', dismissOnTap: true);
    var pdfData = await generateQuotationPdf(personalInformation: personalInformationModel, transactions: saleTransactionModel);
    await uploadPdfToFirebase(pdfData, 'quotation', saleTransactionModel.invoiceNumber);
    EasyLoading.dismiss();
  }

  Future<void> uploadSaleReturnInvoice({required PersonalInformationModel personalInformationModel, required SalesTransitionModel saleTransactionModel, bool? fromInventorySale}) async {
    EasyLoading.show(status: 'Generating PDF...', dismissOnTap: true);
    var pdfData = await generateSaleReturnDocument(personalInformation: personalInformationModel, transactions: saleTransactionModel);
    //Convert unint8List to pdf and upload in to firebase storage
    await uploadPdfToFirebase(pdfData, 'salereturn', saleTransactionModel.invoiceNumber);
    EasyLoading.dismiss();
  }

  Future<void> uploadPurchaseInvoice({required PersonalInformationModel personalInformationModel, required PurchaseTransactionModel purchaseTransactionModel, bool? fromInventorySale}) async {
    EasyLoading.show(status: 'Generating PDF...', dismissOnTap: true);
    var pdfData = await generatePurchasePdf(personalInformation: personalInformationModel, transactions: purchaseTransactionModel);
    //Convert unint8List to pdf and upload in to firebase storage
    await uploadPdfToFirebase(pdfData, 'purchase', purchaseTransactionModel.invoiceNumber);
    EasyLoading.dismiss();
  }

  Future<void> uploadPurchaseReturnInvoice({required PersonalInformationModel personalInformationModel, required PurchaseTransactionModel purchaseTransactionModel, bool? fromInventorySale}) async {
    EasyLoading.show(status: 'Generating PDF...', dismissOnTap: true);
    var pdfData = await generatePurchaseReturnDocument(personalInformation: personalInformationModel, transactions: purchaseTransactionModel);
    //Convert unint8List to pdf and upload in to firebase storage
    await uploadPdfToFirebase(pdfData, 'purchasereturn', purchaseTransactionModel.invoiceNumber);
    EasyLoading.dismiss();
  }

  Future<void> uploadDueInvoice({required PersonalInformationModel personalInformationModel, required DueTransactionModel dueTransactionModel, bool? fromInventorySale}) async {
    EasyLoading.show(status: 'Generating PDF...', dismissOnTap: true);
    var pdfData = await generateDuePdf(personalInformation: personalInformationModel, transactions: dueTransactionModel);
    //Convert unint8List to pdf and upload in to firebase storage
    await uploadPdfToFirebase(pdfData, 'due', dueTransactionModel.invoiceNumber);
    EasyLoading.dismiss();
  }
}
