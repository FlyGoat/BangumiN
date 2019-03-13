import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:munin/models/Bangumi/BangumiCookieCredentials.dart';
import 'package:munin/models/Bangumi/BangumiUserAvatar.dart';
import 'package:munin/models/Bangumi/BangumiUserBaic.dart';
import 'package:munin/models/Bangumi/BangumiUserIdentity.dart';
import 'package:munin/models/Bangumi/timeline/common/TimelineItem.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  BangumiUserBasic,
  BangumiUserAvatar,
  BangumiUserIdentity,
  BangumiCookieCredentials,
  TimelineItem
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
