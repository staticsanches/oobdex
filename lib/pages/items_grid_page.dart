import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../utils/extensions.dart';
import '../widgets/api_image_widget.dart';
import '../widgets/clickable_card.dart';
import '../widgets/retry_fetch_widget.dart';

class ItemsGridPage extends HookWidget {
  const ItemsGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();

    final hasErrorLoadingItems =
        useSelector((state) => state.itemsSlice.hasErrorLoadingItems);
    final loadingItems = useSelector((state) => state.itemsSlice.loadingItems);

    final Widget body;
    if (hasErrorLoadingItems) {
      body = const RetryFetchWidget(fetchItemsAction);
    } else if (loadingItems) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = const SafeArea(child: _ItemsGridView());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.items),
      ),
      body: body,
    );
  }
}

class _ItemsGridView extends HookWidget {
  const _ItemsGridView();

  @override
  Widget build(BuildContext context) {
    final items = useSelector((state) => state.itemsSlice.items);
    final crossAxisCount = useResponsiveValue(
      const Breakpoints(xs: 3, sm: 4, md: 5, lg: 6, xl: 7, xxl: 8),
    );

    return Padding(
      padding: const EdgeInsets.all(4),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 3 / 4,
        ),
        itemCount: items.length,
        itemBuilder: (_, index) => _ItemCard(items[index]),
      ),
    );
  }
}

class _ItemCard extends HookWidget {
  final Item item;

  const _ItemCard(this.item);

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
                ApiDataType.itemImage,
                item.id,
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
                  item.name.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '(${item.type.getName(appLocalizations).toLowerCase()})',
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
