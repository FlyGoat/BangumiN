import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:munin/config/application.dart';
import 'package:munin/models/bangumi/BangumiUserBaic.dart';
import 'package:munin/models/bangumi/subject/common/SubjectType.dart';
import 'package:munin/models/bangumi/user/Relationship.dart';
import 'package:munin/models/bangumi/user/UserProfile.dart';
import 'package:munin/models/bangumi/user/collection/CollectionPreview.dart';
import 'package:munin/redux/app/AppState.dart';
import 'package:munin/redux/shared/LoadingStatus.dart';
import 'package:munin/redux/user/UserActions.dart';
import 'package:munin/styles/theme/common.dart';
import 'package:munin/widgets/UserProfile/CollectionPreviewWidget.dart';
import 'package:munin/widgets/UserProfile/TimelinePreviewWidget.dart';
import 'package:munin/widgets/UserProfile/UserIntroductionPreview.dart';
import 'package:munin/widgets/shared/avatar/CachedCircleAvatar.dart';
import 'package:munin/widgets/shared/icons/AdaptiveIcons.dart';
import 'package:munin/widgets/shared/refresh/AdaptiveProgressIndicator.dart';
import 'package:munin/widgets/shared/services/Clipboard.dart';
import 'package:munin/widgets/shared/text/WrappableText.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:quiver/core.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileWidget extends StatelessWidget {
  ///  An appBar that's on top of the profile
  final Widget providedAppBar;

  final String username;

  final String userProfileMainUrl;

  /// Outer padding for all profile widgets, appBar is not included
  final EdgeInsetsGeometry profileWidgetsPadding;

  UserProfileWidget(
      {Key key,
      @required this.username,
      @required Widget appBar,
      this.profileWidgetsPadding = const EdgeInsets.symmetric(
          horizontal: defaultPortraitHorizontalPadding)})
      : this.providedAppBar = appBar,
        this.userProfileMainUrl =
            'https://${Application.environmentValue.bangumiMainHost}/user/$username',
        assert(isNotEmpty(username)),
        super(key: key);

  _buildMoreActionsMenu(BuildContext outerContext) {
    showModalBottomSheet(
        context: outerContext,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.content_copy),
                    title: Text('复制主页地址'),
                    onTap: () {
                      ClipboardService.copyAsPlainText(
                          outerContext, userProfileMainUrl,
                          popContext: true);
                    },
                  ),
                  ListTile(
                    leading: Icon(OMIcons.openInBrowser),
                    title: Text('查看网页版'),
                    onTap: () {
                      launch(userProfileMainUrl, forceSafariVC: true);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildCollectionPreviews(BuildContext context, String username,
      BuiltMap<SubjectType, CollectionPreview> previews) {
    List<Widget> widgets = [];
    previews.forEach((SubjectType subjectType, CollectionPreview preview) {
      widgets.add(CollectionPreviewWidget(
        preview: preview,
        userName: username,
      ));
    });
    return widgets;
  }

  SliverList _buildProfile(
      BuildContext context, UserProfile profile, bool isCurrentAppUser) {
    List<Widget> widgets = [];
    widgets.addAll([
      Row(
        children: <Widget>[
          CachedCircleAvatar(
            imageUrl: profile.basicInfo.avatar.large,
            radius: 30,
            navigateToUserRouteOnTap: true,
            username: profile.basicInfo.username,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (!isCurrentAppUser)
                  OutlineButton(
                    child: Row(
                      children: <Widget>[
                        Text(Relationship.relationshipText(
                            profile.relationships)),
                      ],
                    ),
                    onPressed: () {},
                  ),
                IconButton(
                  icon: Icon(AdaptiveIcons.moreActionsIconData),
                  onPressed: () {
                    _buildMoreActionsMenu(context);
                  },
                )
              ],
            ),
          )
        ],
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(profile.basicInfo.nickname),
          Text(
            '@${profile.basicInfo.username}',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      UserIntroductionPreview(
        profile: profile,
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
      ),
    ]);

    widgets.addAll(_buildCollectionPreviews(
        context, profile.basicInfo.username, profile.collectionPreviews));

    widgets.addAll([
      TimelinePreviewWidget(
        profile: profile,
      ),
      Divider(),
      InkWell(
        child: Row(
          children: <Widget>[
            WrappableText(
              '收藏的人物',
              fit: FlexFit.tight,
              textStyle: Theme.of(context).textTheme.subhead,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                AdaptiveIcons.forwardIconData,
              ),
            )
          ],
        ),
        onTap: () {
          launch('$userProfileMainUrl/mono', forceSafariVC: true);
        },
      ),
      Divider(),
      InkWell(
        child: Row(
          children: <Widget>[
            WrappableText(
              '好友',
              fit: FlexFit.tight,
              textStyle: Theme.of(context).textTheme.subhead,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                AdaptiveIcons.forwardIconData,
              ),
            )
          ],
        ),
        onTap: () {
          launch('$userProfileMainUrl/friends', forceSafariVC: true);
        },
      ),
      Divider(),
      InkWell(
        child: Row(
          children: <Widget>[
            WrappableText(
              '目录',
              fit: FlexFit.tight,
              textStyle: Theme.of(context).textTheme.subhead,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                AdaptiveIcons.forwardIconData,
              ),
            )
          ],
        ),
        onTap: () {
          launch('$userProfileMainUrl/index', forceSafariVC: true);
        },
      ),
      Divider(),
      InkWell(
        child: Row(
          children: <Widget>[
            WrappableText(
              '参加的小组',
              fit: FlexFit.tight,
              textStyle: Theme.of(context).textTheme.subhead,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                AdaptiveIcons.forwardIconData,
              ),
            )
          ],
        ),
        onTap: () {
          launch('$userProfileMainUrl/groups', forceSafariVC: true);
        },
      ),
    ]);

    return SliverList(
      delegate: SliverChildListDelegate(
        widgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) =>
          _ViewModel.fromStore(store, username),
      distinct: true,
      onInitialBuild: (_ViewModel vm) {
        vm.fetchUserProfile(context);
      },
      builder: (BuildContext context, _ViewModel vm) {
        LoadingStatus loadingStatus = vm.loadingStatus;

        Widget appBar;

        if (providedAppBar == null) {
          if (vm.userProfile != null) {
            appBar = SliverAppBar(
              pinned: true,
              title: Text('${vm.userProfile.basicInfo.nickname}的主页'),
            );
          } else {
            String appBarText =
                loadingStatus?.isException ?? false ? '加载失败' : '加载中';
            appBar = SliverAppBar(
              pinned: true,
              title: Text(appBarText),
            );
          }
        } else {
          appBar = providedAppBar;
        }

        Widget scrollSliver;

        if (vm.userProfile == null) {
          if (loadingStatus?.isException ?? false) {
            scrollSliver = SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: <Widget>[
                    Text('目前无法加载此用户资料, 可能因为应用或bangumi出错'),
                    FlatButton(
                      child: Text('点击重试'),
                      onPressed: () {
                        vm.fetchUserProfile(context);
                      },
                    ),
                    FlatButton(
                      child: Text('查看对应网页版'),
                      onPressed: () {
                        launch(
                            'https://${Application.environmentValue.bangumiMainHost}/user/$username',
                            forceSafariVC: true);
                      },
                    ),
                  ],
                ),
              ]),
            );
          } else {
            scrollSliver = SliverList(
              delegate: SliverChildListDelegate([
                Center(
                  child: AdaptiveProgressIndicator(),
                ),
              ]),
            );
          }
        } else {
          scrollSliver = SliverPadding(
            padding: profileWidgetsPadding,
            sliver: _buildProfile(context, vm.userProfile, vm.isCurrentAppUser),
          );
        }

        return CustomScrollView(
          slivers: <Widget>[appBar, scrollSliver],
        );
      },
    );
  }
}

