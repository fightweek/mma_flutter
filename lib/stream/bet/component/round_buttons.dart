import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';

class RoundButtons extends StatelessWidget {
  final bool isTitle;
  final int? selectedWinRoundIndex;
  final Color mainColor;
  final void Function(int)? onPressed;

  const RoundButtons({
    required this.isTitle,
    required this.selectedWinRoundIndex,
    this.onPressed,
    required this.mainColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        height: 28.0,
        child: Row(
          children: [
            ...List.generate(
              isTitle ? 5 : 3,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: ElevatedButton(
                    onPressed:
                        onPressed != null
                            ? () {
                              onPressed!(index);
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _renderBackGroundColor(index),
                      disabledBackgroundColor: _renderBackGroundColor(index),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8.r),
                      ),
                    ),
                    child: Text(
                      '${index + 1}R',
                      style: defaultTextStyle.copyWith(fontSize: 12.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _renderBackGroundColor(int index) {
    return selectedWinRoundIndex != null && selectedWinRoundIndex == index
        ? mainColor
        : DARK_GREY_COLOR;
  }
}
