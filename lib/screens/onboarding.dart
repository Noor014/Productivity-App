import 'package:flutter/material.dart';
import 'package:productivity_app/screens/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  final pageController = PageController();
  bool isLastPage = false;

  @override
  void dispose(){
    pageController.dispose();

    super.dispose();
  }

  Widget buildPage({required Color color,required String urlImageOrAnim, required bool isImage,
    required String title, required String subtitle}) => Container(
    color: color,
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(isImage)
            Container(
              height: MediaQuery.of(context).size.height*0.6,
                child: Image.asset(urlImageOrAnim, fit: BoxFit.cover, width: double.infinity,)),
          if(!isImage)
              Container(
                  height: MediaQuery.of(context).size.height*0.6,
                  child: Lottie.asset(urlImageOrAnim,)),
         SizedBox(height: 40,),
          Text(title,
          style: TextStyle(
            color: Colors.teal.shade800,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              subtitle,
              style: TextStyle(
              color: Colors.black,
            ),
            ),
          )
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 70),
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index==2;
            });
          },
          children: [
            buildPage(
                color: Colors.orangeAccent.shade100,
                urlImageOrAnim: 'assets/onboard_anim.json',
                isImage: false, title: 'Welcome',
                subtitle: 'cdibucfedbfvuebf'),
            buildPage(
                color: Colors.green.shade100,
                urlImageOrAnim: 'assets/onboard1.jpg',
                isImage: true, title: 'Hey! Efficiently manage your tasks',
                subtitle: 'cdibucfedbfvuebf'),
            buildPage(
                color: Colors.deepPurple.shade200,
                urlImageOrAnim: 'assets/onboard2.jpg',
                isImage: true, title: 'Work with Pomodoro',
                subtitle: 'cdibucfedbfvuebf'),

          ],
        ),
      ),
      bottomSheet: isLastPage?TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          minimumSize: Size.fromHeight(85)
        ),
          child:Text('Get Started', style: TextStyle(fontSize: 20),),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('showHome', true);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        },
      )
          :Container(
            color: Colors.grey[800],
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                    TextButton(
                      child: const Text('SKIP', style: TextStyle(color: Colors.white),),
                      onPressed: () {
                        return pageController.jumpToPage(2);
                      },
                    ),
                    Center(
                        child: SmoothPageIndicator(
                            controller: pageController, count: 3,
                          effect: WormEffect(
                            spacing: 16,

                            dotColor: Colors.grey.shade600,
                            activeDotColor: Colors.white54,
                          ),
                          onDotClicked: (index) => pageController.animateToPage(
                              index,
                              duration: Duration(milliseconds: 500) ,
                              curve:Curves.easeIn)
                        )),
                    TextButton(
                      child: const Text('NEXT', style: TextStyle(color: Colors.white),),
                      onPressed:() => pageController.nextPage(
                          duration: Duration(milliseconds: 500) ,
                          curve:Curves.easeInOut )

                    ),

              ],
            )
      ),
    );
  }
}
