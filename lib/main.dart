import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petmeals_local/di.dart';
import 'package:petmeals_local/src/core/app/routers/routes.dart';
import 'package:petmeals_local/src/core/app/styles/themes/theme.dart';
import 'package:petmeals_local/src/features/pet/presentation/provider/pet_provider.dart';
import 'package:petmeals_local/src/features/user/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GetIt.instance.get<UserProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => GetIt.instance.get<PetProvider>(),
          lazy: true,
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Petmeals',
        theme: themeData,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', 'ES')],
        routerConfig: goRouter,
      ),
    );
  }
}
