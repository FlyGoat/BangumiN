import 'package:munin/models/bangumi/collection/SubjectCollectionInfo.dart';
import 'package:munin/models/bangumi/subject/BangumiSubject.dart';
import 'package:munin/providers/bangumi/subject/BangumiSubjectService.dart';
import 'package:munin/redux/app/AppActions.dart';
import 'package:munin/redux/app/AppState.dart';
import 'package:munin/redux/subject/SubjectActions.dart';
import 'package:munin/shared/utils/misc/async.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

List<Epic<AppState>> createSubjectEpics(
    BangumiSubjectService bangumiSubjectService) {
  final getCollectionInfo = _createGetCollectionInfoEpic(bangumiSubjectService);
  final collectionUpdateRequest =
  _createCollectionUpdateRequestEpic(bangumiSubjectService);
  final getSubjectEpic = _createGetSubjectEpic(bangumiSubjectService);
  final getSubjectReviewsEpic =
  _createGetSubjectReviewsEpic(bangumiSubjectService);

  return [
    getSubjectEpic,
    getCollectionInfo,
    collectionUpdateRequest,
    getSubjectReviewsEpic,
  ];
}

Stream<dynamic> _getSubject(EpicStore<AppState> store,
    BangumiSubjectService bangumiSubjectService,
    GetSubjectAction action) async* {
  try {
    BangumiSubject subject = await bangumiSubjectService.getSubjectFromHttp(
        subjectId: action.subjectId,
        mutedUsers: store.state.settingState.muteSetting.mutedUsers);

    // If the api call is successful, dispatch the results for display
    yield GetSubjectSuccessAction(subject);

    action.completer.complete();
  } catch (error, stack) {
    // If the search call fails, dispatch an error so we can show it
    print(error.toString());
    print(stack);

    action.completer.completeError(error);
  } finally {
    completeDanglingCompleter(action.completer);
  }
}

Epic<AppState> _createGetSubjectEpic(
    BangumiSubjectService bangumiSubjectService) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) {
    return Observable(actions)
        .ofType(TypeToken<GetSubjectAction>())
        .switchMap(
            (action) => _getSubject(store, bangumiSubjectService, action));
  };
}

Stream<dynamic> _getCollectionInfo(BangumiSubjectService bangumiSubjectService,
    GetCollectionInfoAction action, EpicStore<AppState> store) async* {
  try {
    List<Future> futures = [];

    futures.add(bangumiSubjectService.getCollectionInfo(action.subjectId));

    bool isSubjectAbsent =
        store.state.subjectState.subjects[[action.subjectId]] == null;
    if (isSubjectAbsent) {
      futures.add(bangumiSubjectService.getSubjectFromHttp(
          subjectId: action.subjectId,
          mutedUsers: store.state.settingState.muteSetting.mutedUsers));
    }

    List responses = await Future.wait(futures);

    BangumiSubject bangumiSubject;
    SubjectCollectionInfo subjectCollectionInfo = responses[0];

    if (isSubjectAbsent) {
      bangumiSubject = responses[1];
    }

    yield GetCollectionInfoSuccessAction(
      bangumiSubject: bangumiSubject,
      subjectId: action.subjectId,
      collectionInfo: subjectCollectionInfo,
    );

    action.completer.complete();
  } catch (error, stack) {
    // If the search call fails, dispatch an error so we can show it
    print(error.toString());
    print(stack);
    action.completer.completeError(error, stack);
  }
}

Epic<AppState> _createGetCollectionInfoEpic(
    BangumiSubjectService bangumiSubjectService) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) {
    return Observable(actions)
        .ofType(TypeToken<GetCollectionInfoAction>())
        .switchMap((action) =>
            _getCollectionInfo(bangumiSubjectService, action, store));
  };
}

Stream<dynamic> _collectionUpdateRequest(
    BangumiSubjectService bangumiSubjectService,
    UpdateCollectionRequestAction action) async* {
  try {
    final updatedCollectionInfo =
    await bangumiSubjectService.updateCollectionInfoRequest(
        action.subjectId, action.collectionUpdateRequest);

    yield UpdateCollectionRequestSuccessAction(
      subjectId: action.subjectId,
      collectionUpdateResponse: updatedCollectionInfo,
    );

    action.completer.complete();
  } catch (error, stack) {
    // If the search call fails, dispatch an error so we can show it
    print(error.toString());
    print(stack);

    action.completer.completeError(error);
  }
}

Epic<AppState> _createCollectionUpdateRequestEpic(
    BangumiSubjectService bangumiSubjectService) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) {
    return Observable(actions)
        .ofType(TypeToken<UpdateCollectionRequestAction>())
        .switchMap((action) =>
        _collectionUpdateRequest(bangumiSubjectService, action));
  };
}

/// Reviews
Stream<dynamic> _getSubjectReviewsEpic(EpicStore<AppState> store,
    BangumiSubjectService bangumiSubjectService,
    GetSubjectReviewAction action) async* {
  try {
    BangumiSubject subject = store
        .state.subjectState.subjects[action.getSubjectReviewRequest.subjectId];

    // Subject should always be non-null as user must access subject widget first
    // then review widget, if this is not true, throws an exception in dev
    // environment.
    assert(subject != null);
    if (subject == null) {
      yield GetSubjectAction(
          subjectId: action.getSubjectReviewRequest.subjectId);
    }


    final reviewResponse = store
        .state
        .subjectState
        .subjectsReviews[action.getSubjectReviewRequest];

    if (reviewResponse != null && !reviewResponse.canLoadMoreItems) {
      action.completer.complete();
      return;
    }

    int requestedUntilPageNumber = reviewResponse
        ?.requestedUntilPageNumber ??
        0;

    final parsedSubjectReviews = await bangumiSubjectService.getsSubjectReviews(
      pageNumber: requestedUntilPageNumber + 1,
      request: action.getSubjectReviewRequest,
      mutedUsers: store.state.settingState.muteSetting.mutedUsers,
    );

    yield GetSubjectReviewSuccessAction(
      parsedSubjectReviews: parsedSubjectReviews,
      getSubjectReviewRequest: action.getSubjectReviewRequest,
    );
    action.completer.complete();
  } catch (error, stack) {
    // If the search call fails, dispatch an error so we can show it
    print(error.toString());
    print(stack);
    action.completer.completeError(error);
    yield HandleErrorAction(
      context: action.context,
      error: error,
      showErrorMessageSnackBar: false,
    );
  } finally {
    completeDanglingCompleter(action.completer);
  }
}

Epic<AppState> _createGetSubjectReviewsEpic(
    BangumiSubjectService bangumiSubjectService) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) {
    return Observable(actions)
        .ofType(TypeToken<GetSubjectReviewAction>())
        .switchMap((action) =>
        _getSubjectReviewsEpic(store, bangumiSubjectService, action));
  };
}
