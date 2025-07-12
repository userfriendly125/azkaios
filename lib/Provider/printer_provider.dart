import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as IMG;
import 'package:image/image.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../WAVE PRINTER/wave_printer_functions.dart';
import '../constant.dart';
import '../model/add_to_cart_model.dart';
import '../model/print_transaction_model.dart';

final printerProviderNotifier = ChangeNotifierProvider((ref) => Printer());

class Printer extends ChangeNotifier {
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

  Future<bool> printTicket({required PrintTransactionModel printTransactionModel, required List<AddToCartModel>? productList}) async {
    bool isPrinted = false;
    bool? isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected == true) {
      List<int> bytes = await getTicket(printTransactionModel: printTransactionModel, productList: productList);
      if (productList!.isNotEmpty) {
        await PrintBluetoothThermal.writeBytes(bytes);
      } else {
        toast('No Product Found');
      }

      isPrinted = true;
    } else {
      isPrinted = false;
    }
    notifyListeners();
    return isPrinted;
  }

  Future<List<int>> getTicket({required PrintTransactionModel printTransactionModel, required List<AddToCartModel>? productList}) async {
    bool isVatAddedBool = isVatAdded(products: productList ?? []);
    List<int> bytes = [];
    http.Response response = await http.get(
      Uri.parse(printTransactionModel.personalInformationModel.pictureUrl ?? ''),
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
    bytes += generator.text(printTransactionModel.personalInformationModel.companyName ?? '',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text(printTransactionModel.personalInformationModel.countryName ?? '', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: ${printTransactionModel.personalInformationModel.phoneNumber ?? ''}', styles: const PosStyles(align: PosAlign.center), linesAfter: printTransactionModel.personalInformationModel.gst.trim().isNotEmpty ? 0 : 1);
    printTransactionModel.personalInformationModel.gst.trim().isNotEmpty ? bytes += generator.text('Shop GST: ${printTransactionModel.personalInformationModel.gst ?? ''}', styles: const PosStyles(align: PosAlign.center), linesAfter: 1) : null;
    bytes += generator.text('Name: ${printTransactionModel.transitionModel?.customerName ?? 'Guest'}', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('mobile: ${printTransactionModel.transitionModel?.customerPhone ?? 'Not Provided'}', styles: const PosStyles(align: PosAlign.left));
    (printTransactionModel.transitionModel?.customerGst.trim().isNotEmpty ?? false) ? bytes += generator.text('Party GST: ${printTransactionModel.transitionModel?.customerGst ?? 'Not Provided'}', styles: const PosStyles(align: PosAlign.left)) : null;
    bytes += generator.text('Sales By: ${printTransactionModel.transitionModel?.sellerName ?? 'Admin'}', styles: const PosStyles(align: PosAlign.left), linesAfter: 1);

    isVatAddedBool ? bytes += generator.text('Items      Rate  Qty  Tax  Total', styles: const PosStyles(bold: true)) : bytes += generator.text('Items        Rate   Qty    Total', styles: const PosStyles(bold: true));
    bytes += generator.hr();

    isVatAddedBool ? bytes += await productTable(productList: productList ?? [], purchaseProduct: null, isFour: false) : bytes += await productTable(productList: productList ?? [], purchaseProduct: null, isFour: true);
    bytes += generator.hr();

    ///________vat_______________________________________________
    List.generate(getAllTaxFromCartList(cart: productList ?? []).length, (index) {
      return bytes += generator.row([
        PosColumn(
            text: getAllTaxFromCartList(cart: productList ?? [])[index].name,
            width: 8,
            styles: const PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: '${getAllTaxFromCartList(cart: productList ?? [])[index].taxRate.toString()}%',
            width: 4,
            styles: const PosStyles(
              align: PosAlign.right,
            )),
      ]);
    });
    bytes += generator.row([
      PosColumn(
          text: 'Subtotal',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: '${printTransactionModel.transitionModel!.totalAmount!.toDouble() + printTransactionModel.transitionModel!.discountAmount!.toDouble()}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);

    bytes += generator.row([
      PosColumn(
          text: 'Discount',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.transitionModel?.discountAmount.toString() ?? '',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'TOTAL', width: 8, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: printTransactionModel.transitionModel?.totalAmount.toString() ?? '', width: 4, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    // bytes += generator.hr(ch: '=', linesAfter: 1);
    // bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'Payment Type:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.transitionModel?.paymentType ?? 'Cash',
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
          text: '${printTransactionModel.transitionModel!.totalAmount!.toDouble() - printTransactionModel.transitionModel!.dueAmount!.toDouble()}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    (printTransactionModel.transitionModel?.customerType != 'Guest')
        ? bytes += generator.row([
            PosColumn(
                text: 'Return amount:',
                width: 8,
                styles: const PosStyles(
                  align: PosAlign.left,
                )),
            PosColumn(
                text: printTransactionModel.transitionModel!.returnAmount.toString(),
                width: 4,
                styles: const PosStyles(
                  align: PosAlign.right,
                )),
          ])
        : null;
    (printTransactionModel.transitionModel?.customerType != 'Guest')
        ? bytes += generator.row([
            PosColumn(
                text: 'Due Amount:',
                width: 8,
                styles: const PosStyles(
                  align: PosAlign.left,
                )),
            PosColumn(
                text: printTransactionModel.transitionModel!.dueAmount.toString(),
                width: 4,
                styles: const PosStyles(
                  align: PosAlign.right,
                )),
          ])
        : null;
    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!', styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text(printTransactionModel.transitionModel!.purchaseDate, styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text('Note: Goods once sold will not be taken back or exchanged.', styles: const PosStyles(align: PosAlign.center, bold: false), linesAfter: 1);
    // bytes += generator.qrcode('https://posbharat.com', size: QRSize.Size4);
    bytes += generator.text('Developed By: $invoiceName', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.cut();
    return bytes;
  }
}
