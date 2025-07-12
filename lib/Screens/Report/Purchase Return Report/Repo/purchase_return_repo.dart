import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../../../../constant.dart';
import '../../../../model/transition_model.dart';

class PurchaseReturnRepo {
  Future<List<PurchaseTransactionModel>> getAllTransition() async {
    List<PurchaseTransactionModel> transitionList = [];
    await FirebaseDatabase.instance.ref(await getUserID()).child('Purchase Return').orderByKey().get().then((value) {
      for (var element in value.children) {
        transitionList.add(PurchaseTransactionModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return transitionList;
  }
}
