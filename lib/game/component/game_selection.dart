import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/game/model/name_game_questions_model.dart';

class GameSelection extends StatelessWidget {
  final int? selectedAnswerIdx;
  final GameCategory? gameCategory;
  final List<String> selection;
  final void Function(int) onTap;

  const GameSelection({
    required this.selectedAnswerIdx,
    required this.gameCategory,
    required this.selection,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (gameCategory == null ||
        gameCategory == GameCategory.headshot ||
        gameCategory == GameCategory.body) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 1.05,
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: gameCategory == null ? 1.0 : 2.0,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: selection.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onTap(index);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: BLACK_COLOR,
                  border: Border.all(
                    color: selectedAnswerIdx == index ? BLUE_COLOR : GREY_COLOR,
                    width: 2.w,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child:
                    gameCategory != null
                        ? Text(
                          selection[index],
                          style: defaultTextStyle.copyWith(fontSize: 18.sp),
                          textAlign: TextAlign.center,
                        )
                        : CachedNetworkImage(
                          imageUrl: selection[index],
                          height: 172.h,
                        ),
              ),
            );
          },
        ),
      );
    } else {
      return Column(
        children: [
          ...List.generate(selection.length, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 7.5.h, horizontal: 16.w),
              child: GestureDetector(
                onTap: () {
                  onTap(index);
                },
                child: Container(
                  constraints: BoxConstraints(minHeight: 62.h, minWidth: 370.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: BLACK_COLOR,
                    border: Border.all(
                      color:
                          selectedAnswerIdx != null &&
                                  selectedAnswerIdx == index
                              ? BLUE_COLOR
                              : GREY_COLOR,
                      width: 2.w,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    selection[index],
                    style: defaultTextStyle.copyWith(fontSize: 18.sp),
                  ),
                ),
              ),
            );
          }),
        ],
      );
    }
  }
}
