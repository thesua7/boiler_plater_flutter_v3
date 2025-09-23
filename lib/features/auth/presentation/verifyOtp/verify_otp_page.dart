import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/language_switcher.dart';


import '../../auth_binding.dart';
import 'widgets/verify_otp_form.dart';

/// Verify OTP Page
class VerifyOtpPage extends StatelessWidget {
  final String phoneNumber;
  
  const VerifyOtpPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.verifyOtp),
        centerTitle: true,
        elevation: 0,
        actions: const [
          LanguageSwitcher(),
          SizedBox(width: 8),
        ],
      ),
      body: BlocProvider(
        create: (context) => AuthBinding.verifyOtpBloc,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: VerifyOtpForm(phoneNumber: phoneNumber),
          ),
        ),
      ),
    );
  }
}
