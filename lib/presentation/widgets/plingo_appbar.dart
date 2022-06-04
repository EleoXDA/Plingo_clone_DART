/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to
/// deal in the Software without restriction, including without limitation the
/// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
/// sell copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge,
/// publish, distribute, sublicense, create a derivative work, and/or sell
/// copies of the Software in any work that is designed, intended, or marketed
/// for pedagogical or instructional purposes related to programming, coding,
/// application development, or information technology.  Permission for such
/// use, copying, modification, merger, publication, distribution, sublicensing,
///  creation of derivative works, or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
///  IN THE SOFTWARE.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data.dart';
import '../cubit/stats_cubit.dart';
import '../dialogs/stats_dialog.dart';
import 'plingo.dart';

/// Default implementation of the app bar used in Pling
class PlingoAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Constructor
  const PlingoAppBar({Key? key}) : super(key: key);

  static const _kSpacing = 16;
  static const _kToolbarHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: _kToolbarHeight,
      title: SizedBox.fromSize(
        size: const Size.fromHeight(kToolbarHeight - _kSpacing),
        child: const Plingo(),
      ),
      leading: const SizedBox(
        width: 32,
      ),
      actions: [
        IconButton(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (dContext) => BlocProvider(
              create: (bContext) => StatsCubit(
                // TODO: Fetch the stats to display them.
                context.read<GameStatsRepository>(),
              ),
              child: const GameStatsDialog(),
            ),
          ),
          icon: const Icon(Icons.leaderboard_rounded),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_kToolbarHeight);
}
