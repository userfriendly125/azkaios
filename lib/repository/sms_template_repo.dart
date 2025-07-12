import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../currency.dart';
import '../model/whatsapp_marketing_sms_template_model.dart';

class SmsTemplateRepo {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<WhatsappMarketingSmsTemplateModel> getAllTemplate() async {
    final model = await ref.child('$constUserId/Whatsapp Marketing Template').get();
    var data = jsonDecode(jsonEncode(model.value));
    if (data == null) {
      return WhatsappMarketingSmsTemplateModel(
        saleTemplate: 'Loading...',
        purchaseTemplate: 'Loading...',
        paymentTemplate: 'Loading...',
        dueTemplate: 'Loading...',
        saleReturnTemplate: 'Loading...',
        purchaseReturnTemplate: 'Loading...',
        quotationTemplate: 'Loading...',
      );
    } else {
      return WhatsappMarketingSmsTemplateModel.fromJson(data);
    }
  }

  Future<void> updateTemplate(WhatsappMarketingSmsTemplateModel model) async {
    await ref.child('$constUserId/Whatsapp Marketing Template').set(model.toJson());
  }
}
