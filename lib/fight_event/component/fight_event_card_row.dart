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
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';
import 'package:mma_flutter/fighter/screen/fighter_detail_screen.dart';

class FightEventCardRow extends StatefulWidget {
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
  State<FightEventCardRow> createState() => _FightEventCardRowState();
}

class _FightEventCardRowState extends State<FightEventCardRow> {
  late String winnerHeadshotUrl;
  late String loserHeadshotUrl;

  @override
  void initState() {
    super.initState();
    winnerHeadshotUrl = widget.ffe.winner.headshotUrl;
    loserHeadshotUrl = widget.ffe.loser.headshotUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _imageCard(context, widget.ffe.winner, widget.ref, true),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Column(
                        children: [
                          Text(
                            _splitName(widget.ffe.winner.name),
                            style: defaultTextStyle.copyWith(fontSize: 14.h),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            '${widget.ffe.winner.record.win}-${widget.ffe.winner.record.loss}-${widget.ffe.winner.record.draw}',
                            style: defaultTextStyle.copyWith(fontSize: 14.h,color: GREY_COLOR),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (widget.ffe.result != null)
                          Icon(Icons.check, size: 16, color: Colors.green),
                        SizedBox(width: 2),
                        if (widget.ffe.result != null)
                          Text(
                            winMethodMap[widget.ffe.result!.winMethod]!,
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
                if (widget.ffe.title)
                  Text(
                    '타이틀전',
                    style: defaultTextStyle.copyWith(color: Colors.yellow,fontSize: 5.0),
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
                      _splitName(widget.ffe.loser.name),
                      style: defaultTextStyle.copyWith(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      '${widget.ffe.loser.record.win}-${widget.ffe.loser.record.loss}-${widget.ffe.loser.record.draw}',
                      style: defaultTextStyle.copyWith(fontSize: 14.0, color: GREY_COLOR),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _imageCard(context, widget.ffe.loser, widget.ref, false),
            ],
          ),
        ),
      ],
    );
  }

  String _splitName(String name) {
    if (name.contains(' ')) {
      List<String> names = name.split(' ');
      return '${names[0]}\n${names.sublist(1).join(' ')}';
    }
    return name;
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
        imageUrl: left ? winnerHeadshotUrl : loserHeadshotUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) {
          return ElevatedButton(
            onPressed: () async{
              final urlMap = await ref
                  .read(fighterProvider.notifier)
                  .getHeadshotUrl(name: fighter.name);
              print(urlMap['url']);
              setState(() {
                if (left) {
                  winnerHeadshotUrl = urlMap['url']!;
                } else {
                  loserHeadshotUrl = urlMap['url']!;
                }
              });
            },
            child: Text('다시시도'),
          );
        },
      ),
    );
  }
}
