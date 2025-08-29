import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/admin/common_update_screen.dart';
import 'package:mma_flutter/admin/news/screen/news_upload_screen.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class DefaultLayout extends ConsumerWidget {
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget child;
  final Color? backGroundColor;

  const DefaultLayout({
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backGroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
    return Scaffold(
      drawer:
          user is UserModel
              ? Drawer(
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () {
                        print(user.role);
                      },
                      title: Text('게임'),
                    ),
                    if (user.role == 'ROLE_ADMIN')
                      ListTile(
                        onTap: () {
                          context.pushNamed(NewsUploadScreen.routeName);
                        },
                        title: Text('뉴스 업로드'),
                      ),
                    if (user.role == 'ROLE_ADMIN')
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RankingUpdateScreen(),
                            ),
                          );
                        },
                        title: Text('랭킹 업데이트 / 실시간 채팅방 활성화 / 차후 이벤트 업데이트'),
                      ),
                  ],
                ),
              )
              : null,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      appBar: renderAppBar(),
      backgroundColor: backGroundColor ?? BACKGROUND_COLOR,
      body: child,
    );
  }

  PreferredSize renderAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(56.h),
      child: AppBar(
        iconTheme: IconThemeData(color: WHITE_COLOR),
        backgroundColor: BLACK_COLOR,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
    );
  }
}
