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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data.dart';
import '../presentation/bloc/game_bloc.dart';
import '../presentation/pages/game_page.dart';
import 'colors.dart';

/// App widget that wraps the flutter app.
class PlingoApp extends StatelessWidget {
  /// Constructor
  const PlingoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plingo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.shade1,
        brightness: Brightness.dark,
        fontFamily: 'Ubuntu',
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0,
          color: Colors.transparent,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppColors.primary,
            minimumSize: const Size(64, 48),
            textStyle: const TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            primary: AppColors.primary,
            minimumSize: const Size(64, 48),
            side: const BorderSide(width: 1, color: AppColors.primary),
            textStyle: const TextStyle(
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: AppColors.primary,
            minimumSize: const Size(64, 48),
            textStyle: const TextStyle(
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: BlocProvider(
        create: (ctx) =>
            // TODO: Start game here!
            GameBloc(ctx.read<GameStatsRepository>()),
        child: const GamePage(),
      ),
    );
  }
}
