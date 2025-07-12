import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/employee_model.dart';
import '../repo/employee_repo.dart';

EmployeeRepository employeeRepo = EmployeeRepository();
final employeeProvider = FutureProvider<List<EmployeeModel>>((ref) => employeeRepo.getAllEmployees());
