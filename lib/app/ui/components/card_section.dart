import 'package:flutter/material.dart';
import 'package:tinder/app/blocs/profile_card_page_bloc.dart';
import 'package:tinder/app/ui/components/card_animations.dart';
import 'package:tinder/app/ui/components/profile_card_item.dart';

Size backCardSize, contextSize;
double maxPerWidthBack = 0.9, maxPerHeightBack = 0.7;

class CardSection extends StatefulWidget {
  final ProfileCardBloc profileCardBloc;
  
  CardSection (BuildContext context, this.profileCardBloc) {
    contextSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    backCardSize = Size(contextSize.width * maxPerWidthBack, contextSize.height * maxPerHeightBack);
  }

  @override  
  _CardSectionState createState() => _CardSectionState();
}

class _CardSectionState extends State<CardSection> with SingleTickerProviderStateMixin{

  List<ProfileCardItem> cards = List();
  AnimationController _controller;

  @override
  void initState() {
    widget.profileCardBloc.users.forEach((user) {
      cards.add(
        ProfileCardItem(
          onCardPanUpdateCallBack: _onFontCardPanUpdate, 
          onReleaseCallback: changeCardOder, 
          onCardRollBackCallBack: _onCardRollBack,
          onComplete: _onCardReleaseCompleted,
          user: user
        )
      );
    });
    _controller = AnimationController(
      duration: Duration(
        milliseconds: 500
      ), 
      vsync: this
    );
    _controller.addListener(() => setState( () {} ));

    super.initState();
  }
  
  void changeCardOder() async{
    await widget.profileCardBloc.addUser(
      onResponse: (user){
        cards.add(
          ProfileCardItem(
            onCardPanUpdateCallBack: _onFontCardPanUpdate, 
            onReleaseCallback: changeCardOder, 
            onCardRollBackCallBack: _onCardRollBack,
            onComplete: _onCardReleaseCompleted,
            user: widget.profileCardBloc.users.last,
          )
        );   
        backCardSize = Size(contextSize.width * maxPerWidthBack, contextSize.height * maxPerHeightBack);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[ 
          lastCard(),
          backCard(),
          frontCard(),
        ],
      ),
    );
  }

  _onFontCardPanUpdate(double perbackCard) {
    setState(() {
      backCardSize = Size(
        contextSize.width * (maxPerWidthBack + (1 - maxPerWidthBack) * perbackCard * 2), 
        contextSize.height * (maxPerHeightBack + (1 - maxPerHeightBack) * perbackCard / 2)
      );
    });
  }

  _onCardReleaseCompleted() {
    setState(() {
      cards.removeAt(0);
    });
  }

  _onCardRollBack() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward(); 
  }

  frontCard(){
    if(cards.length == 0) {
      return Align(      
        child: Text("Nobody Else!")
      );
    } else {
      return Align(
        child: SizedBox.fromSize(
          child: cards[0]
        )
      );
    }
  }

  backCard() {
    if(cards.length <= 1) {
      return SizedBox();
    } else {
      return Align(      
        child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward ? 
          CardsAnimation.backCardRollBackResizeAnim(
            _controller, 
            backCardSize, 
            Size(contextSize.width * maxPerWidthBack, contextSize.height * maxPerHeightBack)
          ).value : backCardSize,
          child: cards[1]
        )
      );
    }
  } 

  lastCard() {
    if(cards.length <= 2) {
      return SizedBox();
    } else {
      return Align(      
        child: SizedBox.fromSize(
          size: backCardSize,
          child: cards[2]
        )
      );
    }
  }
}
