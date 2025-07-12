import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/HRM/employees/provider/designation_provider.dart';
import 'package:mobile_pos/Screens/HRM/employees/repo/employee_repo.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../GlobalComponents/button_global.dart';
import '../../../constant.dart';
import '../../../currency.dart';
import '../../../empty_screen_widget.dart';
import '../../../generated/l10n.dart' as lang;
import 'add_employee.dart';
import 'model/employee_model.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  static const String route = '/HRM/employee_List';

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  String searchItem = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrentUserAndRestartApp();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final employees = ref.watch(employeeProvider);
        return Scaffold(
          backgroundColor: kMainColor,
          appBar: AppBar(
            backgroundColor: kMainColor,
            title: Text(
              "Employees",
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0.0,
            automaticallyImplyLeading: true,
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: ButtonGlobal(
              iconWidget: Icons.add,
              buttontext: "Add Employee",
              iconColor: Colors.white,
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEmployeeScreen(
                              ref: ref,
                              isEdit: false,
                            )));
              },
            ),
          ),
          body: Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: AppTextField(
                      textFieldType: TextFieldType.NAME,
                      onChanged: (value) {
                        setState(() {
                          searchItem = value;
                        });
                      },
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          //labelText: 'Party Name',
                          labelText: "Employees",
                          // hintText: 'Enter Party Name',
                          hintText: "Search Employee",
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search)),
                    ),
                  ),
                  FutureBuilder(
                      future: EmployeeRepository().getAllEmployees(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          var data = snapshot.data as List<EmployeeModel>;
                          return data.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 60),
                                  child: EmptyScreenWidget(),
                                )
                              : ListView.builder(
                                  itemCount: data.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (_, i) {
                                    return Visibility(
                                      visible: data[i].name.toLowerCase().contains(searchItem.toLowerCase()) || searchItem.isEmpty,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: kMainColor,
                                          child: Text(
                                            data[i].name[0].toUpperCase(),
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        title: Text(data[i].name),
                                        subtitle: Text(data[i].designation),
                                        //Add a pop up menu to edit and delete the designation
                                        trailing: PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: "edit",
                                              child: Row(
                                                children: [
                                                  Icon(FeatherIcons.edit),
                                                  const SizedBox(width: 10.0),
                                                  Text("Edit"),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: "delete",
                                              child: Row(
                                                children: [
                                                  Icon(FeatherIcons.trash),
                                                  const SizedBox(width: 10.0),
                                                  Text("Delete"),
                                                ],
                                              ),
                                            ),
                                          ],
                                          onSelected: (value) {
                                            if (value == "edit") {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => AddEmployeeScreen(
                                                            employeeModel: data[i],
                                                            isEdit: true,
                                                            ref: ref,
                                                          )));
                                            } else {
                                              if (finalUserRoleModel.hrmDelete == false) {
                                                toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                                                return;
                                              }
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text("Delete Designation"),
                                                  content: const Text("Are you sure you want to delete this designation?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await EmployeeRepository().deleteEmployee(id: data[i].id);
                                                        ref.refresh(employeeProvider);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Delete"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  });
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
