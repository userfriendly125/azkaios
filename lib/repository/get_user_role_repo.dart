import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../currency.dart';
import '../model/user_role_permission_model.dart';

class UserRoleRepo {
  Future<List<UserRolePermissionModel>> getAllUserRole() async {
    List<UserRolePermissionModel> allUser = [];
    await FirebaseDatabase.instance.ref(constUserId).child('User Role').orderByKey().get().then((value) {
      for (var element in value.children) {
        try {
          var data = UserRolePermissionModel.fromJson(jsonDecode(jsonEncode(element.value)));
          data.userKey = element.key;
          allUser.add(data);
        } catch (e) {
          print(e);
        }
      }
    });
    return allUser;
  }

  Future<List<UserRolePermissionModel>> getAllUserRoleFromAdmin() async {
    List<UserRolePermissionModel> allUser = [];

    await FirebaseDatabase.instance.ref('Admin Panel').child('User Role').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = UserRolePermissionModel.fromJson(jsonDecode(jsonEncode(element.value)));
        data.userKey = element.key;
        allUser.add(data);
      }
    });
    return allUser;
  }
}
