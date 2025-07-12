import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Screens/HRM/employees/provider/designation_provider.dart';
import 'package:mobile_pos/Screens/HRM/employees/repo/employee_repo.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../GlobalComponents/button_global.dart';
import '../../../constant.dart';
import '../Designation/model/designation_model.dart';
import '../Designation/repo/designation_repo.dart';
import 'model/employee_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  AddEmployeeScreen({super.key, this.isEdit = false, required this.ref, this.employeeModel});

  EmployeeModel? employeeModel;
  bool isEdit = false;
  WidgetRef ref;

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _employmentTypeController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<DesignationModel> designationList = [];
  List<String> employeeType = ["Full Time", "Part Time", "Others"];
  List<String> gender = ["Male", "Female", "Others"];

  String? selectedEmployeeType;
  String? selectedGender;
  String? selectedDesignation;
  num? selectedDesignationId;

  @override
  void initState() {
    super.initState();
    checkCurrentUserAndRestartApp();
    getDesignation();

    if (widget.employeeModel != null) {
      _nameController.text = widget.employeeModel!.name;
      _phoneNumberController.text = widget.employeeModel!.phoneNumber;
      _emailController.text = widget.employeeModel!.email;
      _addressController.text = widget.employeeModel!.address;
      _genderController.text = widget.employeeModel!.gender;
      _employmentTypeController.text = widget.employeeModel!.employmentType;
      _designationController.text = widget.employeeModel!.designation;
      _salaryController.text = widget.employeeModel!.salary.toString();
      _joiningDateController.text = DateFormat('yyyy-MM-dd').format(widget.employeeModel!.joiningDate);
      _birthDateController.text = DateFormat('yyyy-MM-dd').format(widget.employeeModel!.birthDate);
    }
    setTextData();
  }

  setTextData() {
    if (widget.isEdit) {
      selectedEmployeeType = widget.employeeModel!.employmentType;
      selectedGender = widget.employeeModel!.gender;
      selectedDesignation = widget.employeeModel!.designation;
      selectedDesignationId = widget.employeeModel!.designationId;
      selectedDesignation = widget.employeeModel!.designation;
    }
  }

  getDesignation() async {
    designationList = await DesignationRepository().getAllDesignation();
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    _employmentTypeController.dispose();
    _designationController.dispose();
    _salaryController.dispose();
    _joiningDateController.dispose();
    _birthDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          widget.isEdit ? "Update Employee" : "Add Employee",
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
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Full name",
                            hintText: "Enter Employee Name",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.EMAIL,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Email Address",
                            hintText: "Enter Email Address",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.PHONE,
                          controller: _phoneNumberController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Phone is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Phone",
                            hintText: "Enter Phone Number",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.ADDRESS,
                          controller: _addressController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Address is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Address",
                            hintText: "Enter Address",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedGender,
                          items: gender.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedGender = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Gender",
                            hintText: "Select Gender",
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Gender is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedEmployeeType,
                          items: employeeType.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedEmployeeType = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Employment Type",
                            hintText: "Select Employment Type",
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Employment Type is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedDesignation,
                          items: designationList.map((DesignationModel value) {
                            return DropdownMenuItem<String>(
                              value: value.designation,
                              child: Text(value.designation),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedDesignation = newValue;
                              selectedDesignationId = designationList.firstWhere((element) => element.designation == newValue).id;
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Designation",
                            hintText: "Select Designation",
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Designation is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NUMBER,
                          controller: _salaryController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Salary is required";
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
                        child: TextFormField(
                          controller: _joiningDateController,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Joining Date is required";
                            }
                            return null;
                          },
                          onTap: () => _selectDate(context, _joiningDateController),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Joining Date",
                            hintText: "Select Joining Date",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _birthDateController,
                          readOnly: true,
                          onTap: () => _selectDate(context, _birthDateController),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Birth Date is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Birth Date",
                            hintText: "Select Birth Date",
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
                      await EmployeeRepository().updateEmployee(employee: EmployeeModel(id: widget.employeeModel!.id, name: _nameController.text, phoneNumber: _phoneNumberController.text, email: _emailController.text, address: _addressController.text, designation: selectedDesignation!, designationId: selectedDesignationId!, employmentType: selectedEmployeeType!, salary: double.parse(_salaryController.text), gender: selectedGender!, joiningDate: DateFormat('yyyy-MM-dd').parse(_joiningDateController.text), birthDate: DateFormat('yyyy-MM-dd').parse(_birthDateController.text)));
                      widget.ref.refresh(employeeProvider);
                    } else {
                      await EmployeeRepository().addEmployee(employee: EmployeeModel(id: DateTime.now().millisecondsSinceEpoch, name: _nameController.text, phoneNumber: _phoneNumberController.text, email: _emailController.text, address: _addressController.text, designation: selectedDesignation!, designationId: selectedDesignationId!, employmentType: selectedEmployeeType!, salary: double.parse(_salaryController.text), gender: selectedGender!, joiningDate: DateFormat('yyyy-MM-dd').parse(_joiningDateController.text), birthDate: DateFormat('yyyy-MM-dd').parse(_birthDateController.text)));
                      widget.ref.refresh(employeeProvider);
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
