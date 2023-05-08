import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048_clone/constants/app_durations.dart';
import 'package:flutter_2048_clone/constants/app_sizes.dart';
import 'package:flutter_2048_clone/constants/app_strings.dart';
import 'package:flutter_2048_clone/enums/game_status.dart';
import 'package:flutter_2048_clone/enums/swipe_direction.dart';
import 'package:flutter_2048_clone/models/game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Game _game;

  @override
  void initState() {
    super.initState();
    _game = Game(
      height: 4,
      width: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        AppStrings.appName,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spacingM),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size.square(AppSizes.lengthXL)),
          child: AnimatedBuilder(
            animation: _game,
            builder: (context, child) {
              return AnimatedSwitcher(
                duration: AppDurations.m,
                child: _game.status == GameStatus.playing ? _buildPlayBox() : _buildGameOverBox(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlayBox() {
    Offset? startOffset;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Listener(
        onPointerDown: (topDownDetails) {
          startOffset = topDownDetails.localPosition;
        },
        onPointerUp: (tapUpDetails) {
          if (startOffset == null) return;
          final Offset differenceOffset = tapUpDetails.localPosition - startOffset!;
          if (differenceOffset.distance < 50) return;
          int angle = -differenceOffset.direction * 180 ~/ pi;
          if (angle < 0) angle += 360;
          if ((angle <= 22) || (360 - angle <= 22)) {
            _game.swipe(SwipeDirection.right);
          } else if ((angle - 90).abs() <= 22) {
            _game.swipe(SwipeDirection.up);
          } else if ((angle - 180).abs() <= 22) {
            _game.swipe(SwipeDirection.left);
          } else if ((angle - 270).abs() <= 22) {
            _game.swipe(SwipeDirection.down);
          }
          startOffset = null;
        },
        child: GridView.builder(
          itemCount: 16,
          padding: const EdgeInsets.all(AppSizes.spacingM),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: AppSizes.spacingM,
            crossAxisSpacing: AppSizes.spacingM,
          ),
          itemBuilder: (context, index) {
            final int value = _game.getValueWithIndex(index);
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                color: Colors.amber,
              ),
              child: value == 0
                  ? null
                  : Center(
                      child: Text(
                        value.toString(),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameOverBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.gameOver,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: AppSizes.spacingL,
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => _game.restart(),
        ),
      ],
    );
  }
}
