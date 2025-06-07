import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../printer/pages/files_page.dart';
import '../../printer/pages/printer_page.dart';
import '../../pro/bloc/pro_bloc.dart';
import '../../pro/screens/pro_sheet.dart';
import '../../settings/pages/settings_page.dart';
import '../../share/bloc/share_bloc.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_appbar.dart';
import '../widgets/nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routePath = '/HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _paywallShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ProBloc>().state;

      if (!_paywallShown &&
          !state.loading &&
          !state.isPro &&
          state.offering != null &&
          mounted) {
        _paywallShown = true;
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            ProSheet.show(
              context,
              identifier: Paywalls.identifier1,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const HomeAppbar(),
      body: BlocListener<ShareBloc, ShareState>(
        listener: (context, state) {
          if (state is ShareLoaded) {
            context.push(
              FilesPage.routePath,
              extra: File(state.files[0].path),
            );
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 62 + MediaQuery.of(context).viewPadding.bottom,
              ),
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  logger(state.runtimeType);
                },
                buildWhen: (previous, current) {
                  return previous.runtimeType != current.runtimeType;
                },
                builder: (context, state) {
                  int index = state is HomePrinter ? 0 : 1;

                  return IndexedStack(
                    index: index,
                    children: const [
                      PrinterPage(),
                      SettingsPage(),
                    ],
                  );
                },
              ),
            ),
            const NavBar(),
          ],
        ),
      ),
    );
  }
}
