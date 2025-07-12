import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../currency.dart';

class AddManufacturer extends StatefulWidget {
  const AddManufacturer({super.key});

  @override
  State<AddManufacturer> createState() => _AddManufacturerState();
}

class _AddManufacturerState extends State<AddManufacturer> {
  bool showProgress = false;
  late String manufacturerName;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final allManufacturer = ref.watch(manufacturerProvider);
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
            "Add Manufacturer",
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
                    onChanged: (value) {
                      setState(() {
                        manufacturerName = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Enter Manufacturer Name",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Manufacturer Name",
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).save,
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
                    onPressed: () async {
                      bool isAlreadyAdded = false;
                      allManufacturer.value?.forEach((element) {
                        if (element.manufacturerName.toLowerCase().removeAllWhiteSpace() == manufacturerName.toLowerCase().removeAllWhiteSpace()) {
                          isAlreadyAdded = true;
                        }
                      });
                      setState(() {
                        showProgress = true;
                      });
                      final DatabaseReference categoryInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Brands');
                      categoryInformationRef.keepSynced(true);
                      ManufacturerModel manufacturerModel = ManufacturerModel(manufacturerName);
                      isAlreadyAdded ? EasyLoading.showError(lang.S.of(context).alreadyAdded) : categoryInformationRef.push().set(manufacturerModel.toJson());
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
