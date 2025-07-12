import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/Model/category_model.dart';
import 'package:mobile_pos/Screens/Products/add_category.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import '../../currency.dart';

// ignore: must_be_immutable
class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        title: Text(
          lang.S.of(context).categories,
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
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: lang.S.of(context).search,
                          prefixIcon: Icon(
                            Icons.search,
                            color: kGreyTextColor.withOpacity(0.5),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          const AddCategory().launch(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: kGreyTextColor),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: kGreyTextColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                  ],
                ),
                SingleChildScrollView(
                  child: FirebaseAnimatedList(
                    controller: ScrollController(keepScrollOffset: false),
                    defaultChild: Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                      child: Loader(
                        color: Colors.white.withOpacity(0.2),
                        size: 60,
                      ),
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    query: FirebaseDatabase.instance
                        // ignore: deprecated_member_use
                        .ref()
                        .child(constUserId)
                        .child('Categories'),
                    itemBuilder: (context, snapshot, animation, index) {
                      final json = snapshot.value as Map<dynamic, dynamic>;
                      final title = CategoryModel.fromJson(json);
                      final List<String> variations = [];
                      title.size ? variations.add('Size') : null;
                      title.color ? variations.add('Color') : null;
                      title.capacity ? variations.add('Capacity') : null;
                      title.type ? variations.add('Type') : null;
                      title.weight ? variations.add('Weight') : null;

                      GetCategoryAndVariationModel get = GetCategoryAndVariationModel(categoryName: title.categoryName, variations: variations);

                      return title.categoryName.contains(search)
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title.categoryName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                          width: context.width(),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: variations.length,
                                              itemBuilder: (context, index) {
                                                return Text(
                                                  '${variations[index]}, ',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14.0,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ButtonGlobalWithoutIcon(
                                      buttontext: lang.S.of(context).select,
                                      buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: BorderRadius.circular(50.0)),
                                      onPressed: () {
                                        Navigator.pop(context, get);
                                      },
                                      buttonTextColor: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        AddCategory(
                                          isEdit: true,
                                          categoryModel: title,
                                        ).launch(context);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: kMainColor,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        //Confirmation Dialog
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Delete Category",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              content: Text(
                                                "Are you sure you want to delete this category?",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    lang.S.of(context).cancel,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    //Check if any product is using this category
                                                    // ignore: deprecated_member_use
                                                    FirebaseDatabase.instance
                                                        // ignore: deprecated_member_use
                                                        .ref()
                                                        .child(constUserId)
                                                        .child('Products')
                                                        .orderByChild('category')
                                                        .equalTo(title.categoryName)
                                                        .once()
                                                        .then((val) {
                                                      if (val.snapshot.value != null) {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text('This category is being used by some products'),
                                                        ));
                                                      } else {
                                                        FirebaseDatabase.instance.ref().child(constUserId).child('Categories').orderByChild('categoryName').equalTo(title.categoryName).once().then((DatabaseEvent event) {
                                                          if (event.snapshot.value != null) {
                                                            Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
                                                            values.forEach((key, value) {
                                                              FirebaseDatabase.instance.ref().child(constUserId).child('Categories').child(key).remove();
                                                            });
                                                          }
                                                        });
                                                        Navigator.pop(context);
                                                        EasyLoading.showSuccess('Deleted Successfully');
                                                        setState(() {});
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    lang.S.of(context).delete,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.redAccent,
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      )),
                                ],
                              ),
                            )
                          : Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
