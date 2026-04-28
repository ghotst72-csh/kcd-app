import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final dynamic diseaseService;

  const SplashScreen({
    super.key,
    this.diseaseService,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // 2초 후 다음 화면 이동
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/mode');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            const Spacer(),

            // 🔵 로고 이미지
            Image.asset(
              'assets/images/kcd_logo.png',
              width: 140,
            ),

            const SizedBox(height: 24),

            // 🔵 제목
            const Text(
              '질병분류기호',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2B4C),
              ),
            ),

            const SizedBox(height: 8),

            // 🔵 서브텍스트
            const Text(
              '한국표준질병·사인분류(KCD) 검색 서비스',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            // 🔵 로딩 인디케이터
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: Color(0xFF1A73E8),
              ),
            ),

            const SizedBox(height: 30),

            // 🔵 메인 안내 텍스트
            const Text(
              '질병분류기호 데이터를\n확인하는 중입니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              '잠시만 기다려주세요.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const Spacer(),

            // 🔵 하단 안내 박스
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '본 서비스는 KCD 기준 데이터를 활용하여\n정보를 제공하는 참고용 서비스입니다.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
