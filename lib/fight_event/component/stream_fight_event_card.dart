import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card_row.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/vote_request_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';

class StreamFightEventCard extends ConsumerStatefulWidget {
  final StreamFighterFightEventModel ffe;
  final bool upcoming;
  final bool checkboxValue;
  final void Function(bool?) checkboxOnChanged;

  const StreamFightEventCard({
    super.key,
    required this.ffe,
    required this.upcoming,
    required this.checkboxValue,
    required this.checkboxOnChanged
  });

  @override
  ConsumerState<StreamFightEventCard> createState() => _FightEventCardState();
}

class _FightEventCardState extends ConsumerState<StreamFightEventCard> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool? checkBoxValue = widget.checkboxValue;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: DARK_GREY_COLOR,
          borderRadius: BorderRadius.circular(10.0),
          border: BoxBorder.all(
            color:
                widget.ffe.status == StreamFighterFightEventStatus.now
                    ? Colors.blue
                    : Colors.white,
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
            FightEventCardRow(ffe: widget.ffe, context: context, ref: ref),
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
    return InkWell(
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
                    '이 경기의 승자를 예측해 보세요!\n▲',
                    textAlign: TextAlign.center,
                    style: defaultTextStyle.copyWith(color: GREY_COLOR),
                  ),
                  SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Expanded(
                          flex: widget.ffe.winnerVoteRate.toInt() + 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BLUE_COLOR,
                            ),
                            onPressed: () {
                              ref
                                  .read(streamFightEventProvider.notifier)
                                  .vote(
                                    VoteRequestModel(
                                      fighterFightEventId: widget.ffe.id,
                                      winnerId: widget.ffe.winner.id,
                                      loserId: widget.ffe.loser.id,
                                    ),
                                  );
                            },
                            child: Text(
                              '${DataUtils.extractLastName(winner.name)} (${widget.ffe.winnerVoteRate}%)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: GREY_COLOR),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: widget.ffe.loserVoteRate.toInt() + 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: RED_COLOR,
                            ),
                            onPressed: () {
                              ref
                                  .read(streamFightEventProvider.notifier)
                                  .vote(
                                    VoteRequestModel(
                                      fighterFightEventId: widget.ffe.id,
                                      winnerId: widget.ffe.loser.id,
                                      loserId: widget.ffe.winner.id,
                                    ),
                                  );
                            },
                            child: Text(
                              '${DataUtils.extractLastName(loser.name)} (${widget.ffe.loserVoteRate}%)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: GREY_COLOR),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : Text(
                '▼\n이 경기의 승자를 예측해 보세요!',
                textAlign: TextAlign.center,
                style: defaultTextStyle.copyWith(color: GREY_COLOR),
              ),
    );
  }
}
