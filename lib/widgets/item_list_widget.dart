import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import 'api_image_widget.dart';
import 'square_box.dart';

class ItemListWidget extends StatelessWidget {
  final ItemList _itemList;

  const ItemListWidget(this._itemList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _itemList.elements.length,
        itemBuilder: (_, index) => _Element(_itemList.elements[index]),
      ),
    );
  }
}

class _Element extends HookWidget {
  final ItemListElement element;

  const _Element(this.element);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SquareBox(
        child: ApiImageWidget(ApiDataType.itemImage, element.itemID),
      ),
      title: Text(element.itemID),
    );
  }
}
