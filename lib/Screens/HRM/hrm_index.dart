import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/HRM/Designation/designation_list.dart';
import 'package:mobile_pos/Screens/HRM/salaries%20list/salaries_list_screen.dart';
import 'package:mobile_pos/currency.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../generated/l10n.dart' as lang;
import 'employees/employee_list.dart';

class HrmIndex extends StatefulWidget {
  const HrmIndex({super.key});

  @override
  State<HrmIndex> createState() => _HrmIndexState();
}

class _HrmIndexState extends State<HrmIndex> {
  Color color = Colors.black26;
  String searchCustomer = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          "HRM",
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
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (finalUserRoleModel.hrmEdit == false) {
                    toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DesignationListScreen()));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.dashboard_customize_outlined,
                      color: kGreyTextColor,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Designation",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            "Add your employees designation",
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: kGreyTextColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Divider(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (finalUserRoleModel.hrmEdit == false) {
                    toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeeListScreen()));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: kGreyTextColor,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Employees",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            "Add all your employees",
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: kGreyTextColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Divider(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (finalUserRoleModel.hrmEdit == false) {
                    toast(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService);
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SalariesListScreen()));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.money_outlined,
                      color: kGreyTextColor,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Salaries",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            "Keep track of your employees salaries",
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: kGreyTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
