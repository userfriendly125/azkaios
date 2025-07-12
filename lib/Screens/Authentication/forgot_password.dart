import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import 'login_form.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool showProgress = false;
  late String email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  lang.S.of(context).forgotPassword,
                  style: GoogleFonts.poppins(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    lang.S.of(context).pleaseEnterTheEmailAddressBelowToRecive,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: kGreyTextColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppTextField(
                    textFieldType: TextFieldType.EMAIL,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: InputDecoration(labelText: lang.S.of(context).emailAddress, border: const OutlineInputBorder(), floatingLabelBehavior: FloatingLabelBehavior.always, hintText: 'example@example.com'),
                  ),
                ),
                ButtonGlobal(
                    buttontext: lang.S.of(context).sendResetLink,
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () async {
                      EasyLoading.show(status: 'Sending Email...');
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: email,
                        );
                        EasyLoading.showSuccess('Check your Inbox');
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text('Check your Inbox'),
                        //     duration: Duration(seconds: 3),
                        //   ),
                        // );
                        if (!mounted) return;
                        const LoginForm().launch(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              //content: Text('No user found for that email.'),
                              content: Text(lang.S.of(context).noUserFoundForThatEmail),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              //content: Text('Wrong password provided for that user.'),
                              content: Text(lang.S.of(context).wrongPasswordProvidedforThatUser),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    iconWidget: null,
                    iconColor: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
