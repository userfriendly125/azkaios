// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

import '../../Provider/bank_info_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/subscription_plan_model.dart';

class BankPaymentScreen extends StatefulWidget {
  const BankPaymentScreen({
    super.key,
    this.subscriptionPlanModel,
  });

  final SubscriptionPlanModel? subscriptionPlanModel;

  static const String route = '/pay';

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<BankPaymentScreen> {
  ScrollController mainScroll = ScrollController();

  Future<Uint8List?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        imageController.text = result.files.single.name;
      });
      return result.files.single.bytes;
    } else {
      return null;
    }
  }

  Uint8List? bytesFromPicker;

  Future<String> uploadFile() async {
    try {
      if (bytesFromPicker != null) {
        var snapshot = await FirebaseStorage.instance.ref('Subscription Attachment/${DateTime.now().millisecondsSinceEpoch}').putData(bytesFromPicker!);
        var url = await snapshot.ref.getDownloadURL();
        return url;
      } else {
        return '';
      }
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      return '';
    }
  }

  SubscriptionRequestModel data = SubscriptionRequestModel(
    subscriptionPlanModel: SubscriptionPlanModel(dueNumber: 0, duration: 0, offerPrice: 0, partiesNumber: 0, products: 0, purchaseNumber: 0, saleNumber: 0, subscriptionName: '', subscriptionPrice: 00),
    transactionNumber: '',
    note: '',
    attachment: '',
    userId: constUserId,
    businessCategory: '',
    companyName: '',
    countryName: '',
    language: '',
    phoneNumber: '',
    pictureUrl: '',
  );
  TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrentUserAndRestartApp();
    data.subscriptionPlanModel = widget.subscriptionPlanModel!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          lang.S.of(context).bankInformation,
          //'Bank Information'
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 50.0,
          width: MediaQuery.of(context).size.width < 1080 ? 1080 * .30 : MediaQuery.of(context).size.width * .30,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              backgroundColor: kMainColor,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            onPressed: () async {
              if (data.transactionNumber == '') {
                // EasyLoading.showError('Please Enter Transaction Number');
                EasyLoading.showError(lang.S.of(context).pleaseEnterTransactionNumber);
              } else {
                EasyLoading.show(status: '${lang.S.of(context).loading}...');
                String? sellerUserRef = await getSaleID(id: await getUserID());
                if (sellerUserRef != null) {
                  data.userId = await getUserID();

                  data.attachment = await uploadFile();
                  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Admin Panel').child('Subscription Update Request');

                  await ref.push().set(data.toJson());
                  //EasyLoading.showSuccess('Request has been send');
                  EasyLoading.showSuccess(lang.S.of(context).requestHasBeenSend);
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  //EasyLoading.showError('You Are Not A Valid User');
                  EasyLoading.showError(lang.S.of(context).youAreNotAValidUser);
                }
              }
            },
            child: Text(
              lang.S.of(context).submit,
              //'Submit',
              style: kTextStyle.copyWith(color: kWhite, fontSize: 18.0),
            ),
          ),
        ),
      ),
      body: Consumer(builder: (context, ref, __) {
        final userProfileDetails = ref.watch(profileDetailsProvider);
        final bank = ref.watch(bankInfoProvider);
        return userProfileDetails.when(data: (details) {
          data.countryName = details.countryName!;
          data.language = details.language!;
          data.pictureUrl = details.pictureUrl!;
          data.companyName = details.companyName!;
          data.businessCategory = details.businessCategory!;
          data.phoneNumber = details.phoneNumber ?? '';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  ///_________Bank_Info__________________________________
                  bank.when(
                    data: (bankData) {
                      return Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  lang.S.of(context).bankName,
                                  //'Bank Name',
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(
                                      bankData.bankName,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  lang.S.of(context).branchName,
                                  //'Branch Name',
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(
                                      bankData.branchName,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  lang.S.of(context).accountName,
                                  //'Account Name',
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(
                                      bankData.accountName,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  lang.S.of(context).accountNumber,
                                  //'Account Number',
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(
                                      bankData.accountNumber,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  lang.S.of(context).SWIFTCode,
                                  // 'SWIFT Code',
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(
                                      bankData.swiftCode,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  lang.S.of(context).bankAccountCurrency,
                                  //'Bank Account Currency',
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(
                                      bankData.bankAccountCurrency,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    error: (e, stack) {
                      return Center(
                        child: Text(e.toString()),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                  TextFormField(
                    onChanged: (value) {
                      data.transactionNumber = value;
                    },
                    decoration: kInputDecoration.copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        // labelText: 'Transaction Id',
                        labelText: lang.S.of(context).transactionId,
                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                        //hintText: 'Enter Transaction Id'),
                        hintText: lang.S.of(context).enterTransactionId),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) {
                      data.note = value;
                    },
                    decoration: kInputDecoration.copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        //labelText: 'Note',
                        labelText: lang.S.of(context).note,
                        labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                        //hintText: 'notes'
                        hintText: lang.S.of(context).notes),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: imageController,
                    onTap: () async {
                      bytesFromPicker = await pickFile();
                    },
                    readOnly: true,
                    decoration: kInputDecoration.copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        //labelText: 'Upload Document',
                        labelText: lang.S.of(context).uploadDocument,
                        labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                        // hintText: 'Upload File',
                        hintText: lang.S.of(context).uploadFile,
                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        suffixIcon: const Icon(
                          FeatherIcons.upload,
                          color: kGreyTextColor,
                        )),
                  ),
                ],
              ),
            ),
          );
        }, error: (Object error, StackTrace? stackTrace) {
          return Text(error.toString());
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
        });
      }),
    );
  }
}

class SubscriptionRequestModel {
  SubscriptionPlanModel subscriptionPlanModel;
  late String transactionNumber, note, attachment, userId;
  String phoneNumber;
  String companyName;
  String pictureUrl;
  String businessCategory;
  String language;
  String countryName;

  SubscriptionRequestModel({
    required this.subscriptionPlanModel,
    required this.transactionNumber,
    required this.note,
    required this.attachment,
    required this.userId,
    required this.phoneNumber,
    required this.businessCategory,
    required this.companyName,
    required this.pictureUrl,
    required this.countryName,
    required this.language,
  });

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': DateTime.now().toString(),
        'userId': userId,
        'subscriptionName': subscriptionPlanModel.subscriptionName,
        'subscriptionDuration': subscriptionPlanModel.duration,
        'subscriptionPrice': subscriptionPlanModel.offerPrice > 0 ? subscriptionPlanModel.offerPrice : subscriptionPlanModel.subscriptionPrice,
        'transactionNumber': transactionNumber,
        'note': note,
        'status': 'pending',
        'approvedDate': '',
        'attachment': attachment,
        'phoneNumber': phoneNumber,
        'companyName': companyName,
        'pictureUrl': pictureUrl,
        'businessCategory': businessCategory,
        'language': language,
        'countryName': countryName,
      };
}
