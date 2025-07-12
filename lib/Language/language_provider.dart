import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constant.dart';

final languageChangeProvider = ChangeNotifierProvider((ref) => LanguageChangeProvider());

class LanguageChangeProvider with ChangeNotifier {
  Locale _currentLocale = const Locale("en");

  Locale get currentLocale => _currentLocale;

  void changeLocale(String locale) {
    _currentLocale = Locale(locale);
    currentLanguage = locale;
    notifyListeners();
  }
}
