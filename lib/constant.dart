import 'dart:convert';

import 'package:bijoy_helper/bijoy_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:restart_app/restart_app.dart';

import 'Screens/tax report/tax_model.dart';
import 'currency.dart';
import 'model/DailyTransactionModel.dart';
import 'model/add_to_cart_model.dart';

const kMainColor = Color(0xff8424FF);
const kGreyTextColor = Color(0xFF828282);
const kBorderColorTextField = Color(0xFFC2C2C2);
const kBorderColor = Color(0xff7D7D7D);
const kDarkWhite = Color(0xFFF1F7F7);
const kTitleColor = Color(0xFF000000);
const kWhite = Color(0xFFFFFFFF);
const kAlertColor = Color(0xFFFF8C34);
const kPremiumPlanColor = Color(0xFF8752EE);
const kPremiumPlanColor2 = Color(0xFFFF5F00);

///_______Purchase Code_____________________________
String purchaseCode = '040cfa43-cc31-4744-9e8c-65aaa9912b86';
String currentDomain = 'https://api.flutterappacademy.com';

List<String> selectedNumbers = [];

String calculateProductVat({required AddToCartModel product}) {
  if (product.taxType == 'Inclusive') {
    double taxRate = product.groupTaxRate / 100;
    return (((double.tryParse(product.productPurchasePrice.toString()) ?? 0) / (taxRate + 1) * taxRate) * product.quantity) > 0 ? (((double.tryParse(product.productPurchasePrice.toString()) ?? 0) / (taxRate + 1) * taxRate) * product.quantity).toStringAsFixed(2) : '';
  } else {
    return (((product.groupTaxRate * (double.tryParse(product.productPurchasePrice.toString()) ?? 0)) / 100) * product.quantity) > 0 ? (((product.groupTaxRate * (double.tryParse(product.productPurchasePrice.toString()) ?? 0)) / 100) * product.quantity).toStringAsFixed(2) : '';
  }
}

String calculateProductVatPurchase({required ProductModel product}) {
  if (product.taxType == 'Inclusive') {
    double taxRate = product.groupTaxRate / 100;
    return (((double.tryParse(product.productPurchasePrice) ?? 0) / (taxRate + 1) * taxRate) * (double.tryParse(product.productStock) ?? 0)).toStringAsFixed(2);
  } else {
    return (((product.groupTaxRate * (double.tryParse(product.productPurchasePrice) ?? 0)) / 100) * (double.tryParse(product.productStock) ?? 0)).toStringAsFixed(2);
  }
}

bool isVatAdded({required List<AddToCartModel> products}) {
  return products.any((element) => element.groupTaxRate > 0);
}

///________Demo_mode__________________
String appName = 'Azka POS';
String invoiceName = 'azka_pos';
String splashScreenLogo = 'images/logo1.png';
String loginScreenLogo = 'images/sblogo.png';
String pdfFooter = 'pos.azka.in';
bool isDemo = false;
String demoText = 'You Can\'t change anything in demo mode';

void postDailyTransaction({required DailyTransactionModel dailyTransactionModel}) async {
  final DatabaseReference personalInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Personal Information');
  num remainingBalance = 0;
  personalInformationRef.keepSynced(true);

  await personalInformationRef.get().then((value) {
    var data = jsonDecode(jsonEncode(value.value));
    remainingBalance = num.tryParse(data['remainingShopBalance'].toString()) ?? 0;
  });

  if (dailyTransactionModel.type == 'Sale' || dailyTransactionModel.type == 'Due Collection' || dailyTransactionModel.type == 'Income') {
    remainingBalance += dailyTransactionModel.paymentIn;
  } else {
    remainingBalance -= dailyTransactionModel.paymentOut;
  }

  dailyTransactionModel.remainingBalance = remainingBalance;

  ///________post_remaining Balance_on_personal_information___________________________________________________
  personalInformationRef.update({'remainingShopBalance': remainingBalance});

  ///_________dailyTransaction_Posting________________________________________________________________________
  DatabaseReference dailyTransactionRef = FirebaseDatabase.instance.ref("$constUserId/Daily Transaction");
  await dailyTransactionRef.push().set(dailyTransactionModel.toJson());
  dailyTransactionRef.keepSynced(true);
}

