import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Language/language_provider.dart';
import 'package:mobile_pos/Language/language_screen.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/profile_details.dart';
import 'package:mobile_pos/Screens/Settings/Payment%20Type/payment_type_list.dart';
import 'package:mobile_pos/Screens/Settings/currency_screen.dart';
import 'package:mobile_pos/Screens/Settings/feedback_screen.dart';
import 'package:mobile_pos/Screens/Settings/invoice_print.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import 'package:restart_app/restart_app.dart';

import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/personal_information_model.dart';
import '../Shimmers/home_screen_appbar_shimmer.dart';
import '../Terms & Privacy/terms_and_privacy_screen.dart';
import '../User Roles/user_role_screen.dart';
import '../Warehouse/warehouse_list.dart';
import '../subscription/package_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? dropdownValue = '\$ (US Dollar)';
  bool expanded = false;
  bool expandedHelp = false;
  bool expandedAbout = false;
  bool selected = false;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    //EasyLoading.showSuccess('Successfully Logged Out');
    EasyLoading.showSuccess(lang.S.of(context).successfullyLoggedOut);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printerIsEnable();
    getCurrency();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('currency');
    if (!data.isEmptyOrNull) {
      for (var element in items) {
        if (element.substring(0, 2).contains(data!) || element.substring(0, 5).contains(data!)) {
          setState(() {
            dropdownValue = element;
          });
          break;
        }
      }
    } else {
      setState(() {
        dropdownValue = items[0];
      });
    }
  }

  void printerIsEnable() async {
    final prefs = await SharedPreferences.getInstance();

    isPrintEnable = prefs.getBool('isPrintEnable') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (context, ref, _) {
        AsyncValue<PersonalInformationModel> userProfileDetails = ref.watch(profileDetailsProvider);
        return Scaffold(
          backgroundColor: kMainColor,
          body: Column(
            children: [
              Card(
                elevation: 0.0,
                color: kMainColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: userProfileDetails.when(data: (details) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            const ProfileDetails().launch(context);
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage(details.pictureUrl ?? ''), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              details.companyName ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              details.businessCategory ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const HomeScreenAppBarShimmer();
                  }),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                              ]),
                              child: ListTile(
                                horizontalTitleGap: 10,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                title: Text(
                                  lang.S.of(context).profile,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                onTap: () {
                                  const ProfileDetails().launch(context);
                                },
                                leading: const Icon(
                                  Icons.person_outline_rounded,
                                  color: kMainColor,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kGreyTextColor,
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                              ]),
                              child: ListTile(
                                title: Text(
                                  lang.S.of(context).printingOption,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                horizontalTitleGap: 10,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                leading: const Icon(
                                  Icons.print,
                                  color: kMainColor,
                                ),
                                trailing: Transform.scale(
                                  scale: 0.8,
                                  child: Switch.adaptive(
                                    value: isPrintEnable,
                                    onChanged: (bool value) async {
                                      final prefs = await SharedPreferences.getInstance();
                                      await prefs.setBool('isPrintEnable', value);
                                      setState(() {
                                        isPrintEnable = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            userProfileDetails.when(data: (details) {
                              return Container(
                                decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                  BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                  BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                                ]),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  horizontalTitleGap: 10,
                                  title: Text(
                                    "Invoice Print",
                                    //'Warehouse',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  onTap: () {
                                    InvoicePrint(
                                      printSize: details.thermalPrinterPrintSize ?? "3 Inch (80 mm)",
                                      onUpdate: () {
                                        toast("Updated Successfully");
                                        ref.refresh(profileDetailsProvider);
                                      },
                                    ).launch(context);
                                  },
                                  leading: const Icon(
                                    Icons.receipt_long_outlined,
                                    color: kMainColor,
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: kGreyTextColor,
                                    size: 18,
                                  ),
                                ),
                              );
                            }, error: (e, stack) {
                              return Text(e.toString());
                            }, loading: () {
                              return const HomeScreenAppBarShimmer();
                            }),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                              ]),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                horizontalTitleGap: 10,
                                title: Text(
                                  lang.S.of(context).warehouse,
                                  //'Warehouse',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                onTap: () {
                                  const WarehouseList().launch(context);
                                },
                                leading: const Icon(
                                  Icons.warehouse_outlined,
                                  color: kMainColor,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kGreyTextColor,
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                              ]),
                              child: ListTile(
                                title: Text(
                                  lang.S.of(context).feedBack,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                horizontalTitleGap: 10,
                                onTap: () {
                                  // const SubscriptionScreen().launch(context);
                                  const FeedbackScreen().launch(context);
                                },
                                leading: const Icon(
                                  Icons.rate_review,
                                  color: kMainColor,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kGreyTextColor,
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                              ]),
                              child: ListTile(
                                horizontalTitleGap: 10,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                title: Text(
                                  lang.S.of(context).subscription,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                onTap: () {
                                  // const SubscriptionScreen().launch(context);
                                  const PackageScreen().launch(context);
                                },
                                leading: const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: kMainColor,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kGreyTextColor,
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                              ]),
                              child: ListTile(
                                horizontalTitleGap: 10,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                title: Text(
                                  "Payment Type",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                onTap: () {
                                  // const SubscriptionScreen().launch(context);
                                  const PaymentTypeList().launch(context);
                                },
                                leading: const Icon(
                                  Icons.credit_card_outlined,
                                  color: kMainColor,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kGreyTextColor,
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            ///___________user_role___________________________________________________________
                            Container(
                              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                              ]),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                horizontalTitleGap: 10,
                                title: Text(
                                  lang.S.of(context).userRole,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                onTap: () {
                                  const UserRoleScreen().launch(context);
                                },
                                leading: const Icon(
                                  Icons.supervised_user_circle_sharp,
                                  color: kMainColor,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kGreyTextColor,
                                  size: 18,
                                ),
                              ).visible(!isSubUser),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                              ]),
                              child: ListTile(
                                horizontalTitleGap: 10,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CurrencyScreen()));
                                },
                                title: Text(
                                  lang.S.of(context).currency,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                leading: const Icon(
                                  Icons.currency_exchange,
                                  color: kMainColor,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kGreyTextColor,
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Consumer(builder: (_, ref, watch) {
                              final currentLocale = ref.watch(languageChangeProvider).currentLocale.languageCode;

                              return Container(
                                decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                  BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                  BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                                ]),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageScreen()));
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  horizontalTitleGap: 10,
                                  title: Text(
                                    lang.S.of(context).language,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  leading: Flag.fromString(
                                    languageToFlagCode[currentLanguage] ?? 'US',
                                    fit: BoxFit.cover,
                                    height: 25,
                                    width: 30,
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: kGreyTextColor,
                                    size: 18.0,
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(
                              height: 15,
                            ),

                            ///___________Terms & Privacy_____________________________
                            Container(
                              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                              ]),
                              child: ListTile(
                                horizontalTitleGap: 10,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                title: Text(
                                  lang.S.of(context).termsPrivacy,
                                  //'Terms & Privacy',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                onTap: () async {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsAndPrivacyScreen()));
                                },
                                leading: const Icon(
                                  Icons.policy,
                                  color: kMainColor,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kGreyTextColor,
                                  size: 18.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(6), boxShadow: [
                                BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), offset: const Offset(0, 0), blurRadius: 1, spreadRadius: 0),
                                BoxShadow(color: const Color(0xff473232).withOpacity(0.05), offset: const Offset(0, 3), blurRadius: 8, spreadRadius: -1),
                              ]),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                horizontalTitleGap: 10,
                                title: Text(
                                  lang.S.of(context).logOUt,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                onTap: () async {
                                  // EasyLoading.show(status: 'Log out');
                                  EasyLoading.show(status: lang.S.of(context).logOut);
                                  await _signOut();
                                  Future.delayed(const Duration(milliseconds: 1000), () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
                                    Restart.restartApp();
                                    // const SignInScreen().launch(context);
                                  });
                                  // Phoenix.rebirth(context);
                                },
                                leading: const Icon(
                                  Icons.logout,
                                  color: kMainColor,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kGreyTextColor,
                                  size: 18.0,
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 15,
                            // ),
                            // Row(
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.all(16.0),
                            //       child: Text(
                            //         '$appName V-$appVersion',
                            //         style: GoogleFonts.poppins(
                            //           color: kGreyTextColor,
                            //           fontSize: 16.0,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class NoticationSettings extends StatefulWidget {
  const NoticationSettings({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoticationSettingsState createState() => _NoticationSettingsState();
}

class _NoticationSettingsState extends State<NoticationSettings> {
  bool notify = false;
  String notificationText = 'Off';

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 350.0,
      width: MediaQuery.of(context).size.width - 80,
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                color: kGreyTextColor,
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: kDarkWhite,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_outlined,
                size: 50.0,
                color: kMainColor,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              lang.S.of(context).doNotDistrub,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur elit. Interdum cons.',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: kGreyTextColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notificationText,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              Switch(
                value: notify,
                onChanged: (val) {
                  setState(() {
                    notify = val;
                    val ? notificationText = 'On' : notificationText = 'Off';
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
