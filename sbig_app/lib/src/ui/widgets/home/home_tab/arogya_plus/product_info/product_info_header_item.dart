import 'package:flutter/material.dart';
import 'package:sbig_app/src/resources/color_constants.dart';

class ProductInfoHeaderItem extends StatelessWidget {
  final String title;
  final List<Color> colors;
  final String icon;

  ProductInfoHeaderItem(this.title, this.colors, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
          color: ColorConstants.product_info_header_points_bg_color,
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.white,
//                  gradient: LinearGradient(
//                      begin: Alignment.bottomLeft,
//                      end: Alignment.topRight,
//                      colors: colors)
                      ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(icon),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
