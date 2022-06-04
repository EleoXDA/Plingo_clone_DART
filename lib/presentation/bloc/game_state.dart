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
part of 'game_bloc.dart';

/// Possible game states.
enum GameStatus {
  /// When the game has no guesses
  initial,

  /// When the game has at least one guess
  inProgress,

  /// When the player successfully guesses the puzzle.
  success,

  /// When the player fails to guess the puzzle
  /// and has no more attempts available.
  failure,
}

/// Game state.
class GameState extends Equatable {
  /// Constructor
  const GameState({
    this.status = GameStatus.initial,
    this.guesses = const [],
    this.puzzle = '',
  });

  /// Current status of the game,
  final GameStatus status;

  /// The puzzle for the current game.
  final String puzzle;

  /// A list of the guesses available for the game.
  final List<List<String>> guesses;

  @override
  List<Object> get props => [
        status,
        puzzle,
        guesses,
      ];

  /// Provides a copied instance.
  GameState copyWith({
    GameStatus? status,
    String? puzzle,
    List<List<String>>? guesses,
  }) =>
      GameState(
        status: status ?? this.status,
        puzzle: puzzle ?? this.puzzle,
        guesses: guesses ?? this.guesses,
      );
}
