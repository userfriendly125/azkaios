import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/tax%20report/tax_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

class AddTaxGroup extends StatefulWidget {
  const AddTaxGroup({super.key, required this.listOfGroupTax});

  final List<GroupTaxModel> listOfGroupTax;

  @override
  State<AddTaxGroup> createState() => _AddTaxGroupState();
}

class _AddTaxGroupState extends State<AddTaxGroup> {
  String name = '';
  num rate = 0;

  List<TaxModel> subTaxList = [];
  String id = DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(1000).toString();

  num calculateTotalRate(List<TaxModel> subTaxList) {
    rate = 0.0;
    for (var taxModel in subTaxList) {
      rate += taxModel.taxRate;
    }
    return rate;
  }

  @override
  Widget build(BuildContext context) {
    List<String> names = [];
    for (var element in widget.listOfGroupTax) {
      names.add(element.name.removeAllWhiteSpace().toLowerCase());
    }
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        title: Text(
          '${lang.S.of(context).addNewTax}*',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: kMainColor,
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Consumer(
          builder: (_, ref, watch) {
            final tax = ref.watch(taxProvider);
            return tax.when(data: (taxList) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //___________________________________Tax Rates______________________________
                  Text(
                    lang.S.of(context).addNewTaxWithSingleMultipleTaxType,
                    // 'Add New Tax with single/multiple Tax type',
                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Text('${lang.S.of(context).name}*', style: kTextStyle.copyWith(color: kTitleColor)),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    onChanged: (value) {
                      name = value;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8, right: 8.0),
                      border: OutlineInputBorder(),
                      // hintText: 'Enter Name',
                      hintText: lang.S.of(context).enterName,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    '${lang.S.of(context).subTaxes}*',
                    style: kTextStyle.copyWith(color: kTitleColor),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Colors.transparent, border: Border.all(color: kBorderColorTextField)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        subTaxList.isNotEmpty
                            ? Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    children: List.generate(
                                      subTaxList.length,
                                      (index) {
                                        final category = subTaxList[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Container(
                                            height: 30,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: kMainColor),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    setState(() {
                                                      subTaxList.removeAt(index);
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: kWhite,
                                                    size: 16,
                                                  ),
                                                ),
                                                Text(
                                                  category.name,
                                                  style: kTextStyle.copyWith(color: kWhite),
                                                ),
                                                const SizedBox(width: 8)
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                lang.S.of(context).noSubTaxSelected,
                                //'No Sub Tax selected',
                                style: kTextStyle.copyWith(color: kTitleColor),
                              ),

                        //___________________________________________showModalBottomSheet______________________
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setNewState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20.0, 13.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                lang.S.of(context).subTaxList,
                                                // 'Sub Tax List',
                                                style: kTextStyle.copyWith(color: kTitleColor),
                                              ),
                                              IconButton(
                                                onPressed: () => Navigator.pop(context),
                                                icon: const Icon(
                                                  Icons.close_rounded,
                                                  size: 21,
                                                  color: kTitleColor,
                                                ),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          color: kBorderColorTextField,
                                        ),
                                        const SizedBox(height: 5),
                                        Expanded(
                                          child: ListView.builder(
                                            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                                            itemCount: taxList.length,
                                            itemBuilder: (context, index) {
                                              final category = taxList[index];
                                              return Column(
                                                children: [
                                                  CheckboxListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    checkboxShape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(50.0),
                                                    ),
                                                    checkColor: Colors.white,
                                                    activeColor: kMainColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(6.0),
                                                    ),
                                                    fillColor: MaterialStateProperty.all(
                                                      subTaxList.contains(category) ? kMainColor : Colors.transparent,
                                                    ),
                                                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                    side: const BorderSide(color: kBorderColorTextField),
                                                    title: Text(
                                                      category.name.toString(),
                                                      style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis),
                                                    ),
                                                    subtitle: Text(
                                                      '${lang.S.of(context).taxPercentage}: ${category.taxRate}%',
                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                    ),
                                                    value: subTaxList.contains(category),
                                                    onChanged: (isChecked) {
                                                      setNewState(() {
                                                        if (isChecked!) {
                                                          if (!subTaxList.contains(category)) {
                                                            subTaxList.add(category); // Add only the TaxModel instance
                                                          }
                                                        } else {
                                                          subTaxList.remove(category);
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  const Divider(
                                                    color: kBorderColorTextField,
                                                    height: 0.0,
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            height: 45.0,
                                            width: MediaQuery.of(context).size.width,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.only(left: 2, right: 2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.0),
                                                ),
                                                backgroundColor: kMainColor,
                                                elevation: 1.0,
                                                foregroundColor: kGreyTextColor.withOpacity(0.1),
                                                shadowColor: kMainColor,
                                                animationDuration: const Duration(milliseconds: 300),
                                                textStyle: const TextStyle(color: Colors.white, fontFamily: 'Display', fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text(
                                                lang.S.of(context).done,
                                                //'Done',
                                                style: kTextStyle.copyWith(color: kWhite, fontSize: 12, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: kGreyTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //___________________________________________save_button______________________
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 45.0,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(left: 2, right: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: kMainColor,
                          elevation: 1.0,
                          foregroundColor: kGreyTextColor.withOpacity(0.1),
                          shadowColor: kMainColor,
                          animationDuration: const Duration(milliseconds: 300),
                          textStyle: const TextStyle(color: Colors.white, fontFamily: 'Display', fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          num totalRate = calculateTotalRate(subTaxList);
                          if (name != '' && !names.contains(name.toLowerCase().removeAllWhiteSpace())) {
                            GroupTaxModel groupTax = GroupTaxModel(name: name, taxRate: totalRate, id: id.toString(), subTaxes: subTaxList);
                            try {
                              EasyLoading.show(status: '${lang.S.of(context).loading}...', dismissOnTap: false);
                              final DatabaseReference productInformationRef = FirebaseDatabase.instance.ref().child(await getUserID()).child('Group Tax List');
                              await productInformationRef.push().set(groupTax.toJson());
                              EasyLoading.showSuccess(lang.S.of(context).addedSuccessfully, duration: const Duration(milliseconds: 500));
                              ref.refresh(taxProvider);
                              ref.refresh(groupTaxProvider);
                              Future.delayed(const Duration(milliseconds: 100)).then(
                                (value) => Navigator.pop(context),
                              );
                            } catch (e) {
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                            }
                          } else {
                            EasyLoading.showError(name == '' ? lang.S.of(context).enterName : lang.S.of(context).alreadyExists);
                          }
                        },
                        child: Text(
                          lang.S.of(context).save,
                          //'Save',
                          style: kTextStyle.copyWith(color: kWhite, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }, error: (e, stack) {
              return Center(
                child: Text(e.toString()),
              );
            }, loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
          },
        ),
      ),
    );
  }
}
