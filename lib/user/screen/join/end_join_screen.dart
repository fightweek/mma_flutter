import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/component/app_image_with_text.dart';
import 'package:mma_flutter/common/component/auth_text_form_field.dart';
import 'package:mma_flutter/common/component/input_vaiidator.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/common/screen/splash_screen.dart';
import 'package:mma_flutter/user/component/basic_button.dart';
import 'package:mma_flutter/user/model/join_request.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class EndJoinScreen extends ConsumerStatefulWidget {
  final String email;

  const EndJoinScreen({required this.email, super.key});

  @override
  ConsumerState<EndJoinScreen> createState() => _EndJoinScreenState();
}

class _EndJoinScreenState extends ConsumerState<EndJoinScreen> {
  final _formKey = GlobalKey<FormState>();
  bool? isNicknameDup;
  String nickname = '';
  String password = '';
  String passwordConfirm = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider);

    if (state is UserModelLoading) {
      return Center(child: SplashScreen());
    }

    return DefaultLayout(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 310.w,
                  child: Column(
                    children: [
                      AppImageWithText(text: '회원가입'),
                      SizedBox(height: 37.h),
                      _inputLabel(label: '닉네임'),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 5.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 220.w,
                                      child: AuthTextFormField(
                                        onChanged: (val) {
                                          setState(() {
                                            nickname = val;
                                            isNicknameDup = null;
                                          });
                                        },
                                        hintText: '닉네임을 입력해주세요.',
                                        borderSideWidth: 2.w,
                                        borderRadiusSize: 8.r,
                                        borderSideColor: _nicknameBorderColor(),
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(75.w, 34.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        backgroundColor: GREY_COLOR,
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed:
                                          nickname.isEmpty ||
                                                  nickname.length < 2
                                              ? null
                                              : () async {
                                                final dup = await ref
                                                    .read(userProvider.notifier)
                                                    .checkDupNickname(nickname);
                                                setState(() {
                                                  isNicknameDup = dup;
                                                });
                                              },
                                      child: Text(
                                        '중복 확인',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Color(0xff8c8c8c),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // 메시지 영역 (항상 고정 높이로 잡으면 버튼 위치도 안 밀림)
                                SizedBox(
                                  height: 20.h, // 메시지 영역 높이 고정
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: _renderNicknameMessage(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            _inputLabel(label: '비밀번호 입력'),
                            SizedBox(height: 5.h),
                            AuthTextFormField(
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                                _formKey.currentState!.validate();
                              },
                              hintText: '6자 이상 입력해주세요.',
                              borderSideWidth: 2.w,
                              borderRadiusSize: 8.r,
                              validator: InputValidator.validator('비밀번호'),
                            ),
                            SizedBox(height: 12.h),
                            _inputLabel(label: '비밀번호 확인'),
                            SizedBox(height: 5.h),
                            AuthTextFormField(
                              onChanged: (val) {
                                setState(() {
                                  passwordConfirm = val;
                                });
                                _formKey.currentState!.validate();
                              },
                              hintText: '비밀번호를 다시 입력해주세요.',
                              borderSideWidth: 2.w,
                              borderRadiusSize: 8.r,
                              validator:
                                  (String? value) => _validatePasswordConfirm(
                                    password,
                                    passwordConfirm,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.h),
              child: BasicButton(
                bgColor: BLUE_COLOR,
                onPressed:
                    (_validatePasswordConfirm(password, passwordConfirm) !=
                                null) ||
                            nickname.length < 2 ||
                            (isNicknameDup ?? true) ||
                            password.length < 6
                        ? null
                        : () {
                          ref
                              .read(userProvider.notifier)
                              .join(
                                request: JoinRequest(
                                  email: widget.email,
                                  nickname: nickname,
                                  password: password,
                                ),
                              );
                        },
                text: '회원가입 완료',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color? _nicknameBorderColor() {
    if (nickname.isEmpty) return null;
    if (nickname.length < 2 || (isNicknameDup ?? false)) return RED_COLOR;
    if (isNicknameDup == null) return null;
    return BLUE_COLOR;
  }

  Widget _inputLabel({required String label}) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        label,
        style: TextStyle(color: Color(0xff8c8c8c), fontSize: 12.sp),
      ),
    );
  }

  String? _validatePasswordConfirm(String password, String passwordConfirm) {
    if (passwordConfirm.isEmpty) {
      return '비밀번호 확인칸을 입력하세요';
    } else if (password != passwordConfirm) {
      return '입력한 비밀번호가 서로 다릅니다.';
    } else {
      return null;
    }
  }

  Text _renderNicknameMessage() {
    print('!render!');
    bool isError = true;
    String message = '';
    if (nickname.isNotEmpty) {
      if (nickname.trim().length < 2) {
        message = '닉네임의 최소 길이는 2입니다.';
      }
      if (isNicknameDup != null) {
        if (!isNicknameDup!) {
          isError = false;
          message = '사용 가능한 닉네임입니다.';
        } else {
          message = '이미 사용중인 닉네임입니다.';
        }
      }
    }
    return Text(
      message,
      style: TextStyle(
        fontSize: 12.sp,
        color: isError ? RED_COLOR : BLUE_COLOR,
      ),
    );
  }
}
