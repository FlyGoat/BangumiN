// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BangumiCookieCredentials.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BangumiCookieCredentials> _$bangumiCookieCredentialsSerializer =
    new _$BangumiCookieCredentialsSerializer();

class _$BangumiCookieCredentialsSerializer
    implements StructuredSerializer<BangumiCookieCredentials> {
  @override
  final Iterable<Type> types = const [
    BangumiCookieCredentials,
    _$BangumiCookieCredentials
  ];
  @override
  final String wireName = 'BangumiCookieCredentials';

  @override
  Iterable serialize(Serializers serializers, BangumiCookieCredentials object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'authCookie',
      serializers.serialize(object.authCookie,
          specifiedType: const FullType(String)),
      'userAgent',
      serializers.serialize(object.userAgent,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  BangumiCookieCredentials deserialize(
      Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BangumiCookieCredentialsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'authCookie':
          result.authCookie = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userAgent':
          result.userAgent = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BangumiCookieCredentials extends BangumiCookieCredentials {
  @override
  final String authCookie;
  @override
  final String userAgent;

  factory _$BangumiCookieCredentials(
          [void updates(BangumiCookieCredentialsBuilder b)]) =>
      (new BangumiCookieCredentialsBuilder()..update(updates)).build();

  _$BangumiCookieCredentials._({this.authCookie, this.userAgent}) : super._() {
    if (authCookie == null) {
      throw new BuiltValueNullFieldError(
          'BangumiCookieCredentials', 'authCookie');
    }
    if (userAgent == null) {
      throw new BuiltValueNullFieldError(
          'BangumiCookieCredentials', 'userAgent');
    }
  }

  @override
  BangumiCookieCredentials rebuild(
          void updates(BangumiCookieCredentialsBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  BangumiCookieCredentialsBuilder toBuilder() =>
      new BangumiCookieCredentialsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BangumiCookieCredentials &&
        authCookie == other.authCookie &&
        userAgent == other.userAgent;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, authCookie.hashCode), userAgent.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BangumiCookieCredentials')
          ..add('authCookie', authCookie)
          ..add('userAgent', userAgent))
        .toString();
  }
}

class BangumiCookieCredentialsBuilder
    implements
        Builder<BangumiCookieCredentials, BangumiCookieCredentialsBuilder> {
  _$BangumiCookieCredentials _$v;

  String _authCookie;

  String get authCookie => _$this._authCookie;

  set authCookie(String authCookie) => _$this._authCookie = authCookie;

  String _userAgent;

  String get userAgent => _$this._userAgent;

  set userAgent(String userAgent) => _$this._userAgent = userAgent;

  BangumiCookieCredentialsBuilder();

  BangumiCookieCredentialsBuilder get _$this {
    if (_$v != null) {
      _authCookie = _$v.authCookie;
      _userAgent = _$v.userAgent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BangumiCookieCredentials other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BangumiCookieCredentials;
  }

  @override
  void update(void updates(BangumiCookieCredentialsBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$BangumiCookieCredentials build() {
    final _$result = _$v ??
        new _$BangumiCookieCredentials._(
            authCookie: authCookie, userAgent: userAgent);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