Future<String?> getSaleID({required String id}) async {
  String? key;
  await FirebaseDatabase.instance.ref().child('Admin Panel').child('Seller List').orderByKey().get().then((value) async {
    for (var element in value.children) {
      var data = jsonDecode(jsonEncode(element.value));
      if (data['userId'].toString() == id) {
        key = element.key.toString();
      }
    }
  });
  return key;
}

void increaseStock(String productCode, num quantity) async {
  final ref = FirebaseDatabase.instance.ref(constUserId).child('Products');
  ref.keepSynced(true);

  ref.orderByKey().get().then((value) {
    for (var element in value.children) {
      var data = jsonDecode(jsonEncode(element.value));
      if (data['productCode'] == productCode) {
        String? key = element.key;
        num previousStock = num.tryParse(element.child('productStock').value.toString()) ?? 0;
        print(previousStock);
        num remainStock = previousStock + quantity;
        ref.child(key!).update({'productStock': '$remainStock'});
      }
    }
  });
}

void decreaseStock(String productCode, num quantity) async {
  final ref = FirebaseDatabase.instance.ref(constUserId).child('Products');
  ref.keepSynced(true);

  ref.orderByKey().get().then((value) {
    for (var element in value.children) {
      var data = jsonDecode(jsonEncode(element.value));
      if (data['productCode'] == productCode) {
        String? key = element.key;
        num previousStock = num.tryParse(element.child('productStock').value.toString()) ?? 0;
        print(previousStock);
        num remainStock = previousStock - quantity;
        ref.child(key!).update({'productStock': '$remainStock'});
      }
    }
  });
}

void updateFromShopRemainBalance({required num paidAmount, required bool isFromPurchase, required WidgetRef t}) async {
  if (paidAmount > 0) {
    t.watch(profileDetailsProvider).when(
          data: (data) {
            final ref = FirebaseDatabase.instance.ref('$constUserId/Personal Information');
            ref.keepSynced(true);

            ref.update({'remainingShopBalance': isFromPurchase ? (data.remainingShopBalance ?? 0) + paidAmount : (data.remainingShopBalance ?? 0) - paidAmount});
          },
          error: (error, stackTrace) {},
          loading: () {},
        );
  }
}

void getSpecificCustomersDueUpdate({required String phoneNumber, required bool isDuePaid, required num due}) async {
  final ref = FirebaseDatabase.instance.ref(constUserId).child('Customers');
  ref.keepSynced(true);
  String? key;

  ref.orderByKey().get().then((value) {
    for (var element in value.children) {
      var data = jsonDecode(jsonEncode(element.value));
      if (data['phoneNumber'] == phoneNumber) {
        key = element.key;
        num previousDue = element.child('due').value.toString().toInt();

        num totalDue;

        isDuePaid ? totalDue = previousDue + due : totalDue = previousDue - due;
        ref.child(key!).update({'due': '$totalDue'});
      }
    }
  });
}

// Future<void> welcomeEmail({required String email}) async {
//   final smtpServer = SmtpServer(
//     'smtp.stackmail.com',
//     port: 587,
//     username: 'hello@smartbiashara.com',
//     password: 'qwerty7890@',
//   );
//   final message = Message()
//     ..from = const Address('mhello@smartbiashara.com')
//     ..recipients.add(email)
//     ..subject = 'Welcome to SmartBiashara(POS)!'
//     ..html =
//         '<h3>Welcome to SmartBiashara(POS)!</h3><p>Were thrilled to have you join us on your journey to streamline and optimize your business operations.</p><p>Our powerful Point of Sale system is here to simplify transactions and boost your business efficiency.</p><p>Let\'s embark on this smart business adventure together!</p><p>Karibu Sana</p>';
//
//   try {
//     final sendReport = await send(message, smtpServer);
//     print('Message sent: ${sendReport.mail}');
//   } catch (e) {
//     print('Error sending email: $e');
//   }
// }

