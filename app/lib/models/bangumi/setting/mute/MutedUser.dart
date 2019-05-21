import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:munin/models/bangumi/BangumiUserBaic.dart';
import 'package:munin/models/bangumi/common/Images.dart';
import 'package:munin/shared/utils/serializers.dart';

part 'MutedUser.g.dart';

abstract class MutedUser implements Built<MutedUser, MutedUserBuilder> {
  MutedUser._();

  String get username;

  @nullable
  int get userId;

  String get nickname;

  /// Currently not in use and not properly populated
  @nullable
  Images get userAvatar;

  bool get isImportedFromBangumi;

  factory MutedUser([updates(MutedUserBuilder b)]) =>
      _$MutedUser((b) => b..update(updates));

  factory MutedUser.fromBangumiUserBasic(BangumiUserBasic bangumiUserBasic) {
    return MutedUser((b) => b
      ..username = bangumiUserBasic.username
      ..userId = bangumiUserBasic.id
      ..nickname = bangumiUserBasic.nickname
      ..isImportedFromBangumi = false
      ..userAvatar
          .replace(Images.fromBangumiUserAvatar(bangumiUserBasic.avatar)));
  }

  String toJson() {
    return json.encode(serializers.serializeWith(MutedUser.serializer, this));
  }

  static MutedUser fromJson(String jsonString) {
    return serializers.deserializeWith(
        MutedUser.serializer, json.decode(jsonString));
  }

  static Serializer<MutedUser> get serializer => _$mutedUserSerializer;
}
