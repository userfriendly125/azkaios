// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Shop Address`
  String get shopAddress {
    return Intl.message(
      'Shop Address',
      name: 'shopAddress',
      desc: '',
      args: [],
    );
  }

  /// `Net Payable Amount`
  String get netPayableAmount {
    return Intl.message(
      'Net Payable Amount',
      name: 'netPayableAmount',
      desc: '',
      args: [],
    );
  }

  /// `Received Amount`
  String get receivedAmount {
    return Intl.message(
      'Received Amount',
      name: 'receivedAmount',
      desc: '',
      args: [],
    );
  }

  /// `Due Description`
  String get dueDescription {
    return Intl.message(
      'Due Description',
      name: 'dueDescription',
      desc: '',
      args: [],
    );
  }

  /// `Vat`
  String get vat {
    return Intl.message(
      'Vat',
      name: 'vat',
      desc: '',
      args: [],
    );
  }

  /// `Sales Invoice`
  String get salesInvoice {
    return Intl.message(
      'Sales Invoice',
      name: 'salesInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard Overview`
  String get dashBoardOverView {
    return Intl.message(
      'Dashboard Overview',
      name: 'dashBoardOverView',
      desc: '',
      args: [],
    );
  }

  /// `Sale & Purchase Reports`
  String get salesAndPurchaseReports {
    return Intl.message(
      'Sale & Purchase Reports',
      name: 'salesAndPurchaseReports',
      desc: '',
      args: [],
    );
  }

  /// `Acceptance of Terms`
  String get acceptanceOfTerms {
    return Intl.message(
      'Acceptance of Terms',
      name: 'acceptanceOfTerms',
      desc: '',
      args: [],
    );
  }

  /// `By accessing or using the Point of Sale (POS) System (the "System") provided by [Your Company Name] ("Company"), you agree to be bound by these Terms of Use. If you do not agree to these Terms of Use, do not use the System.`
  String get byAccessingOrUsingThePointOfSales {
    return Intl.message(
      'By accessing or using the Point of Sale (POS) System (the "System") provided by [Your Company Name] ("Company"), you agree to be bound by these Terms of Use. If you do not agree to these Terms of Use, do not use the System.',
      name: 'byAccessingOrUsingThePointOfSales',
      desc: '',
      args: [],
    );
  }

  /// `Use of the system`
  String get useOfTheSystem {
    return Intl.message(
      'Use of the system',
      name: 'useOfTheSystem',
      desc: '',
      args: [],
    );
  }

  /// `(a) The System is provided solely for the\npurpose of facilitating point of sale\ntransactions andrelatedactivities in your\nbusiness.`
  String get aTheSystemIsProvided {
    return Intl.message(
      '(a) The System is provided solely for the\npurpose of facilitating point of sale\ntransactions andrelatedactivities in your\nbusiness.',
      name: 'aTheSystemIsProvided',
      desc: '',
      args: [],
    );
  }

  /// `(b) You must be at least 18 years old or the\nlegal age of majority in your jurisdiction to\nuse the System.`
  String get bYouMustBeAtLeastYearsOld {
    return Intl.message(
      '(b) You must be at least 18 years old or the\nlegal age of majority in your jurisdiction to\nuse the System.',
      name: 'bYouMustBeAtLeastYearsOld',
      desc: '',
      args: [],
    );
  }

  /// `(c) You are responsible for ensuring that your\naccess to and use of the System is in\ncompliance with all applicable laws and\nregulations.`
  String get cYouHaveResponsiveForEnsuring {
    return Intl.message(
      '(c) You are responsible for ensuring that your\naccess to and use of the System is in\ncompliance with all applicable laws and\nregulations.',
      name: 'cYouHaveResponsiveForEnsuring',
      desc: '',
      args: [],
    );
  }

  /// `Account Registration`
  String get accountRegistration {
    return Intl.message(
      'Account Registration',
      name: 'accountRegistration',
      desc: '',
      args: [],
    );
  }

  /// `(a) To use the System, you may be\nrequired to create an account. You\nagree to provide accurate, current, and\ncomplete information during\nthe registration process and toupdate\nsuchinformationto keep itaccurate\nand complete.`
  String get aToUseTheSystem {
    return Intl.message(
      '(a) To use the System, you may be\nrequired to create an account. You\nagree to provide accurate, current, and\ncomplete information during\nthe registration process and toupdate\nsuchinformationto keep itaccurate\nand complete.',
      name: 'aToUseTheSystem',
      desc: '',
      args: [],
    );
  }

  /// `(b) You are responsible for\nmaintainingthe confidentiality of your\naccount and password andfor restricting\naccess to your account. You accept\nresponsibility for all activities that\noccur under your account.`
  String get bYouHaveResponsiveFor {
    return Intl.message(
      '(b) You are responsible for\nmaintainingthe confidentiality of your\naccount and password andfor restricting\naccess to your account. You accept\nresponsibility for all activities that\noccur under your account.',
      name: 'bYouHaveResponsiveFor',
      desc: '',
      args: [],
    );
  }

  /// `How We Use Your Information`
  String get howWeUseYourInformation {
    return Intl.message(
      'How We Use Your Information',
      name: 'howWeUseYourInformation',
      desc: '',
      args: [],
    );
  }

  /// `We use your personal information to provide you with the best possible experience on our app, including to personalize your content recomme ndations, connect you with experts, and improve our apps functionality. We may also use your information to communicate with you about updates, promotions, or other information related to our app.`
  String get weUseYourPersonalInformation {
    return Intl.message(
      'We use your personal information to provide you with the best possible experience on our app, including to personalize your content recomme ndations, connect you with experts, and improve our apps functionality. We may also use your information to communicate with you about updates, promotions, or other information related to our app.',
      name: 'weUseYourPersonalInformation',
      desc: '',
      args: [],
    );
  }

  /// `How We Protect Your Information`
  String get howWeProtectYourInformation {
    return Intl.message(
      'How We Protect Your Information',
      name: 'howWeProtectYourInformation',
      desc: '',
      args: [],
    );
  }

  /// `We take industry-standard measures to protect your personal information, including encryption and secure storage. We also limit access to your information to authorized personnel only.`
  String get weTakeIndustryStandard {
    return Intl.message(
      'We take industry-standard measures to protect your personal information, including encryption and secure storage. We also limit access to your information to authorized personnel only.',
      name: 'weTakeIndustryStandard',
      desc: '',
      args: [],
    );
  }

  /// `Third-Party Services`
  String get thirdPartyServices {
    return Intl.message(
      'Third-Party Services',
      name: 'thirdPartyServices',
      desc: '',
      args: [],
    );
  }

  /// `We may use third-party services to support our app's functionality, such as analytics providers and payment processors. These third-party services may collect information about you when you use our app. Please note that we are not responsible for the privacy practices of these third-party services.`
  String get weMayUseThirdPartyServicesToSupport {
    return Intl.message(
      'We may use third-party services to support our app\'s functionality, such as analytics providers and payment processors. These third-party services may collect information about you when you use our app. Please note that we are not responsible for the privacy practices of these third-party services.',
      name: 'weMayUseThirdPartyServicesToSupport',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `POS that contains a great deal of functionality, including sales tracking, inventory management.`
  String get onboardOne {
    return Intl.message(
      'POS that contains a great deal of functionality, including sales tracking, inventory management.',
      name: 'onboardOne',
      desc: '',
      args: [],
    );
  }

  /// `Our POS system should simplify daily operations automatically, making it easy to navigate.`
  String get onboardTwo {
    return Intl.message(
      'Our POS system should simplify daily operations automatically, making it easy to navigate.',
      name: 'onboardTwo',
      desc: '',
      args: [],
    );
  }

  /// `This system helps you improve your operations for your customers.`
  String get onboardThree {
    return Intl.message(
      'This system helps you improve your operations for your customers.',
      name: 'onboardThree',
      desc: '',
      args: [],
    );
  }

  /// `User Role`
  String get userRole {
    return Intl.message(
      'User Role',
      name: 'userRole',
      desc: '',
      args: [],
    );
  }

  /// `No User Role Found`
  String get noUserRoleFound {
    return Intl.message(
      'No User Role Found',
      name: 'noUserRoleFound',
      desc: '',
      args: [],
    );
  }

  /// `Add User Role`
  String get addUserRole {
    return Intl.message(
      'Add User Role',
      name: 'addUserRole',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Profile Edit`
  String get profileEdit {
    return Intl.message(
      'Profile Edit',
      name: 'profileEdit',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `User Title`
  String get UserTitle {
    return Intl.message(
      'User Title',
      name: 'UserTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter user title`
  String get enterUserTitle {
    return Intl.message(
      'Enter user title',
      name: 'enterUserTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `User Title`
  String get userTitle {
    return Intl.message(
      'User Title',
      name: 'userTitle',
      desc: '',
      args: [],
    );
  }

  /// `Added Successful`
  String get addSuccessful {
    return Intl.message(
      'Added Successful',
      name: 'addSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `You have to RE-LOGIN on your account.`
  String get youHaveToReLogin {
    return Intl.message(
      'You have to RE-LOGIN on your account.',
      name: 'youHaveToReLogin',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Pay Cash`
  String get payCash {
    return Intl.message(
      'Pay Cash',
      name: 'payCash',
      desc: '',
      args: [],
    );
  }

  /// `Free Lifetime Update`
  String get freeLifeTimeUpdate {
    return Intl.message(
      'Free Lifetime Update',
      name: 'freeLifeTimeUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Android & iOS App Support`
  String get androidIOSAppSupport {
    return Intl.message(
      'Android & iOS App Support',
      name: 'androidIOSAppSupport',
      desc: '',
      args: [],
    );
  }

  /// `Premium Customer Support`
  String get premiumCustomerSupport {
    return Intl.message(
      'Premium Customer Support',
      name: 'premiumCustomerSupport',
      desc: '',
      args: [],
    );
  }

  /// `Custom Invoice Branding`
  String get customInvoiceBranding {
    return Intl.message(
      'Custom Invoice Branding',
      name: 'customInvoiceBranding',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited Usage`
  String get unlimitedUsage {
    return Intl.message(
      'Unlimited Usage',
      name: 'unlimitedUsage',
      desc: '',
      args: [],
    );
  }

  /// `Free Data Backup`
  String get freeDataBackup {
    return Intl.message(
      'Free Data Backup',
      name: 'freeDataBackup',
      desc: '',
      args: [],
    );
  }

  /// `Stay at the forefront of technological advancements without any extra costs. Our Pos Saas POS Unlimited Upgrade ensures that you always have the latest tools and features at your fingertips, guaranteeing your business remains cutting-edge.`
  String get stayAtTheForFront {
    return Intl.message(
      'Stay at the forefront of technological advancements without any extra costs. Our Pos Saas POS Unlimited Upgrade ensures that you always have the latest tools and features at your fingertips, guaranteeing your business remains cutting-edge.',
      name: 'stayAtTheForFront',
      desc: '',
      args: [],
    );
  }

  /// ` We understand the importance of seamless operations. That's why our round-the-clock support is available to assist you, whether it's a quick query or a comprehensive concern. Connect with us anytime, anywhere via call or WhatsApp to experience unrivaled customer service.`
  String get weUnderStand {
    return Intl.message(
      ' We understand the importance of seamless operations. That\'s why our round-the-clock support is available to assist you, whether it\'s a quick query or a comprehensive concern. Connect with us anytime, anywhere via call or WhatsApp to experience unrivaled customer service.',
      name: 'weUnderStand',
      desc: '',
      args: [],
    );
  }

  /// `Unlock the full potential of Pos Saas POS with personalized training sessions led by our expert team. From the basics to advanced techniques, we ensure you're well-versed in utilizing every facet of the system to optimize your business processes.`
  String get unlockTheFull {
    return Intl.message(
      'Unlock the full potential of Pos Saas POS with personalized training sessions led by our expert team. From the basics to advanced techniques, we ensure you\'re well-versed in utilizing every facet of the system to optimize your business processes.',
      name: 'unlockTheFull',
      desc: '',
      args: [],
    );
  }

  /// `Make a lasting impression on your customers with branded invoices. Our Unlimited Upgrade offers the unique advantage of customizing your invoices, adding a professional touch that reinforces your brand identity and fosters customer loyalty.`
  String get makeALastingImpression {
    return Intl.message(
      'Make a lasting impression on your customers with branded invoices. Our Unlimited Upgrade offers the unique advantage of customizing your invoices, adding a professional touch that reinforces your brand identity and fosters customer loyalty.',
      name: 'makeALastingImpression',
      desc: '',
      args: [],
    );
  }

  /// `The name says it all. With Pos Saas POS Unlimited, there's no cap on your usage. Whether you're processing a handful of transactions or experiencing a rush of customers, you can operate with confidence, knowing you're not constrained by limits`
  String get theNameSysIt {
    return Intl.message(
      'The name says it all. With Pos Saas POS Unlimited, there\'s no cap on your usage. Whether you\'re processing a handful of transactions or experiencing a rush of customers, you can operate with confidence, knowing you\'re not constrained by limits',
      name: 'theNameSysIt',
      desc: '',
      args: [],
    );
  }

  /// `Safeguard your business data effortlessly. Our Pos Saas POS Unlimited Upgrade includes free data backup, ensuring your valuable information is protected against any unforeseen events. Focus on what truly matters - your business growth.`
  String get safeGuardYourBusinessDate {
    return Intl.message(
      'Safeguard your business data effortlessly. Our Pos Saas POS Unlimited Upgrade includes free data backup, ensuring your valuable information is protected against any unforeseen events. Focus on what truly matters - your business growth.',
      name: 'safeGuardYourBusinessDate',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy {
    return Intl.message(
      'Buy',
      name: 'buy',
      desc: '',
      args: [],
    );
  }

  /// `Bank Information`
  String get bankInformation {
    return Intl.message(
      'Bank Information',
      name: 'bankInformation',
      desc: '',
      args: [],
    );
  }

  /// `Bank Name`
  String get bankName {
    return Intl.message(
      'Bank Name',
      name: 'bankName',
      desc: '',
      args: [],
    );
  }

  /// `Branch Name`
  String get branchName {
    return Intl.message(
      'Branch Name',
      name: 'branchName',
      desc: '',
      args: [],
    );
  }

  /// `Account Name`
  String get accountName {
    return Intl.message(
      'Account Name',
      name: 'accountName',
      desc: '',
      args: [],
    );
  }

  /// `Account Number`
  String get accountNumber {
    return Intl.message(
      'Account Number',
      name: 'accountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Bank Account Currency`
  String get bankAccountingCurrecny {
    return Intl.message(
      'Bank Account Currency',
      name: 'bankAccountingCurrecny',
      desc: '',
      args: [],
    );
  }

  /// `SWIFT Code`
  String get swiftCode {
    return Intl.message(
      'SWIFT Code',
      name: 'swiftCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter Transaction Id`
  String get enterTransactionId {
    return Intl.message(
      'Enter Transaction Id',
      name: 'enterTransactionId',
      desc: '',
      args: [],
    );
  }

  /// `Upload Document`
  String get uploadDocument {
    return Intl.message(
      'Upload Document',
      name: 'uploadDocument',
      desc: '',
      args: [],
    );
  }

  /// `Upload File`
  String get uploadFile {
    return Intl.message(
      'Upload File',
      name: 'uploadFile',
      desc: '',
      args: [],
    );
  }

  /// `About App`
  String get aboutApp {
    return Intl.message(
      'About App',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Terms of use`
  String get termsOfUse {
    return Intl.message(
      'Terms of use',
      name: 'termsOfUse',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `User Role Details`
  String get userRoleDetails {
    return Intl.message(
      'User Role Details',
      name: 'userRoleDetails',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Increase Stock`
  String get increaseStock {
    return Intl.message(
      'Increase Stock',
      name: 'increaseStock',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Due Collection Reports`
  String get dueCollectionReports {
    return Intl.message(
      'Due Collection Reports',
      name: 'dueCollectionReports',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Reports`
  String get purchaseReportss {
    return Intl.message(
      'Purchase Reports',
      name: 'purchaseReportss',
      desc: '',
      args: [],
    );
  }

  /// `Sale Reports`
  String get saleReportss {
    return Intl.message(
      'Sale Reports',
      name: 'saleReportss',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get order {
    return Intl.message(
      'Orders',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Revenue`
  String get revenue {
    return Intl.message(
      'Revenue',
      name: 'revenue',
      desc: '',
      args: [],
    );
  }

  /// `Powered By Pos Saas`
  String get powerdedByMobiPos {
    return Intl.message(
      'Powered By Pos Saas',
      name: 'powerdedByMobiPos',
      desc: '',
      args: [],
    );
  }

  /// `Parties`
  String get parties {
    return Intl.message(
      'Parties',
      name: 'parties',
      desc: '',
      args: [],
    );
  }

  /// `Stock List`
  String get stockList {
    return Intl.message(
      'Stock List',
      name: 'stockList',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get expense {
    return Intl.message(
      'Expense',
      name: 'expense',
      desc: '',
      args: [],
    );
  }

  /// `You Have Got An Email`
  String get youHaveGotAnEmail {
    return Intl.message(
      'You Have Got An Email',
      name: 'youHaveGotAnEmail',
      desc: '',
      args: [],
    );
  }

  /// `We Have Send An Email with instructions on how to reset password to:`
  String get weHaveSendAnEmailwithInstructions {
    return Intl.message(
      'We Have Send An Email with instructions on how to reset password to:',
      name: 'weHaveSendAnEmailwithInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Check Email`
  String get checkEmail {
    return Intl.message(
      'Check Email',
      name: 'checkEmail',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get otp {
    return Intl.message(
      'Close',
      name: 'otp',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address below to receive password Reset Link.`
  String get pleaseEnterTheEmailAddressBelowToRecive {
    return Intl.message(
      'Please enter your email address below to receive password Reset Link.',
      name: 'pleaseEnterTheEmailAddressBelowToRecive',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `No user found for that email.`
  String get noUserFoundForThatEmail {
    return Intl.message(
      'No user found for that email.',
      name: 'noUserFoundForThatEmail',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password provided for that user.`
  String get wrongPasswordProvidedforThatUser {
    return Intl.message(
      'Wrong password provided for that user.',
      name: 'wrongPasswordProvidedforThatUser',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email Address`
  String get enterYourEmailAddress {
    return Intl.message(
      'Enter Your Email Address',
      name: 'enterYourEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get pleaseEnterAPassword {
    return Intl.message(
      'Please enter a password',
      name: 'pleaseEnterAPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPasswords {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPasswords',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get login {
    return Intl.message(
      'Log In',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Haven't any account?`
  String get havenotAnAccounts {
    return Intl.message(
      'Haven\'t any account?',
      name: 'havenotAnAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Manage your business with `
  String get manageYourBussinessWith {
    return Intl.message(
      'Manage your business with ',
      name: 'manageYourBussinessWith',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Start typing to search`
  String get startTypingToSearch {
    return Intl.message(
      'Start typing to search',
      name: 'startTypingToSearch',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterYourNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourNumber',
      desc: '',
      args: [],
    );
  }

  /// `Get Otp`
  String get getOtp {
    return Intl.message(
      'Get Otp',
      name: 'getOtp',
      desc: '',
      args: [],
    );
  }

  /// `No Connection`
  String get noConnection {
    return Intl.message(
      'No Connection',
      name: 'noConnection',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connectivity`
  String get pleaseCheckYourInternetConnectivity {
    return Intl.message(
      'Please check your internet connectivity',
      name: 'pleaseCheckYourInternetConnectivity',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message(
      'Try Again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Verifying OTP`
  String get verifyOtp {
    return Intl.message(
      'Verifying OTP',
      name: 'verifyOtp',
      desc: '',
      args: [],
    );
  }

  /// `Change?`
  String get change {
    return Intl.message(
      'Change?',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP : `
  String get resendOtp {
    return Intl.message(
      'Resend OTP : ',
      name: 'resendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message(
      'Resend Code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify Phone Number`
  String get verifyPhoneNumber {
    return Intl.message(
      'Verify Phone Number',
      name: 'verifyPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Setup Your Profile`
  String get setUpYourProfile {
    return Intl.message(
      'Setup Your Profile',
      name: 'setUpYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Update your profile to connect your doctor with better impression`
  String get updateYourProfileToConnect {
    return Intl.message(
      'Update your profile to connect your doctor with better impression',
      name: 'updateYourProfileToConnect',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallary {
    return Intl.message(
      'Gallery',
      name: 'gallary',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Business Category`
  String get businessCategory {
    return Intl.message(
      'Business Category',
      name: 'businessCategory',
      desc: '',
      args: [],
    );
  }

  /// `Company & Shop Name`
  String get companyAndShopName {
    return Intl.message(
      'Company & Shop Name',
      name: 'companyAndShopName',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Phone Number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter Phone Number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Company Address`
  String get companyAddress {
    return Intl.message(
      'Company Address',
      name: 'companyAddress',
      desc: '',
      args: [],
    );
  }

  /// `Enter Full Address`
  String get enterFullAddress {
    return Intl.message(
      'Enter Full Address',
      name: 'enterFullAddress',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Opening Balance `
  String get openingBalance {
    return Intl.message(
      'Opening Balance ',
      name: 'openingBalance',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continu {
    return Intl.message(
      'Continue',
      name: 'continu',
      desc: '',
      args: [],
    );
  }

  /// `Create a Free Account`
  String get createAFreeAccounts {
    return Intl.message(
      'Create a Free Account',
      name: 'createAFreeAccounts',
      desc: '',
      args: [],
    );
  }

  /// `LogIn`
  String get logIn {
    return Intl.message(
      'LogIn',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations`
  String get congratulations {
    return Intl.message(
      'Congratulations',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `You are successfully login into your account. Stay with Pos Saas .`
  String get youHaveSuccefulyLogin {
    return Intl.message(
      'You are successfully login into your account. Stay with Pos Saas .',
      name: 'youHaveSuccefulyLogin',
      desc: '',
      args: [],
    );
  }

  /// `Add Contact`
  String get addContact {
    return Intl.message(
      'Add Contact',
      name: 'addContact',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Phone Number`
  String get enterYourPhoneNumber {
    return Intl.message(
      'Enter Your Phone Number',
      name: 'enterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Name.`
  String get name {
    return Intl.message(
      'Enter Your Name.',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Enter Amount.`
  String get enterAmount {
    return Intl.message(
      'Enter Amount.',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Retailer`
  String get retailer {
    return Intl.message(
      'Retailer',
      name: 'retailer',
      desc: '',
      args: [],
    );
  }

  /// `Dealer`
  String get dealer {
    return Intl.message(
      'Dealer',
      name: 'dealer',
      desc: '',
      args: [],
    );
  }

  /// `Wholesaler`
  String get wholSeller {
    return Intl.message(
      'Wholesaler',
      name: 'wholSeller',
      desc: '',
      args: [],
    );
  }

  /// `Supplier`
  String get supplier {
    return Intl.message(
      'Supplier',
      name: 'supplier',
      desc: '',
      args: [],
    );
  }

  /// `More Info`
  String get moreInfo {
    return Intl.message(
      'More Info',
      name: 'moreInfo',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Enter Address`
  String get enterAddress {
    return Intl.message(
      'Enter Address',
      name: 'enterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Customer Details`
  String get customerDetails {
    return Intl.message(
      'Customer Details',
      name: 'customerDetails',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this user?`
  String get areYourSureDeleteThisUser {
    return Intl.message(
      'Are you sure to delete this user?',
      name: 'areYourSureDeleteThisUser',
      desc: '',
      args: [],
    );
  }

  /// `The user will be deleted and all the data will be deleted from your account.Are you sure to delete this?`
  String get theUserWillBe {
    return Intl.message(
      'The user will be deleted and all the data will be deleted from your account.Are you sure to delete this?',
      name: 'theUserWillBe',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cacel {
    return Intl.message(
      'Cancel',
      name: 'cacel',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Delete Forever`
  String get yesDeleteForever {
    return Intl.message(
      'Yes, Delete Forever',
      name: 'yesDeleteForever',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message(
      'Call',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Recent Transactions`
  String get recentTransactions {
    return Intl.message(
      'Recent Transactions',
      name: 'recentTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Click to connect`
  String get clickToConnect {
    return Intl.message(
      'Click to connect',
      name: 'clickToConnect',
      desc: '',
      args: [],
    );
  }

  /// `Please connect your bluetooth Printer`
  String get pleaseConnectYourBluttothPrinter {
    return Intl.message(
      'Please connect your bluetooth Printer',
      name: 'pleaseConnectYourBluttothPrinter',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Parties List`
  String get partiesList {
    return Intl.message(
      'Parties List',
      name: 'partiesList',
      desc: '',
      args: [],
    );
  }

  /// `Party Name`
  String get partyName {
    return Intl.message(
      'Party Name',
      name: 'partyName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Party Name`
  String get enterPartyName {
    return Intl.message(
      'Enter Party Name',
      name: 'enterPartyName',
      desc: '',
      args: [],
    );
  }

  /// `Due`
  String get due {
    return Intl.message(
      'Due',
      name: 'due',
      desc: '',
      args: [],
    );
  }

  /// `Update Contact`
  String get updateContact {
    return Intl.message(
      'Update Contact',
      name: 'updateContact',
      desc: '',
      args: [],
    );
  }

  /// `Supplier`
  String get upplier {
    return Intl.message(
      'Supplier',
      name: 'upplier',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Name`
  String get enterYourName {
    return Intl.message(
      'Enter Your Name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Bangladesh`
  String get bangladesh {
    return Intl.message(
      'Bangladesh',
      name: 'bangladesh',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get noDataAvailable {
    return Intl.message(
      'No data available',
      name: 'noDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Add Delivery`
  String get addDelivery {
    return Intl.message(
      'Add Delivery',
      name: 'addDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Due List`
  String get dueList {
    return Intl.message(
      'Due List',
      name: 'dueList',
      desc: '',
      args: [],
    );
  }

  /// `Due Collection`
  String get dueCollection {
    return Intl.message(
      'Due Collection',
      name: 'dueCollection',
      desc: '',
      args: [],
    );
  }

  /// `Due Amount: `
  String get dueAmount {
    return Intl.message(
      'Due Amount: ',
      name: 'dueAmount',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Paid Amount`
  String get paidAmount {
    return Intl.message(
      'Paid Amount',
      name: 'paidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Payment Type`
  String get paymentType {
    return Intl.message(
      'Payment Type',
      name: 'paymentType',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get describtion {
    return Intl.message(
      'Description',
      name: 'describtion',
      desc: '',
      args: [],
    );
  }

  /// `Add note`
  String get addDescription {
    return Intl.message(
      'Add note',
      name: 'addDescription',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter A Confirm Password`
  String get pleaseEnterAConfirmPassword {
    return Intl.message(
      'Please Enter A Confirm Password',
      name: 'pleaseEnterAConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already Have An Accounts`
  String get alreadyHaveAnAccounts {
    return Intl.message(
      'Already Have An Accounts',
      name: 'alreadyHaveAnAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Add Customer`
  String get addCustomer {
    return Intl.message(
      'Add Customer',
      name: 'addCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Customer Name`
  String get customerName {
    return Intl.message(
      'Customer Name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Add Note`
  String get addNote {
    return Intl.message(
      'Add Note',
      name: 'addNote',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense`
  String get addExpense {
    return Intl.message(
      'Add Expense',
      name: 'addExpense',
      desc: '',
      args: [],
    );
  }

  /// `Expense Date`
  String get expenseDate {
    return Intl.message(
      'Expense Date',
      name: 'expenseDate',
      desc: '',
      args: [],
    );
  }

  /// `Enter Expense Date`
  String get enterExpenseDate {
    return Intl.message(
      'Enter Expense Date',
      name: 'enterExpenseDate',
      desc: '',
      args: [],
    );
  }

  /// `Expense For`
  String get expenseFor {
    return Intl.message(
      'Expense For',
      name: 'expenseFor',
      desc: '',
      args: [],
    );
  }

  /// `Enter Name`
  String get enterName {
    return Intl.message(
      'Enter Name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Reference Number`
  String get referenceNumber {
    return Intl.message(
      'Reference Number',
      name: 'referenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Reference Number`
  String get enterReferenceNumber {
    return Intl.message(
      'Enter Reference Number',
      name: 'enterReferenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Enter Note`
  String get enterNote {
    return Intl.message(
      'Enter Note',
      name: 'enterNote',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense Category`
  String get addExpenseCategory {
    return Intl.message(
      'Add Expense Category',
      name: 'addExpenseCategory',
      desc: '',
      args: [],
    );
  }

  /// `Fashion`
  String get fashion {
    return Intl.message(
      'Fashion',
      name: 'fashion',
      desc: '',
      args: [],
    );
  }

  /// `Category Name`
  String get cateogryName {
    return Intl.message(
      'Category Name',
      name: 'cateogryName',
      desc: '',
      args: [],
    );
  }

  /// `Expense Category`
  String get expenseCategory {
    return Intl.message(
      'Expense Category',
      name: 'expenseCategory',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Expense Report`
  String get expenseReport {
    return Intl.message(
      'Expense Report',
      name: 'expenseReport',
      desc: '',
      args: [],
    );
  }

  /// `From Date`
  String get formDate {
    return Intl.message(
      'From Date',
      name: 'formDate',
      desc: '',
      args: [],
    );
  }

  /// `To Date`
  String get toDate {
    return Intl.message(
      'To Date',
      name: 'toDate',
      desc: '',
      args: [],
    );
  }

  /// `Total Expense`
  String get totalExpense {
    return Intl.message(
      'Total Expense',
      name: 'totalExpense',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get sales {
    return Intl.message(
      'Sales',
      name: 'sales',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `What's New`
  String get whatsNew {
    return Intl.message(
      'What\'s New',
      name: 'whatsNew',
      desc: '',
      args: [],
    );
  }

  /// `Maan`
  String get maan {
    return Intl.message(
      'Maan',
      name: 'maan',
      desc: '',
      args: [],
    );
  }

  /// `Package`
  String get pacakge {
    return Intl.message(
      'Package',
      name: 'pacakge',
      desc: '',
      args: [],
    );
  }

  /// `Bill To`
  String get billTo {
    return Intl.message(
      'Bill To',
      name: 'billTo',
      desc: '',
      args: [],
    );
  }

  /// `Total Due`
  String get totalDue {
    return Intl.message(
      'Total Due',
      name: 'totalDue',
      desc: '',
      args: [],
    );
  }

  /// `Payment Amount`
  String get paymentAmount {
    return Intl.message(
      'Payment Amount',
      name: 'paymentAmount',
      desc: '',
      args: [],
    );
  }

  /// `Remaining Due`
  String get remainingDue {
    return Intl.message(
      'Remaining Due',
      name: 'remainingDue',
      desc: '',
      args: [],
    );
  }

  /// `Thank You For Your DUe Payment`
  String get thankYOuForYourDuePayment {
    return Intl.message(
      'Thank You For Your DUe Payment',
      name: 'thankYOuForYourDuePayment',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get print {
    return Intl.message(
      'Print',
      name: 'print',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Unit Price`
  String get unitPirce {
    return Intl.message(
      'Unit Price',
      name: 'unitPirce',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message(
      'Total Price',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Sub Total`
  String get subTotal {
    return Intl.message(
      'Sub Total',
      name: 'subTotal',
      desc: '',
      args: [],
    );
  }

  /// `Total Vat`
  String get totalVat {
    return Intl.message(
      'Total Vat',
      name: 'totalVat',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charge`
  String get deliveryCharge {
    return Intl.message(
      'Delivery Charge',
      name: 'deliveryCharge',
      desc: '',
      args: [],
    );
  }

  /// `Total Payable`
  String get totalPayable {
    return Intl.message(
      'Total Payable',
      name: 'totalPayable',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message(
      'Paid',
      name: 'paid',
      desc: '',
      args: [],
    );
  }

  /// `Thank You for your purchase`
  String get thankYouForYourPurchase {
    return Intl.message(
      'Thank You for your purchase',
      name: 'thankYouForYourPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Total Sale`
  String get totalSale {
    return Intl.message(
      'Total Sale',
      name: 'totalSale',
      desc: '',
      args: [],
    );
  }

  /// `Ledger`
  String get ledger {
    return Intl.message(
      'Ledger',
      name: 'ledger',
      desc: '',
      args: [],
    );
  }

  /// `Loss/Profit`
  String get lossOrProfit {
    return Intl.message(
      'Loss/Profit',
      name: 'lossOrProfit',
      desc: '',
      args: [],
    );
  }

  /// `Profit`
  String get profit {
    return Intl.message(
      'Profit',
      name: 'profit',
      desc: '',
      args: [],
    );
  }

  /// `Loss`
  String get loss {
    return Intl.message(
      'Loss',
      name: 'loss',
      desc: '',
      args: [],
    );
  }

  /// `Loss/Profit Details`
  String get lossOrProfitDetails {
    return Intl.message(
      'Loss/Profit Details',
      name: 'lossOrProfitDetails',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Edit Social Media`
  String get editSocailMedia {
    return Intl.message(
      'Edit Social Media',
      name: 'editSocailMedia',
      desc: '',
      args: [],
    );
  }

  /// `Facebook`
  String get facebok {
    return Intl.message(
      'Facebook',
      name: 'facebok',
      desc: '',
      args: [],
    );
  }

  /// `Twitter`
  String get twitter {
    return Intl.message(
      'Twitter',
      name: 'twitter',
      desc: '',
      args: [],
    );
  }

  /// `Instagram`
  String get instragram {
    return Intl.message(
      'Instagram',
      name: 'instragram',
      desc: '',
      args: [],
    );
  }

  /// `LinkedIn`
  String get linkedIn {
    return Intl.message(
      'LinkedIn',
      name: 'linkedIn',
      desc: '',
      args: [],
    );
  }

  /// `Link`
  String get link {
    return Intl.message(
      'Link',
      name: 'link',
      desc: '',
      args: [],
    );
  }

  /// `Social Marketing`
  String get socailMarketing {
    return Intl.message(
      'Social Marketing',
      name: 'socailMarketing',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Alarm`
  String get purchaseAlarm {
    return Intl.message(
      'Purchase Alarm',
      name: 'purchaseAlarm',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Confirmed`
  String get purchaseConfirmed {
    return Intl.message(
      'Purchase Confirmed',
      name: 'purchaseConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Payment Complete`
  String get paymentComplete {
    return Intl.message(
      'Payment Complete',
      name: 'paymentComplete',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get retur {
    return Intl.message(
      'Return',
      name: 'retur',
      desc: '',
      args: [],
    );
  }

  /// `Send Email`
  String get sendEmail {
    return Intl.message(
      'Send Email',
      name: 'sendEmail',
      desc: '',
      args: [],
    );
  }

  /// `Send Sms`
  String get sendSms {
    return Intl.message(
      'Send Sms',
      name: 'sendSms',
      desc: '',
      args: [],
    );
  }

  /// `Received The pin`
  String get recivedThePin {
    return Intl.message(
      'Received The pin',
      name: 'recivedThePin',
      desc: '',
      args: [],
    );
  }

  /// `Start New Sale`
  String get startNewSale {
    return Intl.message(
      'Start New Sale',
      name: 'startNewSale',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message(
      'Payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Master card`
  String get masterCard {
    return Intl.message(
      'Master card',
      name: 'masterCard',
      desc: '',
      args: [],
    );
  }

  /// `Instrument`
  String get inistrument {
    return Intl.message(
      'Instrument',
      name: 'inistrument',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Add Brand`
  String get addBrand {
    return Intl.message(
      'Add Brand',
      name: 'addBrand',
      desc: '',
      args: [],
    );
  }

  /// `Brand Name`
  String get brandName {
    return Intl.message(
      'Brand Name',
      name: 'brandName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Brand Name`
  String get enterBrandName {
    return Intl.message(
      'Enter Brand Name',
      name: 'enterBrandName',
      desc: '',
      args: [],
    );
  }

  /// `Add Category`
  String get addCategory {
    return Intl.message(
      'Add Category',
      name: 'addCategory',
      desc: '',
      args: [],
    );
  }

  /// `Enter Category Name`
  String get enterCategoryName {
    return Intl.message(
      'Enter Category Name',
      name: 'enterCategoryName',
      desc: '',
      args: [],
    );
  }

  /// `Select Variation: `
  String get selectvariations {
    return Intl.message(
      'Select Variation: ',
      name: 'selectvariations',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message(
      'Size',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `Capacity`
  String get capacity {
    return Intl.message(
      'Capacity',
      name: 'capacity',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Add Product`
  String get addNewProduct {
    return Intl.message(
      'Add Product',
      name: 'addNewProduct',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get productName {
    return Intl.message(
      'Product Name',
      name: 'productName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Name`
  String get enterProductName {
    return Intl.message(
      'Enter Product Name',
      name: 'enterProductName',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Enter Size`
  String get enterSize {
    return Intl.message(
      'Enter Size',
      name: 'enterSize',
      desc: '',
      args: [],
    );
  }

  /// `Enter Color`
  String get enterColor {
    return Intl.message(
      'Enter Color',
      name: 'enterColor',
      desc: '',
      args: [],
    );
  }

  /// `Enter Weight`
  String get enterWeight {
    return Intl.message(
      'Enter Weight',
      name: 'enterWeight',
      desc: '',
      args: [],
    );
  }

  /// `Enter Capacity`
  String get enterCapacity {
    return Intl.message(
      'Enter Capacity',
      name: 'enterCapacity',
      desc: '',
      args: [],
    );
  }

  /// `Enter Type`
  String get enterType {
    return Intl.message(
      'Enter Type',
      name: 'enterType',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get brand {
    return Intl.message(
      'Brand',
      name: 'brand',
      desc: '',
      args: [],
    );
  }

  /// `Product Code`
  String get productCode {
    return Intl.message(
      'Product Code',
      name: 'productCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Code Or Scan`
  String get enterProductCodeOrScan {
    return Intl.message(
      'Enter Product Code Or Scan',
      name: 'enterProductCodeOrScan',
      desc: '',
      args: [],
    );
  }

  /// `Stocks`
  String get stocks {
    return Intl.message(
      'Stocks',
      name: 'stocks',
      desc: '',
      args: [],
    );
  }

  /// `Enter Stocks.`
  String get enterStocks {
    return Intl.message(
      'Enter Stocks.',
      name: 'enterStocks',
      desc: '',
      args: [],
    );
  }

  /// `Units`
  String get units {
    return Intl.message(
      'Units',
      name: 'units',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Price`
  String get purchasePrice {
    return Intl.message(
      'Purchase Price',
      name: 'purchasePrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter Purchase Price.`
  String get enterPurchasePrice {
    return Intl.message(
      'Enter Purchase Price.',
      name: 'enterPurchasePrice',
      desc: '',
      args: [],
    );
  }

  /// `MRP`
  String get MRP {
    return Intl.message(
      'MRP',
      name: 'MRP',
      desc: '',
      args: [],
    );
  }

  /// `Enter MRP/Retailer Price`
  String get enterMrpOrRetailerPirce {
    return Intl.message(
      'Enter MRP/Retailer Price',
      name: 'enterMrpOrRetailerPirce',
      desc: '',
      args: [],
    );
  }

  /// `WholeSale Price`
  String get wholeSalePrice {
    return Intl.message(
      'WholeSale Price',
      name: 'wholeSalePrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter Wholesale Price`
  String get enterWholeSalePrice {
    return Intl.message(
      'Enter Wholesale Price',
      name: 'enterWholeSalePrice',
      desc: '',
      args: [],
    );
  }

  /// `Dealer Price`
  String get dealerPrice {
    return Intl.message(
      'Dealer Price',
      name: 'dealerPrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter Dealer Price`
  String get enterDealerPrice {
    return Intl.message(
      'Enter Dealer Price',
      name: 'enterDealerPrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter Discount.`
  String get enterDiscount {
    return Intl.message(
      'Enter Discount.',
      name: 'enterDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer`
  String get menufeturer {
    return Intl.message(
      'Manufacturer',
      name: 'menufeturer',
      desc: '',
      args: [],
    );
  }

  /// `Enter Manufacturer`
  String get enterManufacturer {
    return Intl.message(
      'Enter Manufacturer',
      name: 'enterManufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Save and Publish`
  String get saveAndPublish {
    return Intl.message(
      'Save and Publish',
      name: 'saveAndPublish',
      desc: '',
      args: [],
    );
  }

  /// `Add Unit`
  String get addUnit {
    return Intl.message(
      'Add Unit',
      name: 'addUnit',
      desc: '',
      args: [],
    );
  }

  /// `Kg`
  String get kg {
    return Intl.message(
      'Kg',
      name: 'kg',
      desc: '',
      args: [],
    );
  }

  /// `Unit Name`
  String get unitName {
    return Intl.message(
      'Unit Name',
      name: 'unitName',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Product List`
  String get productList {
    return Intl.message(
      'Product List',
      name: 'productList',
      desc: '',
      args: [],
    );
  }

  /// `Update Product`
  String get updateProduct {
    return Intl.message(
      'Update Product',
      name: 'updateProduct',
      desc: '',
      args: [],
    );
  }

  /// `Clarence`
  String get clarence {
    return Intl.message(
      'Clarence',
      name: 'clarence',
      desc: '',
      args: [],
    );
  }

  /// `Daily Transaction`
  String get dailyTransaciton {
    return Intl.message(
      'Daily Transaction',
      name: 'dailyTransaciton',
      desc: '',
      args: [],
    );
  }

  /// `promo`
  String get promo {
    return Intl.message(
      'promo',
      name: 'promo',
      desc: '',
      args: [],
    );
  }

  /// `Update Your Profile`
  String get updateYourProfile {
    return Intl.message(
      'Update Your Profile',
      name: 'updateYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Update your profile to connect your customer with better impression`
  String get updateYourProfiletoConnectTOCusomter {
    return Intl.message(
      'Update your profile to connect your customer with better impression',
      name: 'updateYourProfiletoConnectTOCusomter',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get updateNow {
    return Intl.message(
      'Update Now',
      name: 'updateNow',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Add Purchase`
  String get addPurchase {
    return Intl.message(
      'Add Purchase',
      name: 'addPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Inv No.`
  String get invNo {
    return Intl.message(
      'Inv No.',
      name: 'invNo',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Name`
  String get supplierName {
    return Intl.message(
      'Supplier Name',
      name: 'supplierName',
      desc: '',
      args: [],
    );
  }

  /// `Item Added`
  String get itemAdded {
    return Intl.message(
      'Item Added',
      name: 'itemAdded',
      desc: '',
      args: [],
    );
  }

  /// `Add Items`
  String get addItems {
    return Intl.message(
      'Add Items',
      name: 'addItems',
      desc: '',
      args: [],
    );
  }

  /// `Return Amount`
  String get returnAMount {
    return Intl.message(
      'Return Amount',
      name: 'returnAMount',
      desc: '',
      args: [],
    );
  }

  /// `Chose a Supplier`
  String get choseASupplier {
    return Intl.message(
      'Chose a Supplier',
      name: 'choseASupplier',
      desc: '',
      args: [],
    );
  }

  /// `Chose a Customer`
  String get choseACustomer {
    return Intl.message(
      'Chose a Customer',
      name: 'choseACustomer',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Details`
  String get purchaseDetails {
    return Intl.message(
      'Purchase Details',
      name: 'purchaseDetails',
      desc: '',
      args: [],
    );
  }

  /// `Purchase List`
  String get purchaseList {
    return Intl.message(
      'Purchase List',
      name: 'purchaseList',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get startDate {
    return Intl.message(
      'Start Date',
      name: 'startDate',
      desc: '',
      args: [],
    );
  }

  /// `Pick Start Date`
  String get pickStartDate {
    return Intl.message(
      'Pick Start Date',
      name: 'pickStartDate',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get endDate {
    return Intl.message(
      'End Date',
      name: 'endDate',
      desc: '',
      args: [],
    );
  }

  /// `Pick End Date`
  String get pickEndDate {
    return Intl.message(
      'Pick End Date',
      name: 'pickEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Total: `
  String get totals {
    return Intl.message(
      'Total: ',
      name: 'totals',
      desc: '',
      args: [],
    );
  }

  /// `Sale Price`
  String get salePrice {
    return Intl.message(
      'Sale Price',
      name: 'salePrice',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Price`
  String get purchaseReports {
    return Intl.message(
      'Purchase Price',
      name: 'purchaseReports',
      desc: '',
      args: [],
    );
  }

  /// `Qty`
  String get qty {
    return Intl.message(
      'Qty',
      name: 'qty',
      desc: '',
      args: [],
    );
  }

  /// `price`
  String get price {
    return Intl.message(
      'price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Purchase`
  String get purchase {
    return Intl.message(
      'Purchase',
      name: 'purchase',
      desc: '',
      args: [],
    );
  }

  /// `Sale Details`
  String get saleDetails {
    return Intl.message(
      'Sale Details',
      name: 'saleDetails',
      desc: '',
      args: [],
    );
  }

  /// `Edit Purchase Invoice`
  String get editPurchaseInvoice {
    return Intl.message(
      'Edit Purchase Invoice',
      name: 'editPurchaseInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Number`
  String get invoiceNumber {
    return Intl.message(
      'Invoice Number',
      name: 'invoiceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Invoice Number`
  String get enterInvoiceNumber {
    return Intl.message(
      'Enter Invoice Number',
      name: 'enterInvoiceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Report`
  String get purchaseRepoet {
    return Intl.message(
      'Purchase Report',
      name: 'purchaseRepoet',
      desc: '',
      args: [],
    );
  }

  /// `Sale Report`
  String get saleReports {
    return Intl.message(
      'Sale Report',
      name: 'saleReports',
      desc: '',
      args: [],
    );
  }

  /// `Due Report`
  String get dueReports {
    return Intl.message(
      'Due Report',
      name: 'dueReports',
      desc: '',
      args: [],
    );
  }

  /// `Promo Code`
  String get promoCode {
    return Intl.message(
      'Promo Code',
      name: 'promoCode',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `See all promo codes`
  String get seeAllPromoCode {
    return Intl.message(
      'See all promo codes',
      name: 'seeAllPromoCode',
      desc: '',
      args: [],
    );
  }

  /// `Add Sales`
  String get addSales {
    return Intl.message(
      'Add Sales',
      name: 'addSales',
      desc: '',
      args: [],
    );
  }

  /// `Send sms?`
  String get sendSmsw {
    return Intl.message(
      'Send sms?',
      name: 'sendSmsw',
      desc: '',
      args: [],
    );
  }

  /// `Walk-in customer`
  String get walkInCustomer {
    return Intl.message(
      'Walk-in customer',
      name: 'walkInCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message(
      'Guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `Sales List`
  String get salesList {
    return Intl.message(
      'Sales List',
      name: 'salesList',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Edit Sales Invoice`
  String get editSalesInvoice {
    return Intl.message(
      'Edit Sales Invoice',
      name: 'editSalesInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Previous Pay Amounts`
  String get previousPayAmounts {
    return Intl.message(
      'Previous Pay Amounts',
      name: 'previousPayAmounts',
      desc: '',
      args: [],
    );
  }

  /// `Return Amount`
  String get returnAmount {
    return Intl.message(
      'Return Amount',
      name: 'returnAmount',
      desc: '',
      args: [],
    );
  }

  /// `FeedBack`
  String get feedBack {
    return Intl.message(
      'FeedBack',
      name: 'feedBack',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Feedback Tittle`
  String get enterYourFeedBackTitle {
    return Intl.message(
      'Enter Your Feedback Tittle',
      name: 'enterYourFeedBackTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your description here`
  String get enterYourDescriptionHere {
    return Intl.message(
      'Enter your description here',
      name: 'enterYourDescriptionHere',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Setting`
  String get invoiceSetting {
    return Intl.message(
      'Invoice Setting',
      name: 'invoiceSetting',
      desc: '',
      args: [],
    );
  }

  /// `Printing Option`
  String get printingOption {
    return Intl.message(
      'Printing Option',
      name: 'printingOption',
      desc: '',
      args: [],
    );
  }

  /// `Logo`
  String get logo {
    return Intl.message(
      'Logo',
      name: 'logo',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get subscription {
    return Intl.message(
      'Subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOUt {
    return Intl.message(
      'Log Out',
      name: 'logOUt',
      desc: '',
      args: [],
    );
  }

  /// `Do not disturb`
  String get doNotDistrub {
    return Intl.message(
      'Do not disturb',
      name: 'doNotDistrub',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Write your message here`
  String get writeYourMessageHere {
    return Intl.message(
      'Write your message here',
      name: 'writeYourMessageHere',
      desc: '',
      args: [],
    );
  }

  /// `Send Message`
  String get sendMessage {
    return Intl.message(
      'Send Message',
      name: 'sendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Send Your Email`
  String get sendYOurEmail {
    return Intl.message(
      'Send Your Email',
      name: 'sendYOurEmail',
      desc: '',
      args: [],
    );
  }

  /// `Back To Home`
  String get backToHome {
    return Intl.message(
      'Back To Home',
      name: 'backToHome',
      desc: '',
      args: [],
    );
  }

  /// `Select Contacts`
  String get selectContacts {
    return Intl.message(
      'Select Contacts',
      name: 'selectContacts',
      desc: '',
      args: [],
    );
  }

  /// `Message History`
  String get messageHistory {
    return Intl.message(
      'Message History',
      name: 'messageHistory',
      desc: '',
      args: [],
    );
  }

  /// `Transaction`
  String get transaction {
    return Intl.message(
      'Transaction',
      name: 'transaction',
      desc: '',
      args: [],
    );
  }

  /// `No History Found!`
  String get noHistoryFound {
    return Intl.message(
      'No History Found!',
      name: 'noHistoryFound',
      desc: '',
      args: [],
    );
  }

  /// `View details`
  String get viewDetails {
    return Intl.message(
      'View details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `No Transaction Found!`
  String get noTransactionFound {
    return Intl.message(
      'No Transaction Found!',
      name: 'noTransactionFound',
      desc: '',
      args: [],
    );
  }

  /// `KYC Verification`
  String get kycVerification {
    return Intl.message(
      'KYC Verification',
      name: 'kycVerification',
      desc: '',
      args: [],
    );
  }

  /// `Identity Verify`
  String get identityVerify {
    return Intl.message(
      'Identity Verify',
      name: 'identityVerify',
      desc: '',
      args: [],
    );
  }

  /// `You need to identity verify before your buying sms`
  String get youNeedToIdentityVerifyBeforeYouBuying {
    return Intl.message(
      'You need to identity verify before your buying sms',
      name: 'youNeedToIdentityVerifyBeforeYouBuying',
      desc: '',
      args: [],
    );
  }

  /// `Government Id`
  String get govermentId {
    return Intl.message(
      'Government Id',
      name: 'govermentId',
      desc: '',
      args: [],
    );
  }

  /// `Take a driver's license, national identity card or passport photo`
  String get takeADriveruser {
    return Intl.message(
      'Take a driver\'s license, national identity card or passport photo',
      name: 'takeADriveruser',
      desc: '',
      args: [],
    );
  }

  /// `Add Document`
  String get addDucument {
    return Intl.message(
      'Add Document',
      name: 'addDucument',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer {
    return Intl.message(
      'Customer',
      name: 'customer',
      desc: '',
      args: [],
    );
  }

  /// `Enter Message Content`
  String get enterMessageContent {
    return Intl.message(
      'Enter Message Content',
      name: 'enterMessageContent',
      desc: '',
      args: [],
    );
  }

  /// `Buy Sms`
  String get buySms {
    return Intl.message(
      'Buy Sms',
      name: 'buySms',
      desc: '',
      args: [],
    );
  }

  /// `Complete Transaction`
  String get completeTransaction {
    return Intl.message(
      'Complete Transaction',
      name: 'completeTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Payment Instruction:`
  String get paymentInstructions {
    return Intl.message(
      'Payment Instruction:',
      name: 'paymentInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Payee Name`
  String get payeeName {
    return Intl.message(
      'Payee Name',
      name: 'payeeName',
      desc: '',
      args: [],
    );
  }

  /// `Payee Number`
  String get payeeNumber {
    return Intl.message(
      'Payee Number',
      name: 'payeeNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your mobile number`
  String get enterYourMobileNumber {
    return Intl.message(
      'Enter your mobile number',
      name: 'enterYourMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Id`
  String get transactionId {
    return Intl.message(
      'Transaction Id',
      name: 'transactionId',
      desc: '',
      args: [],
    );
  }

  /// `Enter your transaction id`
  String get enterYourTransactionId {
    return Intl.message(
      'Enter your transaction id',
      name: 'enterYourTransactionId',
      desc: '',
      args: [],
    );
  }

  /// `Pay with bkash`
  String get payWithBkash {
    return Intl.message(
      'Pay with bkash',
      name: 'payWithBkash',
      desc: '',
      args: [],
    );
  }

  /// `Your message remains`
  String get yourMessageRemains {
    return Intl.message(
      'Your message remains',
      name: 'yourMessageRemains',
      desc: '',
      args: [],
    );
  }

  /// `Sms`
  String get sms {
    return Intl.message(
      'Sms',
      name: 'sms',
      desc: '',
      args: [],
    );
  }

  /// `Add Document Id`
  String get addDocumentId {
    return Intl.message(
      'Add Document Id',
      name: 'addDocumentId',
      desc: '',
      args: [],
    );
  }

  /// `Font Side`
  String get fontSide {
    return Intl.message(
      'Font Side',
      name: 'fontSide',
      desc: '',
      args: [],
    );
  }

  /// `Take an identity card to check your information`
  String get takeaNidCardToCheckYourInformation {
    return Intl.message(
      'Take an identity card to check your information',
      name: 'takeaNidCardToCheckYourInformation',
      desc: '',
      args: [],
    );
  }

  /// `Back side`
  String get backSide {
    return Intl.message(
      'Back side',
      name: 'backSide',
      desc: '',
      args: [],
    );
  }

  /// `Easy to use mobile pos`
  String get easyToUseMobilePos {
    return Intl.message(
      'Easy to use mobile pos',
      name: 'easyToUseMobilePos',
      desc: '',
      args: [],
    );
  }

  /// `Pos Saas  app is free, easy to use. In fact, it's one of the best  POS systems around the world.`
  String get mobiPosAppIsFree {
    return Intl.message(
      'Pos Saas  app is free, easy to use. In fact, it\'s one of the best  POS systems around the world.',
      name: 'mobiPosAppIsFree',
      desc: '',
      args: [],
    );
  }

  /// `Choose your features`
  String get choseYourFeature {
    return Intl.message(
      'Choose your features',
      name: 'choseYourFeature',
      desc: '',
      args: [],
    );
  }

  /// `Features are the important part which makes Pos Saas  different from traditional solutions.`
  String get featureAreTheImportant {
    return Intl.message(
      'Features are the important part which makes Pos Saas  different from traditional solutions.',
      name: 'featureAreTheImportant',
      desc: '',
      args: [],
    );
  }

  /// `All business solutions`
  String get allBusinessSolution {
    return Intl.message(
      'All business solutions',
      name: 'allBusinessSolution',
      desc: '',
      args: [],
    );
  }

  /// `Pos Saas  is a complete business solution with stock, account, sales, expense & loss/profit.`
  String get mobiPosIsaCompleteBusinesSolution {
    return Intl.message(
      'Pos Saas  is a complete business solution with stock, account, sales, expense & loss/profit.',
      name: 'mobiPosIsaCompleteBusinesSolution',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Current Stock`
  String get currentStock {
    return Intl.message(
      'Current Stock',
      name: 'currentStock',
      desc: '',
      args: [],
    );
  }

  /// `Total Stocks`
  String get totalStock {
    return Intl.message(
      'Total Stocks',
      name: 'totalStock',
      desc: '',
      args: [],
    );
  }

  /// `Use Pos Saas`
  String get useMobiPos {
    return Intl.message(
      'Use Pos Saas',
      name: 'useMobiPos',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Your Package`
  String get yourPackage {
    return Intl.message(
      'Your Package',
      name: 'yourPackage',
      desc: '',
      args: [],
    );
  }

  /// `Free Plan`
  String get freePlan {
    return Intl.message(
      'Free Plan',
      name: 'freePlan',
      desc: '',
      args: [],
    );
  }

  /// `You are using`
  String get youAreUsing {
    return Intl.message(
      'You are using',
      name: 'youAreUsing',
      desc: '',
      args: [],
    );
  }

  /// `Free Package`
  String get freePacakge {
    return Intl.message(
      'Free Package',
      name: 'freePacakge',
      desc: '',
      args: [],
    );
  }

  /// `Premium plan`
  String get premiumPlan {
    return Intl.message(
      'Premium plan',
      name: 'premiumPlan',
      desc: '',
      args: [],
    );
  }

  /// `Package Features`
  String get packageFeatures {
    return Intl.message(
      'Package Features',
      name: 'packageFeatures',
      desc: '',
      args: [],
    );
  }

  /// `For unlimited usages`
  String get forUnlimitedUses {
    return Intl.message(
      'For unlimited usages',
      name: 'forUnlimitedUses',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Premium Plan`
  String get purchasePremiumPlan {
    return Intl.message(
      'Purchase Premium Plan',
      name: 'purchasePremiumPlan',
      desc: '',
      args: [],
    );
  }

  /// `Buy Premium Plan`
  String get buyPremiumPlan {
    return Intl.message(
      'Buy Premium Plan',
      name: 'buyPremiumPlan',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message(
      'Monthly',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }

  /// `Lifetime\nPurchase`
  String get lifeTimePurchase {
    return Intl.message(
      'Lifetime\nPurchase',
      name: 'lifeTimePurchase',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get yearly {
    return Intl.message(
      'Yearly',
      name: 'yearly',
      desc: '',
      args: [],
    );
  }

  /// `Pay with Paypal`
  String get payWithPaypal {
    return Intl.message(
      'Pay with Paypal',
      name: 'payWithPaypal',
      desc: '',
      args: [],
    );
  }

  /// `No Data`
  String get noData {
    return Intl.message(
      'No Data',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Your Package Will Expire in 5 Day`
  String get yourPackageWillExpireinDay {
    return Intl.message(
      'Your Package Will Expire in 5 Day',
      name: 'yourPackageWillExpireinDay',
      desc: '',
      args: [],
    );
  }

  /// `Your Package Will Expire Today\n\nPlease Purchase again`
  String get YourPackageWillExpireTodayPleasePurchaseagain {
    return Intl.message(
      'Your Package Will Expire Today\n\nPlease Purchase again',
      name: 'YourPackageWillExpireTodayPleasePurchaseagain',
      desc: '',
      args: [],
    );
  }

  /// `Email can\'n be empty`
  String get emailCanNotBeEmpty {
    return Intl.message(
      'Email can\\\'n be empty',
      name: 'emailCanNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get pleaseEnterAValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'pleaseEnterAValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password can\'t be empty`
  String get passwordCanNotBeEmpty {
    return Intl.message(
      'Password can\\\'t be empty',
      name: 'passwordCanNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a bigger password`
  String get pleaseEnterABiggerPassword {
    return Intl.message(
      'Please enter a bigger password',
      name: 'pleaseEnterABiggerPassword',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `POS SAAS`
  String get POSsAAS {
    return Intl.message(
      'POS SAAS',
      name: 'POSsAAS',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with email`
  String get signInWithEmail {
    return Intl.message(
      'Sign in with email',
      name: 'signInWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is not valid`
  String get phoneNumberIsNotValid {
    return Intl.message(
      'Phone number is not valid',
      name: 'phoneNumberIsNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid phone number`
  String get enterAValidPhoneNumber {
    return Intl.message(
      'Enter a valid phone number',
      name: 'enterAValidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `OTP sent to`
  String get oTPSentTo {
    return Intl.message(
      'OTP sent to',
      name: 'oTPSentTo',
      desc: '',
      args: [],
    );
  }

  /// `Wrong OTP`
  String get wrongOTP {
    return Intl.message(
      'Wrong OTP',
      name: 'wrongOTP',
      desc: '',
      args: [],
    );
  }

  /// `GST Number`
  String get GSTNumber {
    return Intl.message(
      'GST Number',
      name: 'GSTNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your GST Number`
  String get enterYourGSTNumber {
    return Intl.message(
      'Enter your GST Number',
      name: 'enterYourGSTNumber',
      desc: '',
      args: [],
    );
  }

  /// `Added Successfully`
  String get addedSuccessfully {
    return Intl.message(
      'Added Successfully',
      name: 'addedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Business Category`
  String get pleaseSelectBusinessCategory {
    return Intl.message(
      'Please Select Business Category',
      name: 'pleaseSelectBusinessCategory',
      desc: '',
      args: [],
    );
  }

  /// `Select Shop Category`
  String get selectShopCategory {
    return Intl.message(
      'Select Shop Category',
      name: 'selectShopCategory',
      desc: '',
      args: [],
    );
  }

  /// `Uploading`
  String get Uploading {
    return Intl.message(
      'Uploading',
      name: 'Uploading',
      desc: '',
      args: [],
    );
  }

  /// `Password Not mach`
  String get passwordNotMach {
    return Intl.message(
      'Password Not mach',
      name: 'passwordNotMach',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number is required`
  String get phoneNumberIsRequired {
    return Intl.message(
      'Phone Number is required',
      name: 'phoneNumberIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number Already Used`
  String get phoneNumberAlreadyUsed {
    return Intl.message(
      'Phone Number Already Used',
      name: 'phoneNumberAlreadyUsed',
      desc: '',
      args: [],
    );
  }

  /// `Send whatsapp message`
  String get sendWhatsappMessage {
    return Intl.message(
      'Send whatsapp message',
      name: 'sendWhatsappMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enter customer gst number`
  String get enterCustomerGstNumber {
    return Intl.message(
      'Enter customer gst number',
      name: 'enterCustomerGstNumber',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this user`
  String get areYouSureToDeleteThisUser {
    return Intl.message(
      'Are you sure to delete this user',
      name: 'areYouSureToDeleteThisUser',
      desc: '',
      args: [],
    );
  }

  /// `The user will be deleted and all the data will be deleted from your account.Are you sure to delete this`
  String get theUserWillBeDeletedAndAllTheData {
    return Intl.message(
      'The user will be deleted and all the data will be deleted from your account.Are you sure to delete this',
      name: 'theUserWillBeDeletedAndAllTheData',
      desc: '',
      args: [],
    );
  }

  /// `About us`
  String get aboutUs {
    return Intl.message(
      'About us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Total Products`
  String get totalProducts {
    return Intl.message(
      'Total Products',
      name: 'totalProducts',
      desc: '',
      args: [],
    );
  }

  /// `Unpaid`
  String get unpaid {
    return Intl.message(
      'Unpaid',
      name: 'unpaid',
      desc: '',
      args: [],
    );
  }

  /// `Wholesaler`
  String get wholesaler {
    return Intl.message(
      'Wholesaler',
      name: 'wholesaler',
      desc: '',
      args: [],
    );
  }

  /// `Customer GST`
  String get customerGST {
    return Intl.message(
      'Customer GST',
      name: 'customerGST',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Addresses`
  String get deliveryAddresses {
    return Intl.message(
      'Delivery Addresses',
      name: 'deliveryAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Office`
  String get office {
    return Intl.message(
      'Office',
      name: 'office',
      desc: '',
      args: [],
    );
  }

  /// `You can\'t pay more then due`
  String get youCanNotPayMoreThenDue {
    return Intl.message(
      'You can\\\'t pay more then due',
      name: 'youCanNotPayMoreThenDue',
      desc: '',
      args: [],
    );
  }

  /// `Sending message`
  String get sendingMessage {
    return Intl.message(
      'Sending message',
      name: 'sendingMessage',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Please Connect The Printer First`
  String get pleaseConnectThePrinterFirst {
    return Intl.message(
      'Please Connect The Printer First',
      name: 'pleaseConnectThePrinterFirst',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid Amount`
  String get enterValidAmount {
    return Intl.message(
      'Enter Valid Amount',
      name: 'enterValidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Bank`
  String get bank {
    return Intl.message(
      'Bank',
      name: 'bank',
      desc: '',
      args: [],
    );
  }

  /// `Card`
  String get card {
    return Intl.message(
      'Card',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Payment`
  String get mobilePayment {
    return Intl.message(
      'Mobile Payment',
      name: 'mobilePayment',
      desc: '',
      args: [],
    );
  }

  /// `Snacks`
  String get Snacks {
    return Intl.message(
      'Snacks',
      name: 'Snacks',
      desc: '',
      args: [],
    );
  }

  /// `Select Category`
  String get selectCategory {
    return Intl.message(
      'Select Category',
      name: 'selectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Name`
  String get pleaseEnterName {
    return Intl.message(
      'Please Enter Name',
      name: 'pleaseEnterName',
      desc: '',
      args: [],
    );
  }

  /// `please Inter Amount`
  String get pleaseInterAmount {
    return Intl.message(
      'please Inter Amount',
      name: 'pleaseInterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid Amount`
  String get enterAValidAmount {
    return Intl.message(
      'Enter a valid Amount',
      name: 'enterAValidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get ContinueE {
    return Intl.message(
      'Continue',
      name: 'ContinueE',
      desc: '',
      args: [],
    );
  }

  /// `Please select a category first`
  String get pleaseSelectACategoryFirst {
    return Intl.message(
      'Please select a category first',
      name: 'pleaseSelectACategoryFirst',
      desc: '',
      args: [],
    );
  }

  /// `Already Added`
  String get alreadyAdded {
    return Intl.message(
      'Already Added',
      name: 'alreadyAdded',
      desc: '',
      args: [],
    );
  }

  /// `Data Saved Successfully`
  String get dataSavedSuccessfully {
    return Intl.message(
      'Data Saved Successfully',
      name: 'dataSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Not Provided`
  String get notProvided {
    return Intl.message(
      'Not Provided',
      name: 'notProvided',
      desc: '',
      args: [],
    );
  }

  /// `User is deleted`
  String get userIsDeleted {
    return Intl.message(
      'User is deleted',
      name: 'userIsDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get weekly {
    return Intl.message(
      'Weekly',
      name: 'weekly',
      desc: '',
      args: [],
    );
  }

  /// `Plan`
  String get plan {
    return Intl.message(
      'Plan',
      name: 'plan',
      desc: '',
      args: [],
    );
  }

  /// `Update your plan first,\nyour limit is over`
  String get updateYourPlanFirstYourLimitIsOver {
    return Intl.message(
      'Update your plan first,\\nyour limit is over',
      name: 'updateYourPlanFirstYourLimitIsOver',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, you have no permission to access this service`
  String get sorryYouHaveNoPermissionToAccessThisService {
    return Intl.message(
      'Sorry, you have no permission to access this service',
      name: 'sorryYouHaveNoPermissionToAccessThisService',
      desc: '',
      args: [],
    );
  }

  /// `Shop GST`
  String get shopGST {
    return Intl.message(
      'Shop GST',
      name: 'shopGST',
      desc: '',
      args: [],
    );
  }

  /// `Invoice`
  String get invoice {
    return Intl.message(
      'Invoice',
      name: 'invoice',
      desc: '',
      args: [],
    );
  }

  /// `Party GST`
  String get partyGST {
    return Intl.message(
      'Party GST',
      name: 'partyGST',
      desc: '',
      args: [],
    );
  }

  /// `Seller`
  String get seller {
    return Intl.message(
      'Seller',
      name: 'seller',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get admin {
    return Intl.message(
      'Admin',
      name: 'admin',
      desc: '',
      args: [],
    );
  }

  /// `TAX`
  String get TAX {
    return Intl.message(
      'TAX',
      name: 'TAX',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get mobile {
    return Intl.message(
      'Mobile',
      name: 'mobile',
      desc: '',
      args: [],
    );
  }

  /// `Total Loss`
  String get totalLoss {
    return Intl.message(
      'Total Loss',
      name: 'totalLoss',
      desc: '',
      args: [],
    );
  }

  /// `Total Profit`
  String get totalProfit {
    return Intl.message(
      'Total Profit',
      name: 'totalProfit',
      desc: '',
      args: [],
    );
  }

  /// `Add Promo Code`
  String get addPromoCode {
    return Intl.message(
      'Add Promo Code',
      name: 'addPromoCode',
      desc: '',
      args: [],
    );
  }

  /// `Add Discount`
  String get addDiscount {
    return Intl.message(
      'Add Discount',
      name: 'addDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Cancel All Product`
  String get cancelAllProduct {
    return Intl.message(
      'Cancel All Product',
      name: 'cancelAllProduct',
      desc: '',
      args: [],
    );
  }

  /// `Vat Doesn\'t Apply`
  String get vatDoesNotApply {
    return Intl.message(
      'Vat Doesn\\\'t Apply',
      name: 'vatDoesNotApply',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Viewer`
  String get invoiceViewer {
    return Intl.message(
      'Invoice Viewer',
      name: 'invoiceViewer',
      desc: '',
      args: [],
    );
  }

  /// `Select Product Category`
  String get selectProductCategory {
    return Intl.message(
      'Select Product Category',
      name: 'selectProductCategory',
      desc: '',
      args: [],
    );
  }

  /// `Select Brand`
  String get selectBrand {
    return Intl.message(
      'Select Brand',
      name: 'selectBrand',
      desc: '',
      args: [],
    );
  }

  /// `Select Unit`
  String get selectUnit {
    return Intl.message(
      'Select Unit',
      name: 'selectUnit',
      desc: '',
      args: [],
    );
  }

  /// `Inclusive`
  String get inclusive {
    return Intl.message(
      'Inclusive',
      name: 'inclusive',
      desc: '',
      args: [],
    );
  }

  /// `Exclusive`
  String get exclusive {
    return Intl.message(
      'Exclusive',
      name: 'exclusive',
      desc: '',
      args: [],
    );
  }

  /// `Select Tax type`
  String get selectTaxType {
    return Intl.message(
      'Select Tax type',
      name: 'selectTaxType',
      desc: '',
      args: [],
    );
  }

  /// `Bulk \nUpload`
  String get bulkUpload {
    return Intl.message(
      'Bulk \nUpload',
      name: 'bulkUpload',
      desc: '',
      args: [],
    );
  }

  /// `Product name is required`
  String get productNameIsRequired {
    return Intl.message(
      'Product name is required',
      name: 'productNameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Product Name already exists in this warehouse`
  String get productNameAlreadyExistsInThisWarehouse {
    return Intl.message(
      'Product Name already exists in this warehouse',
      name: 'productNameAlreadyExistsInThisWarehouse',
      desc: '',
      args: [],
    );
  }

  /// `Product Code is Required`
  String get productCodeIsRequired {
    return Intl.message(
      'Product Code is Required',
      name: 'productCodeIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `This Product Already added`
  String get thisProductAlreadyAdded {
    return Intl.message(
      'This Product Already added',
      name: 'thisProductAlreadyAdded',
      desc: '',
      args: [],
    );
  }

  /// `Barcode found`
  String get barcodeFound {
    return Intl.message(
      'Barcode found',
      name: 'barcodeFound',
      desc: '',
      args: [],
    );
  }

  /// `Stock is required`
  String get stockIsRequired {
    return Intl.message(
      'Stock is required',
      name: 'stockIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse`
  String get warehouse {
    return Intl.message(
      'Warehouse',
      name: 'warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Applicable Tax`
  String get applicableTax {
    return Intl.message(
      'Applicable Tax',
      name: 'applicableTax',
      desc: '',
      args: [],
    );
  }

  /// `Select Tax`
  String get selectTax {
    return Intl.message(
      'Select Tax',
      name: 'selectTax',
      desc: '',
      args: [],
    );
  }

  /// `Tax Type`
  String get taxType {
    return Intl.message(
      'Tax Type',
      name: 'taxType',
      desc: '',
      args: [],
    );
  }

  /// `Margin`
  String get margin {
    return Intl.message(
      'Margin',
      name: 'margin',
      desc: '',
      args: [],
    );
  }

  /// `Inc. tax`
  String get incTax {
    return Intl.message(
      'Inc. tax',
      name: 'incTax',
      desc: '',
      args: [],
    );
  }

  /// `Exc. Tax`
  String get excTax {
    return Intl.message(
      'Exc. Tax',
      name: 'excTax',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Price is required`
  String get purchasePriceIsRequired {
    return Intl.message(
      'Purchase Price is required',
      name: 'purchasePriceIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `MRP is required`
  String get MRPIsRequired {
    return Intl.message(
      'MRP is required',
      name: 'MRPIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Manufacture Date`
  String get manufactureDate {
    return Intl.message(
      'Manufacture Date',
      name: 'manufactureDate',
      desc: '',
      args: [],
    );
  }

  /// `Expire Date`
  String get expireDate {
    return Intl.message(
      'Expire Date',
      name: 'expireDate',
      desc: '',
      args: [],
    );
  }

  /// `Low Stock Alert`
  String get lowStockAlert {
    return Intl.message(
      'Low Stock Alert',
      name: 'lowStockAlert',
      desc: '',
      args: [],
    );
  }

  /// `Enter Low Stock Alert Quantity`
  String get enterLowStockAlertQuantity {
    return Intl.message(
      'Enter Low Stock Alert Quantity',
      name: 'enterLowStockAlertQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Enter Description`
  String get enterDescription {
    return Intl.message(
      'Enter Description',
      name: 'enterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Storage permission is required to create Excel file`
  String get storagePermissionIsRequiredToCreateExcelFile {
    return Intl.message(
      'Storage permission is required to create Excel file',
      name: 'storagePermissionIsRequiredToCreateExcelFile',
      desc: '',
      args: [],
    );
  }

  /// `The Excel file has already been downloaded`
  String get theExcelFileHasAlreadyBeenDownloaded {
    return Intl.message(
      'The Excel file has already been downloaded',
      name: 'theExcelFileHasAlreadyBeenDownloaded',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded successfully in download folder`
  String get downloadedSuccessfullyInDownloadFolder {
    return Intl.message(
      'Downloaded successfully in download folder',
      name: 'downloadedSuccessfullyInDownloadFolder',
      desc: '',
      args: [],
    );
  }

  /// `Excel Uploader`
  String get excelUploader {
    return Intl.message(
      'Excel Uploader',
      name: 'excelUploader',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Pick and Upload File`
  String get pickAndUploadFile {
    return Intl.message(
      'Pick and Upload File',
      name: 'pickAndUploadFile',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Download Excel Format`
  String get downloadExcelFormat {
    return Intl.message(
      'Download Excel Format',
      name: 'downloadExcelFormat',
      desc: '',
      args: [],
    );
  }

  /// `Upload Done`
  String get uploadDone {
    return Intl.message(
      'Upload Done',
      name: 'uploadDone',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get productDetails {
    return Intl.message(
      'Product Details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Wholesale price`
  String get wholesalePrice {
    return Intl.message(
      'Wholesale price',
      name: 'wholesalePrice',
      desc: '',
      args: [],
    );
  }

  /// `Stock`
  String get stock {
    return Intl.message(
      'Stock',
      name: 'stock',
      desc: '',
      args: [],
    );
  }

  /// `Expiring`
  String get expiring {
    return Intl.message(
      'Expiring',
      name: 'expiring',
      desc: '',
      args: [],
    );
  }

  /// `Deleting`
  String get deleting {
    return Intl.message(
      'Deleting',
      name: 'deleting',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get expired {
    return Intl.message(
      'Expired',
      name: 'expired',
      desc: '',
      args: [],
    );
  }

  /// `Will Expire at`
  String get willExpireAt {
    return Intl.message(
      'Will Expire at',
      name: 'willExpireAt',
      desc: '',
      args: [],
    );
  }

  /// `Please add quantity`
  String get pleaseAddQuantity {
    return Intl.message(
      'Please add quantity',
      name: 'pleaseAddQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Product name is already added`
  String get productNameIsAlreadyAdded {
    return Intl.message(
      'Product name is already added',
      name: 'productNameIsAlreadyAdded',
      desc: '',
      args: [],
    );
  }

  /// `Usb C`
  String get usbC {
    return Intl.message(
      'Usb C',
      name: 'usbC',
      desc: '',
      args: [],
    );
  }

  /// `Taxes`
  String get taxes {
    return Intl.message(
      'Taxes',
      name: 'taxes',
      desc: '',
      args: [],
    );
  }

  /// `Company & Business Name`
  String get companyBusinessName {
    return Intl.message(
      'Company & Business Name',
      name: 'companyBusinessName',
      desc: '',
      args: [],
    );
  }

  /// `Sending Email`
  String get sendingEmail {
    return Intl.message(
      'Sending Email',
      name: 'sendingEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email Sent! Check your Inbox`
  String get emailSentCheckYourInbox {
    return Intl.message(
      'Email Sent! Check your Inbox',
      name: 'emailSentCheckYourInbox',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid Discount`
  String get enterAValidDiscount {
    return Intl.message(
      'Enter a valid Discount',
      name: 'enterAValidDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Add product first`
  String get addProductFirst {
    return Intl.message(
      'Add product first',
      name: 'addProductFirst',
      desc: '',
      args: [],
    );
  }

  /// `Product code/Name`
  String get productCodeName {
    return Intl.message(
      'Product code/Name',
      name: 'productCodeName',
      desc: '',
      args: [],
    );
  }

  /// `Search by product code or name`
  String get searchByProductCodeOrName {
    return Intl.message(
      'Search by product code or name',
      name: 'searchByProductCodeOrName',
      desc: '',
      args: [],
    );
  }

  /// `No product Found`
  String get noProductFound {
    return Intl.message(
      'No product Found',
      name: 'noProductFound',
      desc: '',
      args: [],
    );
  }

  /// `Will be Added Soon`
  String get willBeAddedSoon {
    return Intl.message(
      'Will be Added Soon',
      name: 'willBeAddedSoon',
      desc: '',
      args: [],
    );
  }

  /// `Added To Cart`
  String get addedToCart {
    return Intl.message(
      'Added To Cart',
      name: 'addedToCart',
      desc: '',
      args: [],
    );
  }

  /// `Scan product QR code`
  String get scanProductQRCode {
    return Intl.message(
      'Scan product QR code',
      name: 'scanProductQRCode',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Transition`
  String get purchaseTransition {
    return Intl.message(
      'Purchase Transition',
      name: 'purchaseTransition',
      desc: '',
      args: [],
    );
  }

  /// `Pdf View`
  String get pdfView {
    return Intl.message(
      'Pdf View',
      name: 'pdfView',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this invoice`
  String get areYouSureToDeleteThisInvoice {
    return Intl.message(
      'Are you sure to delete this invoice',
      name: 'areYouSureToDeleteThisInvoice',
      desc: '',
      args: [],
    );
  }

  /// `The sale will be deleted and all the data will be deleted about this purchase.Are you sure to delete this`
  String get theSaleWillBeDeletedAndAllTheDataWill {
    return Intl.message(
      'The sale will be deleted and all the data will be deleted about this purchase.Are you sure to delete this',
      name: 'theSaleWillBeDeletedAndAllTheDataWill',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Return`
  String get purchaseReturn {
    return Intl.message(
      'Purchase Return',
      name: 'purchaseReturn',
      desc: '',
      args: [],
    );
  }

  /// `Service/Shipping`
  String get serviceShipping {
    return Intl.message(
      'Service/Shipping',
      name: 'serviceShipping',
      desc: '',
      args: [],
    );
  }

  /// `Total Return Amount`
  String get totalReturnAmount {
    return Intl.message(
      'Total Return Amount',
      name: 'totalReturnAmount',
      desc: '',
      args: [],
    );
  }

  /// `Bill/Invoice`
  String get billInvoice {
    return Intl.message(
      'Bill/Invoice',
      name: 'billInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get returN {
    return Intl.message(
      'Return',
      name: 'returN',
      desc: '',
      args: [],
    );
  }

  /// `Sells By`
  String get sellsBy {
    return Intl.message(
      'Sells By',
      name: 'sellsBy',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Invoice`
  String get purchaseInvoice {
    return Intl.message(
      'Purchase Invoice',
      name: 'purchaseInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Signature of Customer`
  String get signatureOfCustomer {
    return Intl.message(
      'Signature of Customer',
      name: 'signatureOfCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Authorized Signature`
  String get authorizedSignature {
    return Intl.message(
      'Authorized Signature',
      name: 'authorizedSignature',
      desc: '',
      args: [],
    );
  }

  /// `Powered By`
  String get poweredBy {
    return Intl.message(
      'Powered By',
      name: 'poweredBy',
      desc: '',
      args: [],
    );
  }

  /// `SL`
  String get SL {
    return Intl.message(
      'SL',
      name: 'SL',
      desc: '',
      args: [],
    );
  }

  /// `Product Description`
  String get productDescription {
    return Intl.message(
      'Product Description',
      name: 'productDescription',
      desc: '',
      args: [],
    );
  }

  /// `Warranty`
  String get warranty {
    return Intl.message(
      'Warranty',
      name: 'warranty',
      desc: '',
      args: [],
    );
  }

  /// `Unit Price`
  String get unitPrice {
    return Intl.message(
      'Unit Price',
      name: 'unitPrice',
      desc: '',
      args: [],
    );
  }

  /// `In Word`
  String get inWord {
    return Intl.message(
      'In Word',
      name: 'inWord',
      desc: '',
      args: [],
    );
  }

  /// `Generating PDF`
  String get generatingPDF {
    return Intl.message(
      'Generating PDF',
      name: 'generatingPDF',
      desc: '',
      args: [],
    );
  }

  /// `Created and Saved`
  String get createdAndSaved {
    return Intl.message(
      'Created and Saved',
      name: 'createdAndSaved',
      desc: '',
      args: [],
    );
  }

  /// `Successfully Done`
  String get successfullyDone {
    return Intl.message(
      'Successfully Done',
      name: 'successfullyDone',
      desc: '',
      args: [],
    );
  }

  /// `Return QTY`
  String get returnQTY {
    return Intl.message(
      'Return QTY',
      name: 'returnQTY',
      desc: '',
      args: [],
    );
  }

  /// `Out of Stock`
  String get outOfStock {
    return Intl.message(
      'Out of Stock',
      name: 'outOfStock',
      desc: '',
      args: [],
    );
  }

  /// `Select a product for return`
  String get selectAProductForReturn {
    return Intl.message(
      'Select a product for return',
      name: 'selectAProductForReturn',
      desc: '',
      args: [],
    );
  }

  /// `Confirm return`
  String get confirmReturn {
    return Intl.message(
      'Confirm return',
      name: 'confirmReturn',
      desc: '',
      args: [],
    );
  }

  /// `Total Purchase`
  String get totalPurchase {
    return Intl.message(
      'Total Purchase',
      name: 'totalPurchase',
      desc: '',
      args: [],
    );
  }

  /// `(From`
  String get from {
    return Intl.message(
      '(From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `to`
  String get to {
    return Intl.message(
      'to',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `(This Month)`
  String get thisMonth {
    return Intl.message(
      '(This Month)',
      name: 'thisMonth',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Return Report`
  String get purchaseReturnReport {
    return Intl.message(
      'Purchase Return Report',
      name: 'purchaseReturnReport',
      desc: '',
      args: [],
    );
  }

  /// `Total returns`
  String get totalReturns {
    return Intl.message(
      'Total returns',
      name: 'totalReturns',
      desc: '',
      args: [],
    );
  }

  /// `Ph.no`
  String get PhNo {
    return Intl.message(
      'Ph.no',
      name: 'PhNo',
      desc: '',
      args: [],
    );
  }

  /// `Loss/Profit Report`
  String get lossProfitReport {
    return Intl.message(
      'Loss/Profit Report',
      name: 'lossProfitReport',
      desc: '',
      args: [],
    );
  }

  /// `Duration: From`
  String get durationFrom {
    return Intl.message(
      'Duration: From',
      name: 'durationFrom',
      desc: '',
      args: [],
    );
  }

  /// `Sale Amount`
  String get saleAmount {
    return Intl.message(
      'Sale Amount',
      name: 'saleAmount',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon`
  String get comingSoon {
    return Intl.message(
      'Coming Soon',
      name: 'comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Total Collected`
  String get totalCollected {
    return Intl.message(
      'Total Collected',
      name: 'totalCollected',
      desc: '',
      args: [],
    );
  }

  /// `Fully Paid`
  String get fullyPaid {
    return Intl.message(
      'Fully Paid',
      name: 'fullyPaid',
      desc: '',
      args: [],
    );
  }

  /// `Still Unpaid`
  String get stillUnpaid {
    return Intl.message(
      'Still Unpaid',
      name: 'stillUnpaid',
      desc: '',
      args: [],
    );
  }

  /// `Loss/Profit Reports`
  String get lossProfitReports {
    return Intl.message(
      'Loss/Profit Reports',
      name: 'lossProfitReports',
      desc: '',
      args: [],
    );
  }

  /// `Sale Return Report`
  String get saleReturnReport {
    return Intl.message(
      'Sale Return Report',
      name: 'saleReturnReport',
      desc: '',
      args: [],
    );
  }

  /// `Sales Return`
  String get salesReturn {
    return Intl.message(
      'Sales Return',
      name: 'salesReturn',
      desc: '',
      args: [],
    );
  }

  /// `Sale Setting`
  String get saleSetting {
    return Intl.message(
      'Sale Setting',
      name: 'saleSetting',
      desc: '',
      args: [],
    );
  }

  /// `Saving`
  String get saving {
    return Intl.message(
      'Saving',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  /// `Default VAT percentage`
  String get defaultVATPercentage {
    return Intl.message(
      'Default VAT percentage',
      name: 'defaultVATPercentage',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid quantity`
  String get enterAValidQuantity {
    return Intl.message(
      'Enter a valid quantity',
      name: 'enterAValidQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid price`
  String get enterAValidPrice {
    return Intl.message(
      'Enter a valid price',
      name: 'enterAValidPrice',
      desc: '',
      args: [],
    );
  }

  /// `Sale return`
  String get saleReturn {
    return Intl.message(
      'Sale return',
      name: 'saleReturn',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this sale`
  String get areYouSureToDeleteThisSale {
    return Intl.message(
      'Are you sure to delete this sale',
      name: 'areYouSureToDeleteThisSale',
      desc: '',
      args: [],
    );
  }

  /// `The sale will be deleted and all the data will be deleted about this sale.Are you sure to delete this`
  String get theSaleWillBeDeletedAndAllTheDataWillSale {
    return Intl.message(
      'The sale will be deleted and all the data will be deleted about this sale.Are you sure to delete this',
      name: 'theSaleWillBeDeletedAndAllTheDataWillSale',
      desc: '',
      args: [],
    );
  }

  /// `Title can'n be empty`
  String get titleCanNotBeEmpty {
    return Intl.message(
      'Title can\'n be empty',
      name: 'titleCanNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Description can\'n be empty`
  String get descriptionCanNotBeEmpty {
    return Intl.message(
      'Description can\\\'n be empty',
      name: 'descriptionCanNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get updated {
    return Intl.message(
      'Updated',
      name: 'updated',
      desc: '',
      args: [],
    );
  }

  /// `Follow Us On\nFacebook`
  String get followUsOnFacebook {
    return Intl.message(
      'Follow Us On\\nFacebook',
      name: 'followUsOnFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Follow Us On\nTwitter`
  String get followUsOnTwitter {
    return Intl.message(
      'Follow Us On\\nTwitter',
      name: 'followUsOnTwitter',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe To Our\nYoutube`
  String get subscribeToOurYoutube {
    return Intl.message(
      'Subscribe To Our\\nYoutube',
      name: 'subscribeToOurYoutube',
      desc: '',
      args: [],
    );
  }

  /// `Call For Emergency Support`
  String get callForEmergencySupport {
    return Intl.message(
      'Call For Emergency Support',
      name: 'callForEmergencySupport',
      desc: '',
      args: [],
    );
  }

  /// `Live Chat Support`
  String get liveChatSupport {
    return Intl.message(
      'Live Chat Support',
      name: 'liveChatSupport',
      desc: '',
      args: [],
    );
  }

  /// `Successfully Logged Out`
  String get successfullyLoggedOut {
    return Intl.message(
      'Successfully Logged Out',
      name: 'successfullyLoggedOut',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Privacy`
  String get termsPrivacy {
    return Intl.message(
      'Terms & Privacy',
      name: 'termsPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Use`
  String get use {
    return Intl.message(
      'Use',
      name: 'use',
      desc: '',
      args: [],
    );
  }

  /// `Not Active User`
  String get notActiveUser {
    return Intl.message(
      'Not Active User',
      name: 'notActiveUser',
      desc: '',
      args: [],
    );
  }

  /// `Please use the valid purchase code to use the app`
  String get pleaseUseTheValidPurchaseCodeToUseTheApp {
    return Intl.message(
      'Please use the valid purchase code to use the app',
      name: 'pleaseUseTheValidPurchaseCodeToUseTheApp',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get OK {
    return Intl.message(
      'OK',
      name: 'OK',
      desc: '',
      args: [],
    );
  }

  /// `Thank You`
  String get thankYou {
    return Intl.message(
      'Thank You',
      name: 'thankYou',
      desc: '',
      args: [],
    );
  }

  /// `We will review the payment & approve it within 1-2 hours`
  String get weWillReviewThePaymentApproveItWithinHours {
    return Intl.message(
      'We will review the payment & approve it within 1-2 hours',
      name: 'weWillReviewThePaymentApproveItWithinHours',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Transaction Number`
  String get pleaseEnterTransactionNumber {
    return Intl.message(
      'Please Enter Transaction Number',
      name: 'pleaseEnterTransactionNumber',
      desc: '',
      args: [],
    );
  }

  /// `Request has been send`
  String get requestHasBeenSend {
    return Intl.message(
      'Request has been send',
      name: 'requestHasBeenSend',
      desc: '',
      args: [],
    );
  }

  /// `You Are Not A Valid User`
  String get youAreNotAValidUser {
    return Intl.message(
      'You Are Not A Valid User',
      name: 'youAreNotAValidUser',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited`
  String get unlimited {
    return Intl.message(
      'Unlimited',
      name: 'unlimited',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `SWIFT Code`
  String get SWIFTCode {
    return Intl.message(
      'SWIFT Code',
      name: 'SWIFTCode',
      desc: '',
      args: [],
    );
  }

  /// `Bank Account Currency`
  String get bankAccountCurrency {
    return Intl.message(
      'Bank Account Currency',
      name: 'bankAccountCurrency',
      desc: '',
      args: [],
    );
  }

  /// `notes`
  String get notes {
    return Intl.message(
      'notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Bank Transfer`
  String get bankTransfer {
    return Intl.message(
      'Bank Transfer',
      name: 'bankTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Paypal`
  String get Paypal {
    return Intl.message(
      'Paypal',
      name: 'Paypal',
      desc: '',
      args: [],
    );
  }

  /// `KKIPAY`
  String get KKIPAY {
    return Intl.message(
      'KKIPAY',
      name: 'KKIPAY',
      desc: '',
      args: [],
    );
  }

  /// `Rezorpay`
  String get Rezorpay {
    return Intl.message(
      'Rezorpay',
      name: 'Rezorpay',
      desc: '',
      args: [],
    );
  }

  /// `SSLCommerz`
  String get SSLCommerz {
    return Intl.message(
      'SSLCommerz',
      name: 'SSLCommerz',
      desc: '',
      args: [],
    );
  }

  /// `Tap`
  String get tap {
    return Intl.message(
      'Tap',
      name: 'tap',
      desc: '',
      args: [],
    );
  }

  /// `PayStack`
  String get payStack {
    return Intl.message(
      'PayStack',
      name: 'payStack',
      desc: '',
      args: [],
    );
  }

  /// `BillPlz`
  String get BillPlz {
    return Intl.message(
      'BillPlz',
      name: 'BillPlz',
      desc: '',
      args: [],
    );
  }

  /// `Cash Free`
  String get cashFree {
    return Intl.message(
      'Cash Free',
      name: 'cashFree',
      desc: '',
      args: [],
    );
  }

  /// `Iyzico`
  String get Iyzico {
    return Intl.message(
      'Iyzico',
      name: 'Iyzico',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Now`
  String get purchaseNow {
    return Intl.message(
      'Purchase Now',
      name: 'purchaseNow',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Please Select a Plan`
  String get pleaseSelectAPlan {
    return Intl.message(
      'Please Select a Plan',
      name: 'pleaseSelectAPlan',
      desc: '',
      args: [],
    );
  }

  /// `Add New Tax`
  String get addNewTax {
    return Intl.message(
      'Add New Tax',
      name: 'addNewTax',
      desc: '',
      args: [],
    );
  }

  /// `Add New Tax with single/multiple Tax type`
  String get addNewTaxWithSingleMultipleTaxType {
    return Intl.message(
      'Add New Tax with single/multiple Tax type',
      name: 'addNewTaxWithSingleMultipleTaxType',
      desc: '',
      args: [],
    );
  }

  /// `Sub Taxes`
  String get subTaxes {
    return Intl.message(
      'Sub Taxes',
      name: 'subTaxes',
      desc: '',
      args: [],
    );
  }

  /// `No Sub Tax selected`
  String get noSubTaxSelected {
    return Intl.message(
      'No Sub Tax selected',
      name: 'noSubTaxSelected',
      desc: '',
      args: [],
    );
  }

  /// `Sub Tax List`
  String get subTaxList {
    return Intl.message(
      'Sub Tax List',
      name: 'subTaxList',
      desc: '',
      args: [],
    );
  }

  /// `Tax Percentage`
  String get taxPercentage {
    return Intl.message(
      'Tax Percentage',
      name: 'taxPercentage',
      desc: '',
      args: [],
    );
  }

  /// `Already Exists`
  String get alreadyExists {
    return Intl.message(
      'Already Exists',
      name: 'alreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Tax`
  String get tax {
    return Intl.message(
      'Tax',
      name: 'tax',
      desc: '',
      args: [],
    );
  }

  /// `Tax rate`
  String get taxRate {
    return Intl.message(
      'Tax rate',
      name: 'taxRate',
      desc: '',
      args: [],
    );
  }

  /// `Enter Tax rate`
  String get enterTaxRate {
    return Intl.message(
      'Enter Tax rate',
      name: 'enterTaxRate',
      desc: '',
      args: [],
    );
  }

  /// `Edit Tax`
  String get editTax {
    return Intl.message(
      'Edit Tax',
      name: 'editTax',
      desc: '',
      args: [],
    );
  }

  /// `Name  Already Exists`
  String get nameAlreadyExists {
    return Intl.message(
      'Name  Already Exists',
      name: 'nameAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Name can\'t be empty`
  String get nameCantBeEmpty {
    return Intl.message(
      'Name can\\\'t be empty',
      name: 'nameCantBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Edit Successfully`
  String get editSuccessfully {
    return Intl.message(
      'Edit Successfully',
      name: 'editSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Edit Tax Group`
  String get editTaxGroup {
    return Intl.message(
      'Edit Tax Group',
      name: 'editTaxGroup',
      desc: '',
      args: [],
    );
  }

  /// `Tax Report`
  String get taxReport {
    return Intl.message(
      'Tax Report',
      name: 'taxReport',
      desc: '',
      args: [],
    );
  }

  /// `Tax rates- Manage your Tax rates`
  String get taxRatesManageYourTaxRates {
    return Intl.message(
      'Tax rates- Manage your Tax rates',
      name: 'taxRatesManageYourTaxRates',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Acton`
  String get acton {
    return Intl.message(
      'Acton',
      name: 'acton',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to delete this Tax`
  String get areYouSureWantToDeleteThisTax {
    return Intl.message(
      'Are you sure want to delete this Tax',
      name: 'areYouSureWantToDeleteThisTax',
      desc: '',
      args: [],
    );
  }

  /// `Tax Group`
  String get taxGroup {
    return Intl.message(
      'Tax Group',
      name: 'taxGroup',
      desc: '',
      args: [],
    );
  }

  /// `(Combination of multiple taxes)`
  String get combinationOfMultipleTaxes {
    return Intl.message(
      '(Combination of multiple taxes)',
      name: 'combinationOfMultipleTaxes',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to delete this Tax Group`
  String get areYouSureWantToDeleteThisTaxGroup {
    return Intl.message(
      'Are you sure want to delete this Tax Group',
      name: 'areYouSureWantToDeleteThisTaxGroup',
      desc: '',
      args: [],
    );
  }

  /// `No Data Found`
  String get noDataFound {
    return Intl.message(
      'No Data Found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Password and confirm password does not match`
  String get passwordAndConfirmPasswordDoesNotMatch {
    return Intl.message(
      'Password and confirm password does not match',
      name: 'passwordAndConfirmPasswordDoesNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `User title can\'n be empty`
  String get userTitleCanNotBeEmpty {
    return Intl.message(
      'User title can\\\'n be empty',
      name: 'userTitleCanNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `You Have To Give Permission`
  String get youHaveToGivePermission {
    return Intl.message(
      'You Have To Give Permission',
      name: 'youHaveToGivePermission',
      desc: '',
      args: [],
    );
  }

  /// `Registering`
  String get registering {
    return Intl.message(
      'Registering',
      name: 'registering',
      desc: '',
      args: [],
    );
  }

  /// `Failed with Error`
  String get failedWithError {
    return Intl.message(
      'Failed with Error',
      name: 'failedWithError',
      desc: '',
      args: [],
    );
  }

  /// `The password provided is too weak`
  String get thePasswordProvidedIsTooWeak {
    return Intl.message(
      'The password provided is too weak',
      name: 'thePasswordProvidedIsTooWeak',
      desc: '',
      args: [],
    );
  }

  /// `The account already exists for that email`
  String get theAccountAlreadyExistsForThatEmail {
    return Intl.message(
      'The account already exists for that email',
      name: 'theAccountAlreadyExistsForThatEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please Enter Password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `An Email has been sent\nCheck your inbox`
  String get anEmailHasBeenSentCheckYourInbox {
    return Intl.message(
      'An Email has been sent\\nCheck your inbox',
      name: 'anEmailHasBeenSentCheckYourInbox',
      desc: '',
      args: [],
    );
  }

  /// `Successfully Updated`
  String get successfullyUpdated {
    return Intl.message(
      'Successfully Updated',
      name: 'successfullyUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse List`
  String get warehouseList {
    return Intl.message(
      'Warehouse List',
      name: 'warehouseList',
      desc: '',
      args: [],
    );
  }

  /// `Total value`
  String get totalValue {
    return Intl.message(
      'Total value',
      name: 'totalValue',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get value {
    return Intl.message(
      'Value',
      name: 'value',
      desc: '',
      args: [],
    );
  }

  /// `InHouse can't be edited`
  String get inHouseCantBeEdited {
    return Intl.message(
      'InHouse can\'t be edited',
      name: 'inHouseCantBeEdited',
      desc: '',
      args: [],
    );
  }

  /// `InHouse can\'t be delete`
  String get inHouseCantBeDelete {
    return Intl.message(
      'InHouse can\\\'t be delete',
      name: 'inHouseCantBeDelete',
      desc: '',
      args: [],
    );
  }

  /// `Are you want to delete this warehouse`
  String get areYouWantToDeleteThisWarehouse {
    return Intl.message(
      'Are you want to delete this warehouse',
      name: 'areYouWantToDeleteThisWarehouse',
      desc: '',
      args: [],
    );
  }

  /// `This category Cannot be deleted`
  String get thisCategoryCannotBeDeleted {
    return Intl.message(
      'This category Cannot be deleted',
      name: 'thisCategoryCannotBeDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Add New`
  String get addNew {
    return Intl.message(
      'Add New',
      name: 'addNew',
      desc: '',
      args: [],
    );
  }

  /// `Edit Warehouse`
  String get editWarehouse {
    return Intl.message(
      'Edit Warehouse',
      name: 'editWarehouse',
      desc: '',
      args: [],
    );
  }

  /// `Category Name`
  String get categoryName {
    return Intl.message(
      'Category Name',
      name: 'categoryName',
      desc: '',
      args: [],
    );
  }

  /// `Add Description`
  String get addDescriptioN {
    return Intl.message(
      'Add Description',
      name: 'addDescriptioN',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse  Already Exists`
  String get warehouseAlreadyExists {
    return Intl.message(
      'Warehouse  Already Exists',
      name: 'warehouseAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse Name`
  String get warehouseName {
    return Intl.message(
      'Warehouse Name',
      name: 'warehouseName',
      desc: '',
      args: [],
    );
  }

  /// `Category Name Already Exists`
  String get categoryNameAlreadyExists {
    return Intl.message(
      'Category Name Already Exists',
      name: 'categoryNameAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Enter Warehouse Name`
  String get enterWarehouseName {
    return Intl.message(
      'Enter Warehouse Name',
      name: 'enterWarehouseName',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'af'),
      Locale.fromSubtags(languageCode: 'am'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'as'),
      Locale.fromSubtags(languageCode: 'az'),
      Locale.fromSubtags(languageCode: 'be'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'bs'),
      Locale.fromSubtags(languageCode: 'ca'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'cy'),
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'el'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'et'),
      Locale.fromSubtags(languageCode: 'eu'),
      Locale.fromSubtags(languageCode: 'fa'),
      Locale.fromSubtags(languageCode: 'fi'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'gl'),
      Locale.fromSubtags(languageCode: 'gu'),
      Locale.fromSubtags(languageCode: 'he'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'hr'),
      Locale.fromSubtags(languageCode: 'hu'),
      Locale.fromSubtags(languageCode: 'hy'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'is'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'km'),
      Locale.fromSubtags(languageCode: 'kn'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'ky'),
      Locale.fromSubtags(languageCode: 'lo'),
      Locale.fromSubtags(languageCode: 'lt'),
      Locale.fromSubtags(languageCode: 'lv'),
      Locale.fromSubtags(languageCode: 'mk'),
      Locale.fromSubtags(languageCode: 'ml'),
      Locale.fromSubtags(languageCode: 'mr'),
      Locale.fromSubtags(languageCode: 'ms'),
      Locale.fromSubtags(languageCode: 'my'),
      Locale.fromSubtags(languageCode: 'ne'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'no'),
      Locale.fromSubtags(languageCode: 'pa'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'ps'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ro'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'si'),
      Locale.fromSubtags(languageCode: 'sk'),
      Locale.fromSubtags(languageCode: 'sq'),
      Locale.fromSubtags(languageCode: 'sr'),
      Locale.fromSubtags(languageCode: 'sv'),
      Locale.fromSubtags(languageCode: 'sw'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'uk'),
      Locale.fromSubtags(languageCode: 'ur'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);

  @override
  Future<S> load(Locale locale) => S.load(locale);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
