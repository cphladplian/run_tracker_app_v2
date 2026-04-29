import 'package:flutter/material.dart';
import 'package:run_tracker_app_v2/views/login_ui.dart';
import 'package:run_tracker_app_v2/views/show_all_run_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    super.initState();
    checkSession(); //เช็คผู้ใช้
  }

  Future<void> checkSession() async {
    //ตรวจสอบผู้ใช้ login จาก Supabase
    await Future.delayed(const Duration(seconds: 2));

    final session = Supabase.instance.client.auth
        .currentSession; //ตรวจว่ามีหรือไม่มี ถ้ามีจะมีขึ้นlogin ไม่มีจะเป็นnull

    if (!mounted) return; //ถ้าหน้าไม่อยู่จะไม่ทำงาน

    if (session != null) {
      //login อยู่
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ShowAllRunUi()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginUi()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090359),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/tracker.png',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Run Tracker V2',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          '© 2026 RUN TRACKER\nCreated by Chatinon',
          style: TextStyle(
            color: Color.fromARGB(129, 231, 230, 230),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
