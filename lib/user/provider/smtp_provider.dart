import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/user/model/verify_code_request.dart';
import 'package:mma_flutter/user/repository/smtp_repository.dart';

enum SmtpStatus { none, loading, error, verified, failed }

final smtpProvider = StateNotifierProvider<SmtpStateNotifier, SmtpStatus>((
  ref,
) {
  final smtpRepository = ref.read(smtpRepositoryProvider);
  return SmtpStateNotifier(smtpRepository: smtpRepository);
});

class SmtpStateNotifier extends StateNotifier<SmtpStatus> {
  final SmtpRepository smtpRepository;

  SmtpStateNotifier({required this.smtpRepository}) : super(SmtpStatus.none);

  Future<bool> sendJoinCode(String emailTo) async {
    try {
      state = SmtpStatus.loading;
      final res = await smtpRepository.sendJoinCode(
        emailTo: {'emailTo': emailTo},
      );
      if (res) {
        return true;
      }
      return false;
    } catch (e) {
      state = SmtpStatus.error;
      return false;
    }
  }

  setStateNone(){
    state = SmtpStatus.none;
  }

  Future<SmtpStatus> verifyCode(VerifyCodeRequest request) async {
    try {
      await smtpRepository.verifyCode(request: request);
      state = SmtpStatus.verified;
    } on DioException catch (e) {
      /// 이메일로 전송된 코드와 화면에 입력한 코드가 일치하지 않을 때 (400 error)
      if ((e.response?.statusCode!) == 400) {
        state = SmtpStatus.failed;
      } else {
        state = SmtpStatus.error;
      }
    }
    return state;
  }
}
