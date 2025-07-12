// ignore_for_file: unused_result
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/homepage_image_provider.dart';
import 'package:mobile_pos/Screens/Home/components/grid_items.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/profile_details.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Provider/due_transaction_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../const_commas.dart';
import '../../currency.dart';
import '../../subscription.dart';
import '../subscription/package_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> color = [
    const Color(0xffEBD7FF),
    const Color(0xffFFD6E2),
    const Color(0xffBBFFC1),
    const Color(0xffD9EEFF),
    const Color(0xffd9f7f5),
    const Color(0xffFFE4C1),
    const Color(0xffBFFFEF),
    const Color(0xffFFD6E2),
    const Color(0xffEDDBFF),
    const Color(0xffF7CCFE),
    const Color(0xffBBFFC1),
    const Color(0xffD4ECFF),
    const Color(0xffFFE4C1),
    const Color(0xffEBD7FF),
    const Color(0xffFFF6ED),
    const Color(0xffD6EFF4),
  ];
  TextEditingController fromDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime(2021)));
  TextEditingController toDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  DateTime fromDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime toDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  double totalProfit = 0;
  double totalLoss = 0;
  bool isPicked = false;
  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'images/banner1.png',
    },
    {
      "icon": 'images/banner2.png',
    }
  ];
  PageController pageController = PageController(
    initialPage: 0,
  );

  List<String> get dayList => [
        'Today',
        // lang.S.current.today,
        'Weekly',
        // lang.S.current.weekly,
        'Monthly',
        // lang.S.current.monthly,
        'Yearly',
        // lang.S.current.yearly,
      ];
  late String selectedDay = dayList.first;

  @override
  void initState() {
    super.initState();
    getCurrency();
  }

  double totalSell = 0;
  double totalDue = 0;
  double totalPurchase = 0;
  int count = 0;

  setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    getCurrency();
  }

  void getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('currency');
    if (!data.isEmptyOrNull) {
      currency = data!;
    }
  }

  @override
  Widget build(BuildContext context) {
    freeIcons = getFreeIcons(context: context);
    return SafeArea(
      child: Consumer(builder: (_, ref, __) {
        final purchaseProviderData = ref.watch(purchaseTransitionProvider);
        final userProfileDetails = ref.watch(profileDetailsProvider);
        final homePageImageProvider = ref.watch(homepageImageProvider);
        final salesProviderData = ref.watch(transitionProvider);
        return WillPopScope(
          onWillPop: () async => false,
          child: userProfileDetails.when(data: (details) {
            setCurrency(details.currency.toString());
            return Scaffold(
              backgroundColor: kMainColor,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: kMainColor,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      isSubUser ? null : const ProfileDetails().launch(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(details.pictureUrl ?? ''), fit: BoxFit.cover), shape: BoxShape.circle, border: Border.all(color: kBorderColorTextField)),
                    ),
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSubUser ? '${details.companyName ?? ''} [$subUserTitle]' : details.companyName ?? '',
                      style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    Text(
                      '${Subscription.selectedItem} ${lang.S.of(context).plan}',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                            color: kDarkWhite),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                lang.S.of(context).dashBoardOverView,
                                style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                              ),
                              const Spacer(),
                              Transform.scale(
                                scale: 0.6,
                                child: CupertinoSwitch(
                                    activeColor: kMainColor,
                                    value: isReportShow,
                                    onChanged: (newValue) {
                                      setState(() {
                                        isReportShow = newValue;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      isReportShow
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              lang.S.of(context).salesAndPurchaseReports,
                                              style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: kTitleColor),
                                            ),
                                            const Spacer(),
                                            DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                    icon: const Icon(
                                                      Icons.keyboard_arrow_down_sharp,
                                                      color: kGreyTextColor,
                                                      size: 18,
                                                    ),
                                                    value: selectedDay,
                                                    items: dayList
                                                        .map(
                                                          (e) => DropdownMenuItem(
                                                            value: e,
                                                            child: Text(
                                                              e,
                                                              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 14),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        selectedDay = newValue!;
                                                        if (newValue == 'Today') {
                                                          fromDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                                                        } else if (newValue == 'Weekly') {
                                                          fromDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).subtract(const Duration(days: 7));
                                                        } else if (newValue == 'Monthly') {
                                                          fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
                                                        } else if (newValue == 'Yearly') {
                                                          fromDate = DateTime(DateTime.now().year, 1, 1);
                                                        }
                                                      });
                                                    }))
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          alignment: Alignment.center,
                                          height: 64,
                                          decoration: BoxDecoration(color: const Color(0xffCEFFE2), borderRadius: BorderRadius.circular(8)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              salesProviderData.when(data: (transaction) {
                                                totalSell = 0;
                                                totalDue = 0;
                                                final reTransaction = transaction.reversed.toList();
                                                for (var element in transaction) {
                                                  if ((fromDate.isBefore(DateTime.parse(element.purchaseDate)) || DateTime.parse(element.purchaseDate).isAtSameMomentAs(fromDate)) && (toDate.isAfter(DateTime.parse(element.purchaseDate)) || DateTime.parse(element.purchaseDate).isAtSameMomentAs(toDate))) {
                                                    totalSell = totalSell + element.totalAmount!.toDouble();
                                                    totalDue = totalDue + element.dueAmount!.toDouble();
                                                  }
                                                }
                                                return reTransaction.isNotEmpty
                                                    ? Text(
                                                        '$currency${myFormat.format(totalSell)}',
                                                        style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                                      )
                                                    : Text('$currency 0');
                                              }, error: (e, stack) {
                                                return Text(e.toString());
                                              }, loading: () {
                                                return const Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(lang.S.of(context).sales),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 64,
                                                decoration: BoxDecoration(color: const Color(0xffDFD3FF), borderRadius: BorderRadius.circular(8)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    purchaseProviderData.when(data: (transaction) {
                                                      final reTransaction = transaction.reversed.toList();
                                                      totalPurchase = 0;
                                                      for (var element in reTransaction) {
                                                        if ((fromDate.isBefore(DateTime.parse(element.purchaseDate)) || DateTime.parse(element.purchaseDate).isAtSameMomentAs(fromDate)) && (toDate.isAfter(DateTime.parse(element.purchaseDate)) || DateTime.parse(element.purchaseDate).isAtSameMomentAs(toDate))) {
                                                          totalPurchase = totalPurchase + element.totalAmount!.toDouble();
                                                        }
                                                      }
                                                      return reTransaction.isNotEmpty
                                                          ? Text(
                                                              '$currency${myFormat.format(totalPurchase)}',
                                                              style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                                            )
                                                          : Text('$currency 0');
                                                    }, error: (e, stack) {
                                                      return Text(e.toString());
                                                    }, loading: () {
                                                      return const Center(
                                                        child: CircularProgressIndicator(),
                                                      );
                                                    }),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(lang.S.of(context).purchase),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 64,
                                                decoration: BoxDecoration(color: const Color(0xffFFDBDB), borderRadius: BorderRadius.circular(8)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text('$currency${myFormat.format(totalDue)}', style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor)),
                                                    // dueProviderData.when(data: (transaction) {
                                                    //   final reTransaction = transaction.reversed.toList();
                                                    //   // totalDue = 0;
                                                    //   // for (var element in reTransaction) {
                                                    //   //   if ((fromDate.isBefore(DateTime.parse(element.purchaseDate)) ||
                                                    //   //           DateTime.parse(element.purchaseDate).isAtSameMomentAs(fromDate)) &&
                                                    //   //       (toDate.isAfter(DateTime.parse(element.purchaseDate)) ||
                                                    //   //           DateTime.parse(element.purchaseDate).isAtSameMomentAs(toDate))) {
                                                    //   //     totalDue = totalDue + element.totalDue!.toDouble();
                                                    //   //   }
                                                    //   // }
                                                    //   return transaction.isNotEmpty
                                                    //       ? Text('$currency${myFormat.format(totalDue)}',
                                                    //           style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor))
                                                    //       : Text('$currency 0');
                                                    // }, error: (e, stack) {
                                                    //   return Text(e.toString());
                                                    // }, loading: () {
                                                    //   return const Center(
                                                    //     child: CircularProgressIndicator(),
                                                    //   );
                                                    // }),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      lang.S.of(context).due,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: GridView.count(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        childAspectRatio: 1.0,
                                        crossAxisSpacing: 0,
                                        mainAxisSpacing: 0,
                                        crossAxisCount: 3,
                                        children: List.generate(
                                          freeIcons.length,
                                          (index) => HomeGridCards(
                                            gridItems: freeIcons[index],
                                            color: color[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 10),

                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Row(
                                    //     children: [
                                    //       SizedBox(
                                    //         width: 10.0,
                                    //       ),
                                    //       Text(
                                    //         'Business',
                                    //         style: GoogleFonts.poppins(
                                    //           color: Colors.black,
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 20.0,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Container(
                                    //   padding: EdgeInsets.all(10.0),
                                    //   child: GridView.count(
                                    //     physics: NeverScrollableScrollPhysics(),
                                    //     shrinkWrap: true,
                                    //     childAspectRatio: 1,
                                    //     crossAxisCount: 4,
                                    //     children: List.generate(
                                    //       businessIcons.length,
                                    //       (index) => HomeGridCards(
                                    //         gridItems: businessIcons[index],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),

                                    homePageImageProvider.when(data: (images) {
                                      if (images.isNotEmpty) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                lang.S.of(context).whatsNew,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    child: const Icon(Icons.keyboard_arrow_left),
                                                    onTap: () {
                                                      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
                                                    },
                                                  ),
                                                  Container(
                                                    height: 180,
                                                    width: 310,
                                                    padding: const EdgeInsets.all(10),
                                                    child: PageView.builder(
                                                      pageSnapping: true,
                                                      itemCount: images.length,
                                                      controller: pageController,
                                                      itemBuilder: (_, index) {
                                                        if (images[index].imageUrl.contains('https://firebasestorage.googleapis.com')) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              const PackageScreen().launch(context);
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(images[index].imageUrl))),
                                                            ),
                                                          );
                                                        } else {
                                                          YoutubePlayerController videoController = YoutubePlayerController(
                                                            flags: const YoutubePlayerFlags(
                                                              autoPlay: false,
                                                              mute: false,
                                                            ),
                                                            initialVideoId: images[index].imageUrl,
                                                          );
                                                          return YoutubePlayer(
                                                            controller: videoController,
                                                            showVideoProgressIndicator: true,
                                                            onReady: () {},
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child: const Icon(Icons.keyboard_arrow_right),
                                                    onTap: () {
                                                      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 30),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          padding: const EdgeInsets.all(10),
                                          height: 180,
                                          width: 320,
                                          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('image/banner1.png'))),
                                        );
                                      }
                                    }, error: (e, stack) {
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        height: 180,
                                        width: 320,
                                        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('image/banner1.png'))),
                                      );
                                    }, loading: () {
                                      return const CircularProgressIndicator();
                                    }),

                                    // ignore: sized_box_for_whitespace

                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Row(
                                    //     children: [
                                    //       SizedBox(
                                    //         width: 10.0,
                                    //       ),
                                    //       Text(
                                    //         'Enterprise',
                                    //         style: GoogleFonts.poppins(
                                    //           color: Colors.black,
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 20.0,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Container(
                                    //   padding: EdgeInsets.all(10.0),
                                    //   child: GridView.count(
                                    //     physics: NeverScrollableScrollPhysics(),
                                    //     shrinkWrap: true,
                                    //     childAspectRatio: 1,
                                    //     crossAxisCount: 4,
                                    //     children: List.generate(
                                    //       enterpriseIcons.length,
                                    //       (index) => HomeGridCards(
                                    //         gridItems: enterpriseIcons[index],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          }, error: (e, stack) {
            return Container(
              padding: const EdgeInsets.all(10),
              height: 180,
              width: 320,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('image/banner1.png'))),
            );
          }, loading: () {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }),
        );
      }),
    );
  }
}

