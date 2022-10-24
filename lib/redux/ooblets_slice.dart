part of 'redux.dart';

@sealed
@immutable
class OobletsSlice {
  final List<OobletWithVariant> ooblets;
  final bool loadingOoblets;
  final bool hasErrorLoadingOoblets;

  const OobletsSlice._({
    this.ooblets = const [],
    this.loadingOoblets = true,
    this.hasErrorLoadingOoblets = false,
  });

  OobletsSlice _copyWith({
    List<OobletWithVariant>? ooblets,
    bool? loadingOoblets,
    bool? hasErrorLoadingOoblets,
  }) =>
      OobletsSlice._(
        ooblets: ooblets ?? this.ooblets,
        loadingOoblets: loadingOoblets ?? this.loadingOoblets,
        hasErrorLoadingOoblets:
            hasErrorLoadingOoblets ?? this.hasErrorLoadingOoblets,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OobletsSlice &&
          listEquals(ooblets, other.ooblets) &&
          loadingOoblets == other.loadingOoblets &&
          hasErrorLoadingOoblets == other.hasErrorLoadingOoblets);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(ooblets),
        loadingOoblets,
        hasErrorLoadingOoblets,
      );
}

// Actions - start

Future<void> fetchOobletsAction(Store<OobdexState> store) async {
  store.dispatch(const _UpdateOobletsSliceAction(
    loadingOoblets: true,
    hasErrorLoadingOoblets: false,
  ));
  try {
    final allOoblets = await ApiManager.instance.fetchAllOoblets();
    final ooblets = allOoblets.ids.expand((id) => [
          OobletWithVariant(OobletVariant.common, id),
          OobletWithVariant(OobletVariant.unusual, id),
          OobletWithVariant(OobletVariant.gleamy, id),
        ]);

    store.dispatch(_UpdateOobletsSliceAction(
      ooblets: List.unmodifiable(ooblets).cast(),
      loadingOoblets: false,
      hasErrorLoadingOoblets: false,
    ));
  } catch (_) {
    store.dispatch(const _UpdateOobletsSliceAction(
      loadingOoblets: false,
      hasErrorLoadingOoblets: true,
    ));
  }
}

class _UpdateOobletsSliceAction {
  final List<OobletWithVariant>? ooblets;
  final bool? loadingOoblets;
  final bool? hasErrorLoadingOoblets;

  const _UpdateOobletsSliceAction({
    this.ooblets,
    this.loadingOoblets,
    this.hasErrorLoadingOoblets,
  });
}

// Actions - end

// Reducers - start

OobletsSlice _updateOobletsReducer(
  OobletsSlice state,
  _UpdateOobletsSliceAction action,
) =>
    state._copyWith(
      ooblets: action.ooblets,
      loadingOoblets: action.loadingOoblets,
      hasErrorLoadingOoblets: action.hasErrorLoadingOoblets,
    );

final _oobletsReducer = combineReducers<OobletsSlice>([
  TypedReducer<OobletsSlice, _UpdateOobletsSliceAction>(_updateOobletsReducer),
]);

// Reducers - end
