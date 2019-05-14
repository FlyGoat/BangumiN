import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:munin/redux/app/AppState.dart';
import 'package:munin/widgets/Progress/Progress.dart';
import 'package:munin/widgets/Timeline/Timeline.dart';
import 'package:munin/widgets/UserProfile/UserHome.dart';
import 'package:munin/widgets/UserProfile/UserProfileWidget.dart';
import 'package:munin/widgets/discussion/DiscussionHome.dart';
import 'package:munin/widgets/search/home/SearchHomeDelegate.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class MuninHomePage extends StatefulWidget {
  @override
  _MuninHomePageState createState() => _MuninHomePageState();
}

class _MuninHomePageState extends State<MuninHomePage> {
  MuninTimeline muninTimeline;
  MuninSubjectProgress muninSubjectProgress;
  UserProfileWidget muninUserProfile;
  DiscussionHome discussionHome;
  SearchHomeDelegate searchHomeDelegate;

  final PageController controller = PageController();
  int currentIndex = 0;

  final List<Widget> pages = [
    MuninTimeline(
      key: PageStorageKey('Page1'),
    ),
    MuninSubjectProgress(
      key: PageStorageKey('Page2'),
    ),
    DiscussionHome(
      key: PageStorageKey('Page4'),
    ),
    UserHome(
      key: PageStorageKey('Page3'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _onSelectedIndexChanged(int index) {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });
  }

  _buildBottomNavigationBar() {
    BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(OMIcons.home), title: Text('动态')),
        BottomNavigationBarItem(icon: Icon(OMIcons.done), title: Text('进度')),
        BottomNavigationBarItem(icon: Icon(OMIcons.group), title: Text('讨论')),
        BottomNavigationBarItem(icon: Icon(OMIcons.person), title: Text('主页')),
      ],
      onTap: _onSelectedIndexChanged,
    );

    /// If current theme is dark theme, change `bottomNavigationBar` color
    /// to current primary to distinguish from canvas
    if (Theme
        .of(context)
        .brightness == Brightness.dark) {
      return Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Theme
            .of(context)
            .primaryColor),
        child: bottomNavigationBar,
      );
    } else {
      return bottomNavigationBar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) {
        return _ViewModel(
          state: store.state,
        );
      },
      builder: (BuildContext context, _ViewModel vm) {
        return Scaffold(
          body: SafeArea(
            top: false,
            child: PageStorage(
              child: pages[currentIndex],
              bucket: bucket,
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }
}

class _ViewModel {
  final AppState state;

  _ViewModel({this.state});

  @override
  int get hashCode => state.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _ViewModel && state == other.state;
  }
}
