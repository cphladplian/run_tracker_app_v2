import 'package:flutter/material.dart';
import 'package:run_tracker_app_v2/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iphhchkvpcilwuxafrms.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlwaGhjaGt2cGNpbHd1eGFmcm1zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxMzk4MzcsImV4cCI6MjA5MjcxNTgzN30.DypvQqmeueVSEZtpU-hQLqaKeH9mb8p_S6ooOd7hqZM',
  );

  runApp(const RunTrackerAppV2());
}

class RunTrackerAppV2 extends StatelessWidget {
  const RunTrackerAppV2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Run Tracker App V2',
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(),
        primarySwatch: Colors.indigo,
      ),
      home: const SplashScreenUi(),
    );
  }
}