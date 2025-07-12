import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/HRM/Designation/provider/designation_provider.dart';
import 'package:mobile_pos/Screens/HRM/Designation/repo/designation_repo.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../GlobalComponents/button_global.dart';
import '../../../constant.dart';
import 'model/designation_model.dart';

class AddDesignationScreen extends StatefulWidget {
  AddDesignationScreen({super.key, this.isEdit = false, required this.ref, this.designationModel});

  DesignationModel? designationModel;
  bool isEdit = false;
  WidgetRef ref;

  @override
  State<AddDesignationScreen> createState() => _AddDesignationScreenState();
}

class _AddDesignationScreenState extends State<AddDesignationScreen> {
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkCurrentUserAndRestartApp();

    if (widget.designationModel != null) {
      _designationController.text = widget.designationModel?.designation ?? '';
      _descriptionController.text = widget.designationModel?.designationDescription ?? '';
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _designationController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          widget.isEdit ? "Update Designation" : "Add Designation",
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
                          controller: _designationController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Designation is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Designation",
                            hintText: "Enter Designation",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          controller: _descriptionController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Designation Description is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Description",
                            hintText: "Enter Designation Description",
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
                      await DesignationRepository().updateDesignation(designation: DesignationModel(id: widget.designationModel!.id, designation: _designationController.text, designationDescription: _descriptionController.text));
                      widget.ref.refresh(designationProvider);
                    } else {
                      await DesignationRepository().addDesignation(designation: DesignationModel(id: DateTime.now().millisecondsSinceEpoch, designation: _designationController.text, designationDescription: _descriptionController.text));
                      widget.ref.refresh(designationProvider);
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