final kTextStyle = GoogleFonts.manrope(
  color: Colors.white,
);

bool connected = false;
bool isPrintEnable = true;
List<String> paymentsTypeList = ['Cash', 'Mobile Pay'];

const String onesignalAppId = '1549acc6-6958-4c79-bea0-b8fdae3cbdce';

bool isReportShow = false;

//___________currency__________________________

// const String appVersion = '4.4';
const String playStoreUrl = "market://details?id=com.oryxkart.my_app";

const String paypalClientId = 'AdQDpLFbWnRoGi7jOkgge0ueWevmBJCfW338TZEXOlIQBC0Mmwr14EweZRPgPETxGw0XReo_5vRL0fhE';
const String paypalClientSecret = 'ENMZ1-7ftayyLnlSEE3RPJn96V1BWUwxnTvoBc4cV10yzTPyM4ZGUle93kTjz8uzHOCwMDXEMNAUisSK';
const bool sandbox = true;

const kButtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);

Future<String> getUserID() async {
  final prefs = await SharedPreferences.getInstance();
  final String? uid = prefs.getString('userId');
  return uid ?? '';
}

const kInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: kBorderColorTextField),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(1.0),
    borderSide: const BorderSide(color: kBorderColorTextField),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

final List<String> businessCategory = [
  'Bag & Luggage',
  'Books & Stationery',
  'Clothing',
  'Construction & Raw materials',
  'Coffee & Tea',
  'Cosmetic & Jewellery',
  'Computer & Electronic',
  'E-Commerce',
  'Furniture',
  'General Store',
  'Gift, Toys & flowers',
  'Grocery, Fruits & Bakery',
  'Handicraft',
  'Home & Kitchen',
  'Hardware & sanitary',
  'Internet, Dish & TV',
  'Laundry',
  'Manufacturing',
  'Mobile Top up',
  'Motorbike & parts',
  'Mobile & Gadgets',
  'Pharmacy',
  'Poultry & Agro',
  'Pet & Accessories',
  'Rice mill',
  'Super Shop',
  'Sunglasses',
  'Service & Repairing',
  'Sports & Exercise',
  'Shoes',
  'Saloon & Beauty Parlour',
  'Shop Rent & Office Rent',
  'Travel Ticket & Rental',
  'Trading',
  'Thai Aluminium & Glass',
  'Vehicles & Parts',
  'Others',
];

List<String> language = ['English', 'Spanish', 'Hindi', 'Arabic', 'France', 'Bengali', 'Turkish', 'Chinese', 'Japanese', 'Romanian', 'Germany', 'Vietnamese', 'Italian', 'Thai', 'Portuguese', 'Hebrew', 'Polish', 'Hungarian', 'Finland', 'Korean', 'Malay', 'Indonesian', 'Ukrainian', 'Bosnian', 'Greek', 'Dutch', 'Urdu', 'Sinhala', 'Persian', 'Serbian', 'Khmer', 'Lao', 'Russian', 'Kannada', 'Marathi', 'Tamil', 'Afrikaans', 'Czech', 'Swedish', 'Slovak', 'Swahili', 'Albanian', 'Danish', 'Azerbaijani', 'Kazakh', 'Croatian', 'Nepali'];

List<String> baseFlagsCode = ['US', 'ES', 'IN', 'SA', 'FR', 'BD', 'TR', 'CN', 'JP', 'RO', 'DE', 'VN', 'IT', 'TH', 'PT', 'IL', 'PL', 'HU', 'FI', 'KR', 'MY', 'ID', 'UA', 'BA', 'GR', 'NL', 'Pk', 'LK', 'IR', 'RS', 'KH', 'LA', 'RU', 'IN', 'IN', 'IN', 'ZA', 'CZ', 'SE', 'SK', 'TZ', 'AL', 'DK', 'AZ', 'KZ', 'HR', 'NP'];

List<String> productCategory = ['Fashion', 'Electronics', 'Computer', 'Gadgets', 'Watches', 'Cloths'];

List<String> userRole = [
  'Super Admin',
  'Admin',
  'User',
];

