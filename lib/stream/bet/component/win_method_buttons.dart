import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/stream/bet/model/bet_request_model.dart';

class WinMethodButtons extends StatelessWidget {
  final bool isHistory;
  final Color mainColor;
  final int? selectedWinMethodIndex;
  final void Function(int)? onPressed;

  const WinMethodButtons({
    required this.isHistory,
    required this.mainColor,
    required this.selectedWinMethodIndex,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        height: 28.h,
        child: Row(
          children: [
            ...WinMethodForBet.values
                .mapIndexed(
                  (index, e) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: _renderBackGroundColor(index),
                          disabledBackgroundColor: _renderBackGroundColor(
                            index,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8.0),
                          ),
                        ),
                        onPressed:
                            onPressed != null
                                ? () {
                                  onPressed!(index);
                                }
                                : null,
                        child: Text(
                          e.label,
                          style: defaultTextStyle.copyWith(fontSize: 12.0),
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

  Color _renderBackGroundColor(index) {
    return (selectedWinMethodIndex == index) ||
            (isHistory && selectedWinMethodIndex == null)
        ? mainColor
        : DARK_GREY_COLOR;
  }
}
