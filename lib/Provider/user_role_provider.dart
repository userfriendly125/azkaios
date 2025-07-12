import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/user_role_permission_model.dart';
import 'package:mobile_pos/repository/get_user_role_repo.dart';

UserRoleRepo repo = UserRoleRepo();
final userRoleProvider = FutureProvider.autoDispose<List<UserRolePermissionModel>>((ref) => repo.getAllUserRole());
final allUserRoleProvider = FutureProvider.autoDispose<List<UserRolePermissionModel>>((ref) => repo.getAllUserRoleFromAdmin());
