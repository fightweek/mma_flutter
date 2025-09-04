import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fight_event/model/i_fighter_fight_event_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/screen/fighter_detail_screen.dart';

class FightEventCardRow extends StatelessWidget {
  final IFighterFightEvent ffe;
  final BuildContext context;
  final WidgetRef ref;

  const FightEventCardRow({
    super.key,
    required this.ffe,
    required this.context,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _imageCard(context, ffe.winner, ref, true),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Column(
                        children: [
                          Text(
                            _firstName(ffe.winner.name),
                            style: defaultTextStyle.copyWith(fontSize: 14.h),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            _lastName(ffe.winner.name),
                            style: defaultTextStyle.copyWith(fontSize: 14.h),
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
                    Row(
                      children: [
                        if (ffe.result != null)
                          Icon(Icons.check, size: 16, color: Colors.green),
                        SizedBox(width: 2),
                        if (ffe.result != null)
                          Text(
                            winMethodMap[ffe.result!.winMethod]!,
                            style: defaultTextStyle.copyWith(fontSize: 10.0),
                          ),
                      ],
                    ),
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
    );
  }

  String _firstName(String name){
    return name.contains(' ') ? name.split(' ')[0] : name;
  }

  String _lastName(String name){
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
      child: CachedNetworkImage(
        key: ValueKey(fighter.id),
        width: 78.w,
        height: 78.h,
        imageUrl: fighter.headshotUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) {
          return Image.asset('asset/img/component/default-headshot.png');
        },
      ),
    );
  }
}
