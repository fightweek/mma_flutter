import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fight_event/model/abst/i_fighter_fight_event_model.dart';
import 'package:mma_flutter/fight_event/screen/fighter_fight_event/fighter_fight_event_detail_screen.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/screen/fighter_detail_screen.dart';

class FighterFightEventCardRow extends ConsumerWidget {
  final IFighterFightEvent ffe;
  final BuildContext context;

  const FighterFightEventCardRow({
    super.key,
    required this.ffe,
    required this.context,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 86.h,
      width: 362.w,
      decoration: BoxDecoration(
        color: BLACK_COLOR,
        borderRadius: BorderRadius.circular(8.r),
        border: BoxBorder.all(color: GREY_COLOR, width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _imageCard(context, ffe.winner, ref, true),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        child: Column(
                          children: [
                            Text(
                              _firstName(ffe.winner.name),
                              style: defaultTextStyle.copyWith(
                                fontSize: 14.h,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              _lastName(ffe.winner.name),
                              style: defaultTextStyle.copyWith(
                                fontSize: 14.h,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              '${ffe.winner.record.win}-${ffe.winner.record.loss}-${ffe.winner.record.draw}',
                              style: defaultTextStyle.copyWith(
                                fontSize: 14.h,
                                color: GREY_COLOR,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (ffe.result != null) _renderWinMethodFromWinner(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 24,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (ffe.title)
                    Text(
                      '타이틀전',
                      style: defaultTextStyle.copyWith(
                        color: Colors.yellow,
                        fontSize: 5.0,
                      ),
                    ),
                  Text('VS', style: defaultTextStyle.copyWith(fontSize: 12)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _firstName(ffe.loser.name),
                        style: defaultTextStyle.copyWith(fontSize: 14.0),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        _lastName(ffe.loser.name),
                        style: defaultTextStyle.copyWith(fontSize: 14.0),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        '${ffe.loser.record.win}-${ffe.loser.record.loss}-${ffe.loser.record.draw}',
                        style: defaultTextStyle.copyWith(
                          fontSize: 14.0,
                          color: GREY_COLOR,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _imageCard(context, ffe.loser, ref, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _firstName(String name) {
    return name.contains(' ') ? name.split(' ')[0] : name;
  }

  String _lastName(String name) {
    return !name.contains(' ') ? '' : name.split(' ')[1];
  }

  _imageCard(
    BuildContext context,
    FighterModel fighter,
    WidgetRef ref,
    bool left,
  ) {
    return GestureDetector(
      onTap: () {
        print(fighter.id);
        context.pushNamed(
          FighterDetailScreen.routeName,
          pathParameters: {'id': fighter.id.toString()},
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: CachedNetworkImage(
          key: ValueKey(fighter.id),
          width: 86.w,
          height: 55.h,
          imageUrl: fighter.headshotUrl!,
          placeholder:
              (context, url) => Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: DARK_GREY_COLOR,
                    border: Border.all(width: 1.w, color: GREY_COLOR),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  width: 86.w,
                  height: 86.h,
                ),
              ),
          errorWidget: (context, url, error) {
            return Image.asset('asset/img/component/default-headshot.png');
          },
        ),
      ),
    );
  }

  Widget _renderWinMethodFromWinner() {
    return Row(
      children: [
        Icon(Icons.check, size: 16, color: Colors.green),
        SizedBox(width: 2),
        SizedBox(
          width: 60.w,
          child: Text(
            winMethodMap[ffe.result!.winMethod] ?? '',
            style: defaultTextStyle.copyWith(fontSize: 10.0),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
