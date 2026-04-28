import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_store.dart';
import 'providers/cart_store.dart';
import 'providers/location_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/location_screen.dart';
import 'screens/call_center_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => CartStore()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: const FoodDashApp(),
    ),
  );
}

class FoodDashApp extends StatelessWidget {
  const FoodDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tashkent table',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF97316),
          primary: const Color(0xFFF97316),
          secondary: const Color(0xFF1F2937),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF7ED),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Consumer<AuthStore>(
        builder: (ctx, auth, _) =>
            auth.isAuthenticated ? const HomeScreen() : const LoginScreen(),
      ),
      routes: {
        '/home': (ctx) => const HomeScreen(),
        '/cart': (ctx) => const CartScreen(),
        '/login': (ctx) => const LoginScreen(),
        '/location': (ctx) => const LocationScreen(),
        '/call-center': (ctx) => const CallCenterScreen(),
      },
    );
  }
}
