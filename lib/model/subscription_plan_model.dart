import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/model/subscription_model.dart';

import '../constant.dart';

class SubscriptionPlanModel {
  SubscriptionPlanModel({
    required this.subscriptionName,
    required this.saleNumber,
    required this.purchaseNumber,
    required this.partiesNumber,
    required this.dueNumber,
    required this.duration,
    required this.products,
    required this.subscriptionPrice,
    required this.offerPrice,
  });

  String subscriptionName;
  int saleNumber, purchaseNumber, partiesNumber, dueNumber, duration, products;
  int subscriptionPrice, offerPrice;

  SubscriptionPlanModel.fromJson(Map<dynamic, dynamic> json)
      : subscriptionName = json['subscriptionName'] as String,
        saleNumber = json['saleNumber'],
        purchaseNumber = json['purchaseNumber'],
        partiesNumber = json['partiesNumber'],
        subscriptionPrice = json['subscriptionPrice'],
        dueNumber = json['dueNumber'],
        duration = json['duration'],
        products = json['products'],
        offerPrice = json['offerPrice'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'subscriptionName': subscriptionName,
        'subscriptionPrice': subscriptionPrice,
        'saleNumber': saleNumber,
        'purchaseNumber': purchaseNumber,
        'partiesNumber': partiesNumber,
        'dueNumber': dueNumber,
        'duration': duration,
        'products': products,
        'offerPrice': offerPrice,
      };
}

class CurrentSubscriptionPlanRepo {
  Future<SubscriptionPlanModel?> getSubscriptionPlanByName(String planName) async {
    SubscriptionPlanModel? specificPlan;
    final ref = FirebaseDatabase.instance.ref().child('Admin Panel').child('Subscription Plan');
    ref.keepSynced(true);

    await FirebaseDatabase.instance.ref().child('Admin Panel').child('Subscription Plan').get().then((value) {
      for (var element in value.children) {
        if (jsonDecode(jsonEncode(element.value))['subscriptionName'] == planName) {
          specificPlan = SubscriptionPlanModel.fromJson(jsonDecode(jsonEncode(element.value)));
        }
      }
    });

    return specificPlan;
  }

  Future<SubscriptionModel> getCurrentSubscriptionPlans() async {
    SubscriptionModel finalModel = SubscriptionModel(
      subscriptionName: '',
      subscriptionDate: '',
      saleNumber: 0,
      purchaseNumber: 0,
      partiesNumber: 0,
      dueNumber: 0,
      duration: 0,
      products: 0,
    );
    final ref = FirebaseDatabase.instance.ref('${await getUserID()}/Subscription');
    ref.keepSynced(true);

    await ref.get().then((value) {
      var data = jsonDecode(jsonEncode(value.value));
      finalModel = SubscriptionModel.fromJson(data);
    });
    return finalModel;
  }
}
