
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../apis/models/APIResponses.dart';
import '../../apis/models/APIResponsesShop.dart';
import '../../components/TPTextNegative.dart';

class GenericShopThumbCellHorizontal extends StatelessWidget {
  final int index;
  final Shop shop;
  final bool isSelected;
  final Function onPressed;

  const GenericShopThumbCellHorizontal({Key? key, required this.shop, required this.index, this.isSelected = false, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return TextButton(
        onPressed: () {
          onPressed();
        },
        child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [


                    const SizedBox(width: 20, height: 7,),

                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              TPTextNegative(
                                  '${index + 1}. ${shop.getName(context)}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),

                              const SizedBox(height: 2,),

                              TPTextNegative(
                                '${shop.getAddress(context)}',
                                color: Color(0xFFe0e0e0),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),

                            ]
                        )


                    ),

                    const SizedBox(width: 20, height: 7,),


                    AnimatedOpacity(
                      opacity: isSelected ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const Icon(Icons.chevron_right, size: 32, color: Color(0xffffffff)),
                    )


                  ]
              ),

            ]
        )
    );
  }

}
