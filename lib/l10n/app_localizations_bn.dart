// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'বয়লার প্লেট অ্যাপ';

  @override
  String get enterPhoneNumber => 'আপনার ফোন নম্বর দিন';

  @override
  String get sendVerificationCode => 'আমরা আপনাকে একটি যাচাইকরণ কোড পাঠাব';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get phoneNumberHint => '+১ ২৩৪ ৫৬৭ ৮৯০০';

  @override
  String get sendOtp => 'OTP পাঠান';

  @override
  String get reset => 'রিসেট';

  @override
  String get success => 'সফল';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get pleaseEnterPhoneNumber => 'অনুগ্রহ করে আপনার ফোন নম্বর দিন';

  @override
  String get pleaseEnterValidPhoneNumber =>
      'অনুগ্রহ করে একটি বৈধ ফোন নম্বর দিন';

  @override
  String get termsAndPrivacy =>
      'চালিয়ে যাওয়ার মাধ্যমে, আপনি আমাদের সেবার শর্তাবলী এবং গোপনীয়তা নীতি মেনে চলার সম্মতি দিচ্ছেন';

  @override
  String get verifyOtp => 'OTP যাচাই করুন';

  @override
  String get enterVerificationCode => 'যাচাইকরণ কোড দিন';

  @override
  String get verificationCodeSent =>
      'আমরা আপনার ফোনে একটি ৬-অঙ্কের যাচাইকরণ কোড পাঠিয়েছি';

  @override
  String get verificationCode => 'যাচাইকরণ কোড';

  @override
  String get verify => 'যাচাই করুন';

  @override
  String get resendCode => 'কোড পুনরায় পাঠান';

  @override
  String get didntReceiveCode => 'কোড পাননি?';

  @override
  String get pleaseEnterOtp => 'অনুগ্রহ করে যাচাইকরণ কোড দিন';

  @override
  String get pleaseEnterValidOtp => 'অনুগ্রহ করে একটি বৈধ ৬-অঙ্কের কোড দিন';

  @override
  String get otpVerified => 'OTP সফলভাবে যাচাই হয়েছে';

  @override
  String get otpVerificationFailed => 'OTP যাচাইকরণ ব্যর্থ';

  @override
  String resendIn(String seconds) {
    return '$seconds সেকেন্ডে পুনরায় পাঠান';
  }

  @override
  String get resendAvailable => 'কোড পুনরায় পাঠানো উপলব্ধ';
}
