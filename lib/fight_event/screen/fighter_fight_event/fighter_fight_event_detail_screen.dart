import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/fight_event/component/fighter_fight_event_detail_stat.dart';
import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';
import 'package:mma_flutter/fight_event/provider/fight_event_provider.dart';

class FighterFightEventDetailScreen extends ConsumerWidget {
  static String get routeName => 'fighter_fight_event_detail_screen';

  final String eventName;
  final CardDateTimeInfoModel? cardStartDateTimeInfo;
  final String fightWeight;
  final bool isTitle;
  final int? whichCard;
  final int id;

  const FighterFightEventDetailScreen({
    required this.eventName,
    required this.id,
    required this.cardStartDateTimeInfo,
    required this.fightWeight,
    required this.isTitle,
    required this.whichCard,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(fighterFightEventDetailFutureProvider(id));
    return DefaultLayout(
      child: data.when(
        error: (error, stackTrace) {
          print(error);
          print(stackTrace);
          return Center(
            child: ElevatedButton(
              onPressed: () {
                ref.invalidate(fighterFightEventDetailFutureProvider);
              },
              child: Text('다시 시도'),
            ),
          );
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
        data: (data) {
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Text(
                  eventName,
                  style: defaultTextStyle.copyWith(fontSize: 24.sp),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${weightClassMap[fightWeight] ?? ''} ${isTitle ? '타이틀전' : '매치'}',
                      style: TextStyle(
                        color: GREY_COLOR,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (whichCard != null)
                      Text(
                        ' / ${whichCard == mainCard
                            ? '메인'
                            : whichCard == prelimCard
                            ? '언더'
                            : '파이트 패스 언더'} 카드',
                        style: TextStyle(
                          color: GREY_COLOR,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                if (cardStartDateTimeInfo != null)
                  Text(
                    '${DataUtils.formatDateTime(cardStartDateTimeInfo!.date)} ${DataUtils.formatDurationToHHMM(cardStartDateTimeInfo!.time)} KST',
                    style: TextStyle(fontSize: 12.sp, color: GREY_COLOR),
                  ),
                SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: 0.95.w,
                          child: _renderImageWithOpacity(data.winner.bodyUrl),
                        ),
                      ),
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scale(-1.0, 1.0),
                            child: _renderImageWithOpacity(data.loser.bodyUrl),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FighterFightEventDetailStat(
                  winner: data.winner,
                  loser: data.loser,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _renderImageWithOpacity(String imgUrl) {
    return Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, BLACK_COLOR.withValues(alpha: 0.5)],
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        height: 344.h,
        width: 226.w,
        fit: BoxFit.contain,
        errorWidget: (context, url, error) {
          return Image.asset('asset/img/component/default-headshot.png');
        },
      ),
    );
  }
}
