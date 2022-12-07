import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../widgets/api_image_widget.dart';
import '../widgets/clickable_card.dart';
import '../widgets/retry_fetch_widget.dart';

class MovesGridPage extends HookWidget {
  const MovesGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();

    final hasErrorLoadingMoves =
        useSelector((state) => state.movesSlice.hasErrorLoadingMoves);
    final loadingMoves = useSelector((state) => state.movesSlice.loadingMoves);

    final Widget body;
    if (hasErrorLoadingMoves) {
      body = const RetryFetchWidget(fetchMovesAction);
    } else if (loadingMoves) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = const SafeArea(child: _MovesGridView());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.moves),
      ),
      body: body,
    );
  }
}

class _MovesGridView extends HookWidget {
  const _MovesGridView();

  @override
  Widget build(BuildContext context) {
    final moves = useSelector((state) => state.movesSlice.moves);
    final crossAxisCount = useResponsiveValue(
      const Breakpoints(xs: 3, sm: 4, md: 5, lg: 6, xl: 7, xxl: 8),
    );

    return Padding(
      padding: const EdgeInsets.all(4),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 5 / 8,
        ),
        itemCount: moves.length,
        itemBuilder: (_, index) => _MoveCard(moves[index]),
      ),
    );
  }
}

class _MoveCard extends HookWidget {
  final Move move;

  const _MoveCard(this.move);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();

    return ClickableCard(
      margin: const EdgeInsets.all(4),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ApiImageWidget(
                ApiDataType.moveImage,
                move.id,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  move.name.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '(${appLocalizations.moveCost.toLowerCase()}: ${move.cost})',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