class HomeGridCards extends StatefulWidget {
  const HomeGridCards({super.key, required this.gridItems, required this.color});

  final GridItems gridItems;
  final Color color;

  @override
  State<HomeGridCards> createState() => _HomeGridCardsState();
}

class _HomeGridCardsState extends State<HomeGridCards> {
  // Future<bool> subscriptionChecker({
  //   required String item,
  // }) async {
  //   final DatabaseReference subscriptionRef = FirebaseDatabase.instance.ref().child(constUserId).child('Subscription');
  //   DatabaseReference ref = FirebaseDatabase.instance.ref('$constUserId/Subscription');
  //   ref.keepSynced(true);
  //   subscriptionRef.keepSynced(true);
  //
  //   bool boolValue = true;
  //
  //   ref.get().then((value) async {
  //     final dataModel = SubscriptionModel.fromJson(jsonDecode(jsonEncode(value.value)));
  //     final remainTime = DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());
  //     for (var element in Subscription.subscriptionPlan) {
  //       if (dataModel.subscriptionName == element.subscriptionName) {
  //         if (remainTime.inHours.abs() > element.duration * 24) {
  //           Subscription.freeSubscriptionModel.subscriptionDate = DateTime.now().toString();
  //           subscriptionRef.set(Subscription.freeSubscriptionModel.toJson());
  //           final prefs = await SharedPreferences.getInstance();
  //           await prefs.setBool('isFiveDayRemainderShown', true);
  //         } else if (item == 'Sales' && dataModel.saleNumber <= 0 && dataModel.saleNumber != -202) {
  //           boolValue = false;
  //         } else if (item == 'Parties' && dataModel.partiesNumber <= 0 && dataModel.partiesNumber != -202) {
  //           boolValue = false;
  //         } else if (item == 'Purchase' && dataModel.purchaseNumber <= 0 && dataModel.purchaseNumber != -202) {
  //           boolValue = false;
  //         } else if (item == 'Products' && dataModel.products <= 0 && dataModel.products != -202) {
  //           boolValue = false;
  //         } else if (item == 'Due List' && dataModel.dueNumber <= 0 && dataModel.dueNumber != -202) {
  //           boolValue = false;
  //         }
  //       }
  //     }
  //   });
  //   return boolValue;
  // }

