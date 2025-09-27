import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/report/model/report_request_model.dart';
import 'package:mma_flutter/report/repository/report_repository.dart';

class ReportUser extends ConsumerStatefulWidget {
  final int reportedId;

  const ReportUser({required this.reportedId, super.key});

  @override
  ConsumerState<ReportUser> createState() => _ReportUserState();
}

class _ReportUserState extends ConsumerState<ReportUser> {
  ReportCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: DARK_GREY_COLOR,
      title: Text(
        '사용자 신고\n',
        style: TextStyle(
          fontSize: 20.sp,
          color: WHITE_COLOR,
          fontWeight: FontWeight.w700,
        ),
      ),
      children: [
        ...ReportCategory.values.map(
          (e) => RadioListTile<ReportCategory>(
            title: Text(
              e.label,
              style: TextStyle(color: WHITE_COLOR, fontSize: 14.sp),
            ),
            value: e,
            groupValue: selectedCategory,
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
                print('selectedCategory=$selectedCategory');
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SimpleDialogOption(
              onPressed:
                  selectedCategory == null
                      ? null
                      : () async {
                        // 신고 API 직접 호출 예시
                        try {
                          await ref
                              .read(reportRepositoryProvider)
                              .report(
                                request: ReportRequestModel(
                                  reportedId: widget.reportedId,
                                  reportCategory: selectedCategory!,
                                ),
                              );
                          if (mounted) {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('신고가 접수되었습니다.')),
                            );
                          }
                        } catch (e) {
                          // 에러 처리
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('신고 중 오류가 발생했습니다.')),
                          );
                        }
                      },
              child: Text('신고', style: TextStyle(color: WHITE_COLOR)),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소', style: TextStyle(color: WHITE_COLOR)),
            ),
          ],
        ),
      ],
    );
  }
}
