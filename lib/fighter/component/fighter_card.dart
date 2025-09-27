import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';

class FighterCard extends ConsumerWidget {
  final FighterModel fighter;

  const FighterCard({super.key, required this.fighter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        CachedNetworkImage(
          width: 80.w,
          height: 80.h,
          imageUrl: fighter.headshotUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) {
            print('no such image.${fighter.name}');
            return ElevatedButton(
              onPressed: () {
                ref.read(fighterProvider.notifier).getHeadshotUrl(name: fighter.name);
              },
              child: Text('다시 시도'),
            );
          },
        ),
        Column(
          children: [
            Text(
              '${_splitNameAndNickname(
                  name: fighter.name, nickname: fighter.nickname)}\n${fighter
                  .record.win}-${fighter.record.loss}-${fighter.record.draw}',
              style: defaultTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  String _splitNameAndNickname({
    required String name,
    required String? nickname,
  }) {
    if (name.contains(' ')) {
      final names = name.split(' ');
      final midNickname = nickname != null ? '\'$nickname\'\n' : '';
      return '${names[0]}\n$midNickname${names.sublist(1).join(' ')}';
    }
    return name;
  }
}
