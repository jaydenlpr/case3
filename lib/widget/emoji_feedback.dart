
import 'dart:math';
import 'package:flutter/material.dart';

class EmojiModel {
  final String label;
  final String src;
  final String activeSrc;
  const EmojiModel({this.src, this.activeSrc, this.label});
}

final List<EmojiModel> reactions = <EmojiModel>[
  EmojiModel(
      label: 'Serious problem',
      src: 'assets/worried.png',
      activeSrc: 'assets/worried_big.png'),
  EmojiModel(
      label: 'Somewhat serious problem',
      src: 'assets/sad.png',
      activeSrc: 'assets/sad_big.png'),
  EmojiModel(
      label: 'Moderate problem',
      src: 'assets/ambitious.png',
      activeSrc: 'assets/ambitious_big.png'),
  EmojiModel(
      label: 'Minor Problem',
      src: 'assets/smile.png',
      activeSrc: 'assets/smile_big.png'),
  EmojiModel(
      label: 'Not a problem',
      src: 'assets/surprised.png',
      activeSrc: 'assets/surprised_big.png'),
].toList();

class EmojiFeedback extends StatefulWidget {
  final int currentIndex;
  final Function onChange;

  final EmojiSize;
  num EmojiRadius;
  num ActiveEmojiSize;
  num ActiveEmojiRadius;
  num HalfDiffSize;

  num availableWidth;

  final bool showLabel;

  EmojiFeedback({
    Key key,
    this.currentIndex = 2,
    this.onChange,
    this.EmojiSize = 40.0,
    this.showLabel = true
  }) : super(key: key) {
    EmojiRadius = EmojiSize / 2.0;
    ActiveEmojiSize = EmojiSize * 1.5;
    ActiveEmojiRadius = ActiveEmojiSize / 2.0;
    HalfDiffSize = (ActiveEmojiSize - EmojiSize) / 2.0;

    availableWidth = EmojiSize * 8;
  }

  @override
  EmojiFeedbackState createState() {
    return new EmojiFeedbackState();
  }
}

class EmojiFeedbackState extends State<EmojiFeedback>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  double pos = 2.0; // should be between [0, 4]

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
  }

  void moveTo(int index) {
    animation = Tween<double>(
      begin: pos,
      end: index.toDouble(),
    ).chain(CurveTween(curve: Curves.linear)).animate(controller)
      ..addListener(() {
        setState(() {
          pos = animation.value;
        });
      });
    controller.forward(from: 0.0);
    if (widget.onChange is Function) {
      widget.onChange(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final posTween =
        Tween<double>(begin: 0, end: widget.availableWidth - widget.ActiveEmojiSize);
    List<_EmojiButton> emojiButtons = [];
    List<Widget> activeEmojis = [];
    for (var i = 0; i < reactions.length; i++) {
      final distanceTo = posTween.transform((i - pos).abs() / 4);
      var scale = 1.0;
      if (distanceTo < widget.ActiveEmojiRadius) {
        scale = 0.0;
      } else {
        scale =
            min<double>((distanceTo - widget.ActiveEmojiRadius) / widget.EmojiRadius, 1.0);
      }
      emojiButtons.add(_EmojiButton(
        scale: scale,
        label: widget.showLabel ?  reactions[i].label : "",
        src: reactions[i].src,
        onPressed: () {
          moveTo(i);
        },
        EmojiSize: widget.EmojiSize,
        ActiveEmojiSize: widget.ActiveEmojiSize,
        HalfDiffSize: widget.HalfDiffSize,
      ));
      activeEmojis.add(
        Positioned(
          child: Opacity(
            opacity: 1.0 - scale,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    reactions[i].activeSrc,
                  ),
                ),
                borderRadius: BorderRadius.circular(widget.ActiveEmojiSize),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: widget.availableWidth,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: widget.ActiveEmojiRadius,
            left: widget.ActiveEmojiRadius,
            right: widget.ActiveEmojiRadius,
            child: Container(
              height: 1.0,
              color: Colors.grey,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: emojiButtons,
            ),
          ),
          Positioned(
            left: posTween.transform(pos / 4),
            child: Container(
              width: widget.ActiveEmojiSize,
              height: widget.ActiveEmojiSize,
              child: Stack(
                children: activeEmojis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _EmojiButton extends StatelessWidget {
  final VoidCallback onPressed;
  final num scale;
  final String label;
  final String src;

  final EmojiSize;
  final ActiveEmojiSize;
  final HalfDiffSize;

  const _EmojiButton({
    Key key,
    @required this.onPressed,
    this.scale,
    @required this.label,
    @required this.src,
    this.EmojiSize,
    this.ActiveEmojiSize,
    this.HalfDiffSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(scale >= 0 && scale <= 1);
    final offsetTop = Tween<double>(begin: 16.0, end: 6.0).transform(scale);
    final realScale = Tween<double>(begin: 0.25, end: 1.0).transform(scale);
    final color =
        ColorTween(begin: Colors.black, end: Colors.grey).transform(scale);
    return Container(
      width: ActiveEmojiSize,
      padding: EdgeInsets.only(top: HalfDiffSize),
      child: Column(
        children: <Widget>[
          Transform.scale(
            scale: realScale,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: onPressed,
              child: Container(
                width: EmojiSize,
                height: EmojiSize,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(src),
                  ),
                  borderRadius: BorderRadius.circular(EmojiSize),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: offsetTop),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 10
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
