// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// This sample app shows an app with two screens.
///
/// The first route '/' is mapped to [HomeScreen], and the second route
/// '/details' is mapped to [DetailsScreen].
///
/// The buttons use context.go() to navigate to each destination. On mobile
/// devices, each destination is deep-linkable and on the web, can be navigated
/// to using the address bar.
void main() => runApp(const MyApp());

/// The route configuration.
final GoRouter _router = GoRouter(
  initialLocation: '/home1',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      branches: [
      StatefulShellBranch(
        routes: [
        GoRoute(path: '/home1',builder: (context, state) => Home1(),routes: <RouteBase>[
          GoRoute(path: ':id',builder: (context, state) => DetailsPage(id: state.pathParameters['id']),routes: <RouteBase>[
            GoRoute(path: ':subid',builder: (context, state) => DetailsPage2(id: state.pathParameters['subid']),)
          ])
        ])
      ]),
      StatefulShellBranch(
        routes: [
        GoRoute(
          path: '/home2',
          builder: (context, state) => Home2(),
          routes: [
            // GoRoute(path: 'tabs/:one',
            // builder: (context, state) => TabsViewForHome2(name: state.pathParameters['name']),
            // )
            StatefulShellRoute.indexedStack(
              branches: [
              StatefulShellBranch(
                routes: [
                GoRoute(path: 'tabs/followers',
                builder: (context, state) => TabsViewForHome2(moreData: "This is Followers tab"),
                )
              ]),
              StatefulShellBranch(
                routes: [
                GoRoute(path: 'tabs/following',
                builder: (context, state) => TabsViewForHome2(moreData: "This is Following Tab"),
                )
              ]),
            ],
            builder: (context, state, navigationShell) => FollowersFollowingDashBoard(child: navigationShell),
            )
          ]
          ),
      ]
      ),
    ],

    builder: (context, state, navigationShell) => HomeDashBoard(child: navigationShell),

    ),


  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

/// The home dashboard
class HomeDashBoard extends StatefulWidget {
  final StatefulNavigationShell? child;
   HomeDashBoard({super.key,this.child});

  @override
  State<HomeDashBoard> createState() => _HomeDashBoardState();
}

class _HomeDashBoardState extends State<HomeDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"),),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.child!.currentIndex,
        onTap: (value) {
          if(value == 0){
            widget.child?.goBranch(0,initialLocation: value ==widget.child!.currentIndex);
          }else{
                 widget.child?.goBranch(1,initialLocation: value ==widget.child!.currentIndex);

          }
        },
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.add),label: "Home1"),
        BottomNavigationBarItem(icon: Icon(Icons.dangerous_sharp),label: "Home2"),
      ]),
    );
  }
}

//HomeScreen1
class Home1 extends StatefulWidget {
  const Home1({super.key});

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 20,
      itemBuilder: (context, index) => GestureDetector(
        onTap: (){
          context.go('/home1/20');
        },
        child: ListTile(title: Text("Home1"))),);
  }
}

//Homescreen2
class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 20,
      itemBuilder: (context, index) => GestureDetector(
        onTap: ()=> context.go('/home2/tabs/followers'),
        child: ListTile(title: Text("Home2"))),);
  }
}

//Detail page
class DetailsPage extends StatefulWidget {
  final String? id;
  const DetailsPage({super.key,this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      children: [
        Text("This is detail page"),
        TextFormField(controller: TextEditingController(),),
        ElevatedButton(onPressed: (){
          context.go('/home1/20/30');
        }, child: Text("Go to deep path of details one"))
      ],
    ) );
  }
}

//Details page 2 
//Detail page
class DetailsPage2 extends StatefulWidget {
  final String? id;
  const DetailsPage2({super.key,this.id});

  @override
  State<DetailsPage2> createState() => _DetailsPage2State();
}

class _DetailsPage2State extends State<DetailsPage2> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      children: [
        Text("This is detail page2"),
        TextFormField(controller: TextEditingController(),)
      ],
    ) );
  }
}


//Second Branch Block-SubLocs
class TabsViewForHome2 extends StatefulWidget {
  final String? name;
  final String? moreData;
  const TabsViewForHome2({super.key,this.name,this.moreData});

  @override
  State<TabsViewForHome2> createState() => _TabsViewForHome2State();
}

class _TabsViewForHome2State extends State<TabsViewForHome2>  with TickerProviderStateMixin{

  TabController? tabController;
  StatefulNavigationShell? statefulNavigationShell;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    tabController?.addListener(() { 
      int index = tabController!.index;
      print(index);
      // switch (index) {
      //   case 0:
      //     statefulNavigationShell?.goBranch(0);
      //     break;
      //     case 1:
      //     statefulNavigationShell?.goBranch(1);
      //     break;
      //   default:
      // }
    });
  }

  List<Tab> tabs = <Tab>[
    const Tab(
      text: "Followers",
    ),
    const Tab(
      text: "Following",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        child: Column(
          children: [
          //   TabBar(
          //     onTap: (value) {
          //       switch (value) {
          //         case 0:
          //           statefulNavigationShell?.goBranch(0);
          //           break;
          //           case 1:
          //           statefulNavigationShell?.goBranch(1);

          //           break;
          //         default:
          //       }
          //     },
          //   unselectedLabelColor: Colors.grey,
          //   labelColor: Colors.black,
          //   isScrollable: true,
          //   controller: tabController,
          //   physics: const AlwaysScrollableScrollPhysics(),
          //   automaticIndicatorColorAdjustment: true,
          //   labelStyle: Theme.of(context).textTheme.bodySmall,
          //   indicatorSize: TabBarIndicatorSize.tab,
          //   indicatorColor: Colors.blueAccent,
          //   // indicator: CircleTabIndicator(color: colorTheme.primaryColorDark, radius: 4),
          //   tabs: tabs,
          // ),
            SizedBox(height: 5,),
            SizedBox(
              height: 150,
              child: TabBarView(children: tabs.map((e) => Text(widget.moreData!)).toList(),controller: tabController,))
          ],
        ),

      ))
    );
  }
}

class FollowersFollowingDashBoard extends StatefulWidget {
  final StatefulNavigationShell? child;
  const FollowersFollowingDashBoard({super.key,this.child});

  @override
  State<FollowersFollowingDashBoard> createState() => _FollowersFollowingDashBoardState();
}

class _FollowersFollowingDashBoardState extends State<FollowersFollowingDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(child: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            TextButton(onPressed: (){
              widget.child!.goBranch(0);
            }, child: Text("Followers")),
            TextButton(onPressed: (){
              widget.child!.goBranch(1);

            }, child: Text("Following")),
          ],
        ),
      ), preferredSize: Size.fromHeight(40)),
      body: widget.child,
    );
  }
}