import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../GlobalComponents/button_global.dart';
import '../../../constant.dart';
import '../../../currency.dart';
import '../../../empty_screen_widget.dart';
import '../../../generated/l10n.dart' as lang;
import 'add_designation.dart';
import 'provider/designation_provider.dart';
import 'repo/designation_repo.dart';

class DesignationListScreen extends StatefulWidget {
  const DesignationListScreen({super.key});

  @override
  State<DesignationListScreen> createState() => _DesignationListScreenState();
}

class _DesignationListScreenState extends State<DesignationListScreen> {
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
        final designations = ref.watch(designationProvider);
        return Scaffold(
          backgroundColor: kMainColor,
          appBar: AppBar(
            backgroundColor: kMainColor,
            title: Text(
              "Designation",
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
              buttontext: "Add Designation",
              iconColor: Colors.white,
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddDesignationScreen(
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
              child: designations.when(data: (data) {
                return data.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: EmptyScreenWidget(),
                      )
                    : Column(
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
                                  labelText: "Designation",
                                  // hintText: 'Enter Party Name',
                                  hintText: "Search Designation",
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.search)),
                            ),
                          ),
                          ListView.builder(
                              itemCount: data.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, i) {
                                return Visibility(
                                  visible: data[i].designation.toLowerCase().contains(searchItem.toLowerCase()) || searchItem.isEmpty,
                                  child: ListTile(
                                    title: Text(data[i].designation),
                                    subtitle: Text(data[i].designationDescription),
                                    //Add a pop up menu to edit and delete the designation
                                    trailing: PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(FeatherIcons.edit),
                                              const SizedBox(width: 10.0),
                                              Text("Edit"),
                                            ],
                                          ),
                                          value: "edit",
                                        ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(FeatherIcons.trash),
                                              const SizedBox(width: 10.0),
                                              Text("Delete"),
                                            ],
                                          ),
                                          value: "delete",
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == "edit") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AddDesignationScreen(
                                                        designationModel: data[i],
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
                                                    await DesignationRepository().deleteDesignation(id: data[i].id);
                                                    ref.refresh(designationProvider);
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
                              })
                        ],
                      );
              }, error: (e, stack) {
                return Text(e.toString());
              }, loading: () {
                return CircularProgressIndicator();
              }),
            ),
          ),
        );
      },
    );
  }
}
