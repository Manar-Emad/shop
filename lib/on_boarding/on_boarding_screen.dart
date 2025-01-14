import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/login/login_screen.dart';
import 'package:shop/network/local/cache_helper.dart';
import 'package:shop/shared/components/components.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../shared/styles/colors.dart';

class BoardingModel {
  late final String image;
  late final String title;
  late final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/onboarding.png',
      title: 'On Boarding 1 Title',
      body: 'On Boarding 1 Title',
    ),
    BoardingModel(
      image: 'assets/images/onboarding.png',
      title: 'On Boarding 2 Title',
      body: 'On Boarding 2 Title',
    ),
    BoardingModel(
      image: 'assets/images/onboarding.png',
      title: 'On Boarding 3 Title',
      body: 'On Boarding 3 Title',
    ),
  ];

  bool islast = false;

  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if(value!){    navigateAndFinish(context, ShopLoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        actions: [
          DefaultTextButton(function:submit, text: 'SKIP'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      islast = true;
                    });
                  } else {
                    setState(() {
                      islast = false;
                    });
                  }
                },
                physics: BouncingScrollPhysics(),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardController,
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: defaultColor,
                      dotHeight: 10,
                      expansionFactor: 4,
                      dotWidth: 10,
                      spacing: 5,
                    ),
                    count: boarding.length),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if(islast){
                      submit();
                      //هنا هيتحرك ع الصفحة اللي بعدها عادي ولكن لو رجعت هيرجع تاني للصفحة بتاع البوردنج ودي مينفعش تظهر غير ف الاول فقط
                      // navigateTo(context, ShopLoginScreen());
                      // عشان اتفادي دا هستخدم دي بعمل استبدال للصفحات اني اشيل القديمة واروح للجديدة
                     // navigateAndFinish(context, ShopLoginScreen());
                    }
                    else{

                      boardController.nextPage(
                        duration: Duration(microseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn);}

                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage('${model.image}'),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Text(
            '${model.title}',
            style: TextStyle(fontSize: 24.0),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            '${model.body}',
            style: TextStyle(fontSize: 14.0),
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );
}
