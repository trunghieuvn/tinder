import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'circle_image.dart';

class CircleImageOutline extends StatelessWidget {
  final double diameter;
  final String image;
  final Color borderColor;
  final double borderWidth;
  final bool isUrlImage;
  final double padding;
  final Color backgroundColor;

  const CircleImageOutline({
    Key key, 
    this.diameter, 
    this.image, 
    this.borderColor, 
    this.borderWidth = 4, 
    this.isUrlImage, 
    this.padding = 3,
    this.backgroundColor = Colors.white
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: diameter,
      width: diameter,
      child: Container(
        height: diameter,
        width: diameter,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(diameter)),
          border: Border.all(color: borderColor, width: borderWidth),
          color: backgroundColor
        ),
        child: isUrlImage ?  CachedNetworkImage(
          imageUrl: image,
          imageBuilder: (context, imageProvider){
            return CircleImage(
              image: Image(
                image: imageProvider,
                width: diameter, 
                height: diameter,
                fit: BoxFit.cover
              )
            );
          },
          errorWidget: (context, url, error) => CircleImage(
            image : Image.asset(
              image, 
              width: diameter, 
              height: diameter, 
              fit: BoxFit.cover
            )
          )
        ) : Image.asset(
          image, 
          width: diameter, 
          height: diameter, 
          fit: BoxFit.cover
        )
      )
    );
  }
}