List<String> paymentType = [
  'Cheque',
  'Deposit',
  'Cash',
  'Transfer',
  'Sales',
];
List<String> posStats = [
  'Daily',
  'Monthly',
  'Yearly',
];
List<String> saleStats = [
  'Weekly',
  'Monthly',
  'Yearly',
];

bool isRtl = false;

///------------------Language---------------------------------
// List<String> countryList = [
//   'English',
//   'Spanish',
//   'Hindi',
//   'Arabic',
//   'France',
//   'Bengali',
//   'Turkish',
//   'Chinese',
//   'Japanese',
//   'Romanian',
//   'Germany',
//   'Vietnamese',
//   'Italian',
//   'Thai',
//   'Portuguese',
//   'Hebrew',
//   'Polish',
//   'Hungarian',
//   'Finland',
//   'Korean',
//   'Malay',
//   'Indonesian',
//   'Ukrainian',
//   'Bosnian',
//   'Greek',
//   'Dutch',
//   'Urdu',
//   'Sinhala',
//   'Persian',
//   'Serbian',
//   'Khmer',
//   'Lao',
//   'Russian',
//   'Kannada',
//   'Marathi',
//   'Tamil',
//   'Afrikaans',
//   'Czech',
//   'Swedish',
//   'Slovak',
//   'Swahili',
//   'Albanian',
//   'Danish',
//   'Azerbaijani',
//   'Kazakh',
//   'Croatian',
//   'Nepali'
// ];
// String selectedCountry = 'English';

void checkCurrentUserAndRestartApp() {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user?.uid == null) {
    Restart.restartApp();
  }
}

List<TaxModel> getAllTaxFromCartList({required List<AddToCartModel> cart}) {
  List<TaxModel> data = [];
  for (var element in cart) {
    if (element.subTaxes.isNotEmpty) {
      for (var element1 in element.subTaxes) {
        if (!data.any(
          (element2) => element2.name == element1.name,
        )) {
          data.add(element1);
        }
      }
    }
  }
  return data;
}

//_______________________vat_percentage________________________________
String defaultVat = 'vat';
String currentLanguage = 'en';

Map<String, String> languageToFlagCode = {
  'en': 'US',
  'es': 'ES',
  'hi': 'IN',
  'ar': 'SA',
  'fr': 'FR',
  'bn': 'BD',
  'tr': 'TR',
  'zh': 'CN',
  'ja': 'JP',
  'ro': 'RO',
  'de': 'DE',
  'vi': 'VN',
  'it': 'IT',
  'th': 'TH',
  'pt': 'PT',
  'he': 'IL',
  'pl': 'PL',
  'hu': 'HU',
  'fi': 'FI',
  'ko': 'KR',
  'ms': 'MY',
  'id': 'ID',
  'uk': 'UA',
  'bs': 'BA',
  'el': 'GR',
  'nl': 'NL',
  'ur': 'Pk',
  'si': 'LK',
  'fa': 'IR',
  'sr': 'RS',
  'km': 'KH',
  'lo': 'LA',
  'ru': 'RU',
  'af': 'ZA',
  'cs': 'CZ',
  'sv': 'SE',
  'sk': 'SK',
  'sw': 'TZ',
  'sq': 'AL',
  'da': 'DK',
  'az': 'AZ',
  'kk': 'KZ',
  'hr': 'HR',
  'ne': 'NP',
  'hy': 'AM',
  'as': 'AS',
  'be': 'BE',
  'ca': 'CA',
  'cy': 'CY',
  'et': 'ET',
  'eu': 'EU',
  'gl': 'GL',
  'is': 'IS',
  'ky': 'KG',
  'lt': 'LT',
  'lv': 'LV',
  'mk': 'MK',
  'no': 'NO',
  'ps': 'AF',
};

pw.Widget getLocalizedPdfText(String text, pw.TextStyle textStyle) {
  print('Current Language: $currentLanguage, Text: $text');
  return pw.Text(
    currentLanguage == "bn" ? unicodeToBijoy(text) : text,
    style: textStyle,
  );
}