  Future<bool> checkUserRolePermission({required String type}) async {
    bool permission = true;

    if (isSubUser) {
      switch (type) {
        case 'Sales':
          permission = finalUserRoleModel.saleEdit ?? false;
          break;
        case 'Sale List':
          permission = finalUserRoleModel.salesListView ?? false;
          break;
        case "Expense":
          permission = finalUserRoleModel.addExpenseView ?? false;
          break;
        case "Due List":
          permission = finalUserRoleModel.dueListView ?? false;
          break;
        case "Loss/Profit":
          permission = finalUserRoleModel.lossProfitView ?? false;
          break;
        case 'Parties':
          permission = finalUserRoleModel.partiesView ?? false;
          break;
        case 'Product':
          permission = finalUserRoleModel.productView ?? false;
          break;
        case 'Purchase List':
          permission = finalUserRoleModel.purchaseListView ?? false;
          break;
        case 'Purchase':
          permission = finalUserRoleModel.purchaseEdit ?? false;
          break;
        case "Reports":
          permission = finalUserRoleModel.reportsView ?? false;
          break;
        case 'Stock List':
          permission = finalUserRoleModel.stockView ?? false;
          break;
        case 'profileEdit':
          permission = finalUserRoleModel.profileEditView ?? false;
          break;
        case 'hrm':
          permission = finalUserRoleModel.hrmView ?? false;
          break;
        case 'Quotation':
          permission = finalUserRoleModel.quotationView ?? false;
          break;
        default:
          permission = true;
          break;
      }
      if (permission) {
        return permission;
      } else {
        return permission;
      }
    } else {
      return true;
    }
  }

