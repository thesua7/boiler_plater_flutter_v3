import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/route/route_constant.dart';
import '../../../../../core/widgets/otp_input_field.dart';
import '../../../../../core/responsive/responsive.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../../auth_binding.dart';
import '../bloc/verify_otp_bloc.dart';
import '../bloc/verify_otp_event.dart';
import '../bloc/veriy_otp_state.dart';

/// Verify OTP Form Widget
class VerifyOtpForm extends StatefulWidget {
  final String phoneNumber;
  
  const VerifyOtpForm({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<VerifyOtpForm> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends State<VerifyOtpForm> {
  final _formKey = GlobalKey<FormState>();
  String _otp = '';
  bool _isOtpValid = false;
  int _resendTimer = 0;
  bool _canResend = true;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 60; // 60 seconds timer
      _canResend = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendTimer--;
          if (_resendTimer <= 0) {
            _canResend = true;
          }
        });
        return _resendTimer > 0;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          _showSuccessDialog(context, "Verified Successfully");
        } else if (state is VerifyOtpError) {
          _showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is VerifyOtpLoading;
        
        return ResponsiveBuilder(
          builder: (context, screenSize, isLandscape) {
            return Form(
              key: _formKey,
              child: ResponsiveColumn(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 40)),
                  
                  // Header
                  ResponsiveText(
                    l10n.enterVerificationCode,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                  
                  ResponsiveText(
                    l10n.verificationCodeSent,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                  
                  // Phone number display
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
                      vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.getResponsiveBorderRadius(context, 8),
                      ),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: ResponsiveText(
                      widget.phoneNumber,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 48)),
                  
                  // OTP Input Field
                  OtpInputField(
                    length: 6,
                    enabled: !isLoading,
                    onChanged: (value) {
                      setState(() {
                        _otp = value;
                        _isOtpValid = value.length == 6;
                      });
                    },
                    onCompleted: (value) {
                      if (value.length == 6) {
                        _verifyOtp();
                      }
                    },
                    errorText: _otp.isNotEmpty && _otp.length < 6 
                      ? l10n.pleaseEnterValidOtp 
                      : null,
                  ),
                  
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),
                  
                  // Verify Button
                  ResponsiveButton(
                    onPressed: _isOtpValid && !isLoading ? _verifyOtp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveBorderRadius(context, 12),
                        ),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: ResponsiveUtils.getResponsiveFontSize(context, 20),
                            width: ResponsiveUtils.getResponsiveFontSize(context, 20),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : ResponsiveText(
                            l10n.verify,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
                  
                  // Resend Code Section
                  ResponsiveColumn(
                    children: [
                      ResponsiveText(
                        l10n.didntReceiveCode,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                      
                      if (_canResend)
                        TextButton(
                          onPressed: isLoading ? null : _resendOtp,
                          child: ResponsiveText(
                            l10n.resendCode,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                            ),
                          ),
                        )
                      else
                        ResponsiveText(
                          l10n.resendIn(_resendTimer.toString()),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Back to phone number
                  TextButton(
                    onPressed: isLoading ? null : _goBack,
                    child: ResponsiveText(
                      '← Back to phone number',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Verify OTP
  void _verifyOtp() {
    if (_otp.length == 6) {
      context.read<VerifyOtpBloc>().add(
        VerifyOtp(phone: widget.phoneNumber, otp: _otp),
      );
    }
  }

  /// Resend OTP
  void _resendOtp() {
    context.read<VerifyOtpBloc>().add(const VerifyOtpResend());
    _startResendTimer();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP resent to ${widget.phoneNumber}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Go back to phone number entry
  void _goBack() {
    context.go(RouteConstant.sendOtp);
  }

  /// Show success dialog
  void _showSuccessDialog(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.success),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to next screen or home
              _navigateToNext();
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Navigate to next screen after successful verification
  void _navigateToNext() {
    // Navigate to home screen after successful verification
    context.go(RouteConstant.home);
  }
}
