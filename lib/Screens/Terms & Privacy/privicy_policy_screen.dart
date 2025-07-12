import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Provider/terms_and_privacy_provider.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class PrivicyPolicyScreen extends StatefulWidget {
  const PrivicyPolicyScreen({super.key});

  @override
  State<PrivicyPolicyScreen> createState() => _PrivicyPolicyScreenState();
}

class _PrivicyPolicyScreenState extends State<PrivicyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: kWhite),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          lang.S.of(context).privacyPolicy,
          //'Privacy Policy',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: kWhite),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Consumer(builder: (context, ref, __) {
              final provider = ref.watch(privacyProvider);
              return provider.when(
                data: (data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        data.title,
                        style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data.description,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) {
                  return Center(child: Text(lang.S.of(context).noDataFound));
                },
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            }),
          ),
        ),
      ),
    );
  }
}
