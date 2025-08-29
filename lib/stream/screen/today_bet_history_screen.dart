import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/today_bet_response_model.dart';
import 'package:mma_flutter/stream/provider/today_bet_history_provider.dart';

class TodayBetHistoryScreen extends ConsumerStatefulWidget {
  const TodayBetHistoryScreen({super.key});

  @override
  ConsumerState<TodayBetHistoryScreen> createState() => _TodayBetHistoryScreenState();
}

class _TodayBetHistoryScreenState extends ConsumerState<TodayBetHistoryScreen> {

  @override
  void initState() {
    print('init today bet history_screen');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todayBetHistoryProvider.notifier).getTodayBetHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todayBetHistoryProvider);

    if (state is StateLoading) {
      return Container(color: BLACK_COLOR, child: Center(child: CircularProgressIndicator()));
    }

    if (state is StateError) {
      return Container(
        color: BLACK_COLOR,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              ref.read(todayBetHistoryProvider.notifier).getTodayBetHistory();
            },
            child: Text('다시시도',style: defaultTextStyle,),
          ),
        ),
      );
    }

    final todayBetHistory = state as StateData<TodayBetResponseModel>;

    if (todayBetHistory.data == null) {
      return Container(
        color: BLACK_COLOR,
        child: SizedBox.expand(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Text('오늘의 배팅 기록이 없습니다.', style: defaultTextStyle),
            ),
          ),
        ),
      );
    }

    final sortedSingleBets =
        todayBetHistory.data!.singleBets
          ..sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));

    return SafeArea(
      child: Container(
        color: BLACK_COLOR,
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return _renderSingleBet(sortedSingleBets[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 4.h);
                },
                itemCount: todayBetHistory.data!.singleBets.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderSingleBet(SingleBetResponseModel singleBet) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2.w),
          color: DARK_GREY_COLOR,
        ),
        child: Column(
          children: [
            Text(
              _renderTimeFromDateTime(singleBet.createdDateTime),
              style: defaultTextStyle,
            ),
            ...List.generate(singleBet.betCards.length, (index) {
              return _renderSingleBetCard(singleBet.betCards[index],index);
            }),
          ],
        ),
      ),
    );
  }

  Widget _renderSingleBetCard(SingleBetCardResponseModel singleBetCard, int index) {
    final betPrediction = singleBetCard.betPrediction;
    final winMethod = betPrediction.winMethod;
    final winRound = betPrediction.winRound;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: BLACK_COLOR, width: 2.w),
        color: DARK_GREY_COLOR,
      ),
      child: Column(
        children: [
          Text(
            '\n[카드 $index]\n승자: ${betPrediction.winnerName}\n'
            '패자: ${betPrediction.loserName}',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          if (winMethod != null)
            Text(
              '승리 방식: ${winMethod.label}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          if (winRound != null)
            Text(
              '예측 라운드: $winRound',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          Text(
            '예측 성공 여부: ${singleBetCard.succeed}',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          Text(
            '배팅 포인트 : ${singleBetCard.seedPoint}',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          Text(
            '성공 시 획득 가능 포인트 : -\n',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _renderTimeFromDateTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    return '생성 시각: $hour시 $minute분';
  }
}
