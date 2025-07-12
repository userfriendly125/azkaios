import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as IMG;
import 'package:image/image.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../constant.dart';
import '../model/print_transaction_model.dart';

final printerDueProviderNotifier = ChangeNotifierProvider((ref) => PrinterDue());

class PrinterDue extends ChangeNotifier {
  List<BluetoothInfo> availableBluetoothDevices = [];

  Future<void> getBluetooth() async {
    final List<BluetoothInfo> bluetooths = await PrintBluetoothThermal.pairedBluetooths;
    availableBluetoothDevices = bluetooths;
    notifyListeners();
  }

  Future<bool> setConnect(String mac) async {
    bool status = false;
    final bool? result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    if (result == true) {
      connected = true;
      status = true;
    }
    notifyListeners();
    return status;
  }

  Future<bool> printTicket({required PrintDueTransactionModel printDueTransactionModel}) async {
    bool isPrinted = false;
    bool? isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected == true) {
      List<int> bytes = await getTicket(printDueTransactionModel: printDueTransactionModel);
      await PrintBluetoothThermal.writeBytes(bytes);

      isPrinted = true;
    } else {
      isPrinted = false;
    }
    notifyListeners();
    return isPrinted;
  }

  Future<List<int>> getTicket({required PrintDueTransactionModel printDueTransactionModel}) async {
    List<int> bytes = [];
    http.Response response = await http.get(
      Uri.parse(printDueTransactionModel.personalInformationModel.pictureUrl ?? ''),
    );
    response.bodyBytes;
    final decodedImage = IMG.decodeImage(response.bodyBytes);
    final resizedImage = IMG.copyResize(decodedImage!, width: 120, height: 120); //Uint8List
    final encodedImage = IMG.encodeJpg(resizedImage);
    Uint8List byteList = Uint8List.fromList(encodedImage);

    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final Uint8List imageBytes = byteList;
    bytes += generator.image(decodeImage(imageBytes)!);
    bytes += generator.text(printDueTransactionModel.personalInformationModel.companyName ?? '',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text(printDueTransactionModel.personalInformationModel.countryName ?? '', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: ${printDueTransactionModel.personalInformationModel.phoneNumber ?? ''}', styles: const PosStyles(align: PosAlign.center), linesAfter: printDueTransactionModel.personalInformationModel.gst.trim().isNotEmpty ? 0 : 1);
    printDueTransactionModel.personalInformationModel.gst.trim().isNotEmpty ? bytes += generator.text('Shop GST: ${printDueTransactionModel.personalInformationModel.gst ?? ''}', styles: const PosStyles(align: PosAlign.center), linesAfter: 1) : null;
    bytes += generator.text('Received From: ${printDueTransactionModel.dueTransactionModel!.customerName} ', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('mobile: ${printDueTransactionModel.dueTransactionModel!.customerPhone}', styles: const PosStyles(align: PosAlign.left));
    (printDueTransactionModel.dueTransactionModel?.customerGst.trim().isNotEmpty ?? false) ? bytes += generator.text('Party GST: ${printDueTransactionModel.dueTransactionModel?.customerGst ?? 'Not Provided'}', styles: const PosStyles(align: PosAlign.left)) : null;
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'Invoice', width: 8, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Due', width: 4, styles: const PosStyles(align: PosAlign.center, bold: true)),
    ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: printDueTransactionModel.dueTransactionModel!.invoiceNumber,
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printDueTransactionModel.dueTransactionModel!.totalDue.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
    ]);

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'Payment Type:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printDueTransactionModel.dueTransactionModel!.paymentType.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Payment Amount:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printDueTransactionModel.dueTransactionModel!.payDueAmount.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Remaining Due:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printDueTransactionModel.dueTransactionModel!.dueAmountAfterPay.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!', styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text(printDueTransactionModel.dueTransactionModel!.purchaseDate, styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    // bytes += generator.qrcode('https://posbharat.com', size: QRSize.Size4);
    bytes += generator.text('Developed By: $invoiceName', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.cut();
    return bytes;
  }
}
