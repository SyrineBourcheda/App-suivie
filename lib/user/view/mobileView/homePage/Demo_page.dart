import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Components/ConnectAs.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';


class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(pages: [
        OnboardingPageModel(
          
          description: 'To use our service you have to pay.',
          imageUrl: 'assets/images/money.png',
          bgColor: HexColor('#f9fcdc'),//#F8F5E6
        ),
        
        OnboardingPageModel(
          
          description: 'Get live tracking on your child\'s location throughout the day.',
          imageUrl: 'assets/images/geo.jpg',
          bgColor: HexColor('#f5f7fc'),
        ),
        OnboardingPageModel(
          
          description:'Filter web search results by categories.',
          imageUrl: 'assets/images/filtre.png',
          bgColor: HexColor('#f8fae6'),//#faf7d4
        ),
        OnboardingPageModel(
         
          description: 'Press and listen to your child\'s environment when they do not respond.',
          imageUrl: 'assets/images/vocale.jpg',
          bgColor: HexColor('#fce4d4'),
        ),
        OnboardingPageModel(
         
          description: 'Get security alerts from your child.',
          imageUrl: 'assets/images/sos.png',
          bgColor: HexColor('#fcf5f9'),//d4f8fc
        ),
      ]),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter(
      {Key? key, required this.pages, this.onSkip, this.onFinish})
      : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  // Store the currently visible page
  int _currentPage = 0;
  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                // Pageview to render each page
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    // Change current page when pageview changes
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Container(
                              
                              decoration: BoxDecoration(
                                color: HexColor('#F5F2E0'),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Color.fromARGB(255, 198, 196, 196),blurRadius: 6.0,spreadRadius: 1.0,offset: Offset(2.0,2.0, ),)],
                                image: DecorationImage(image:AssetImage(item.imageUrl),)
                              ),
                            )
                            
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(children: [
                              Padding( padding: const EdgeInsets.all(16.0),),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 280),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 8.0),
                                child: Text(item.description,
                                    textAlign: TextAlign.center,
                                    style:GoogleFonts.oleoScript
                                       (
                                      textStyle: TextStyle( 
                                       color: HexColor('#0E0E0E').withOpacity(0.9),
                                       fontSize: 20,
                                      fontWeight: FontWeight.bold
                                      )
                  )
                                     ),
                              )
                            ]))
                      ],
                    );
                  },
                ),
              ),

              // Current page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages
                    .map((item) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _currentPage == widget.pages.indexOf(item)
                              ? 30
                              : 8,
                          height: 8,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: HexColor('#ACA9A9'),
                              borderRadius: BorderRadius.circular(10.0)),
                        ))
                    .toList(),
              ),

              // Bottom buttons
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                            visualDensity: VisualDensity.comfortable,
                            foregroundColor: Colors.black.withOpacity(0.7),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConnectAs(),
                        ),
                      );
                        },
                        child: const Text("Skip")),
                    TextButton(
                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          foregroundColor: Colors.black.withOpacity(0.7),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if (_currentPage == widget.pages.length - 1) {
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConnectAs(),
                        ),
                      );
                        } else {
                          _pageController.animateToPage(_currentPage + 1,
                              curve: Curves.easeInOutCubic,
                              duration: const Duration(milliseconds: 250));
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            _currentPage == widget.pages.length - 1
                                ? "Finish"
                                : "Next",
                          ),
                          const SizedBox(width: 8),
                          Icon(_currentPage == widget.pages.length - 1
                              ? Icons.done
                              : Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  
  final String description;
  final String imageUrl;
  
  final Color bgColor;
  

  OnboardingPageModel(
      {
      required this.description,
      required this.imageUrl,
     
      this.bgColor = Colors.blue,
      });
}
