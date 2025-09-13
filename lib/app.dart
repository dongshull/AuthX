import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:authx/providers/totp_provider.dart';
import 'package:authx/services/timer_service.dart';
import 'package:authx/ui/screens/home_screen.dart';

class AuthXApp extends StatefulWidget {
  const AuthXApp({super.key});

  @override
  State<AuthXApp> createState() => _AuthXAppState();
}

class _AuthXAppState extends State<AuthXApp> {

  @override
  void initState() {
    super.initState();
    
    // 设置系统UI模式为边缘到边缘显示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TotpProvider()),
        ChangeNotifierProvider(create: (_) => TimerService()),
      ],
      child: MaterialApp(
        title: 'AuthX TOTP',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}