import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/component/app_image_with_text.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/user/component/basic_button.dart';
import 'package:mma_flutter/user/model/verify_code_request.dart';
import 'package:mma_flutter/user/provider/smtp_provider.dart';
import 'package:mma_flutter/user/screen/join/end_join_screen.dart';
import 'package:mma_flutter/user/screen/login_screen.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const VerificationScreen({required this.email, super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  Timer? timer;
  int totalTimeSec = 300;
  final List<String> _code = List.filled(6, '');
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  bool isCodeCorrect = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                AppImageWithText(text: '이메일 인증 코드'),
                SizedBox(height: 47.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.7.w,
                  child: Column(
                    children: [
                      Text(
                        '${widget.email}으로 회원가입 이메일 인증 코드를 전송하였습니다.',
                        style: TextStyle(fontSize: 12.sp, color: GREY_COLOR),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 22.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            List.generate(
                              6,
                              (index) => SizedBox(
                                height: 36.h,
                                width: 28.w,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    counterText: '',
                                    fillColor: Color(0XFF8C8C8C),
                                    filled: true,
                                    // 텍스트 필드 선택 시 border 적용
                                  ),

                                  style: TextStyle(
                                    color: BLACK_COLOR,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      if (index < 5) {
                                        _focusNodes[index + 1].requestFocus();
                                      } else {
                                        _focusNodes[index].unfocus();
                                      }
                                    } else if (value.isEmpty && index > 0) {
                                      _focusNodes[index - 1].requestFocus();
                                    }
                                    setState(() {
                                      _code[index] = value;
                                      isCodeCorrect = true;
                                    });
                                  },
                                ),
                              ),
                            ).toList(),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        secToMinSecFormat(totalTimeSec),
                        style: TextStyle(fontSize: 15.sp, color: BLUE_COLOR),
                      ),
                      if (isCodeCorrect == false)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            '입력된 코드가 올바르지 않습니다.',
                            style: TextStyle(color: RED_COLOR, fontSize: 12.sp),
                          ),
                        ),
                      SizedBox(height: 180.h),
                    ],
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(smtpProvider.notifier)
                          .sendJoinCode(widget.email);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '인증번호를 재전송했습니다. 이메일로 전송된 인증번호 6자리를 입력해주세요.',
                          ),
                        ),
                      );
                      startTimer();
                    },
                    child: Text(
                      '인증번호 재전송',
                      style: TextStyle(
                        color: Color(0xff8c8c8c),
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BasicButton(
                    bgColor: BLUE_COLOR,
                    onPressed:
                        isCodeEmpty() || !isCodeCorrect
                            ? null
                            : () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              final res = await ref
                                  .read(smtpProvider.notifier)
                                  .verifyCode(
                                    VerifyCodeRequest(
                                      email: widget.email,
                                      verifyingCode: _code.join(),
                                    ),
                                  );
                              if (res != SmtpStatus.verified) {
                                setState(() {
                                  isCodeCorrect = false;
                                });
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return EndJoinScreen(email: widget.email,);
                                    },
                                  ),
                                );
                              }
                            },
                    text: '다음',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isCodeEmpty() {
    for (String c in _code) {
      if (c.isEmpty) {
        return true;
      }
    }
    return false;
  }

  void reduceTime(Timer timer) {
    if (totalTimeSec == 0) {
      setState(() {
        timer.cancel();
      });
    } else {
      setState(() {
        totalTimeSec -= 1;
      });
    }
  }

  String secToMinSecFormat(int sec) {
    final duration = Duration(seconds: sec);
    return '${duration.toString().split('.').first.substring(2, 7).replaceAll(':', '분 ').replaceFirst('0', '')}초';
  }

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    totalTimeSec = 300;
    timer = Timer.periodic(Duration(seconds: 1), reduceTime);
  }
}
