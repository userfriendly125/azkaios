import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/login_form.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/user_role_provider.dart';
import '../../currency.dart';
import '../../model/user_role_permission_model.dart';
import '../../repository/get_user_role_repo.dart';

class AddUserRole extends StatefulWidget {
  AddUserRole({super.key, this.userRoleModel});

  UserRolePermissionModel? userRoleModel;

  @override
  // ignore: library_private_types_in_public_api
  _AddUserRoleState createState() => _AddUserRoleState();
}

class _AddUserRoleState extends State<AddUserRole> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool allPermissions = false;
  bool salePermission = false;
  bool partiesPermission = false;
  bool purchasePermission = false;
  bool productPermission = false;
  bool profileEditPermission = false;
  bool addExpensePermission = false;
  bool lossProfitPermission = false;
  bool dueListPermission = false;
  bool stockPermission = false;
  bool reportsPermission = false;
  bool salesListPermission = false;
  bool purchaseListPermission = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  List<Permission> permissions = [
    Permission(title: 'Sale'),
    Permission(title: 'Parties'),
    Permission(title: 'Purchase'),
    Permission(title: 'Product'),
    Permission(title: 'Profile Edit'),
    Permission(title: 'Add Expense'),
    Permission(title: 'Loss Profit'),
    Permission(title: 'Due List'),
    Permission(title: 'Stock'),
    Permission(title: 'Reports'),
    Permission(title: 'Sales List'),
    Permission(title: 'Purchase List'),
    Permission(title: 'HRM'),
    Permission(title: 'Quotation'),
  ];

  @override
  void initState() {
    if (widget.userRoleModel != null) {
      setEditData();
    }

    super.initState();
  }

  setEditData() {
    emailController.text = widget.userRoleModel!.email!;
    titleController.text = widget.userRoleModel!.userTitle!;
    for (var data in permissions) {
      if (data.title == 'Sale') {
        data.view = widget.userRoleModel!.saleView!;
        data.edit = widget.userRoleModel!.saleEdit!;
        data.delete = widget.userRoleModel!.saleDelete!;
      } else if (data.title == 'Parties') {
        data.view = widget.userRoleModel!.partiesView!;
        data.edit = widget.userRoleModel!.partiesEdit!;
        data.delete = widget.userRoleModel!.partiesDelete!;
      } else if (data.title == 'Purchase') {
        data.view = widget.userRoleModel!.purchaseView!;
        data.edit = widget.userRoleModel!.purchaseEdit!;
        data.delete = widget.userRoleModel!.purchaseDelete!;
      } else if (data.title == 'Product') {
        data.view = widget.userRoleModel!.productView!;
        data.edit = widget.userRoleModel!.productEdit!;
        data.delete = widget.userRoleModel!.productDelete!;
      } else if (data.title == 'Profile Edit') {
        data.view = widget.userRoleModel!.profileEditView!;
        data.edit = widget.userRoleModel!.profileEditEdit!;
        data.delete = widget.userRoleModel!.profileEditDelete!;
      } else if (data.title == 'Add Expense') {
        data.view = widget.userRoleModel!.addExpenseView!;
        data.edit = widget.userRoleModel!.addExpenseEdit!;
        data.delete = widget.userRoleModel!.addExpenseDelete!;
      } else if (data.title == 'Loss Profit') {
        data.view = widget.userRoleModel!.lossProfitView!;
        data.edit = widget.userRoleModel!.lossProfitEdit!;
        data.delete = widget.userRoleModel!.lossProfitDelete!;
      } else if (data.title == 'Due List') {
        data.view = widget.userRoleModel!.dueListView!;
        data.edit = widget.userRoleModel!.dueListEdit!;
        data.delete = widget.userRoleModel!.dueListDelete!;
      } else if (data.title == 'Stock') {
        data.view = widget.userRoleModel!.stockView!;
        data.edit = widget.userRoleModel!.stockEdit!;
        data.delete = widget.userRoleModel!.stockDelete!;
      } else if (data.title == 'Reports') {
        data.view = widget.userRoleModel!.reportsView!;
        data.edit = widget.userRoleModel!.reportsEdit!;
        data.delete = widget.userRoleModel!.reportsDelete!;
      } else if (data.title == 'Sales List') {
        data.view = widget.userRoleModel!.salesListView!;
        data.edit = widget.userRoleModel!.salesListEdit!;
        data.delete = widget.userRoleModel!.salesListDelete!;
      } else if (data.title == 'Purchase List') {
        data.view = widget.userRoleModel!.purchaseListView!;
        data.edit = widget.userRoleModel!.purchaseListEdit!;
        data.delete = widget.userRoleModel!.purchaseListDelete!;
      } else if (data.title == 'HRM') {
        data.view = widget.userRoleModel!.hrmView!;
        data.edit = widget.userRoleModel!.hrmEdit!;
        data.delete = widget.userRoleModel!.hrmDelete!;
      } else if (data.title == 'Quotation') {
        data.view = widget.userRoleModel!.quotationView!;
        data.edit = widget.userRoleModel!.quotationEdit!;
        data.delete = widget.userRoleModel!.quotationDelete!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            lang.S.of(context).addUserRole,
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(width: 0.5, color: kGreyTextColor),
                //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                //     ),
                //     child: Column(
                //       children: [
                //         ///_______all_&_sale____________________________________________
                //         Row(
                //           children: [
                //             ///_______all__________________________
                //             SizedBox(
                //               width: context.width() / 2 - 20,
                //               child: CheckboxListTile(
                //                 value: allPermissions,
                //                 onChanged: (value) {
                //                   if (value == true) {
                //                     setState(() {
                //                       allPermissions = value!;
                //                       salePermission = true;
                //                       partiesPermission = true;
                //                       purchasePermission = true;
                //                       productPermission = true;
                //                       profileEditPermission = true;
                //                       addExpensePermission = true;
                //                       lossProfitPermission = true;
                //                       dueListPermission = true;
                //                       stockPermission = true;
                //                       reportsPermission = true;
                //                       salesListPermission = true;
                //                       purchaseListPermission = true;
                //                     });
                //                   } else {
                //                     setState(() {
                //                       allPermissions = value!;
                //                       salePermission = false;
                //                       partiesPermission = false;
                //                       purchasePermission = false;
                //                       productPermission = false;
                //                       profileEditPermission = false;
                //                       addExpensePermission = false;
                //                       lossProfitPermission = false;
                //                       dueListPermission = false;
                //                       stockPermission = false;
                //                       reportsPermission = false;
                //                       salesListPermission = false;
                //                       purchaseListPermission = false;
                //                     });
                //                   }
                //                 },
                //                 title: Text(lang.S.of(context).all),
                //               ),
                //             ),
                //           ],
                //         ),
                //
                //         ///_______Edit Profile_&_sale____________________________________________
                //         Row(
                //           children: [
                //             ///_______Edit_Profile_________________________
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: profileEditPermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     profileEditPermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).profileEdit),
                //               ),
                //             ),
                //
                //             ///______sales____________________________
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: salePermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     salePermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).sales),
                //               ),
                //             ),
                //           ],
                //         ),
                //
                //         ///_____parties_&_Purchase_________________________________________
                //         Row(
                //           children: [
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: partiesPermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     partiesPermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).parties),
                //               ),
                //             ),
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: purchasePermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     purchasePermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).purchase),
                //               ),
                //             ),
                //           ],
                //         ),
                //
                //         ///_____Product_&_DueList_________________________________________
                //         Row(
                //           children: [
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: productPermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     productPermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).product),
                //               ),
                //             ),
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: dueListPermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     dueListPermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).dueList),
                //               ),
                //             ),
                //           ],
                //         ),
                //
                //         ///_____Stock_&_Reports_________________________________________
                //         Row(
                //           children: [
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: stockPermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     stockPermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).stocks),
                //               ),
                //             ),
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: reportsPermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     reportsPermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).reports),
                //               ),
                //             ),
                //           ],
                //         ),
                //
                //         ///_____SalesList_&_Purchase List_________________________________________
                //         Row(
                //           children: [
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: salesListPermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     salesListPermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).salesList),
                //               ),
                //             ),
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: purchaseListPermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     purchaseListPermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).purchaseList),
                //               ),
                //             ),
                //           ],
                //         ),
                //
                //         ///_____LossProfit_&_Expense_________________________________________
                //         Row(
                //           children: [
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: lossProfitPermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     lossProfitPermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).lossOrProfit),
                //               ),
                //             ),
                //             Expanded(
                //               child: CheckboxListTile(
                //                 value: addExpensePermission,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     addExpensePermission = value!;
                //                   });
                //                 },
                //                 title: Text(lang.S.of(context).expense),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: kGreyTextColor),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Type"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("View", style: TextStyle(color: textPrimaryColor, fontSize: 16)),
                              SizedBox(width: 10),
                              Text("Edit", style: TextStyle(color: textPrimaryColor, fontSize: 16)),
                              SizedBox(width: 10),
                              Text("Delete", style: TextStyle(color: textPrimaryColor, fontSize: 16)),
                            ],
                          ),
                        ),
                        Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: permissions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(permissions[index].title),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: permissions[index].view,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        permissions[index].view = value ?? false;
                                      });
                                    },
                                  ),
                                  Checkbox(
                                    value: permissions[index].edit,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        permissions[index].edit = value ?? false;
                                      });
                                    },
                                  ),
                                  Checkbox(
                                    value: permissions[index].delete,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        permissions[index].delete = value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                ///___________Text_fields_____________________________________________
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      children: [
                        ///__________email_________________________________________________________
                        AppTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              // return 'Email can\'n be empty';
                              return lang.S.of(context).emailCanNotBeEmpty;
                            } else if (!value.contains('@')) {
                              //return 'Please enter a valid email';
                              return lang.S.of(context).pleaseEnterAValidEmail;
                            }
                            return null;
                          },
                          showCursor: true,
                          controller: emailController,
                          // cursorColor: kTitleColor,
                          decoration: kInputDecoration.copyWith(
                            labelText: lang.S.of(context).email,
                            // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText: lang.S.of(context).enterYourEmailAddress,
                            // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                            contentPadding: const EdgeInsets.all(10.0),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                            ),
                            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                          ),
                          textFieldType: TextFieldType.EMAIL,
                        ),
                        const SizedBox(height: 20.0),

                        ///______password___________________________________________________________
                        AppTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              //return 'Password can\'t be empty';
                              return lang.S.of(context).passwordCanNotBeEmpty;
                            } else if (value.length < 4) {
                              //return 'Please enter a bigger password';
                              return lang.S.of(context).pleaseEnterABiggerPassword;
                            }
                            return null;
                          },
                          controller: passwordController,
                          showCursor: true,
                          // cursorColor: kTitleColor,
                          decoration: kInputDecoration.copyWith(
                            labelText: lang.S.of(context).password,
                            floatingLabelAlignment: FloatingLabelAlignment.start,
                            // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText: lang.S.of(context).enterYourPassword,
                            // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                            contentPadding: const EdgeInsets.all(10.0),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                            ),
                            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                          ),
                          textFieldType: TextFieldType.PASSWORD,
                        ),

                        ///________retype_email____________________________________________________
                        const SizedBox(height: 20.0),
                        AppTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              //return 'Password can\'t be empty';
                              return lang.S.of(context).passwordCanNotBeEmpty;
                            } else if (value != passwordController.text) {
                              //return 'Password and confirm password does not match';
                              return lang.S.of(context).passwordAndConfirmPasswordDoesNotMatch;
                            } else if (value.length < 4) {
                              //return 'Please enter a bigger password';
                              return lang.S.of(context).pleaseEnterABiggerPassword;
                            }
                            return null;
                          },
                          controller: confirmPasswordController,
                          showCursor: true,
                          // cursorColor: kTitleColor,
                          decoration: kInputDecoration.copyWith(
                            labelText: lang.S.of(context).password,
                            floatingLabelAlignment: FloatingLabelAlignment.start,
                            // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText: lang.S.of(context).enterYourPassword,
                            // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                            contentPadding: const EdgeInsets.all(10.0),
                            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                          ),
                          textFieldType: TextFieldType.PASSWORD,
                        ),

                        ///__________Title_________________________________________________________
                        const SizedBox(height: 20.0),
                        AppTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              // return 'User title can\'n be empty';
                              return lang.S.of(context).userTitleCanNotBeEmpty;
                            }
                            return null;
                          },
                          showCursor: true,
                          controller: titleController,
                          decoration: kInputDecoration.copyWith(
                            labelText: lang.S.of(context).userTitle,
                            hintText: lang.S.of(context).enterUserTitle,
                            contentPadding: const EdgeInsets.all(10.0),
                            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                          ),
                          textFieldType: TextFieldType.EMAIL,
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          margin: const EdgeInsets.all(10.0),
          child: ButtonGlobalWithoutIcon(
              buttonSize: 48,
              buttonTextSize: 18,
              buttontext: lang.S.of(context).create,
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
              onPressed: (() async {
                UserRolePermissionModel userRolePermissionModel = UserRolePermissionModel();

                for (var data in permissions) {
                  if (data.title == 'Sale') {
                    userRolePermissionModel.saleEdit = data.edit;
                    userRolePermissionModel.saleView = data.view;
                    userRolePermissionModel.saleDelete = data.delete;
                  } else if (data.title == 'Parties') {
                    userRolePermissionModel.partiesEdit = data.edit;
                    userRolePermissionModel.partiesView = data.view;
                    userRolePermissionModel.partiesDelete = data.delete;
                  } else if (data.title == 'Purchase') {
                    userRolePermissionModel.purchaseEdit = data.edit;
                    userRolePermissionModel.purchaseView = data.view;
                    userRolePermissionModel.purchaseDelete = data.delete;
                  } else if (data.title == 'Product') {
                    userRolePermissionModel.productEdit = data.edit;
                    userRolePermissionModel.productView = data.view;
                    userRolePermissionModel.productDelete = data.delete;
                  } else if (data.title == 'Profile Edit') {
                    userRolePermissionModel.profileEditEdit = data.edit;
                    userRolePermissionModel.profileEditView = data.view;
                    userRolePermissionModel.profileEditDelete = data.delete;
                  } else if (data.title == 'Add Expense') {
                    userRolePermissionModel.addExpenseEdit = data.edit;
                    userRolePermissionModel.addExpenseView = data.view;
                    userRolePermissionModel.addExpenseDelete = data.delete;
                  } else if (data.title == 'Loss Profit') {
                    userRolePermissionModel.lossProfitEdit = data.edit;
                    userRolePermissionModel.lossProfitView = data.view;
                    userRolePermissionModel.lossProfitDelete = data.delete;
                  } else if (data.title == 'Due List') {
                    userRolePermissionModel.dueListEdit = data.edit;
                    userRolePermissionModel.dueListView = data.view;
                    userRolePermissionModel.dueListDelete = data.delete;
                  } else if (data.title == 'Stock') {
                    userRolePermissionModel.stockEdit = data.edit;
                    userRolePermissionModel.stockView = data.view;
                    userRolePermissionModel.stockDelete = data.delete;
                  } else if (data.title == 'Reports') {
                    userRolePermissionModel.reportsEdit = data.edit;
                    userRolePermissionModel.reportsView = data.view;
                    userRolePermissionModel.reportsDelete = data.delete;
                  } else if (data.title == 'Sales List') {
                    userRolePermissionModel.salesListEdit = data.edit;
                    userRolePermissionModel.salesListView = data.view;
                    userRolePermissionModel.salesListDelete = data.delete;
                  } else if (data.title == 'Purchase List') {
                    userRolePermissionModel.purchaseListEdit = data.edit;
                    userRolePermissionModel.purchaseListView = data.view;
                    userRolePermissionModel.purchaseListDelete = data.delete;
                  } else if (data.title == 'HRM') {
                    userRolePermissionModel.hrmEdit = data.edit;
                    userRolePermissionModel.hrmView = data.view;
                    userRolePermissionModel.hrmDelete = data.delete;
                  } else if (data.title == 'Quotation') {
                    userRolePermissionModel.quotationEdit = data.edit;
                    userRolePermissionModel.quotationView = data.view;
                    userRolePermissionModel.quotationDelete = data.delete;
                  }
                }
                print(userRolePermissionModel.toJson());

                //Check if no true in is permission array
                if (permissions.every((element) => element.view == false && element.edit == false && element.delete == false)) {
                  EasyLoading.showError(lang.S.of(context).youHaveToGivePermission);
                  return;
                }
                if (widget.userRoleModel != null) {
                  try {
                    EasyLoading.show(status: '${lang.S.of(context).loading}...', dismissOnTap: false);
                    UserRoleRepo repo = UserRoleRepo();
                    String adminRoleKey = '';
                    String userRoleKey = '';
                    var adminRoleList = await repo.getAllUserRoleFromAdmin();
                    var userRoleList = await repo.getAllUserRole();
                    for (var element in adminRoleList) {
                      if (element.email == (widget.userRoleModel?.email ?? "")) {
                        adminRoleKey = element.userKey ?? '';
                        break;
                      }
                    }
                    for (var element in userRoleList) {
                      if (element.email == (widget.userRoleModel?.email ?? "")) {
                        userRoleKey = element.userKey ?? '';
                        break;
                      }
                    }

                    DatabaseReference dataRef = FirebaseDatabase.instance.ref("$constUserId/User Role/$userRoleKey");
                    DatabaseReference adminDataRef = FirebaseDatabase.instance.ref("Admin Panel/User Role/$adminRoleKey");
                    userRolePermissionModel.email = emailController.text;
                    userRolePermissionModel.userTitle = titleController.text;
                    userRolePermissionModel.databaseId = FirebaseAuth.instance.currentUser!.uid;
                    await dataRef.update(userRolePermissionModel.toJson());
                    await adminDataRef.update(userRolePermissionModel.toJson());
                    ref.refresh(userRoleProvider);

                    EasyLoading.showSuccess(lang.S.of(context).successfullyUpdated, duration: const Duration(milliseconds: 500));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } catch (e) {
                    EasyLoading.dismiss();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                  return;
                }
                if (validateAndSave()) {
                  print(userRolePermissionModel.toJson());
                  // UserRoleModel userRoleData = UserRoleModel(
                  //   email: emailController.text,
                  //   userTitle: titleController.text,
                  //   databaseId: FirebaseAuth.instance.currentUser!.uid,
                  //   salePermission: salePermission,
                  //   partiesPermission: partiesPermission,
                  //   purchasePermission: purchasePermission,
                  //   productPermission: productPermission,
                  //   profileEditPermission: profileEditPermission,
                  //   addExpensePermission: addExpensePermission,
                  //   lossProfitPermission: lossProfitPermission,
                  //   dueListPermission: dueListPermission,
                  //   stockPermission: stockPermission,
                  //   reportsPermission: reportsPermission,
                  //   salesListPermission: salesListPermission,
                  //   purchaseListPermission: purchaseListPermission,
                  // );
                  userRolePermissionModel.email = emailController.text;
                  userRolePermissionModel.userTitle = titleController.text;
                  userRolePermissionModel.databaseId = FirebaseAuth.instance.currentUser!.uid;
                  // print(FirebaseAuth.instance.currentUser!.uid);
                  signUp(
                    context: context,
                    email: emailController.text,
                    password: passwordController.text,
                    ref: ref,
                    userRoleModel: userRolePermissionModel!,
                  );
                }
              }),
              buttonTextColor: Colors.white),
        ),
      );
    });
  }
}

