// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import 'Screens/subscription/package_screen.dart';
import 'constant.dart';
import 'currency.dart';
import 'model/subscription_model.dart';
import 'model/subscription_plan_model.dart';

class Subscription {
  static List<SubscriptionPlanModel> subscriptionPlan = [];

  static SubscriptionModel freeSubscriptionModel = SubscriptionModel(
    dueNumber: 0,
    duration: 0,
    partiesNumber: 0,
    products: 0,
    purchaseNumber: 0,
    saleNumber: 0,
    subscriptionDate: DateTime.now().toString(),
    subscriptionName: 'Free',
  );
  static String selectedItem = 'Year';

  static bool isExpiringInFiveDays = false;
  static bool isExpiringInOneDays = false;

  static Future<void> getUserLimitsData({required BuildContext context, required bool wannaShowMsg}) async {
    final prefs = await SharedPreferences.getInstance();

    DatabaseReference ref = FirebaseDatabase.instance.ref('$constUserId/Subscription');
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    selectedItem = SubscriptionModel.fromJson(data).subscriptionName;
    final dataModel = SubscriptionModel.fromJson(data);
    final remainingTime = DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());

    if (wannaShowMsg) {
      if (remainingTime.inHours.abs().isBetween((dataModel.duration * 24) - 24, dataModel.duration * 24)) {
        await prefs.setBool('isFiveDayRemainderShown', false);
        isExpiringInOneDays = true;
        isExpiringInFiveDays = false;
      } else if (remainingTime.inHours.abs().isBetween((dataModel.duration * 24) - 120, dataModel.duration * 24)) {
        isExpiringInFiveDays = true;
        isExpiringInOneDays = false;
      }

      final bool isFiveDayRemainderShown = prefs.getBool('isFiveDayRemainderShown') ?? false;

      if (isExpiringInFiveDays && isFiveDayRemainderShown == false) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      lang.S.of(context).yourPackageWillExpireinDay,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        await prefs.setBool('isFiveDayRemainderShown', true);
                        Navigator.pop(context);
                      },
                      child: Text(
                        lang.S.of(context).cacel,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (isExpiringInOneDays) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        lang.S.of(context).YourPackageWillExpireTodayPleasePurchaseagain,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              const PackageScreen().launch(context);
                            },
                            child: Text(lang.S.of(context).purchase),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              lang.S.of(context).cacel,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  static Future<bool> subscriptionChecker({required String item}) async {
    // Fetch current subscription plan and the corresponding details from the database
    SubscriptionModel userSubscriptionModel = await CurrentSubscriptionPlanRepo().getCurrentSubscriptionPlans();
    SubscriptionPlanModel? originalModel = await CurrentSubscriptionPlanRepo().getSubscriptionPlanByName(userSubscriptionModel.subscriptionName);

    // Return false with error if originalModel is null (safety check)
    if (originalModel == null) {
      EasyLoading.showError('Subscription plan not found');
      return false;
    }

    // Calculate remaining time in days
    Duration remainingTime = DateTime.parse(userSubscriptionModel.subscriptionDate).difference(DateTime.now());
    int remainingDays = remainingTime.inHours.abs() ~/ 24;

    // Handle the case where the subscription has expired
    if (remainingDays > originalModel.duration) {
      if (originalModel.subscriptionPrice == 0) {
        // Create a new free subscription model and update the database
        SubscriptionModel postFreePlan = SubscriptionModel(
          subscriptionName: originalModel.subscriptionName,
          subscriptionDate: DateTime.now().toString(),
          saleNumber: originalModel.saleNumber,
          purchaseNumber: originalModel.purchaseNumber,
          partiesNumber: originalModel.partiesNumber,
          dueNumber: originalModel.dueNumber,
          duration: originalModel.duration,
          products: originalModel.products,
        );

        // Update user's subscription data in Firebase and set the reminder flag
        final DatabaseReference subscriptionRef = FirebaseDatabase.instance.ref().child(await getUserID()).child('Subscription');
        subscriptionRef.keepSynced(true);
        subscriptionRef.set(postFreePlan.toJson());

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFiveDayRemainderShown', true);

        return true; // Free plan reset, subscription continues
      } else {
        EasyLoading.showError('Subscription expired, please renew');
        return false; // Paid plan expired
      }
    }

    // Check subscription item limits
    int? itemCount;
    switch (item) {
      case 'Sales':
        itemCount = userSubscriptionModel.saleNumber;
        break;
      case 'Parties':
        itemCount = userSubscriptionModel.partiesNumber;
        break;
      case 'Purchase':
        itemCount = userSubscriptionModel.purchaseNumber;
        break;
      case 'Product':
        itemCount = userSubscriptionModel.products;
        break;
      case 'Due List':
        itemCount = userSubscriptionModel.dueNumber;
        break;
      default:
        return true;
    }

    // Handle unlimited (-202) or valid remaining numbers
    if (itemCount == -202 || itemCount > 0) {
      return true;
    } else {
      EasyLoading.showError('Limit reached for $item');
      return false;
    }
  }

