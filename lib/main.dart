import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_1/Admin/add_product.dart';
import 'package:shopping_app_1/Admin/admin_login.dart';
import 'package:shopping_app_1/Admin/all_orders.dart';
import 'package:shopping_app_1/Admin/home_admin.dart';
import 'package:shopping_app_1/consts/theme_data.dart';
import 'package:shopping_app_1/pages/bottomnav.dart';
import 'package:shopping_app_1/pages/home.dart';
import 'package:shopping_app_1/pages/login.dart';
import 'package:shopping_app_1/pages/onboarding.dart';
import 'package:shopping_app_1/pages/signup.dart';
import 'package:shopping_app_1/providers/theme_provider.dart';
import 'package:shopping_app_1/services/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishablekey;
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (
        context,
        themeProvider,
        child,
      ) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BalochDev Shop ADMIN',
          // theme: Styles.themeData(
          //     isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: const AdminLogin(),
        );
      }),
    );
  }
}
