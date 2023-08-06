import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/home_screen.dart';
import 'package:car_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString('token');

  runApp(AppEntryPoint(token: token));
}

class AppEntryPoint extends StatelessWidget {
  final String? token;
  const AppEntryPoint({super.key,required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ThemeHelper.secondaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: ThemeHelper.secondaryColor,
        )
      ),

      home: SplashScreen(token: token),
    );
  }
}


class MaryamAdnanaComponent extends StatelessWidget {
  const MaryamAdnanaComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CustomScrollView(
          controller: ScrollController(), // Add a ScrollController here
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _CustomFlexibleSpaceBarBackground(),
              ),
              title: Text('AppBar Title',style: TextStyle(
                color: Colors.black
              ),),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(
                  title: Text('Item $index'),
                ),
                childCount: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomFlexibleSpaceBarBackground extends StatefulWidget {
  @override
  _CustomFlexibleSpaceBarBackgroundState createState() =>
      _CustomFlexibleSpaceBarBackgroundState();
}

class _CustomFlexibleSpaceBarBackgroundState
    extends State<_CustomFlexibleSpaceBarBackground> {
  late ScrollController _scrollController;
  double appBarHeight = 200;
  final double opacityThreshold = 100;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    setState(() {
      appBarHeight = _scrollController.hasClients
          ? _scrollController.offset + 200 // Add the expandedHeight to the offset to get the current height
          : 200; // Default expandedHeight
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the opacity based on the appBarHeight
    double opacity = 1.0;
    if (appBarHeight <= opacityThreshold) {
      opacity = appBarHeight / opacityThreshold;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://dq1eylutsoz4u.cloudfront.net/2016/12/07190305/not-so-nice-nice-guy.jpg',
          fit: BoxFit.cover,
        ),
        Container(
          height: double.infinity,
          color: Colors.black.withOpacity(1 - opacity),
        ),
      ],
    );
  }
}