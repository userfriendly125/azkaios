import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:mobile_pos/model/product_model.dart';

import '../constant.dart';
import '../model/add_to_cart_model.dart';

Future<List<int>> productTable({required List<AddToCartModel> productList, required List<ProductModel>? purchaseProduct, required bool isFour}) async {
  List<int> data = [];
  if (purchaseProduct != null) {
    for (var element in purchaseProduct) {
      data += await tableItem(
        items: [
          element.productName ?? '',
          (double.tryParse(element.productPurchasePrice) ?? 0).round().toString(),
          element.productStock,
          "${(double.tryParse(element.productPurchasePrice) ?? 0) * (double.tryParse(element.productStock) ?? 0)}",
        ],
        isFour: true,
      );
    }
  } else {
    for (var element in productList) {
      data += isFour
          ? await tableItem(
              items: [
                element.productName ?? '',
                (double.tryParse(element.subTotal) ?? 0).round().toString(),
                element.quantity.toString(),
                "${double.parse(element.subTotal) * element.quantity.toInt()}",
              ],
              isFour: true,
            )
          : await tableItem(
              items: [
                element.productName ?? '',
                (double.tryParse(element.subTotal) ?? 0).round().toString(),
                element.quantity.toString(),
                calculateProductVat(product: element),
                "${double.parse(element.subTotal) * element.quantity.toInt()}",
              ],
              isFour: false,
            );
    }
  }

  return data;
}

List<String> largeTextSplit({required String text, required int letterCount}) {
  List<String> lines = [];

  int textLength = text.length;
  int numLines = (textLength / letterCount).ceil();

  for (int i = 0; i < numLines; i++) {
    int start = i * letterCount;
    int end = (i + 1) * letterCount;
    if (end > textLength) {
      end = textLength;
    }
    lines.add(text.substring(start, end));
  }

  print(lines);

  return lines;
}

Future<List<int>> tableItem({required List<String> items, required bool isFour}) async {
  CapabilityProfile profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  List<int> data = [];
  List<String> lines = largeTextSplit(text: items.first, letterCount: 10);

  for (var eachLine in lines) {
    if (eachLine == lines.first) {
      items[0] = eachLine;
      data += isFour ? generator.text(generateLine(items: items, spacing: [12, 6, 5, 6])) : generator.text(generateLine(items: items, spacing: [10, 5, 4, 4, 5]));
    } else {
      data += isFour ? generator.text(generateLine(items: [eachLine], spacing: [12, 6, 5, 6])) : generator.text(generateLine(items: [eachLine], spacing: [10, 5, 4, 4, 5]));
    }
  }
  return data;
}

String generateLine({required List<String> items, required List<int> spacing}) {
  if (items.length == 1) {
    return addSpace(text: items.first, count: 32);
  } else {
    return spacing.length == 4 ? '${addSpace(text: items[0], count: spacing[0])} ${addSpace(text: items[1], count: spacing[1])} ${addSpace(text: items[2], count: spacing[2])} ${addSpace(text: items[3], count: spacing[3])}' : '${addSpace(text: items[0], count: spacing[0])} ${addSpace(text: items[1], count: spacing[1])} ${addSpace(text: items[2], count: spacing[2])} ${addSpace(text: items[3], count: spacing[3])} ${addSpace(text: items[4], count: spacing[4])}';
  }
}

String addSpace({required String text, required int count}) {
  final trimmedText = text.trim();
  final neededSpaces = count - trimmedText.length;
  if (neededSpaces.isNegative) {
    return text.substring(0, (trimmedText.length - (neededSpaces.abs())));
  }
  return '$trimmedText${' ' * neededSpaces}';
}
