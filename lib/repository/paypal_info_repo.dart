import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_pos/model/paystack_response.dart';

import '../model/paypal_info_model.dart';

class PaypalInfoRepo {
  Future<PaypalInfoModel> getPaypalInfo() async {
    DatabaseReference paypalRef = FirebaseDatabase.instance.ref('Admin Panel/Paypal Info');
    final paypalData = await paypalRef.get();
    PaypalInfoModel paypalInfoModel = PaypalInfoModel.fromJson(jsonDecode(jsonEncode(paypalData.value)));

    return paypalInfoModel;
  }
}

class StripeInfoRepo {
  Future<StripeInfoModel> getStripeInfo() async {
    DatabaseReference stripeRef = FirebaseDatabase.instance.ref('Admin Panel/Stripe Info');
    final stripeData = await stripeRef.get();
    StripeInfoModel stripeInfoModel = StripeInfoModel.fromJson(jsonDecode(jsonEncode(stripeData.value)));

    return stripeInfoModel;
  }
}

class SSLInfoRepo {
  Future<SSLInfoModel> getSSLInfo() async {
    DatabaseReference sslRef = FirebaseDatabase.instance.ref('Admin Panel/SSL Info');
    final sslData = await sslRef.get();
    SSLInfoModel sslInfoModel = SSLInfoModel.fromJson(jsonDecode(jsonEncode(sslData.value)));

    return sslInfoModel;
  }
}

class FlutterWaveInfoRepo {
  Future<FlutterWaveInfoModel> getFlutterWaveInfo() async {
    DatabaseReference flutterWaveRef = FirebaseDatabase.instance.ref('Admin Panel/FlutterWave Info');
    final flutterWaveData = await flutterWaveRef.get();
    FlutterWaveInfoModel flutterWaveInfoModel = FlutterWaveInfoModel.fromJson(jsonDecode(jsonEncode(flutterWaveData.value)));

    return flutterWaveInfoModel;
  }
}

class RazorpayInfoRepo {
  Future<RazorpayInfoModel> getRazorpayInfo() async {
    DatabaseReference razorpayRef = FirebaseDatabase.instance.ref('Admin Panel/Razorpay Info');
    final razorpayData = await razorpayRef.get();
    RazorpayInfoModel razorpayInfoModel = RazorpayInfoModel.fromJson(jsonDecode(jsonEncode(razorpayData.value)));

    return razorpayInfoModel;
  }
}

class TapInfoRepo {
  Future<TapInfoModel> getTapInfo() async {
    DatabaseReference tapRef = FirebaseDatabase.instance.ref('Admin Panel/Tap Info');
    final tapData = await tapRef.get();
    TapInfoModel tapInfoModel = TapInfoModel.fromJson(jsonDecode(jsonEncode(tapData.value)));

    return tapInfoModel;
  }
}

class KkiPayInfoRepo {
  Future<KkiPayInfoModel> getKkiPayInfo() async {
    DatabaseReference kkiPayRef = FirebaseDatabase.instance.ref('Admin Panel/KkiPay Info');
    final kkiPayData = await kkiPayRef.get();
    KkiPayInfoModel kkiPayInfoModel = KkiPayInfoModel.fromJson(jsonDecode(jsonEncode(kkiPayData.value)));

    return kkiPayInfoModel;
  }
}

class PayStackInfoRepo {
  Future<PayStackInfoModel> getPayStackInfo() async {
    DatabaseReference payStackRef = FirebaseDatabase.instance.ref('Admin Panel/PayStack Info');
    final payStackData = await payStackRef.get();
    PayStackInfoModel payStackInfoModel = PayStackInfoModel.fromJson(jsonDecode(jsonEncode(payStackData.value)));

    return payStackInfoModel;
  }

  Future<PaystackResponse> payWithPaystack(String email, String amount, String secret) async {
    String totalAmount = (double.parse(amount) * 100).toStringAsFixed(0);
    var response = await http.post(Uri.parse('https://api.paystack.co/transaction/initialize'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $secret',
        },
        body: json.encode({"email": "customer@email.com", "amount": totalAmount, "callback_url": "https://example.com"}));

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return PaystackResponse.fromJson(data);
    } else {
      throw Exception(data['message']);
    }
  }
}

class BillplzInfoRepo {
  Future<BillPlzInfoModel> getBillplzInfo() async {
    DatabaseReference billPlzRef = FirebaseDatabase.instance.ref('Admin Panel/Billplz Info');
    final billPlzData = await billPlzRef.get();
    BillPlzInfoModel billPlzInfoModel = BillPlzInfoModel.fromJson(jsonDecode(jsonEncode(billPlzData.value)));

    return billPlzInfoModel;
  }
}

class CashFreeInfoRepo {
  Future<CashFreeInfoModel> getCashFreeInfo() async {
    DatabaseReference cashFreeRef = FirebaseDatabase.instance.ref('Admin Panel/CashFree Info');
    final cashFreeData = await cashFreeRef.get();
    CashFreeInfoModel cashFreeInfoModel = CashFreeInfoModel.fromJson(jsonDecode(jsonEncode(cashFreeData.value)));

    return cashFreeInfoModel;
  }
}

class IyzicoInfoRepo {
  Future<IyzicoInfoModel> getIyzicoInfo() async {
    DatabaseReference iyzicoRef = FirebaseDatabase.instance.ref('Admin Panel/Iyzico Info');
    final iyzicoData = await iyzicoRef.get();
    IyzicoInfoModel iyzicoInfoModel = IyzicoInfoModel.fromJson(jsonDecode(jsonEncode(iyzicoData.value)));

    return iyzicoInfoModel;
  }
}
