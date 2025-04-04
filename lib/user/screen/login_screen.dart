import 'package:flutter/material.dart';
import 'package:mma_flutter/user/screen/join_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idController = TextEditingController();
  final pwdController = TextEditingController();
  bool isRemainLogin = false;

  @override
  void dispose() {
    idController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Image.asset('asset/img/logo/punch.png', width: 50),
      ),
      body: Column(
        children: [
          const SizedBox(height: 70),
          Column(
            children: [
              Center(
                child: Text(
                  'FightApp',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                '로그인',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          TextField(
            style: TextStyle(color: Colors.white),
            controller: idController,
            maxLength: 20,
            decoration: InputDecoration(
              labelText: '아이디',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            style: TextStyle(color: Colors.white),
            controller: pwdController,
            maxLength: 20,
            decoration: InputDecoration(
              labelText: '비밀번호',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          Row(
            children: [
              Checkbox(
                value: isRemainLogin,
                onChanged: (value) {
                  setState(() {
                    isRemainLogin = value!;
                  });
                  print(isRemainLogin);
                },
                activeColor: Color(0xFF6200EE),
              ),
              const Text('로그인 유지', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 170),
              GestureDetector(
                onTap: () {
                  print('hello');
                },
                child: const Text(
                  '비밀번호 찾기',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              print('id : ${idController.text}');
              print('pwd : ${pwdController.text}');
            },
            child: Text(
              '로그인',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return JoinScreen();
                },)
              );
            },
            child: const Text(
              '계정이 없으신가요?',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          Expanded(child: SizedBox()),
          _SocialLogin(),
        ],
      ),
    );
  }

}

class _SocialLogin extends StatelessWidget {
  const _SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        children: [
          Text(
            '------------------------소셜 로그인------------------------',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('asset/img/social/kakao.png', height: 45, width: 45),
              Image.asset('asset/img/social/naver.png', height: 45, width: 45),
              Image.asset('asset/img/social/google.png', height: 45, width: 45),
            ],
          ),
        ],
      ),
    );
  }
}
