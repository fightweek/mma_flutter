import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fight_event/screen/fight_event_detail_screen.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/screen/fighter_detail_screen.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';

import '../model/fight_event_model.dart';

class FightEventCard extends ConsumerWidget {
  final IFighterFightEvent ffe;
  final bool isUpcoming;
  final bool isDetail;
  final bool isStream;

  const FightEventCard({
    super.key,
    required this.ffe,
    required this.isUpcoming,
    required this.isDetail,
    required this.isStream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isStream ? Colors.black : MY_DARK_GREY_COLOR,
          borderRadius: BorderRadius.circular(10.0),
          border:
              isStream
                  ? BoxBorder.all(
                    color:
                        (isStream &&
                                (ffe as StreamFighterFightEventModel).status ==
                                    StreamFighterFightEventStatus.now)
                            ? Colors.blue
                            : Colors.white,
                    width: 2,
                  )
                  : null,
        ),
        width: MediaQuery.of(context).size.width / 1.1,
        child: Column(
          children: [
            if (isDetail)
              header(
                context,
                eventDate: (ffe as FighterFightEventModel).eventDate,
                eventName: (ffe as FighterFightEventModel).eventName,
                isDetail: true,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _imageCard(context, ffe.winner, ref),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${_splitName(ffe.winner.name)}\n${ffe.winner.record.win}-${ffe.winner.record.loss}-${ffe.winner.record.draw}',
                        style: defaultTextStyle,
                      ),
                      Row(
                        children: [
                          if (ffe.result != null)
                            Icon(Icons.check, size: 16, color: Colors.green),
                          SizedBox(width: 4),
                          if (ffe.result != null)
                            Text(
                              ffe.result!.winMethod,
                              style: defaultTextStyle,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 32.0,
                  child: Text('VS', style: defaultTextStyle),
                ),
                Expanded(
                  child: Text(
                    '${_splitName(ffe.loser.name)}\n${ffe.loser.record.win}-${ffe.loser.record.loss}-${ffe.loser.record.draw}',
                    style: defaultTextStyle,
                  ),
                ),
                _imageCard(context, ffe.loser, ref),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _splitName(String name) {
    if (name.contains(' ')) {
      List<String> names = name.split(' ');
      return '${names[0]}\n${names.sublist(1).join(' ')}';
    }
    return name;
  }

  _imageCard(BuildContext context, FighterModel fighter, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        print(fighter.id);
        context.pushNamed(
          FighterDetailScreen.routeName,
          pathParameters: {'id': fighter.id.toString()},
        );
      },
      child: CachedNetworkImage(
        width: 80,
        height: 80,
        imageUrl: fighter.headshotUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) {
          return Image.asset('asset/img/logo/fight_week.png');
        },
      ),
    );
  }

  static Widget header(
    BuildContext context, {
    required DateTime eventDate,
    required String eventName,
    required bool isDetail,
  }) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            context.pushNamed(
              FightEventDetailScreen.routeName,
              pathParameters: {
                'date': eventDate.toString(),
                'isStream': false.toString(),
              },
            );
          },
          child: Text(
            eventName,
            style: defaultTextStyle.copyWith(
              fontSize: isDetail ? 20 : 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    ],
  );
}
