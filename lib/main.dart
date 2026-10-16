//  main.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/models/auth/credentials/cpf.dart';
import 'package:agroshare/models/auth/credentials/email.dart';
import 'package:agroshare/models/auth/credentials/name.dart';
import 'package:agroshare/models/auth/credentials/password.dart';
import 'package:agroshare/models/auth/credentials/property/latitude.dart';
import 'package:agroshare/models/auth/credentials/property/location.dart';
import 'package:agroshare/models/auth/credentials/property/longitude.dart';
import 'package:agroshare/models/auth/credentials/property/name.dart';
import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/core/providers/picker/picker_profile.dart';
import 'package:agroshare/core/session/app_session.dart';
import 'package:agroshare/models/equipamentos/days.dart';
import 'package:agroshare/models/equipamentos/description.dart';
import 'package:agroshare/models/equipamentos/equipamentos_model.dart';
import 'package:agroshare/models/equipamentos/images.dart';
import 'package:agroshare/models/equipamentos/name_equipamento.dart';
import 'package:agroshare/models/equipamentos/price.dart';
import 'package:agroshare/providers/current_anuncio_provider.dart';
import 'package:agroshare/providers/navigator/navigator_provider.dart';
import 'package:agroshare/repository/product_repository.dart';
import 'package:agroshare/services/auth/auth_services.dart';
import 'package:agroshare/services/ferramentas/ferramentas_services.dart';
import 'package:agroshare/services/location/location_services.dart';
import 'package:agroshare/services/picker/select_images.dart';
import 'package:agroshare/ui/pages/current_anuncio_page.dart';
import 'package:agroshare/ui/pages/auth/auth_page.dart';
import 'package:agroshare/ui/pages/home/home_page.dart';
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
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
  );
  runApp(const AgroShare());
}

class AgroShare extends StatelessWidget {
  const AgroShare({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSession(
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserModel()),
          ChangeNotifierProvider(create: (_) => NavigatorProvider()),
          ChangeNotifierProvider(create: (_) => PickerProfile()),
          ChangeNotifierProvider(create: (_) => AuthServices()),
          ChangeNotifierProvider(create: (_) => Name()),
          ChangeNotifierProvider(create: (_) => Cpf()),
          ChangeNotifierProvider(create: (_) => Email()),
          ChangeNotifierProvider(create: (_) => Password()),
          ChangeNotifierProvider(create: (_) => NameProperty()),
          ChangeNotifierProvider(create: (_) => LocationProperty()),
          ChangeNotifierProvider(create: (_) => LocationServices()),
          ChangeNotifierProvider(create: (_) => ImageManager()),
          ChangeNotifierProvider(create: (_) => EquipamentosModel()),
          ChangeNotifierProvider(create: (_) => NameEquipamento()),
          ChangeNotifierProvider(create: (_) => PriceEquipamento()),
          ChangeNotifierProvider(create: (_) => DaysEquipamento()),
          ChangeNotifierProvider(create: (_) => DescriptionEquipamento()),
          ChangeNotifierProvider(create: (_) => ImagesEquipamento()),
          ChangeNotifierProvider(create: (_) => LatitudeProperty()),
          ChangeNotifierProvider(create: (_) => LongitudeProperty()),
          ChangeNotifierProvider(create: (_) => EditEquipamento()),
          ChangeNotifierProvider(create: (_) => ProductRepository()),
          ChangeNotifierProvider(create: (_) => FerramentasServices()),
          ChangeNotifierProvider(create: (_) => CurrentAnuncioProvider()),
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
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [Locale('pt', 'BR')],
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
      ),
    );
  }
}
