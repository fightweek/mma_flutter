import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/single_bet_model.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/user/model/user_model.dart';

class BetCard extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final SingleBetModel bet;
  final UserModel user;
  final void Function(String) onSeedChanged;
  final TextEditingController controller;

  const BetCard({
    required this.formKey,
    required this.bet,
    required this.user,
    required this.onSeedChanged,
    required this.controller,
    super.key,
  });

  @override
  ConsumerState<BetCard> createState() => BetCardState();
}

class BetCardState extends ConsumerState<BetCard> {
  bool _leftNameSelected = false;
  bool _rightNameSelected = false;
  int? _selectedWinMethodIndex;
  int? _selectedWinRoundIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: BLACK_COLOR,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '다음 경기의 승자는?',
                        style: defaultTextStyle.copyWith(fontSize: 15.0),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        print('ontap');
                        ref.read(betTargetProvider.notifier).update((state) {
                          final singleBetModelToRemove =
                              List<SingleBetModel>.from(state); // copy
                          singleBetModelToRemove.removeWhere(
                            (e) => e.winnerName == widget.bet.winnerName,
                          );
                          return singleBetModelToRemove;
                        });
                      },
                      child: Icon(
                        FontAwesomeIcons.x,
                        color: Colors.white,
                        size: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    _nameButton(
                      mainColor: RED_COLOR,
                      name: widget.bet.winnerName,
                      isLeft: true,
                    ),
                    SizedBox(width: 17),
                    _nameButton(
                      mainColor: BLUE_COLOR,
                      name: widget.bet.loserName,
                      isLeft: false,
                    ),
                  ],
                ),
              ),
            ),
            if (_leftNameSelected || _rightNameSelected) _winMethodButtons(),
            if (_selectedWinMethodIndex != null &&
                    _selectedWinMethodIndex == 0 ||
                _selectedWinMethodIndex == 1)
              _selectWhichRoundToFinish(widget.bet.title),
            SizedBox(height: 36.0),
            if (_leftNameSelected || _rightNameSelected) _askBet(),
          ],
        ),
      ),
    );
  }

  Widget _nameButton({
    required Color mainColor,
    required String name,
    required bool isLeft,
  }) {
    final bool isSelected = isLeft ? _leftNameSelected : _rightNameSelected;

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (isLeft) {
            _leftNameSelected = !_leftNameSelected;
            if (_leftNameSelected) {
              _rightNameSelected = false;
            }
          } else {
            _rightNameSelected = !_rightNameSelected;
            if (_rightNameSelected) {
              _leftNameSelected = false;
            }
          }
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(177.w, 28.h),
          backgroundColor: isSelected ? BLACK_COLOR : mainColor,
          foregroundColor: isSelected ? mainColor : BLACK_COLOR,
          side: BorderSide(width: 2, color: mainColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8.r),
          ),
        ),
        child: Text(
          name,
          style: defaultTextStyle.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: isSelected ? mainColor : WHITE_COLOR
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _winMethodButtons() {
    final mainColor = _leftNameSelected ? RED_COLOR : BLUE_COLOR;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        height: 28.h,
        child: Row(
          children: [
            ...WinMethodForBet.values.mapIndexed(
              (index, e) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          _selectedWinMethodIndex != null &&
                                  _selectedWinMethodIndex == index
                              ? mainColor
                              : DARK_GREY_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      if (_selectedWinMethodIndex == index) {
                        _selectedWinMethodIndex = null;
                      } else {
                        _selectedWinMethodIndex = index;
                      }
                      setState(() {});
                    },
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

  Widget _selectWhichRoundToFinish(bool isTitle) {
    final mainColor = _leftNameSelected ? RED_COLOR : BLUE_COLOR;
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedWinRoundIndex == index) {
                        _selectedWinRoundIndex = null;
                      } else {
                        _selectedWinRoundIndex = index;
                      }
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedWinRoundIndex != null &&
                                  _selectedWinRoundIndex == index
                              ? mainColor
                              : DARK_GREY_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8.0),
                      ),
                    ),
                    child: Text(
                      '${index + 1}R',
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

  Widget _askBet() {
    final betWinner =
        _leftNameSelected ? widget.bet.winnerName : widget.bet.loserName;
    final mainColor = _leftNameSelected ? RED_COLOR : BLUE_COLOR;
    final winMethod =
        _selectedWinMethodIndex != null
            ? (WinMethodForBet.values.elementAt(_selectedWinMethodIndex!)).label
            : null;
    final winRound =
        _selectedWinMethodIndex != null &&
                _selectedWinRoundIndex != null &&
                (_selectedWinMethodIndex == 0 || _selectedWinMethodIndex == 1)
            ? '${_selectedWinRoundIndex! + 1}R'
            : null;
    final subStrInAsk = '$betWinner의 ${winRound ?? ''} ${winMethod ?? ''} ';
    final askStr =
        winMethod == '무승부'
            ? '무승부에 포인트를 얼마나 배팅하시겠습니까?'
            : '$subStrInAsk승리에 포인트를 얼마나 배팅하시겠습니까?';
    return Column(
      children: [
        Text(askStr, style: defaultTextStyle, textAlign: TextAlign.center),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: Form(
            key: widget.formKey,
            child: TextFormField(
              controller: widget.controller,
              onChanged: widget.onSeedChanged,
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixIcon: Icon(FontAwesomeIcons.coins),
                filled: true,
                fillColor: BLACK_COLOR,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: mainColor),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: mainColor),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              validator: validator,
            ),
          ),
        ),
      ],
    );
  }

  SingleBetCardRequestModel toRequest(TextEditingController controller) {
    final int seedPoint = int.parse(controller.text);
    return SingleBetCardRequestModel(
      fighterFightEventId: widget.bet.fighterFightEventId,
      betPrediction: BetPredictionModel(
        winnerName:
            _leftNameSelected ? widget.bet.winnerName : widget.bet.loserName,
        loserName:
            _leftNameSelected ? widget.bet.loserName : widget.bet.winnerName,
        winMethod:
            _selectedWinMethodIndex != null
                ? WinMethodForBet.values[_selectedWinMethodIndex!]
                : null,
        winRound:
            _selectedWinRoundIndex != null ? _selectedWinRoundIndex! + 1 : null,
      ),
      seedPoint: seedPoint,
    );
  }

  int _calculateTotalProfit(int seedMoney) {
    double total = seedMoney as double;
    if (_leftNameSelected || _rightNameSelected) {
      total *= 2;
    }
    if (_selectedWinMethodIndex != null) {
      if (_selectedWinMethodIndex == 0 || _selectedWinMethodIndex == 1) {
        total *= 2;
      } else if (_selectedWinMethodIndex == 2) {
        total *= 2.5;
      } else {
        total *= 30;
      }
    }
    if (_selectedWinRoundIndex != null) {
      total *= 2;
    }
    return total as int;
  }

  String? validator(String? val) {
    final userPoint = widget.user.point;
    if (val == null || val.trim().isEmpty) {
      print('val is null');
      return '배팅하실 포인트를 입력해주세요.';
    }
    if (int.tryParse(val) != null) {
      int parsedVal = int.parse(val);
      print('parsedVal = $parsedVal');
      if (parsedVal <= 0) {
        print('val equal of lower than 0');
        return '0보다 큰 포인트를 배팅해주세요.';
      }
      if (parsedVal % 10 != 0) {
        print('val should be multiple of 10');
        return '배팅 포인트는 10의 배수여야 합니다.';
      }
      if (parsedVal > userPoint) {
        print('point shortage');
        return '포인트가 부족합니다.';
      }
    }
    return null;
  }
}
