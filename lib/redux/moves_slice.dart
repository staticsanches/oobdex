part of 'redux.dart';

@sealed
@immutable
class MovesSlice {
  final List<Move> moves;
  final bool loadingMoves;
  final bool hasErrorLoadingMoves;

  const MovesSlice._({
    this.moves = const [],
    this.loadingMoves = true,
    this.hasErrorLoadingMoves = false,
  });

  MovesSlice _copyWith({
    List<Move>? moves,
    bool? loadingMoves,
    bool? hasErrorLoadingMoves,
  }) =>
      MovesSlice._(
        moves: moves ?? this.moves,
        loadingMoves: loadingMoves ?? this.loadingMoves,
        hasErrorLoadingMoves: hasErrorLoadingMoves ?? this.hasErrorLoadingMoves,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovesSlice &&
          listEquals(moves, other.moves) &&
          loadingMoves == other.loadingMoves &&
          hasErrorLoadingMoves == other.hasErrorLoadingMoves);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(moves),
        loadingMoves,
        hasErrorLoadingMoves,
      );
}

// Actions - start

Future<void> fetchMovesAction(Store<OobdexState> store) async {
  store.dispatch(const _UpdateMovesSlice(
    moves: [],
    loadingMoves: true,
    hasErrorLoadingMoves: false,
  ));
  try {
    final allMoves = await ApiManager.instance.fetchAllMoves();
    final moves = SplayTreeSet<Move>(_compareMoves);
    await for (final move in allMoves.fetchMoves()) {
      moves.add(move);
    }
    store.dispatch(_UpdateMovesSlice(
      moves: List.unmodifiable(moves),
      loadingMoves: false,
      hasErrorLoadingMoves: false,
    ));
  } catch (_) {
    store.dispatch(const _UpdateMovesSlice(
      loadingMoves: false,
      hasErrorLoadingMoves: true,
    ));
  }
}

int _compareMoves(Move m1, Move m2) {
  if (m1 == m2) {
    return 0;
  }
  var result = m1.name.toString().compareTo(m2.name.toString());
  if (result == 0) {
    result = m1.id.compareTo(m2.id);
  }
  return result;
}

class _UpdateMovesSlice {
  final List<Move>? moves;
  final bool? loadingMoves;
  final bool? hasErrorLoadingMoves;

  const _UpdateMovesSlice({
    this.moves,
    this.loadingMoves,
    this.hasErrorLoadingMoves,
  });
}

// Actions - end

// Reducers - start

MovesSlice _movesReducer(MovesSlice state, dynamic action) {
  if (action is _UpdateMovesSlice) {
    return state._copyWith(
      moves: action.moves,
      loadingMoves: action.loadingMoves,
      hasErrorLoadingMoves: action.hasErrorLoadingMoves,
    );
  }
  return state;
}

// Reducers - end
