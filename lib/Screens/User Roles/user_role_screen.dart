import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/user_role_provider.dart';
import '../../constant.dart';
import 'add_user_role_screen.dart';

class UserRoleScreen extends StatefulWidget {
  const UserRoleScreen({super.key});

  @override
  State<UserRoleScreen> createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends State<UserRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final userRoleData = ref.watch(userRoleProvider);
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            lang.S.of(context).userRole,
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
            child: userRoleData.when(data: (users) {
              if (users.isNotEmpty) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          AddUserRole(
                            userRoleModel: users[index],
                          ).launch(context);
                        },
                        title: Text(users[index].email ?? ''),
                        subtitle: Text(users[index].userTitle ?? ''),
                        trailing: const Icon(
                          (Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text(lang.S.of(context).noUserRoleFound));
              }
            }, error: (e, stack) {
              return Text(e.toString());
            }, loading: () {
              return const Center(child: CircularProgressIndicator());
            }),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ButtonGlobalWithoutIcon(
            buttonSize: 48,
            buttonTextSize: 18,
            onPressed: () {
              AddUserRole().launch(context);
            },
            buttontext: lang.S.of(context).addUserRole,
            buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
            buttonTextColor: Colors.white,
          ),
        ),
      );
    });
  }
}
