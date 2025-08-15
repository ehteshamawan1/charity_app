import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/case_provider.dart';
import 'providers/donation_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/imam_registration_screen.dart';
import 'screens/auth/donor_registration_screen.dart';
import 'screens/auth/beneficiary_registration_screen.dart';
import 'screens/donor/donor_home_screen.dart';
import 'screens/imam/imam_home_screen.dart';
import 'screens/beneficiary/beneficiary_home_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CaseProvider()),
        ChangeNotifierProvider(create: (_) => DonationProvider()),
      ],
      child: MaterialApp(
        title: 'Muslim Charity App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/role-selection': (context) => const RoleSelectionScreen(),
          '/login': (context) => const LoginScreen(),
          '/imam-registration': (context) => const ImamRegistrationScreen(),
          '/donor-registration': (context) => const DonorRegistrationScreen(),
          '/beneficiary-registration': (context) => const BeneficiaryRegistrationScreen(),
          '/donor-home': (context) => const DonorHomeScreen(),
          '/imam-home': (context) => const ImamHomeScreen(),
          '/beneficiary-home': (context) => const BeneficiaryHomeScreen(),
        },
      ),
    );
  }
}