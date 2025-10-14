import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/component/point_with_icon.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/stream/bet/component/bet_alert_dialog.dart';
import 'package:mma_flutter/stream/bet/component/bet_card.dart';
import 'package:mma_flutter/stream/bet/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet/provider/bet_card_provider.dart';
import 'package:mma_flutter/stream/bet/provider/bet_history_provider.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class BetScreen extends ConsumerStatefulWidget {
  final TabController tabController;

  const BetScreen({required this.tabController, super.key});

  @override
  ConsumerState<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends ConsumerState<BetScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    print('bet screen init state');
    formKey = GlobalKey<FormState>();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final betList = ref.watch(betTargetProvider);

    print('rebuild');
    final user = ref.watch(userProvider) as UserModel;

    if (betList.isEmpty) {
      return Container(
        color: DARK_GREY_COLOR,
        child: Center(
          child: Text(
            '이벤트 화면에서 배팅하실 카드를 선택하세요.',
            style: defaultTextStyle.copyWith(fontSize: 16.0),
          ),
        ),
      );
    }

    return SafeArea(
      child: Container(
        color: DARK_GREY_COLOR,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 20.w),
              child: PointWithIcon(point: user.point),
            ),
            Center(
              child: Text(
                '다음 경기의 승자는?',
                style: defaultTextStyle.copyWith(fontSize: 17.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.h, bottom: 2.h, right: 20.w),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        titleMsg: '포인트 배당',
                        contentMsg: betDescription,
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '포인트 배당 ',
                      style: defaultTextStyle.copyWith(
                        color: GREY_COLOR,
                        fontSize: 12.sp,
                      ),
                    ),
                    Icon(Icons.help_outline_sharp, color: GREY_COLOR, size: 16),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  print(index);
                  return BetCard(bet: betList[index], user: user, index: index);
                },
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemCount: betList.length,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Form(
                  key: formKey,
                  child: SizedBox(
                    width: 362.w,
                    child: TextFormField(
                      controller: controller,
                      onChanged: (val) {
                        if (int.tryParse(val) != null) {
                          formKey.currentState!.validate();
                        }
                      },
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 16.w,
                          bottom: 10.h,
                          top: 10.h,
                        ),
                        prefixIcon: Image.asset(
                          'asset/img/icon/point.png',
                          width: 12.w,
                          height: 12.h,
                        ),
                        filled: true,
                        fillColor: BLACK_COLOR,
                        border: linearGradientInputBorder,
                        enabledBorder: linearGradientInputBorder,
                        focusedBorder: linearGradientInputBorder,
                      ),
                      validator: _validator,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: SizedBox(
                  width: 127.w,
                  height: 31.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: BLUE_COLOR,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () {
                      bool allValid = formKey.currentState?.validate() ?? false;
                      print(allValid);
                      if (allValid) {
                        int seedPoint = int.parse(controller.text);
                        print(seedPoint);
                        allValid = seedPoint <= user.point;
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              titleMsg: '실패',
                              contentMsg:
                                  '배팅 실패. 선택하신 모든 배팅 항목들에 대해 값을 입력해주세요.',
                            );
                          },
                        );
                        return;
                      }
                      if (allValid) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BetAlertDialog(
                              tabController: widget.tabController,
                              textEditingController: controller,
                            );
                          },
                        );
                      } else {
                        print('실패');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              titleMsg: '실패',
                              contentMsg: '배팅 실패. 전체 입력 포인트가 보유하신 포인트보다 높습니다.',
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      '전체 배팅하기',
                      style: defaultTextStyle.copyWith(fontSize: 14.sp),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validator(String? val) {
    final userPoint = (ref.read(userProvider) as UserModel).point;
    if (val == null || val.trim().isEmpty) {
      print('val is null');
      return '배팅하실 포인트를 입력해주세요.';
    }
    if (int.tryParse(val) != null) {
      int parsedVal = int.parse(val);
      print('parsedVal = $parsedVal');
      if (parsedVal <= 0) {
        print('val equal of lower than 0');
        return '0보다 큰 포인트를 배팅해주세요.';
      }
      if (parsedVal % 100 != 0) {
        print('val should be multiple of 10');
        return '배팅 포인트는 100의 배수여야 합니다.';
      }
      if (parsedVal > userPoint) {
        print('point shortage');
        return '포인트가 부족합니다.';
      }
    }
    return null;
  }
}