class _ViewModel {
  /// Whether the user page belongs to current user who is using the app
  /// If set to true, user page will be rendered as 'I'm viewing my profile'
  /// Otherwise it's going to be rendered as 'I'm viewing other people's profile'
  final bool isCurrentAppUser;

  final String username;
  final UserProfile userProfile;
  final LoadingStatus loadingStatus;
  final Function(BuildContext context) fetchUserProfile;

  factory _ViewModel.fromStore(Store<AppState> store, String username) {
    Future _fetchUserProfile(BuildContext context) {
      final action =
          FetchUserPreviewRequestAction(context: context, username: username);
      store.dispatch(action);
      return action.completer.future;
    }

    bool isCurrentAppUser;
    BangumiUserBasic currentUser =
        store.state.currentAuthenticatedUserBasicInfo;

    /// If [username] is the same as current app user username
    /// Or passed-in username is the same as id of the current app user username
    /// set isCurrentAppUser to true
    /// The second username-id check is needed because id(pure digit) and username(~alphanumeric)
    /// can both be used to identify a user
    if (currentUser.username == username ||
        currentUser.id.toString() == username) {
      isCurrentAppUser = true;
    } else {
      isCurrentAppUser = false;
    }

    return _ViewModel(
      username: username,
      userProfile: store.state.userState.profiles[username],
      fetchUserProfile: (BuildContext context) => _fetchUserProfile(context),
      isCurrentAppUser: isCurrentAppUser,
      loadingStatus: store.state.userState.profilesLoadingStatus[username],
    );
  }

  _ViewModel({
    @required this.username,
    @required this.userProfile,
    @required this.fetchUserProfile,
    @required this.isCurrentAppUser,
    @required this.loadingStatus,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          isCurrentAppUser == other.isCurrentAppUser &&
          username == other.username &&
          userProfile == other.userProfile &&
          loadingStatus == other.loadingStatus;

  @override
  int get hashCode =>
      hash4(isCurrentAppUser, username, userProfile, loadingStatus);
}
