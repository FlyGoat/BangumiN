import 'dart:math' show min;

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:munin/config/application.dart';
import 'package:munin/models/bangumi/BangumiUserSmall.dart';
import 'package:munin/providers/bangumi/BangumiCookieService.dart';
import 'package:munin/providers/bangumi/BangumiOauthService.dart';
import 'package:munin/providers/bangumi/user/BangumiUserService.dart';
import 'package:munin/providers/storage/SharedPreferenceService.dart';
import 'package:munin/redux/app/AppState.dart';
import 'package:munin/redux/oauth/OauthActions.dart';
import 'package:munin/router/routes.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createOauthMiddleware(
    BangumiOauthService oauthClient,
    BangumiCookieService cookieClient,
    BangumiUserService bangumiUserService,
    SharedPreferenceService sharedPreferenceService) {
  final loginPage = _createLoginPage();

  final oauthRequest =
  _createOAuthRequest(
      oauthClient, cookieClient, bangumiUserService, sharedPreferenceService);
  final oauthCancel = _createOAuthCancel(oauthClient, cookieClient);

  final logoutRequest =
  _createLogoutRequest(oauthClient, cookieClient, sharedPreferenceService);

  return [
    TypedMiddleware<AppState, LoginPage>(loginPage),
    TypedMiddleware<AppState, LogoutRequest>(logoutRequest),
    TypedMiddleware<AppState, OAuthLoginRequest>(oauthRequest),
    TypedMiddleware<AppState, OAuthLoginCancel>(oauthCancel),
  ];
}

Middleware<AppState> _createLoginPage() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action.context != null) {
      Navigator.of(action.context).pushNamed('/login');
    }

    next(action);
  };
}

// TODO: refactor this messy middleware
Middleware<AppState> _createOAuthRequest(BangumiOauthService oauthService,
    BangumiCookieService cookieService,
    BangumiUserService bangumiUserService,
    SharedPreferenceService sharedPreferenceService,) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    assert(action.context != null);

    try {
      /// Tries to invalidate previous cookie if user has logged in
      if (cookieService.hasCookieCredential) {
        cookieService.silentlyTryLogout();
      }

      Application.router.navigateTo(
        action.context,
        Routes.bangumiOauthRoute,
        transition: TransitionType.native,
      );
      await oauthService.initializeAuthentication();
      int userId = await oauthService.verifyUser();
      BangumiUserSmall userInfo =
      await bangumiUserService.getUserBasicInfo(userId.toString());

      oauthService.client.currentUser = userInfo;

      AppState updatedAppState = store.state.rebuild((b) =>
      b
        ..isAuthenticated = true
        ..currentAuthenticatedUserBasicInfo.replace(userInfo));
      await Future.wait([
        oauthService.persistCredentials(),
        cookieService.persistCredentials(),
        sharedPreferenceService.persistAppState(updatedAppState)
      ]);
      store.dispatch(OAuthLoginSuccess(userInfo));
      Application.router.navigateTo(
          action.context,
          Routes.homeRoute,
          transition: TransitionType.native,
          clearStack: true
      );
    } catch (error, stack) {
      final maxErrorMessageMaxLength = 200;
      final errorMessage = error.toString();

      print(errorMessage);
      print(stack);
      Application.router.navigateTo(
          action.context,
          Routes.loginRoute,
          transition: TransitionType.native,
          clearStack: true
      );
      store.dispatch(OAuthLoginFailure(
          action.context,
          error.toString().substring(
              0, min(errorMessage.length, maxErrorMessageMaxLength))));
    }

    next(action);
  };
}

Middleware<AppState> _createOAuthCancel(BangumiOauthService oauthClient,
    BangumiCookieService bangumiCookieService) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    assert(action.context != null);
    await oauthClient.disposeServerAndWebview();
    next(action);
  };
}

Middleware<AppState> _createLogoutRequest(BangumiOauthService oauthClient,
    BangumiCookieService cookieService,
    SharedPreferenceService sharedPreferenceService) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    assert(action.context != null);
    cookieService.silentlyTryLogout();
    await Future.wait([
      oauthClient.clearCredentials(),
      cookieService.clearCredentials(),
      sharedPreferenceService.deleteAppState(),
    ]);
    store.dispatch(LogoutSuccess(action.context));
    Application.router.navigateTo(
        action.context,
        Routes.loginRoute,
        transition: TransitionType.native,
        clearStack: true
    );
    next(action);
  };
}
