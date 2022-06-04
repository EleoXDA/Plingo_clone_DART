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
import '../bloc/game_bloc.dart';
import 'aligned_grid.dart';
import 'guess_cell.dart';

/// Displays the game board.
class Board extends StatelessWidget {
  /// Constructor
  const Board({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final guesses = context.watch<GameBloc>().state.guesses;
    final puzzle = context.watch<GameBloc>().state.puzzle;

    return AlignedGrid(
      padding: const EdgeInsets.symmetric(vertical: 16),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      maxAxisCount: 5,
      childAspectRatio: 1 / 1,
      children: guesses
          .map((row) => row
              .map((letter) => GuessCell(
                    color: defineGuessCellColor(
                      row,
                      puzzle,
                      letter,
                    ),
                    content: letter,
                  ))
              .toList())
          .expand((row) => row)
          .toList(),
    );
  }

  /// Helper function that defines the color of a guess cell.
  Color? defineGuessCellColor(
    List<String> row,
    String puzzle,
    String letter,
  ) {
    final letterCount =
        row.reduce((letter, anotherLetter) => letter + anotherLetter);

    if (letter.isEmpty || letterCount.length < 5 || !puzzle.contains(letter)) {
      return null;
    }

    final position = row.indexOf(letter);
    if (position != -1 && puzzle[position] == letter) {
      return AppColors.success;
    }

    return AppColors.warning;
  }
}
