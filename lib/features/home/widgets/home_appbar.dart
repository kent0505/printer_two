import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/models/vip.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../settings/pages/info_page.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_sheet.dart';
import '../bloc/home_bloc.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeBloc>().state;

    return AppBar(
      centerTitle: false,
      shape: const Border(
        bottom: BorderSide(color: Colors.transparent),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ).copyWith(top: 8),
      title: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          state is HomePrinter ? 'Printer' : 'Settings',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: AppFonts.w600,
          ),
        ),
      ),
      actions: [
        if (state is HomePrinter) ...[
          Button(
            onPressed: () {
              context.push(InfoPage.routePath);
            },
            minSize: 52,
            child: const SvgWidget(Assets.info),
          ),
          BlocBuilder<VipBloc, Vip>(
            builder: (context, state) {
              return state.loading
                  ? const SizedBox(
                      width: 52,
                      child: LoadingWidget(),
                    )
                  : state.isVip
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Button(
                            onPressed: () {
                              VipSheet.show(
                                context,
                                identifier: Paywalls.identifier2,
                              );
                            },
                            child: const Center(
                              child: SvgWidget(Assets.premium),
                            ),
                          ),
                        );
            },
          ),
        ],
      ],
    );
  }
}
