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

import '../bloc/game_bloc.dart';
import '../widgets/board.dart';
import '../widgets/plingo_appbar.dart';
import '../widgets/plingo_keyboard.dart';

/// HomePage widget.
///
/// [Scaffold] that displays the KeyMotion menu
class GamePage extends StatelessWidget {
  /// @macro home_page
  const GamePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PlingoAppBar(),
      body: SafeArea(
        child: _Game(),
      ),
    );
  }
}

class _Game extends StatelessWidget {
  const _Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameBloc>().state;

    if (state.status == GameStatus.initial ||
        state.status == GameStatus.inProgress) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Expanded(child: Board()),
          const PlingoKeyboard(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            state.status == GameStatus.success
                ? 'You\'ve won!\nYour lingo is growing strong.'
                : 'You\'ve lost!\nOur playful lingo was too strong. ',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        ),
        const Board(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: ElevatedButton(
            // TODO: Restart game here!
            onPressed: () {},
            child: const Text('Play again!'),
          ),
        ),
      ],
    );
  }
}
