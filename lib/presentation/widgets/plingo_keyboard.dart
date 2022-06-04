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

import '../../app/colors.dart';
import '../../domain.dart';
import '../bloc/game_bloc.dart';
import 'aligned_grid.dart';
import 'plingo_key.dart';

/// Displays the keyboard available for creating word guesses.
class PlingoKeyboard extends StatelessWidget {
  /// Constructor
  const PlingoKeyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final guesses = context.watch<GameBloc>().state.guesses;
    final puzzle = context.watch<GameBloc>().state.puzzle;

    final attemptedLetters = guesses
        .where((guess) => guess.join().length == kWordLength)
        .expand((guess) => guess)
        .where((letter) => letter.isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: AlignedGrid(
        crossAxisSpacing: 16,
        children: keyboardKeys
            .map(
              (row) => AlignedGrid(
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 6,
                crossAxisSpacing: 4,
                maxAxisCount: 10,
                padding: const EdgeInsets.all(16),
                childAspectRatio: 1 / 1.5,
                children: row.characters
                    .map(
                      (letter) => PlingoKey(
                        letter: letter,
                        color: definePlingoKeyColor(
                          attemptedLetters,
                          puzzle,
                          letter,
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }

  /// Helper function that defines the color of a guess cell.
  Color? definePlingoKeyColor(
    List<String> attemptedLetters,
    String puzzle,
    String letter,
  ) {
    if (letter.isEmpty || !attemptedLetters.contains(letter)) {
      return null;
    }

    final position = puzzle.indexOf(letter);
    if (attemptedLetters.contains(letter)) {
      if (position != -1) {
        return AppColors.success;
      }

      return AppColors.shade2;
    }

    return null;
  }
}
