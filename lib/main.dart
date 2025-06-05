import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants.dart';
import 'core/router.dart';
import 'core/themes.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/internet/bloc/internet_bloc.dart';
import 'features/onboard/data/onboard_repository.dart';
import 'features/photo/bloc/photo_bloc.dart';
import 'features/photo/data/photo_repository.dart';
import 'features/vip/bloc/vip_bloc.dart';
import 'features/vip/data/vip_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  await Purchases.configure(
    PurchasesConfiguration('appl_CGzDMWeVRNbUSsDDrPTrfgGDBHA'),
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OnboardRepository>(
          create: (context) => OnboardRepositoryImpl(prefs: prefs),
        ),
        // RepositoryProvider<FirebaseRepository>(
        //   create: (context) => FirebaseRepositoryImpl(prefs: prefs),
        // ),
        RepositoryProvider<VipRepository>(
          create: (context) => VipRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<PhotoRepository>(
          create: (context) => PhotoRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(
            create: (context) => InternetBloc()..add(CheckInternet()),
          ),
          BlocProvider(
            create: (context) =>
                VipBloc(repository: context.read<VipRepository>())
                  ..add(
                    CheckVip(
                      identifier: Paywalls.identifier1,
                      initial: true,
                    ),
                  ),
          ),
          // BlocProvider(
          //   create: (context) => FirebaseBloc(
          //     repository: context.read<FirebaseRepository>(),
          //   ),
          // ),
          BlocProvider(
            create: (context) => PhotoBloc(
              repository: context.read<PhotoRepository>(),
            ),
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
