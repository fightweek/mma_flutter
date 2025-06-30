import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class InitNicknameScreen extends ConsumerStatefulWidget {
  static String get routeName => 'init_nickname';

  const InitNicknameScreen({super.key});

  @override
  ConsumerState<InitNicknameScreen> createState() => _InitNicknameScreenState();
}

class _InitNicknameScreenState extends ConsumerState<InitNicknameScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    print('initstate');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showNicknameDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: SizedBox.shrink());
  }

  void _showNicknameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? errorText;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: MY_MIDDLE_GREY_COLOR,
              title: const Text(
                '닉네임 설정',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),

                      fillColor: Color(0xFF2C2C2C),
                      hintText: '닉네임을 입력하세요',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (errorText != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorText!,
                        style: TextStyle(color: Colors.red, fontSize: 12.0),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final nickname = _controller.text.trim();
                    if (nickname.length < 2) {
                      setState(() {
                        errorText = '닉네임은 최소 2 글자입니다.';
                      });
                      return;
                    }
                    final res = await ref
                        .read(userProvider.notifier)
                        .checkDupNickname(nickname);
                    if (!res) {
                      print('non-duplicated');
                      ref.read(userProvider.notifier).updateNickname(nickname);
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        errorText = '이미 사용 중인 닉네임입니다.';
                      });
                    }
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
