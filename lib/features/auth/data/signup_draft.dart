import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupDraft {
  final String phone;
  final String otp;
  final String firstName;
  final String lastName;
  final String? campusId;
  final String? campusName;
  final String? referralCode;
  final bool resumeOtp;

  const SignupDraft({
    this.phone = '',
    this.otp = '',
    this.firstName = '',
    this.lastName = '',
    this.campusId,
    this.campusName,
    this.referralCode,
    this.resumeOtp = false,
  });

  SignupDraft copyWith({
    String? phone,
    String? otp,
    String? firstName,
    String? lastName,
    String? campusId,
    String? campusName,
    String? referralCode,
    bool? resumeOtp,
  }) {
    return SignupDraft(
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      campusId: campusId ?? this.campusId,
      campusName: campusName ?? this.campusName,
      referralCode: referralCode ?? this.referralCode,
      resumeOtp: resumeOtp ?? this.resumeOtp,
    );
  }
}

class SignupDraftNotifier extends Notifier<SignupDraft> {
  @override
  SignupDraft build() => const SignupDraft();

  void setPhone(String phone) => state = state.copyWith(phone: phone);

  void setOtp(String otp) => state = state.copyWith(otp: otp);

  void setNames({required String firstName, required String lastName}) {
    state = state.copyWith(firstName: firstName, lastName: lastName);
  }

  void setCampus({required String id, required String name}) {
    state = state.copyWith(campusId: id, campusName: name);
  }

  void setReferral(String? code) => state = state.copyWith(referralCode: code);

  void markResumeOtp() => state = state.copyWith(resumeOtp: true);

  void clearResumeOtp() => state = state.copyWith(resumeOtp: false);

  void clear() => state = const SignupDraft();
}

final signupDraftProvider = NotifierProvider<SignupDraftNotifier, SignupDraft>(
  SignupDraftNotifier.new,
);
