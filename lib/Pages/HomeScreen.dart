import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, screenSize) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.maxWidth * 0.05,
              ),
              child: (userProvider.loadingStatus == LoadingStatus.COMPLETED)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: screenSize.maxHeight * 0.1,
                          child: FittedBox(
                            child: Text(
                              'Hello ${userProvider.user!.userName}, \nWhat would you like to learn today?',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: screenSize.maxHeight * 0.1,
                          child: Text(
                            'Choose a category below and boost your skills',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          height: screenSize.maxHeight * 0.8,
                          color: Colors.white,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return GridView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: 10,
                                itemBuilder: (context, index) =>
                                    CategoryTile(index: index),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      constraints.maxWidth > 700 ? 4 : 2,
                                  // childAspectRatio: 5,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : ((userProvider.loadingStatus == LoadingStatus.LOADING)
                      ? Center(
                          child: Container(
                            color: Colors.white,
                            height: 100,
                            width: 100,
                            child: LoadingIndicator(
                                indicatorType: Indicator.ballPulse,
                                colors: [Colors.red, Colors.blue, Colors.green],

                                /// Optional, The color collections
                                strokeWidth: 1,

                                /// Optional, The stroke of the line, only applicable to widget which contains line
                                backgroundColor: Colors.white,

                                /// Optional, Background of the widget
                                pathBackgroundColor: Colors.white

                                /// Optional, the stroke backgroundColor

                                ),
                          ),
                        )
                      : const Text(
                          'No data',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
            ),
          );
        },
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  int index;
  CategoryTile({required this.index});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Material(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black, width: 0.5, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.lightGreenAccent,
              ),
              alignment: Alignment.center,
              child: LayoutBuilder(
                builder: (context, size) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.maxHeight * 0.8,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                20,
                              ),
                              topRight: Radius.circular(
                                20,
                              ),
                            ),
                            color: Colors.lightGreen,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                20,
                              ),
                              topRight: Radius.circular(
                                20,
                              ),
                            ),
                            child: Image.asset(
                              'images/category_default.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: size.maxHeight * 0.2,
                        child: FittedBox(
                          child: Text(
                            'category $index',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
