import 'dart:math';
import 'package:flutter/material.dart';

import 'package:tinder/app/models/user.dart';
import 'package:tinder/app/styles.dart';
import 'package:tinder/app/ui/components/card_animations.dart'; 
import 'package:tinder/app/ui/widgets/circle_image_outline.dart';
import 'package:tinder/app/utils.dart';

abstract class CardSwipeListenr  {
  void moveToLeft({User user});
  void moveToRight({User user});
}

class ProfileCardItem extends StatefulWidget {
  final User user;
  final Function onCardPanUpdateCallBack, onReleaseCallback, onCardRollBackCallBack, onComplete;

  ProfileCardItem({ 
    this.onCardPanUpdateCallBack, 
    this.onReleaseCallback, 
    this.onCardRollBackCallBack,
    this.onComplete, 
    this.user,
  }) : super(key: UniqueKey());

  @override
  _ProfileCardItemState createState() {
    return _ProfileCardItemState();
  }
}

class _ProfileCardItemState extends State<ProfileCardItem> with SingleTickerProviderStateMixin {
  bool _isRollback;
  Offset _offset;
  double _rotation;
  AnimationController _controller;

  @override
  void initState() {
    _offset = Offset(0.0, 0.0);
    _rotation = 0.0;
    _isRollback = true;

    _controller = AnimationController(
      duration: Duration(milliseconds: 500), 
      vsync: this
    );
    _controller.addListener(() => setState(() { }));
    _controller.addStatusListener(_onComplete);

    super.initState();    
  }

  _onComplete(AnimationStatus status) {
    if(status == AnimationStatus.completed) {
      if(_isRollback) {
        _offset = Offset(0.0, 0.0);
        _rotation = 0.0;
      } else {
        widget.onComplete();
      }
      _isRollback = true;
    }
  }

  _onCardPanUpdate(DragUpdateDetails details, BuildContext context) {
    setState(() {
      //translate card
      _offset = Offset(
        _offset.dx + 400 * details.delta.dx / MediaQuery.of(context).size.width,
        _offset.dy + 600 * details.delta.dy / MediaQuery.of(context).size.height
      );

      //rotate card
      _rotation = _offset.dx / 500;
    });
    
    //Animation resize backcard
    double newPerX = min(max(_offset.dx, -_offset.dx) * 0.01, 1);
    double newPerY = min(max(_offset.dy , -_offset.dy) * 0.01, 1);

    widget.onCardPanUpdateCallBack(max(newPerX, newPerY));
  }

  _onCardPanEnd() {
    _isRollback = !(_offset.dx >= 80.0 || _offset.dx <= -80.0);

    if(_isRollback) {
      printLog("[ProfileCardItem] swipe cancel");

      widget.onCardRollBackCallBack();
    }
    else {

      widget.onReleaseCallback(
        _offset.dx,
        user: widget.user 
      );
    }
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }

  _onTapUp(TapUpDetails details, BuildContext context) {
    
  }

  _cardAnimRollBackOrDisappear() => !_isRollback 
  ?  CardsAnimation.frontCardDisappearOffsetAnim(_controller, _offset).value 
  :  CardsAnimation.frontCardRollBackOffsetAnim(_controller, _offset).value;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Transform.translate(
        offset: _controller.status == AnimationStatus.forward ? _cardAnimRollBackOrDisappear() : _offset,
        child: Transform.rotate(
          angle: _controller.status == AnimationStatus.forward 
            && _isRollback 
            ? CardsAnimation.frontCardRollBackRotAnim(_controller, _rotation).value : _rotation,
          child: Container(
            margin: EdgeInsets.all(3),  
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: MyColors.card_background
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: MyColors.primaryColor
                    ),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                  color: Colors.black.withOpacity(0.05),
                                )
                              )
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                  color: MyColors.primaryColor
                                )
                              )
                            )
                          ]
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleImageOutline(
                              diameter: MySize.CARD_RADIUS,
                              isUrlImage: true,
                              image: widget.user.avatar,
                              borderColor: MyColors.card_border,
                              borderWidth: MySize.CARD_BORDER_WIDTH,
                              padding: 5,
                            ),
                            SizedBox(height: 20),
                            Text(
                              widget.user.name.getName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            SizedBox(height: 10,),
                            Text(
                              widget.user.email,
                              style: TextStyle(
                                fontSize: 16
                              )
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.mail_outline, size: 40, color: Colors.grey,),
                                SizedBox(width: 10,),
                                Icon(Icons.people_outline, size: 40, color: Colors.grey),
                                SizedBox(width: 10,),
                                Icon(Icons.data_usage, size: 40, color: Colors.green),
                                SizedBox(width: 10,),
                                Icon(Icons.chat_bubble_outline, size: 40, color: Colors.grey,),
                                SizedBox(width: 10,),
                                Icon(Icons.lock_outline, size: 40, color: Colors.grey,),
                              ]
                            )
                          ]
                        )
                      ]
                    )
                  )
                ),
                GestureDetector(
                  onPanUpdate: (details) => _onCardPanUpdate(details, context),
                  onPanEnd: (_) => _onCardPanEnd(),
                  onTapUp: (details) => _onTapUp(details, context)
                )
              ]
            )
          )
        )
      )
    );
  }
}