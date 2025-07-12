// ignore_for_file: unused_result

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/model/user_role_model.dart';
import 'package:mobile_pos/repository/get_user_role_repo.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/user_role_provider.dart';
import '../../currency.dart';
import '../../model/user_role_permission_model.dart';
import 'add_user_role_screen.dart';

class UserRoleDetails extends StatefulWidget {
  const UserRoleDetails({super.key, required this.userRoleModel});

  final UserRoleModel userRoleModel;

  @override
  // ignore: library_private_types_in_public_api
  _UserRoleDetailsState createState() => _UserRoleDetailsState();
}

class _UserRoleDetailsState extends State<UserRoleDetails> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

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
  TextEditingController titleController = TextEditingController();
  bool isMailSent = false;

  @override
  void initState() {
    getAllUserData();
    // TODO: implement initState
    super.initState();
    salePermission = widget.userRoleModel.salePermission;
    partiesPermission = widget.userRoleModel.partiesPermission;
    purchasePermission = widget.userRoleModel.purchasePermission;
    productPermission = widget.userRoleModel.productPermission;
    profileEditPermission = widget.userRoleModel.profileEditPermission;
    addExpensePermission = widget.userRoleModel.addExpensePermission;
    lossProfitPermission = widget.userRoleModel.lossProfitPermission;
    dueListPermission = widget.userRoleModel.dueListPermission;
    stockPermission = widget.userRoleModel.stockPermission;
    reportsPermission = widget.userRoleModel.reportsPermission;
    salesListPermission = widget.userRoleModel.salesListPermission;
    purchaseListPermission = widget.userRoleModel.purchaseListPermission;
    emailController.text = widget.userRoleModel.email;
    titleController.text = widget.userRoleModel.userTitle;
  }

  UserRoleRepo repo = UserRoleRepo();
  List<UserRolePermissionModel> adminRoleList = [];
  List<UserRolePermissionModel> userRoleList = [];

  String adminRoleKey = '';
  String userRoleKey = '';

  void getAllUserData() async {
    adminRoleList = await repo.getAllUserRoleFromAdmin();
    userRoleList = await repo.getAllUserRole();
    for (var element in adminRoleList) {
      if (element.email == widget.userRoleModel.email) {
        adminRoleKey = element.userKey ?? '';
        break;
      }
    }
    for (var element in userRoleList) {
      if (element.email == widget.userRoleModel.email) {
        userRoleKey = element.userKey ?? '';
        break;
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
            lang.S.of(context).userRoleDetails,
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      String pass = '';
                      return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppTextField(
                                    textFieldType: TextFieldType.EMAIL,
                                    onChanged: (value) {
                                      pass = value;
                                    },
                                    decoration: InputDecoration(labelText: lang.S.of(context).enterYourPassword, border: const OutlineInputBorder()),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ButtonGlobalWithoutIcon(
                                          buttontext: lang.S.of(context).cacel,
                                          buttonDecoration: kButtonDecoration.copyWith(color: Colors.green),
                                          onPressed: (() {
                                            Navigator.pop(context);
                                          }),
                                          buttonTextColor: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: ButtonGlobalWithoutIcon(
                                            buttontext: lang.S.of(context).delete,
                                            buttonDecoration: kButtonDecoration.copyWith(color: Colors.red),
                                            onPressed: (() async {
                                              if (pass != '' && pass.isNotEmpty) {
                                                await deleteUserRole(email: widget.userRoleModel.email, password: pass, adminKey: adminRoleKey, userKey: userRoleKey, context: context);
                                              } else {
                                                // EasyLoading.showError('Please Enter Password');
                                                EasyLoading.showError(lang.S.of(context).pleaseEnterPassword);
                                              }
                                            }),
                                            buttonTextColor: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: kGreyTextColor),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        ///_______all_&_sale____________________________________________
                        Row(
                          children: [
                            ///_______all__________________________
                            SizedBox(
                              width: context.width() / 2 - 20,
                              child: CheckboxListTile(
                                value: allPermissions,
                                onChanged: (value) {
                                  if (value == true) {
                                    setState(() {
                                      allPermissions = value!;
                                      salePermission = true;
                                      partiesPermission = true;
                                      purchasePermission = true;
                                      productPermission = true;
                                      profileEditPermission = true;
                                      addExpensePermission = true;
                                      lossProfitPermission = true;
                                      dueListPermission = true;
                                      stockPermission = true;
                                      reportsPermission = true;
                                      salesListPermission = true;
                                      purchaseListPermission = true;
                                    });
                                  } else {
                                    setState(() {
                                      allPermissions = value!;
                                      salePermission = false;
                                      partiesPermission = false;
                                      purchasePermission = false;
                                      productPermission = false;
                                      profileEditPermission = false;
                                      addExpensePermission = false;
                                      lossProfitPermission = false;
                                      dueListPermission = false;
                                      stockPermission = false;
                                      reportsPermission = false;
                                      salesListPermission = false;
                                      purchaseListPermission = false;
                                    });
                                  }
                                },
                                title: Text(lang.S.of(context).all),
                              ),
                            ),
                          ],
                        ),

                        ///_______Edit Profile_&_sale____________________________________________
                        Row(
                          children: [
                            ///_______Edit_Profile_________________________
                            Expanded(
                              child: CheckboxListTile(
                                value: profileEditPermission,
                                onChanged: (value) {
                                  setState(() {
                                    profileEditPermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).profileEdit),
                              ),
                            ),

                            ///______sales____________________________
                            Expanded(
                              child: CheckboxListTile(
                                value: salePermission,
                                onChanged: (value) {
                                  setState(() {
                                    salePermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).sales),
                              ),
                            ),
                          ],
                        ),

                        ///_____parties_&_Purchase_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: partiesPermission,
                                onChanged: (value) {
                                  setState(() {
                                    partiesPermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).parties),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: purchasePermission,
                                onChanged: (value) {
                                  setState(() {
                                    purchasePermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).purchase),
                              ),
                            ),
                          ],
                        ),

                        ///_____Product_&_DueList_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: productPermission,
                                onChanged: (value) {
                                  setState(() {
                                    productPermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).product),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: dueListPermission,
                                onChanged: (value) {
                                  setState(() {
                                    dueListPermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).dueList),
                              ),
                            ),
                          ],
                        ),

                        ///_____Stock_&_Reports_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: stockPermission,
                                onChanged: (value) {
                                  setState(() {
                                    stockPermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).stocks),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: reportsPermission,
                                onChanged: (value) {
                                  setState(() {
                                    reportsPermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).reports),
                              ),
                            ),
                          ],
                        ),

                        ///_____SalesList_&_Purchase List_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: salesListPermission,
                                onChanged: (value) {
                                  setState(() {
                                    salesListPermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).salesList),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: purchaseListPermission,
                                onChanged: (value) {
                                  setState(() {
                                    purchaseListPermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).purchaseList),
                              ),
                            ),
                          ],
                        ),

                        ///_____LossProfit_&_Expense_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: lossProfitPermission,
                                onChanged: (value) {
                                  setState(() {
                                    lossProfitPermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).lossOrProfit),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: addExpensePermission,
                                onChanged: (value) {
                                  setState(() {
                                    addExpensePermission = value!;
                                  });
                                },
                                title: Text(lang.S.of(context).expense),
                              ),
                            ),
                          ],
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ///__________email_________________________________________________________
                        AppTextField(
                          readOnly: true,
                          initialValue: widget.userRoleModel.email,
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

                        ///__________Title_________________________________________________________
                        AppTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              //return 'User title can\'n be empty';
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

                        TextButton(
                          onPressed: () async {
                            try {
                              EasyLoading.show(status: '${lang.S.of(context).loading}....');
                              await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: widget.userRoleModel.email,
                              );

                              //EasyLoading.showSuccess('An Email has been sent\nCheck your inbox');
                              EasyLoading.showSuccess(lang.S.of(context).anEmailHasBeenSentCheckYourInbox);
                              setState(() {
                                isMailSent = true;
                              });
                            } catch (e) {
                              EasyLoading.showError(e.toString());
                            }
                          },
                          child: Text(lang.S.of(context).forgotPasswords),
                        ).visible(!isMailSent),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ButtonGlobalWithoutIcon(
              buttonSize: 48,
              buttonTextSize: 18,
              buttontext: lang.S.of(context).update,
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
              onPressed: (() async {
                if (!isDemo) {
                  if (salePermission || partiesPermission || purchasePermission || productPermission || profileEditPermission || addExpensePermission || lossProfitPermission || dueListPermission || stockPermission || reportsPermission || salesListPermission || purchaseListPermission) {
                    try {
                      EasyLoading.show(status: '${lang.S.of(context).loading}...', dismissOnTap: false);
                      DatabaseReference dataRef = FirebaseDatabase.instance.ref("$constUserId/User Role/$userRoleKey");
                      DatabaseReference adminDataRef = FirebaseDatabase.instance.ref("Admin Panel/User Role/$adminRoleKey");
                      await dataRef.update({
                        'userTitle': titleController.text,
                        'salePermission': salePermission,
                        'partiesPermission': partiesPermission,
                        'purchasePermission': purchasePermission,
                        'productPermission': productPermission,
                        'profileEditPermission': profileEditPermission,
                        'addExpensePermission': addExpensePermission,
                        'lossProfitPermission': lossProfitPermission,
                        'dueListPermission': dueListPermission,
                        'stockPermission': stockPermission,
                        'reportsPermission': reportsPermission,
                        'salesListPermission': salesListPermission,
                        'purchaseListPermission': purchaseListPermission,
                      });
                      await adminDataRef.update({
                        'userTitle': titleController.text,
                        'salePermission': salePermission,
                        'partiesPermission': partiesPermission,
                        'purchasePermission': purchasePermission,
                        'productPermission': productPermission,
                        'profileEditPermission': profileEditPermission,
                        'addExpensePermission': addExpensePermission,
                        'lossProfitPermission': lossProfitPermission,
                        'dueListPermission': dueListPermission,
                        'stockPermission': stockPermission,
                        'reportsPermission': reportsPermission,
                        'salesListPermission': salesListPermission,
                        'purchaseListPermission': purchaseListPermission,
                      });
                      ref.refresh(userRoleProvider);

                      EasyLoading.showSuccess(lang.S.of(context).successfullyUpdated, duration: const Duration(milliseconds: 500));
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    } catch (e) {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  } else {
                    EasyLoading.showError(lang.S.of(context).youHaveToGivePermission);
                  }
                } else {}
              }),
              buttonTextColor: Colors.white),
        ),
      );
    });
  }
}

Future<void> deleteUserRole({required String email, required String password, required String adminKey, required String userKey, required BuildContext context}) async {
  EasyLoading.show(status: '${lang.S.of(context).loading}...');
  try {
    final userCredential = await FirebaseAuth.instance.signInWithCredential(EmailAuthProvider.credential(email: email, password: password));
    final user = userCredential.user;
    await user?.delete();
    DatabaseReference dataRef = FirebaseDatabase.instance.ref("$constUserId/User Role/$userKey");
    DatabaseReference adminDataRef = FirebaseDatabase.instance.ref("Admin Panel/User Role/$adminKey");

    await dataRef.remove();
    await adminDataRef.remove();

    EasyLoading.dismiss();
    // ignore: use_build_context_synchronously
    await showSussesScreenAndLogOut(context: context);
  } catch (e) {
    EasyLoading.dismiss();
    EasyLoading.showError(e.toString());
  }
}
