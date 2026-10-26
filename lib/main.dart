//  main.dart
//  AgroMart
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/features/chat/providers/conversations_provider.dart';
import 'package:agroshare/features/equipment/form/equipment_edit_form.dart';
import 'package:agroshare/features/rental_requests/providers/rental_request_provider.dart';
import 'package:agroshare/features/auth/form/fields/cpf_field.dart';
import 'package:agroshare/features/auth/form/fields/email_field.dart';
import 'package:agroshare/features/auth/form/fields/name_field.dart';
import 'package:agroshare/features/auth/form/fields/password_field.dart';
import 'package:agroshare/features/auth/form/fields/latitude_field.dart';
import 'package:agroshare/features/auth/form/fields/farm_location_field.dart';
import 'package:agroshare/features/auth/form/fields/longitude_field.dart';
import 'package:agroshare/features/auth/form/fields/farm_name_field.dart';
import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/features/auth/providers/profile_photo_picker.dart';
import 'package:agroshare/core/session/app_session.dart';
import 'package:agroshare/features/equipment/form/fields/equipment_days_field.dart';
import 'package:agroshare/features/equipment/form/fields/equipment_description_field.dart';
import 'package:agroshare/features/equipment/form/equipment_form.dart';
import 'package:agroshare/features/equipment/form/fields/equipment_images_field.dart';
import 'package:agroshare/features/equipment/form/fields/equipment_name_field.dart';
import 'package:agroshare/features/equipment/form/fields/equipment_price_field.dart';
import 'package:agroshare/features/equipment/providers/manage_equipment_provider.dart';
import 'package:agroshare/features/home/providers/bottom_nav_provider.dart';
import 'package:agroshare/features/equipment/providers/create_equipment_provider.dart';
import 'package:agroshare/features/auth/services/auth_service.dart';
import 'package:agroshare/core/services/notification_service.dart';
import 'package:agroshare/features/auth/providers/location_provider.dart';
import 'package:agroshare/features/equipment/providers/equipment_image_picker.dart';
import 'package:agroshare/features/auth/ui/login_page.dart';
import 'package:agroshare/features/home/ui/main_shell_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? AndroidDebugProvider()
        : AndroidPlayIntegrityProvider(),
  );
  runApp(const AgroShare());

  // permissão, token FCM e abertura de notificações
  await NotificationService.instance.init();
}

class AgroShare extends StatelessWidget {
  const AgroShare({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSession(
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthForm()),
          ChangeNotifierProvider(create: (_) => BottomNavProvider()),
          ChangeNotifierProvider(create: (_) => ProfilePhotoPicker()),
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => NameField()),
          ChangeNotifierProvider(create: (_) => CpfField()),
          ChangeNotifierProvider(create: (_) => EmailField()),
          ChangeNotifierProvider(create: (_) => PasswordField()),
          ChangeNotifierProvider(create: (_) => FarmNameField()),
          ChangeNotifierProvider(create: (_) => FarmLocationField()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => EquipmentImagePicker()),
          ChangeNotifierProvider(create: (_) => EquipmentForm()),
          ChangeNotifierProvider(create: (_) => EquipmentNameField()),
          ChangeNotifierProvider(create: (_) => EquipmentPriceField()),
          ChangeNotifierProvider(create: (_) => EquipmentDaysField()),
          ChangeNotifierProvider(create: (_) => EquipmentDescriptionField()),
          ChangeNotifierProvider(create: (_) => EquipmentImagesField()),
          ChangeNotifierProvider(create: (_) => LatitudeField()),
          ChangeNotifierProvider(create: (_) => LongitudeField()),
          ChangeNotifierProvider(create: (_) => EquipmentEditForm()),
          ChangeNotifierProvider(create: (_) => CreateEquipmentProvider()),
          ChangeNotifierProvider(create: (_) => RentalRequestProvider()),
          ChangeNotifierProvider(create: (_) => ManageEquipmentProvider()),
          ChangeNotifierProvider(create: (_) => ConversationsProvider()),
        ],
        child: MaterialApp(
          navigatorKey: NotificationService.navigatorKey,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1)),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [Locale('pt', 'BR')],
          title: 'AgroMart',
          theme: ThemeData(
            textTheme: GoogleFonts.figtreeTextTheme(),
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return snapshot.hasData ? MainShellPage() : LoginPage();
            },
          ),
        ),
      ),
    );
  }
}
