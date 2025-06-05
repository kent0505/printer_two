import 'dart:io';

import 'package:go_router/go_router.dart';

import '../features/home/pages/home_page.dart';
import '../features/onboard/pages/onboard_page.dart';
import '../features/onboard/pages/printer_model_page.dart';
import '../features/onboard/pages/splash_page.dart';
import '../features/photo/screens/albums_page.dart';
import '../features/photo/screens/photo_page.dart';
import '../features/printer/pages/email_page.dart';
import '../features/printer/pages/files_page.dart';
import '../features/printer/pages/printable_page.dart';
import '../features/printer/pages/printables_page.dart';
import '../features/printer/pages/scanner_page.dart';
import '../features/printer/pages/web_page.dart';
import '../features/settings/pages/info_page.dart';
import '../features/vip/screens/vip_page.dart';
import 'models/album.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: OnboardPage.routePath,
      builder: (context, state) => const OnboardPage(),
    ),
    GoRoute(
      path: HomePage.routePath,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: ScannerPage.routePath,
      builder: (context, state) => ScannerPage(
        paths: state.extra as List<String>,
      ),
    ),
    GoRoute(
      path: FilesPage.routePath,
      builder: (context, state) => FilesPage(
        file: state.extra as File,
      ),
    ),
    GoRoute(
      path: EmailPage.routePath,
      builder: (context, state) => const EmailPage(),
    ),
    GoRoute(
      path: PrintablesPage.routePath,
      builder: (context, state) => const PrintablesPage(),
    ),
    GoRoute(
      path: PrintablePage.routePath,
      builder: (context, state) => PrintablePage(
        asset: state.extra as String,
      ),
    ),
    // GoRoute(
    //   path: PrintableDetailPage.routePath,
    //   builder: (context, state) => PrintableDetailPage(
    //     printable: state.extra as Printable,
    //   ),
    // ),
    GoRoute(
      path: WebPage.routePath,
      builder: (context, state) => const WebPage(),
    ),
    GoRoute(
      path: PhotoPage.routePath,
      builder: (context, state) => PhotoPage(
        album: state.extra as Album,
      ),
    ),
    GoRoute(
      path: AlbumsPage.routePath,
      builder: (context, state) => const AlbumsPage(),
    ),
    GoRoute(
      path: VipPage.routePath,
      builder: (context, state) => VipPage(
        identifier: state.extra as String,
      ),
    ),
    GoRoute(
      path: InfoPage.routePath,
      builder: (context, state) => const InfoPage(),
    ),
    GoRoute(
      path: PrinterModelPage.routePath,
      builder: (context, state) => PrinterModelPage(
        onboard: state.extra as bool,
      ),
    ),
  ],
);
