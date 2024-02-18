import 'package:flutter/material.dart';

class SliderAni extends StatefulWidget {
  const SliderAni({Key? key}) : super(key: key);

  @override
  State<SliderAni> createState() => _SliderAniState();
}

class _SliderAniState extends State<SliderAni> {
  PageController pageController = PageController(viewportFraction: 0.85);

  var _currentPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = 120;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: SliderAniContent(
            pageController: pageController,
            currentPageValue: _currentPageValue,
            scaleFactor: _scaleFactor,
            height: _height,
          ),
        ),
      ),
    );
  }
}

class SliderAniContent extends StatelessWidget {
  final PageController pageController;
  final double currentPageValue;
  final double scaleFactor;
  final double height;

  const SliderAniContent({
    Key? key,
    required this.pageController,
    required this.currentPageValue,
    required this.scaleFactor,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 60.0, left: 10.0),
              child: Text(
                "Slider Amimation",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            height: double.infinity,
            child: PageView.builder(
              itemCount: 5,
              controller: pageController,
              itemBuilder: (context, position) {
                return _builderItem(position);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _builderItem(int index) {
    Matrix4 matrix4 = Matrix4.identity();
    if (index == currentPageValue.floor()) {
      var currScale = 1 - (currentPageValue - index) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currentPageValue.floor() + 1) {
      var currScale =
          scaleFactor + (currentPageValue - index + 1) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currentPageValue.floor() - 1) {
      var currScale = 1 - (currentPageValue - index) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, height * (1 - scaleFactor) / 2, 0);
    }
    return Transform(
      transform: matrix4,
      child: Container(
        width: 200,
        margin: EdgeInsets.only(
            left: 10, right: 10),
        // This margin use for space between two slider.
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: index.isEven ? const Color(0xFF69c5df) : Colors.blue,
            image: DecorationImage(
              image: NetworkImage("https://unsplash.com/photos/pancakes-with-strawberries-and-blueberries-on-top-yxZSAjyToP4"),
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
