import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/HRM/employees/repo/employee_repo.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../GlobalComponents/button_global.dart';
import '../../../constant.dart';
import '../employees/model/employee_model.dart';
import '../salaries%20list/provider/salary_provider.dart';
import '../salaries%20list/repo/salary_repo.dart';
import 'model/pay_salary_model.dart';

class PaySalaryScreen extends StatefulWidget {
  PaySalaryScreen({
    super.key,
    this.payedSalary,
    this.isEdit = false,
    required this.ref,
  });

  bool isEdit;
  PaySalaryModel? payedSalary;
  final WidgetRef ref;

  @override
  State<PaySalaryScreen> createState() => _PaySalaryScreenState();
}

class _PaySalaryScreenState extends State<PaySalaryScreen> {
  List<String> yearList = List.generate(111, (index) => (1990 + index).toString());
  List<String> paymentItem = ['Cash', 'Bank', 'Mobile Pay'];
  String? selectedPaymentOption = 'Cash';
  List<EmployeeModel> employeeList = [];

  List<String> monthList = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  final TextEditingController paySalaryController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedYear = DateTime.now().year.toString();
  String? selectedMonth;
  EmployeeModel? selectedEmployee;

  @override
  void initState() {
    super.initState();
    checkCurrentUserAndRestartApp();

    getEmployeeList();
    setEmployee();
  }

  setEmployee() {
    if (widget.isEdit) {
      paySalaryController.text = widget.payedSalary?.paySalary.toString() ?? '';
      notesController.text = widget.payedSalary?.note ?? '';

      for (var element in employeeList) {
        if (element.id == widget.payedSalary?.employmentId) {
          setState(() {
            selectedEmployee = element;
            selectedMonth = widget.payedSalary?.month;
            selectedYear = widget.payedSalary?.year;
            selectedPaymentOption = widget.payedSalary?.paymentType;
          });
          return;
        }
      }
    } else {
      setState(() {
        selectedYear = DateTime.now().year.toString();
        selectedPaymentOption = widget.payedSalary?.paymentType;
        selectedMonth = monthList[DateTime.now().month - 1];
      });
    }
  }

  Future<void> getEmployeeList() async {
    var employees = await EmployeeRepository().getAllEmployees();
    setState(() {
      employeeList = employees;
    });
  }

  @override
  void dispose() {
    paySalaryController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          widget.isEdit ? "Update Salary" : "Pay Salary",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedEmployee?.name,
                          items: employeeList.map((EmployeeModel value) {
                            return DropdownMenuItem<String>(
                              value: value.name,
                              child: Text(value.name),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedEmployee = employeeList.firstWhere((element) => element.name == newValue);
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Employee",
                            hintText: "Select Employee",
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Employee selection is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NUMBER,
                          controller: paySalaryController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Salary amount is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Salary",
                            hintText: "Enter Salary",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedYear,
                          items: yearList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedYear = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Year",
                            hintText: "Select Year",
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Year selection is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedMonth,
                          items: monthList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedMonth = newValue ?? 'January';
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Month",
                            hintText: "Select Month",
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Month selection is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedPaymentOption,
                          items: paymentItem.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedPaymentOption = newValue ?? 'Cash';
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Payment Type",
                            hintText: "Select payment type",
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Payment type is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          controller: notesController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Note is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Note",
                            hintText: "Enter Note",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  )),
              ButtonGlobal(
                iconWidget: Icons.add,
                buttontext: widget.isEdit ? "Update" : "Save",
                iconColor: Colors.white,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                    if (widget.isEdit) {
                      await SalaryRepository().updateSalary(salary: PaySalaryModel(id: widget.payedSalary!.id, employmentId: selectedEmployee!.id, paySalary: double.parse(paySalaryController.text), month: selectedMonth ?? 'January', year: selectedYear!, paymentType: selectedPaymentOption!, note: notesController.text, employeeName: selectedEmployee!.name, designationId: selectedEmployee!.designationId, designation: selectedEmployee!.designation, netSalary: selectedEmployee!.salary, payingDate: DateTime.now()));
                      widget.ref.refresh(salaryProvider);
                    } else {
                      await SalaryRepository().paySalary(salary: PaySalaryModel(id: DateTime.now().millisecondsSinceEpoch, employmentId: selectedEmployee!.id, paySalary: double.parse(paySalaryController.text), month: selectedMonth ?? 'January', year: selectedYear!, paymentType: selectedPaymentOption!, note: notesController.text, employeeName: selectedEmployee!.name, designationId: selectedEmployee!.designationId, designation: selectedEmployee!.designation, netSalary: selectedEmployee!.salary, payingDate: DateTime.now()));
                      widget.ref.refresh(salaryProvider);
                    }
                    EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
