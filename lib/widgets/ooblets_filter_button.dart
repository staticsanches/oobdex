import 'package:flutter/material.dart';

import '../hooks/hooks.dart';

class OobletsFilterButton extends HookWidget {
  final void Function() onPressed;

  const OobletsFilterButton(this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    final withFilters = useSelector(
      (state) =>
          state.oobletsSlice.variantsFilter.isNotEmpty ||
          state.oobletsSlice.locationsFilter.isNotEmpty ||
          state.oobletsSlice.nameFilter.isNotEmpty,
    );
    return Container(
      width: 72,
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.filter_list),
          ),
          if (withFilters)
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                constraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
