import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ThreadType.g.dart';

class ThreadType extends EnumClass {
  /// A thread that's posted in a blog, a [Blog] can be associated
  //  with multiple subjects and appears under `讨论` of a subject.
  static const ThreadType Blog = _$Blog;

  /// A thread that's in a group.
  static const ThreadType Group = _$Group;

  /// A thread that posted under a subject, a [SubjectTopic] can be associated
  /// with only one subject and appears under `讨论版` of a subject.
  static const ThreadType SubjectTopic = _$SubjectTopic;

  /// A thread that posted under a episode. A [Episode] can only be associated
  /// wth one episode and an episode can only have one thread.
  static const ThreadType Episode = _$Episode;

  const ThreadType._(String name) : super(name);

  static BuiltSet<ThreadType> get values => _$values;

  static ThreadType valueOf(String name) => _$valueOf(name);

  static Serializer<ThreadType> get serializer => _$threadTypeSerializer;
}
