import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/screen/fighter_detail_screen.dart';

import '../model/schedule_model.dart';

class ScheduleCard extends ConsumerWidget {
  final FighterFightEventModel ffe;
  final bool? isDetail;

  const ScheduleCard({super.key, required this.ffe, this.isDetail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: MY_DARK_GREY_COLOR,
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          if(isDetail!=null)
            header(ffe.eventName,isDetail: true),
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
                        Icon(Icons.check, size: 16, color: Colors.green),
                        SizedBox(width: 4),
                        Text(ffe.result.winMethod,style: defaultTextStyle,),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(width: 12.0,),
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
    );
  }

  String _splitName(String name) {
    if (name.contains(' ')) {
      List<String> names = name.split(' ');
      return '${names[0]}\n${names.sublist(1).join(' ')}';
    }
    return name;
  }

  bool _isPresignedUrlExpired(Object error) {
    return error.toString().contains('403');
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
        width: 150,
        height: 150,
        imageUrl: fighter.imgPresignedUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) {
          print('no such image.${fighter.name}');
          return Image.asset('asset/img/logo/fight_week.png');
        },
      ),
    );
  }

  static Widget header(String eventName, {bool? isDetail}) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          eventName,
          style: defaultTextStyle.copyWith(
            fontSize: isDetail != null ? 20 : 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    ],
  );
}