  static Future<bool> subscriptionEnabledChecker() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('$constUserId/Subscription');
    await ref.keepSynced(true);
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    var dataModel = SubscriptionModel.fromJson(data);
    return dataModel.whatsappMarketingEnabled ?? false;
  }

  // static Future<bool> subscriptionChecker({
  //   required String item,
  // }) async {
  //   final DatabaseReference subscriptionRef = FirebaseDatabase.instance.ref().child(constUserId).child('Subscription');
  //
  //   if (subscriptionName == 'Free') {
  //     if (remainingTime.inHours.abs() > 720) {
  //       await subscriptionRef.set(subscriptionModel.toJson());
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setBool('isFiveDayRemainderShown', true);
  //     } else if (item == 'Sales' && remainingSales <= 0) {
  //       return false;
  //     } else if (item == 'Parties' && remainingParties <= 0) {
  //       return false;
  //     } else if (item == 'Purchase' && remainingPurchase <= 0) {
  //       return false;
  //     } else if (item == 'Products' && remainingProducts <= 0) {
  //       return false;
  //     } else if (item == 'Due List' && remainingDue <= 0) {
  //       return false;
  //     }
  //   } else if (subscriptionName == 'Month') {
  //     if (remainingTime.inHours.abs() > 720) {
  //       await subscriptionRef.set(subscriptionModel.toJson());
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setBool('isFiveDayRemainderShown', true);
  //     } else {
  //       return true;
  //     }
  //   } else if (subscriptionName == 'Year') {
  //     if (remainingTime.inHours.abs() > 8760) {
  //       await subscriptionRef.set(subscriptionModel.toJson());
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setBool('isFiveDayRemainderShown', true);
  //     } else {
  //       return true;
  //     }
  //     EasyLoading.dismiss();
  //   } else if (subscriptionName == 'Lifetime') {
  //     return true;
  //   }
  //   return true;
  // }

  static void decreaseSubscriptionLimits({required String itemType, required BuildContext? context}) async {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Subscription');
    ref.keepSynced(true);
    ref.child(itemType).get().then((value) {
      print(value.value);
      int beforeAction = int.parse(value.value.toString());
      if (beforeAction != -202) {
        int afterAction = beforeAction - 1;
        ref.update({itemType: afterAction});
      }

      context != null ? Subscription.getUserLimitsData(context: context, wannaShowMsg: false) : null;
    });
    // var data = await ref.once();
    // int beforeAction = int.parse(data.snapshot.value.toString());
    // int afterAction = beforeAction - 1;
    // FirebaseDatabase.instance.ref('$userId/Subscription').update({itemType: afterAction});
    // Subscription.getUserLimitsData(context: context, wannaShowMsg: false);
  }
}
