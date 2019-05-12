import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:munin/main.dart';
import 'package:munin/models/bangumi/BangumiUserBaic.dart';
import 'package:munin/providers/bangumi/BangumiCookieService.dart';
import 'package:munin/providers/bangumi/BangumiOauthService.dart';
import 'package:munin/providers/bangumi/discussion/BangumiDiscussionService.dart';
import 'package:munin/providers/bangumi/progress/BangumiProgressService.dart';
import 'package:munin/providers/bangumi/search/BangumiSearchService.dart';
import 'package:munin/providers/bangumi/subject/BangumiSubjectService.dart';
import 'package:munin/providers/bangumi/timeline/BangumiTimelineService.dart';
import 'package:munin/providers/bangumi/user/BangumiUserService.dart';
import 'package:munin/redux/app/AppReducer.dart';
import 'package:munin/redux/app/AppState.dart';
import 'package:munin/redux/discussion/DiscussionEpics.dart';
import 'package:munin/redux/oauth/OauthMiddleware.dart';
import 'package:munin/redux/progress/ProgressEpics.dart';
import 'package:munin/redux/search/SearchEpics.dart';
import 'package:munin/redux/subject/SubjectMiddleware.dart';
import 'package:munin/redux/timeline/TimelineEpics.dart';
import 'package:munin/redux/user/UserEpics.dart';
import 'package:munin/shared/injector/injector.dart';
import 'package:munin/shared/utils/time/TimeUtils.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_logging/redux_logging.dart'; // ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt();

enum EnvironmentType { Development, Uat, Production }

abstract class Application {
  static Application environmentValue;
  static Router router;

  static final String bangumiOauthAuthorizationEndpoint = 'https://bgm.tv/oauth/authorize';
  static final Uri bangumiOauthTokenEndpointUri = Uri.https(
      'bgm.tv', 'oauth/access_token');
  static final String bangumiOauthTokenEndpoint = bangumiOauthTokenEndpointUri
      .toString();

  /// bgm.tv is the cdn version(behind cloud flare) of bangumi, it's the main host
  /// of bangumi(i.e. static assets under `lain.bgm.tv`, api under `api.bgm.tv`)
  final bangumiMainHost = 'bgm.tv';

  /// bangumi.tv is the non-cdn version of bangumi, it's mainly used for parsing html
  final bangumiNonCdnHost = 'bangumi.tv';
  final bangumiApiHost = 'api.bgm.tv';
  final forsetiApiHost = 'api.bangumin.tv';

  EnvironmentType environmentType;
  String bangumiOauthClientIdentifier;
  String bangumiOauthClientSecret;
  String bangumiRedirectUrl;

  Application() {
    initialize();
  }

  initialize() async {
    environmentValue = this;

    /// misc utils initialization
    TimeUtils.initializeTimeago();

    /// service locator initialization
    await injector(getIt);

    final BangumiCookieService _bangumiCookieService =
    getIt.get<BangumiCookieService>();
    final BangumiOauthService _bangumiOauthService =
    getIt.get<BangumiOauthService>();
    final BangumiUserService bangumiUserService =
    getIt.get<BangumiUserService>();
    final BangumiTimelineService _bangumiTimelineService =
    getIt.get<BangumiTimelineService>();
    final BangumiSubjectService _bangumiSubjectService =
    getIt.get<BangumiSubjectService>();
    final BangumiSearchService _bangumiSearchService =
    getIt.get<BangumiSearchService>();
    final BangumiDiscussionService _bangumiDiscussionService =
    getIt.get<BangumiDiscussionService>();
    final BangumiUserService _bangumiUserService =
    getIt.get<BangumiUserService>();
    final BangumiProgressService _bangumiProgressService =
    getIt.get<BangumiProgressService>();
    final SharedPreferences preferences = getIt.get<SharedPreferences>();
    final String serializedUserInfo =
    preferences.get('currentAuthenticatedUserBasicInfo');

    bool _isAuthenticated =
        _bangumiCookieService.readyToUse() && _bangumiOauthService.readyToUse();

    BangumiUserBasic userInfo;
    if (serializedUserInfo != null) {
      try {
        userInfo = BangumiUserBasic.fromJson(serializedUserInfo);
      } catch (e) {
        // user profile might have corrupted, re-authentication is needed
        _isAuthenticated = false;
      }
    }

    /// redux initialization
    Epic<AppState> epics = combineEpics<AppState>(
        []..addAll(createSubjectEpics(_bangumiSubjectService))..addAll(
            createSearchEpics(_bangumiSearchService))..addAll(
            createDiscussionEpics(_bangumiDiscussionService))..addAll(
            createTimelineEpics(_bangumiTimelineService))..addAll(
            createUserEpics(_bangumiUserService))..addAll(
            createProgressEpics(_bangumiProgressService)));
    final store = new Store<AppState>(appReducer, initialState: AppState((b) {
      if (userInfo != null) {
        b.currentAuthenticatedUserBasicInfo.replace(userInfo);
      }
      return b..isAuthenticated = _isAuthenticated;
    }),
        middleware: [
//          LoggingMiddleware.printer(),
          EpicMiddleware<AppState>(epics),
        ]
          ..addAll(createOauthMiddleware(_bangumiOauthService,
              _bangumiCookieService, bangumiUserService, preferences)));

    /// flutter initialization
    runApp(MuninApp(this, store));
  }

  String get name => runtimeType.toString();
}
