import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/fight_event/component/fighter_fight_event_card_row.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';
import 'package:mma_flutter/stream/vote/model/vote_request_model.dart';
import 'package:mma_flutter/stream/vote/repository/vote_repository.dart';

class StreamFighterFightEventCard extends ConsumerStatefulWidget {
  final StreamFighterFightEventModel ffe;
  final bool upcoming;
  final bool checkboxValue;
  final void Function(bool?) checkboxOnChanged;

  const StreamFighterFightEventCard({
    super.key,
    required this.ffe,
    required this.upcoming,
    required this.checkboxValue,
    required this.checkboxOnChanged,
  });

  @override
  ConsumerState<StreamFighterFightEventCard> createState() => _FightEventCardState();
}

class _FightEventCardState extends ConsumerState<StreamFighterFightEventCard> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool? checkBoxValue = widget.checkboxValue;

    return Padding(
      padding: EdgeInsets.only(top: 4.h, right: 9.w, left: 9.w),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: BLACK_COLOR,
          borderRadius: BorderRadius.circular(8.r),
          border: BoxBorder.all(
            color:
                widget.ffe.status == StreamFighterFightEventStatus.now
                    ? Colors.blue
                    : Colors.black,
            width: 2,
          ),
        ),
        width: MediaQuery.of(context).size.width / 1.05,
        child: Column(
          children: [
            Row(
              children: [
                if (widget.upcoming)
                  Checkbox(
                    value: checkBoxValue,
                    onChanged: widget.checkboxOnChanged,
                  ),
                Text(
                  '${weightClassMap[widget.ffe.fightWeight] ?? widget.ffe.fightWeight} 매치',
                  style: defaultTextStyle,
                ),
              ],
            ),
            FighterFightEventCardRow(ffe: widget.ffe, context: context,),
            if (widget.upcoming)
              showVoteBar(
                expanded: isExpanded,
                winner: widget.ffe.winner,
                loser: widget.ffe.loser,
              ),
          ],
        ),
      ),
    );
  }

  Widget showVoteBar({
    required bool expanded,
    required FighterModel winner,
    required FighterModel loser,
  }) {
    final leftPercent = widget.ffe.winnerVoteRate.toInt();
    final rightPercent = widget.ffe.loserVoteRate.toInt();
    return InkWell(
      splashColor: Colors.white,
      highlightColor: Colors.white,
      onTap: () {
        setState(() {
          isExpanded = !expanded;
        });
      },
      child:
          expanded
              ? Column(
                children: [
                  Text(
                    '다음 경기의 승자는 누구?\n▲',
                    textAlign: TextAlign.center,
                    style: defaultTextStyle.copyWith(color: GREY_COLOR),
                  ),
                  SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Expanded(
                          flex: leftPercent + 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: RED_COLOR,
                            ),
                            onPressed: () {
                              ref.read(
                                voteCreateFutureProvider(
                                  VoteRequestModel(
                                    fighterFightEventId: widget.ffe.id,
                                    winnerId: widget.ffe.winner.id,
                                    loserId: widget.ffe.loser.id,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              '${DataUtils.extractLastName(winner.name)} ($leftPercent%)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: rightPercent + 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BLUE_COLOR,
                            ),
                            onPressed: () {
                              ref.read(
                                voteCreateFutureProvider(
                                  VoteRequestModel(
                                    fighterFightEventId: widget.ffe.id,
                                    winnerId: widget.ffe.loser.id,
                                    loserId: widget.ffe.winner.id,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              '${DataUtils.extractLastName(loser.name)} ($rightPercent%)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : Text(
                '다음 경기의 승자는 누구?\n▼',
                textAlign: TextAlign.center,
                style: defaultTextStyle.copyWith(
                  color: GREY_COLOR,
                  fontSize: 12.sp,
                ),
              ),
    );
  }
}
