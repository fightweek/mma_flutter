import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';

class FighterCard extends ConsumerWidget {
  final FighterModel fighter;

  const FighterCard({super.key, required this.fighter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 362.w,
      height: 86.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 1.w, color: GREY_COLOR),
        color: BLACK_COLOR,
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            width: 80.w,
            height: 80.h,
            imageUrl: fighter.headshotUrl!,
            errorWidget: (context, url, error) {
              print('no such image.${fighter.name}');
              return ElevatedButton(
                onPressed: () {
                  ref
                      .read(fighterProvider.notifier)
                      .getHeadshotUrl(name: fighter.name);
                },
                child: Text('다시 시도'),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _splitNameAndNickname(
                  name: fighter.name,
                ),
                style: defaultTextStyle.copyWith(
                  fontSize: 16.sp
                ),
              ),
              SizedBox(height: 2.h,),
              Text(
                '${fighter.record.win}-${fighter.record.loss}-${fighter.record.draw}',
                style: defaultTextStyle.copyWith(
                  fontSize: 12.sp
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _splitNameAndNickname({
    required String name,
  }) {
    if (name.contains(' ')) {
      final names = name.split(' ');
      return '${names[0]}\n${names.sublist(1).join(' ')}';
    }
    return name;
  }
}