  // bool checkPermission({required String item}) {
  //   if (item == 'Sales' && finalUserRoleModel.salePermission) {
  //     return true;
  //   } else if (item == 'Parties' && finalUserRoleModel.partiesPermission) {
  //     return true;
  //   } else if (item == 'Purchase' && finalUserRoleModel.purchasePermission) {
  //     return true;
  //   } else if (item == 'Products' && finalUserRoleModel.productPermission) {
  //     return true;
  //   } else if (item == 'Due List' && finalUserRoleModel.dueListPermission) {
  //     return true;
  //   } else if (item == 'Stock' && finalUserRoleModel.stockPermission) {
  //     return true;
  //   } else if (item == 'Reports' && finalUserRoleModel.reportsPermission) {
  //     return true;
  //   } else if (item == 'Sales List' && finalUserRoleModel.salesListPermission) {
  //     return true;
  //   } else if (item == 'Purchase List' && finalUserRoleModel.purchaseListPermission) {
  //     return true;
  //   } else if (item == 'Loss/Profit' && finalUserRoleModel.lossProfitPermission) {
  //     return true;
  //   } else if (item == 'Expense' && finalUserRoleModel.addExpensePermission) {
  //     return true;
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Consumer(builder: (context, ref, __) {
      return Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                border: Border.all(
                  color: widget.color,
                )),
            child: TextButton(
              onPressed: () async {
                if (kDebugMode) {
                  print(widget.gridItems.title);
                }
                ref.refresh(customerProvider);
                ref.refresh(dueTransactionProvider);
                ref.refresh(purchaseTransitionProvider);
                ref.refresh(transitionProvider);
                isSubUser
                    ? await checkUserRolePermission(type: widget.gridItems.route)
                        ? await Subscription.subscriptionChecker(item: widget.gridItems.route)
                            ? Navigator.of(context).pushNamed('/${widget.gridItems.route}')
                            // : EasyLoading.showError('Update your plan first,\nyour limit is over.')
                            : EasyLoading.showError('${lang.S.of(context).updateYourPlanFirstYourLimitIsOver}.')
                        //: EasyLoading.showError('Sorry, you have no permission to access this service')
                        : EasyLoading.showError(lang.S.of(context).sorryYouHaveNoPermissionToAccessThisService)
                    : await Subscription.subscriptionChecker(item: widget.gridItems.route)
                        ? Navigator.of(context).pushNamed('/${widget.gridItems.route}')
                        //  : EasyLoading.showError('Update your plan first,\nyour limit is over.');
                        : EasyLoading.showError('${lang.S.of(context).updateYourPlanFirstYourLimitIsOver}.');
              },
              child: SvgPicture.asset(
                widget.gridItems.icon,
                height: 40.0,
                width: 40.0,
                allowDrawingOutsideViewBox: false,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            widget.gridItems.title.toString(),
            style: const TextStyle(fontSize: 13, color: Colors.black),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      );
    });
  }
}
