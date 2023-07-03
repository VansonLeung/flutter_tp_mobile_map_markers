
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../apis/models/APIResponses.dart';
import '../../apis/models/APIResponsesShop.dart';
import '../../components/TPTextNegative.dart';
import '../generic/GenericShopThumbCellHorizontal.dart';

class NearbyMapShopListView extends StatefulWidget {

  final bool? isRefreshing;
  final bool? isBusy;
  final List<Shop> shops;
  final Function? onBottomReach;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final int selectedIndex;
  final Function(int)? onSelectIndex;

  NearbyMapShopListView({required this.shops, this.isRefreshing, this.onBottomReach, this.isBusy, required this.itemScrollController, required this.itemPositionsListener, required this.selectedIndex, this.onSelectIndex});

  @override
  _NearbyMapShopListViewState createState() => _NearbyMapShopListViewState();
}

class _NearbyMapShopListViewState extends State<NearbyMapShopListView> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ScrollablePositionedList.builder(
            itemCount: widget.shops.length,
            itemBuilder: (context, index) => Column(
              children: [
                if (index > 0)
                  const Divider(
                    height: 4,
                    color: Color(0xFFFFFFFF),
                  ),

                Container(
                    color: widget.selectedIndex == index ? Color(0xaa000000) : null,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GenericShopThumbCellHorizontal(
                      index: index,
                      shop: widget.shops[index],
                      onPressed: () {
                        if (widget.selectedIndex == index) {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ShopDetailsPage(shop_id: widget.shops[index].getId() ?? ""),
                          //   ),
                          // );
                        } else {
                          widget.onSelectIndex!(index);
                        }
                      },
                      isSelected: widget.selectedIndex == index,
                    )
                ),
              ],
            ),
            itemScrollController: widget.itemScrollController,
            itemPositionsListener: widget.itemPositionsListener,
          ),
        ),


        if (widget.isRefreshing == true)
          Container(
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFFFFFF),
                ),
              )
          ),

        if (widget.isRefreshing != true && widget.shops.length <= 0)
          Container(
              child: Center(
                child: TPTextNegative(
                  "No results",
                ),
              )
          ),
      ],
    );
  }
}

