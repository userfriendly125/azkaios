import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/constant.dart';

import '../../currency.dart';

// ignore: must_be_immutable
class InvoicePrint extends StatefulWidget {
  const InvoicePrint({super.key, required this.printSize, required this.onUpdate});
  final String printSize;
  final Function() onUpdate;
  @override
  // ignore: library_private_types_in_public_api
  _InvoicePrintState createState() => _InvoicePrintState();
}

class _InvoicePrintState extends State<InvoicePrint> {
  String pageSize = '3 Inch (80 mm)';

  @override
  void initState() {
    // Initialize the page size based on the passed printSize or default to '3 Inch (80 mm)'
    pageSize = widget.printSize.isNotEmpty ? widget.printSize : '3 Inch (80 mm)';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        title: Text(
          "Invoice Print",
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
                    Text("Thermal Printer Page Size:",
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: 12.0,
                        )),
                    const Spacer(),
                    //A DropdownButtom<String> for selecting the page size ( 3 Inch (80 mm) or 2 Inch (58 mm) ) without any border just the dropdown icon and underline
                    DropdownButton<String>(
                      value: pageSize,
                      items: const [
                        DropdownMenuItem(value: '3 Inch (80 mm)', child: Text('3 Inch (80 mm)')),
                        DropdownMenuItem(value: '2 Inch (58 mm)', child: Text('2 Inch (58 mm)')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          pageSize = value!;
                        });
                        //Update the page size in firebase
                        final DatabaseReference personalInformationRef = FirebaseDatabase.instance
                            // ignore: deprecated_member_use
                            .ref()
                            .child(constUserId)
                            .child('Personal Information');
                        personalInformationRef.keepSynced(true);
                        personalInformationRef.update({
                          "thermalPrinterPrintSize": pageSize,
                        });
                        widget.onUpdate(); // Call the onUpdate function to notify the parent widget
                      },
                      underline: Container(
                        height: 1,
                        color: kGreyTextColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