void signUp({required BuildContext context, required String email, required String password, required WidgetRef ref, required UserRolePermissionModel userRoleModel}) async {
  if (!isDemo) {
    EasyLoading.show(status: '${lang.S.of(context).registering}....');
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      // ignore: unnecessary_null_comparison
      if (userCredential != null) {
        print(userRoleModel.toJson());
        await FirebaseDatabase.instance.ref().child(userRoleModel.databaseId ?? "").child('User Role').push().set(userRoleModel.toJson());
        await FirebaseDatabase.instance.ref().child('Admin Panel').child('User Role').push().set(userRoleModel.toJson());

        EasyLoading.dismiss();
        await FirebaseAuth.instance.signOut();
        // ignore: use_build_context_synchronously
        await showSussesScreenAndLogOut(context: context);
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(lang.S.of(context).failedWithError);
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${lang.S.of(context).thePasswordProvidedIsTooWeak}.'),
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            //content: Text('The account already exists for that email.'),
            content: Text('${lang.S.of(context).theAccountAlreadyExistsForThatEmail}.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      EasyLoading.showError(lang.S.of(context).failedWithError);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  } else {
    EasyLoading.showError(demoText);
  }
}

Future showSussesScreenAndLogOut({required BuildContext context}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      lang.S.of(context).addSuccessful,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lang.S.of(context).youHaveToReLogin,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonGlobalWithoutIcon(
                        buttontext: lang.S.of(context).ok,
                        buttonDecoration: kButtonDecoration.copyWith(color: Colors.green),
                        onPressed: (() {
                          const LoginForm().launch(context, isNewTask: true);
                          // const SplashScreen().launch(context, isNewTask: true);
                        }),
                        buttonTextColor: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
