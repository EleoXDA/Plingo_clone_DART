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
import 'package:flutter/widgets.dart';

/// A Grid that wraps the different children and allows for alignment of the
/// rows available.
class AlignedGrid extends StatelessWidget {
  /// Padding for the grid.
  final EdgeInsetsGeometry padding;

  /// Spacing for the cross axis.
  final double crossAxisSpacing;

  /// Spacing for the main axis.
  final double mainAxisSpacing;

  /// Amount of items peer main axis.
  final int maxAxisCount;

  /// Alignment of the rows if there's space available.
  final WrapAlignment alignment;

  /// Child aspect ratio, if null then children will take all availabl space.
  final double? childAspectRatio;

  /// Scroll physics.
  final ScrollPhysics? physics;

  /// The list of widgets to be displayed in the grid.
  final List<Widget> children;

  /// Constructor.
  const AlignedGrid({
    Key? key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.alignment = WrapAlignment.center,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.maxAxisCount = 1,
    this.childAspectRatio,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final verticalPadding = padding.vertical;
    final spacingSumWidth = mainAxisSpacing * (maxAxisCount - 1);
    final availableWidth =
        MediaQuery.of(context).size.width - verticalPadding - spacingSumWidth;

    final itemWidth = availableWidth / maxAxisCount;
    return SingleChildScrollView(
      physics: physics,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Wrap(
          runSpacing: crossAxisSpacing,
          spacing: mainAxisSpacing,
          alignment: alignment,
          children: children
              .map(
                (child) => ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: itemWidth),
                  child: childAspectRatio != null
                      ? AspectRatio(
                          aspectRatio: childAspectRatio!,
                          child: child,
                        )
                      : child,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
