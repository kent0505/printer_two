import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:printer_two/core/utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants.dart';
import 'core/router.dart';
import 'core/themes.dart';
import 'features/fire/bloc/fire_bloc.dart';
import 'features/fire/data/fire_repository.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/connection/bloc/connection_bloc.dart';
import 'features/onboard/data/onboard_repository.dart';
import 'features/photo/bloc/photo_bloc.dart';
import 'features/photo/data/photo_repository.dart';
import 'features/pro/bloc/pro_bloc.dart';
import 'features/pro/data/pro_repository.dart';
import 'features/fire/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (isIOS()) {
    await Purchases.configure(
      PurchasesConfiguration('appl_CGzDMWeVRNbUSsDDrPTrfgGDBHA'),
    );
  }

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OnboardRepository>(
          create: (context) => OnboardRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<FireRepository>(
          create: (context) => FireRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<ProRepository>(
          create: (context) => ProRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<PhotoRepository>(
          create: (context) => PhotoRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(
            create: (context) => ConnectionBloc()..add(CheckConnection()),
          ),
          BlocProvider(
            create: (context) =>
                ProBloc(repository: context.read<ProRepository>())
                  ..add(
                    CheckPro(
                      identifier: Paywalls.identifier1,
                      initial: true,
                    ),
                  ),
          ),
          BlocProvider(
            create: (context) => FireBloc(
              repository: context.read<FireRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PhotoBloc(
              repository: context.read<PhotoRepository>(),
            )..add(LoadPhotos()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: routerConfig,
    );
  }
}
