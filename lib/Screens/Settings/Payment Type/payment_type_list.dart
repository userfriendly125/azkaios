import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../../currency.dart';
import 'add_payment_type.dart';

// ignore: must_be_immutable
class PaymentTypeList extends StatefulWidget {
  const PaymentTypeList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentTypeListState createState() => _PaymentTypeListState();
}

class _PaymentTypeListState extends State<PaymentTypeList> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        title: Text(
          "Payment Type",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: kMainColor,
        elevation: 0.0,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: lang.S.of(context).search,
                          prefixIcon: Icon(
                            Icons.search,
                            color: kGreyTextColor.withOpacity(0.5),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          AddPaymentType().launch(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: kGreyTextColor),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: kGreyTextColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: FirebaseAnimatedList(
                    controller: ScrollController(keepScrollOffset: false),
                    defaultChild: Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                      child: Loader(
                        color: Colors.white.withOpacity(0.2),
                        size: 60,
                      ),
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    query: FirebaseDatabase.instance
                        // ignore: deprecated_member_use
                        .ref()
                        .child(constUserId)
                        .child('Payment Types'),
                    itemBuilder: (context, snapshot, animation, index) {
                      final json = snapshot.value as Map<dynamic, dynamic>;
                      final title = PaymentTypesModel.fromJson(json);
                      return title.paymentTypeName.contains(search)
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          title.paymentTypeName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                AddPaymentType(
                                                  type: title.paymentTypeName,
                                                  pushKey: title.id,
                                                ).launch(context);
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                color: kMainColor,
                                              ),
                                            ),
                                            const SizedBox(width: 10.0),
                                            GestureDetector(
                                              onTap: () {
                                                showConfirmDialogCustom(context, title: "Are you sure you want to delete this payment type?", onAccept: (c) async {
                                                  //Delete the payment type
                                                  await FirebaseDatabase.instance.ref(constUserId).child('Payment Types').child(title.id).remove().then((value) {
                                                    toast("Payment Type Deleted Successfully");
                                                  }).catchError((error) {
                                                    toast("Failed to delete payment type: $error");
                                                  });
                                                });
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            )
                          : Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
