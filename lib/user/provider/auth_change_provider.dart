import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

final authChangeProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier(ref: ref);
},);

class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({required this.ref}) {
    ref.listen<UserModelBase?>(userProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  String? redirectLogic(GoRouterState state){
    print('redirect');
    final UserModelBase? user = ref.read(userProvider);
    final loggingIn = state.location == '/login';

    /**
     * 유저 정보가 없는데 로그인 중이면, 그대로 로그인 페이지에 두고
     * 만약 로그인 중이 아니라면, 로그인 페이지로 이동
     * user == null && logginIn일 때 null이 아닌, '/login'으로 redirect 시키는 경우,
     * 무한 redirect 발생하여 무한 루프에 빠질 수 있다.
     * 로그아웃 화면에서 로그아웃 시 user == null & login 경로 아니므로, 당연히 '/login' 스크린으로 라우팅됨
     */
    if (user is UserModelLoading) {
      return state.location == '/splash' ? null : '/splash';
    }
    if(user == null){
      print(state.location);
      return loggingIn ? null : '/login';
    }

    if(user is UserModel){
      // '/splash' 는 처음 앱 시작할 때 라우팅되는 경로
      return (loggingIn || (state.location == '/splash')) ? '/' : null;
    }
    if(user is UserModelError){
      return !loggingIn ? '/login' : null;
    }
    return null;
  }

}
