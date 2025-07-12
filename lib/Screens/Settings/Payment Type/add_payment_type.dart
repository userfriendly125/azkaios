import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/currency.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

class AddPaymentType extends StatefulWidget {
  AddPaymentType({super.key, this.type, this.pushKey});
  String? type;
  String? pushKey;

  @override
  // ignore: library_private_types_in_public_api
  _AddPaymentTypeState createState() => _AddPaymentTypeState();
}

class _AddPaymentTypeState extends State<AddPaymentType> {
  bool showProgress = false;
  late String brandName;
  TextEditingController brandNameController = TextEditingController();

  @override
  void initState() {
    brandName = widget.type ?? '';
    brandNameController.text = brandName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final allBrands = ref.watch(brandsProvider);
      return Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.white,
              )),
          title: Text(
            "Add Payment Type",
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Visibility(
                    visible: showProgress,
                    child: const CircularProgressIndicator(
                      color: kMainColor,
                      strokeWidth: 5.0,
                    ),
                  ),
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: brandNameController,
                    onChanged: (value) {
                      setState(() {
                        brandName = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Enter Payment Type",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: lang.S.of(context).brandName,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).save,
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
                    onPressed: () async {
                      bool isAlreadyAdded = false;
                      allBrands.value?.forEach((element) {
                        if (element.brandName.toLowerCase().removeAllWhiteSpace() == brandName.toLowerCase().removeAllWhiteSpace()) {
                          isAlreadyAdded = true;
                        }
                      });
                      setState(() {
                        showProgress = true;
                      });
                      final DatabaseReference categoryInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Payment Types');
                      categoryInformationRef.keepSynced(true);
                      String pushKeynew = categoryInformationRef.push().key ?? '';
                      if (pushKeynew == '') {
                        EasyLoading.showError("An Error Occurred, Please try again later");
                        return;
                      }
                      if (widget.type != null && widget.pushKey != null) {
                        //Get the key from rtdb
                        isAlreadyAdded
                            ? EasyLoading.showError(lang.S.of(context).alreadyAdded)
                            : categoryInformationRef.update(
                                {widget.pushKey!: PaymentTypesModel(id: widget.pushKey!, paymentTypeName: brandName).toJson()},
                              );
                      } else {
                        PaymentTypesModel brandModel = PaymentTypesModel(
                          id: pushKeynew,
                          paymentTypeName: brandName,
                        );
                        isAlreadyAdded ? EasyLoading.showError(lang.S.of(context).alreadyAdded) : categoryInformationRef.child(pushKeynew).set(brandModel.toJson());
                      }
                      setState(() {
                        showProgress = false;
                        isAlreadyAdded ? null : ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang.S.of(context).dataSavedSuccessfully)));
                      });

                      // ignore: use_build_context_synchronously
                      isAlreadyAdded ? null : Navigator.pop(context);
                    },
                    buttonTextColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
