// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Boiler Plate App';

  @override
  String get enterPhoneNumber => 'Enter Your Phone Number';

  @override
  String get sendVerificationCode => 'We\'ll send you a verification code';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberHint => '+1 234 567 8900';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get reset => 'Reset';

  @override
  String get success => 'Success';

  @override
  String get ok => 'OK';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get pleaseEnterValidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get termsAndPrivacy =>
      'By continuing, you agree to our Terms of Service and Privacy Policy';
}
