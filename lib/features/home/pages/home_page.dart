import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils.dart';
import '../../printer/pages/printer_page.dart';
import '../../settings/pages/settings_page.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_appbar.dart';
import '../widgets/nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routePath = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const HomeAppbar(),
      body: Stack(
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
    );
  }
}
