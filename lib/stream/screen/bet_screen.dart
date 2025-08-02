import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/stream/bet_and_vote/component/bet_card.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/single_bet_model.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class BetScreen extends ConsumerStatefulWidget {
  const BetScreen({super.key});

  @override
  ConsumerState<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends ConsumerState<BetScreen> {
  late List<GlobalKey<FormState>> formKeys;
  late List<TextEditingController> controllers;
  late List<GlobalKey<BetCardState>> cardKeys;

  @override
  void initState() {
    super.initState();
    print('bet screen init state');
    final List<SingleBetModel> betList = ref.read(betTargetProvider);
    formKeys = List.generate(
      betList.length,
          (_) => GlobalKey<FormState>(),
    );
    controllers = List.generate(
      betList.length,
          (_) => TextEditingController(),
    );
    cardKeys =
    betList.map((_) => GlobalKey<BetCardState>()).toList();
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
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        FontAwesomeIcons.coins,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    WidgetSpan(child: SizedBox(width: 4.0)),
                    TextSpan(
                      text: user.point.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return BetCard(
                    key: cardKeys[index],
                    controller: controllers[index],
                    formKey: formKeys[index],
                    onSeedChanged: (val) {
                      if (int.tryParse(val) != null) {
                        formKeys[index].currentState!.validate();
                        // _predictedPoint = _calculateTotalProfit(_seedPoint!);
                      }
                    },
                    bet: betList[index],
                    user: user,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 20.0),
                itemCount: betList.length,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  bool allValid = formKeys.every(
                    (key) => key.currentState?.validate() ?? false,
                  );
                  if (allValid) {
                    int totalSeedPoints = controllers.fold(
                      0,
                      (prev, next) => prev + int.parse(next.text),
                    );
                    print(totalSeedPoints);
                    allValid = totalSeedPoints <= user.point;
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          titleMsg: '실패',
                          contentMsg: '배팅 실패. 선택하신 모든 배팅 항목들에 대해 값을 입력해주세요.',
                        );
                      },
                    );
                    return;
                  }
                  if (allValid) {
                    final singleBets =
                        cardKeys
                            .mapIndexed(
                              (index, e) =>
                                  e.currentState?.toRequest(controllers[index]),
                            )
                            .whereType<SingleBetRequestModel>()
                            .toList();
                    ref
                        .read(streamFightEventProvider.notifier)
                        .bet(BetRequestModel(singleBets: singleBets));
                    print('성공');
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
                child: Text('전체 배팅하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
