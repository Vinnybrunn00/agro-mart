//  main.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
// 

import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/core/providers/picker/picker_profile.dart';
import 'package:agroshare/ui/pages/auth/auth_page.dart';
import 'package:agroshare/ui/pages/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AgroShare());
}

class AgroShare extends StatelessWidget {
  const AgroShare({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => NavigatorProvider()),
        ChangeNotifierProvider(create: (_) => PickerProfile()),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1)),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'AgroShare',
        theme: ThemeData(
          textTheme: GoogleFonts.figtreeTextTheme(),
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return snapshot.hasData ? HomePage() : AuthPage();
          },
        ),
      ),
    );
  }
}
