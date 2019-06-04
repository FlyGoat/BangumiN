import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:munin/models/bangumi/BangumiCookieCredentials.dart';
import 'package:munin/models/bangumi/BangumiUserAvatar.dart';
import 'package:munin/models/bangumi/BangumiUserIdentity.dart';
import 'package:munin/models/bangumi/BangumiUserSmall.dart';
import 'package:munin/models/bangumi/collection/CollectionStatus.dart';
import 'package:munin/models/bangumi/collection/CollectionStatusFromBangumi.dart';
import 'package:munin/models/bangumi/collection/SubjectCollectionInfo.dart';
import 'package:munin/models/bangumi/common/BangumiImage.dart';
import 'package:munin/models/bangumi/common/BangumiUserBasic.dart';
import 'package:munin/models/bangumi/discussion/DiscussionItem.dart';
import 'package:munin/models/bangumi/discussion/GeneralDiscussionItem.dart';
import 'package:munin/models/bangumi/discussion/GetDiscussionRequest.dart';
import 'package:munin/models/bangumi/discussion/GetDiscussionResponse.dart';
import 'package:munin/models/bangumi/discussion/GroupDiscussionPost.dart';
import 'package:munin/models/bangumi/discussion/enums/DiscussionType.dart';
import 'package:munin/models/bangumi/discussion/enums/RakuenFilter.dart';
import 'package:munin/models/bangumi/discussion/enums/base.dart';
import 'package:munin/models/bangumi/discussion/thread/blog/BlogContent.dart';
import 'package:munin/models/bangumi/discussion/thread/blog/BlogThread.dart';
import 'package:munin/models/bangumi/discussion/thread/common/GetThreadRequest.dart';
import 'package:munin/models/bangumi/discussion/thread/common/OriginalPost.dart';
import 'package:munin/models/bangumi/discussion/thread/common/ThreadParentSubject.dart';
import 'package:munin/models/bangumi/discussion/thread/common/ThreadType.dart';
import 'package:munin/models/bangumi/discussion/thread/episode/EpisodeThread.dart';
import 'package:munin/models/bangumi/discussion/thread/episode/ThreadRelatedEpisode.dart';
import 'package:munin/models/bangumi/discussion/thread/group/GroupThread.dart';
import 'package:munin/models/bangumi/discussion/thread/post/MainPostReply.dart';
import 'package:munin/models/bangumi/discussion/thread/post/SubPostReply.dart';
import 'package:munin/models/bangumi/discussion/thread/subject/SubjectTopicThread.dart';
import 'package:munin/models/bangumi/mono/Actor.dart';
import 'package:munin/models/bangumi/mono/Character.dart';
import 'package:munin/models/bangumi/progress/api/EpisodeProgress.dart';
import 'package:munin/models/bangumi/progress/api/InProgressAnimeOrRealCollection.dart';
import 'package:munin/models/bangumi/progress/api/InProgressBookCollection.dart';
import 'package:munin/models/bangumi/progress/common/AirStatus.dart';
import 'package:munin/models/bangumi/progress/common/EpisodeStatus.dart';
import 'package:munin/models/bangumi/progress/common/EpisodeType.dart';
import 'package:munin/models/bangumi/progress/common/GetProgressRequest.dart';
import 'package:munin/models/bangumi/progress/common/InProgressCollection.dart';
import 'package:munin/models/bangumi/progress/common/InProgressSubjectInfo.dart';
import 'package:munin/models/bangumi/search/SearchRequest.dart';
import 'package:munin/models/bangumi/search/SearchType.dart';
import 'package:munin/models/bangumi/search/result/BangumiGeneralSearchResponse.dart';
import 'package:munin/models/bangumi/search/result/BangumiSearchResponse.dart';
import 'package:munin/models/bangumi/search/result/MonoSearchResult.dart';
import 'package:munin/models/bangumi/search/result/SearchResult.dart';
import 'package:munin/models/bangumi/search/result/SubjectSearchResult.dart';
import 'package:munin/models/bangumi/search/result/UserSearchResult.dart';
import 'package:munin/models/bangumi/setting/general/GeneralSetting.dart';
import 'package:munin/models/bangumi/setting/general/PreferredLaunchNavTab.dart';
import 'package:munin/models/bangumi/setting/general/PreferredSubjectInfoLanguage.dart';
import 'package:munin/models/bangumi/setting/mute/MuteSetting.dart';
import 'package:munin/models/bangumi/setting/mute/MutedGroup.dart';
import 'package:munin/models/bangumi/setting/mute/MutedUser.dart';
import 'package:munin/models/bangumi/setting/theme/MuninTheme.dart';
import 'package:munin/models/bangumi/setting/theme/ThemeSetting.dart';
import 'package:munin/models/bangumi/setting/theme/ThemeSwitchMode.dart';
import 'package:munin/models/bangumi/subject/BangumiSubject.dart';
import 'package:munin/models/bangumi/subject/Count.dart';
import 'package:munin/models/bangumi/subject/InfoBox/InfoBoxItem.dart';
import 'package:munin/models/bangumi/subject/InfoBox/InfoBoxRow.dart';
import 'package:munin/models/bangumi/subject/Rating.dart';
import 'package:munin/models/bangumi/subject/RelatedSubject.dart';
import 'package:munin/models/bangumi/subject/SubjectCollectionInfoPreview.dart';
import 'package:munin/models/bangumi/subject/comment/ReviewMetaInfo.dart';
import 'package:munin/models/bangumi/subject/comment/SubjectReview.dart';
import 'package:munin/models/bangumi/subject/common/SubjectType.dart';
import 'package:munin/models/bangumi/timeline/BlogCreationSingle.dart';
import 'package:munin/models/bangumi/timeline/CollectionUpdateSingle.dart';
import 'package:munin/models/bangumi/timeline/FriendshipCreationSingle.dart';
import 'package:munin/models/bangumi/timeline/GroupJoinSingle.dart';
import 'package:munin/models/bangumi/timeline/IndexFavoriteSingle.dart';
import 'package:munin/models/bangumi/timeline/MonoFavoriteSingle.dart';
import 'package:munin/models/bangumi/timeline/ProgressUpdateEpisodeSingle.dart';
import 'package:munin/models/bangumi/timeline/ProgressUpdateEpisodeUntil.dart';
import 'package:munin/models/bangumi/timeline/PublicMessageNoReply.dart';
import 'package:munin/models/bangumi/timeline/PublicMessageNormal.dart';
import 'package:munin/models/bangumi/timeline/StatusUpdateMultiple.dart';
import 'package:munin/models/bangumi/timeline/UnknownTimelineActivity.dart';
import 'package:munin/models/bangumi/timeline/WikiCreationSingle.dart';
import 'package:munin/models/bangumi/timeline/common/BangumiContent.dart';
import 'package:munin/models/bangumi/timeline/common/FeedMetaInfo.dart';
import 'package:munin/models/bangumi/timeline/common/GetTimelineRequest.dart';
import 'package:munin/models/bangumi/timeline/common/HyperBangumiItem.dart';
import 'package:munin/models/bangumi/timeline/common/HyperImage.dart';
import 'package:munin/models/bangumi/timeline/common/Mono.dart';
import 'package:munin/models/bangumi/timeline/common/TimelineCategoryFilter.dart';
import 'package:munin/models/bangumi/timeline/common/TimelineFeed.dart';
import 'package:munin/models/bangumi/timeline/common/TimelineSource.dart';
import 'package:munin/models/bangumi/user/Relationship.dart';
import 'package:munin/models/bangumi/user/UserProfile.dart';
import 'package:munin/models/bangumi/user/collection/CollectionPreview.dart';
import 'package:munin/models/bangumi/user/collection/SubjectPreview.dart';
import 'package:munin/models/bangumi/user/social/NetworkServiceTag.dart';
import 'package:munin/models/bangumi/user/social/NetworkServiceTagLink.dart';
import 'package:munin/models/bangumi/user/social/NetworkServiceTagPlainText.dart';
import 'package:munin/models/bangumi/user/social/NetworkServiceType.dart';
import 'package:munin/models/bangumi/user/timeline/TimelinePreview.dart';
import 'package:munin/redux/app/AppState.dart';
import 'package:munin/redux/app/BasicAppState.dart';
import 'package:munin/redux/discussion/DiscussionState.dart';
import 'package:munin/redux/oauth/OauthState.dart';
import 'package:munin/redux/progress/ProgressState.dart';
import 'package:munin/redux/search/SearchState.dart';
import 'package:munin/redux/setting/SettingState.dart';
import 'package:munin/redux/shared/LoadingStatus.dart';
import 'package:munin/redux/subject/SubjectState.dart';
import 'package:munin/redux/timeline/FeedChunks.dart';
import 'package:munin/redux/timeline/TimelineState.dart';
import 'package:munin/redux/user/UserState.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  /// Top level state
  AppState,

  /// If [AppState] is serialized, it's recommended to serialize [BasicAppState], too
  BasicAppState,

  /// Oauth
  OauthState,

  /// Common
  BangumiContent,
  BangumiUserBasic,

  /// Timeline
  TimelineState,
  GetTimelineRequest,
  TimelineCategoryFilter,
  TimelineSource,
  BangumiUserSmall,
  BangumiUserAvatar,
  BangumiUserIdentity,
  BangumiCookieCredentials,
  BlogCreationSingle,
  CollectionUpdateSingle,
  FriendshipCreationSingle,
  GroupJoinSingle,
  IndexFavoriteSingle,
  MonoFavoriteSingle,
  ProgressUpdateEpisodeSingle,
  ProgressUpdateEpisodeUntil,
  PublicMessageNoReply,
  PublicMessageNormal,
  StatusUpdateMultiple,
  UnknownTimelineActivity,
  WikiCreationSingle,
  HyperBangumiItem,
  HyperImage,
  FeedMetaInfo,
  FeedChunks,

  /// Subject
  LoadingStatus,
  BangumiSubject,
  SubjectType,
  Count,
  Rating,
  BangumiImage,
  Character,
  Mono,
  RelatedSubject,
  SubjectReview,
  ReviewMetaInfo,
  Actor,
  InfoBoxRow,
  InfoBoxItem,
  SubjectCollectionInfoPreview,
  SubjectCollectionInfo,
  CollectionStatusFromBangumi,
  CollectionStatus,
  SubjectState,

  /// Search
  BangumiSearchResponse,
  BangumiGeneralSearchResponse,
  SearchResult,
  MonoSearchResult,
  SubjectSearchResult,
  UserSearchResult,
  SearchRequest,
  SearchType,
  SearchState,

  /// Discussion
  GeneralDiscussionItem,
  GroupDiscussionPost,
  DiscussionType,
  DiscussionFilter,
  RakuenTopicFilter,
  GetDiscussionRequest,
  GetDiscussionResponse,
  DiscussionState,
  EpisodeThread,
  ThreadRelatedEpisode,
  ThreadParentSubject,
  SubjectTopicThread,
  BlogThread,
  BlogContent,
  GroupThread,
  OriginalPost,
  MainPostReply,
  SubPostReply,
  ThreadType,
  GetThreadRequest,

  /// User
  UserProfile,
  NetworkServiceTag,
  NetworkServiceTagLink,
  NetworkServiceTagPlainText,
  NetworkServiceType,
  SubjectPreview,
  CollectionPreview,
  TimelinePreview,
  Relationship,
  UserState,

  /// Progress
  ProgressState,
  InProgressCollection,
  EpisodeProgress,
  InProgressAnimeOrRealCollection,
  InProgressBookCollection,
  InProgressCollection,
  InProgressSubjectInfo,
  EpisodeStatus,
  EpisodeType,
  AirStatus,
  GetProgressRequest,

  /// Settings
  SettingState,
  ThemeSetting,
  MuninTheme,
  ThemeSwitchMode,
  MuteSetting,
  MutedUser,
  MutedGroup,
  GeneralSetting,
  PreferredLaunchNavTab,
  PreferredSubjectInfoLanguage
])
final Serializers serializers = (_$serializers.toBuilder()
  ..addBuilderFactory(FullType(BuiltList, [FullType(SubjectPreview)]),
          () => ListBuilder<SubjectPreview>())..addBuilderFactory(
      FullType(BuiltList, [FullType(InProgressCollection)]),
          () => ListBuilder<InProgressCollection>())
  ..addPlugin(StandardJsonPlugin()))
    .build();
