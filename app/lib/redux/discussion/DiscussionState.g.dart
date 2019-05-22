// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DiscussionState.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DiscussionState> _$discussionStateSerializer =
    new _$DiscussionStateSerializer();

class _$DiscussionStateSerializer
    implements StructuredSerializer<DiscussionState> {
  @override
  final Iterable<Type> types = const [DiscussionState, _$DiscussionState];
  @override
  final String wireName = 'DiscussionState';

  @override
  Iterable serialize(Serializers serializers, DiscussionState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'results',
      serializers.serialize(object.results,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(GetDiscussionRequest),
            const FullType(GetDiscussionResponse)
          ])),
    ];
    if (object.getDiscussionRequestStatus != null) {
      result
        ..add('getDiscussionRequestStatus')
        ..add(serializers.serialize(object.getDiscussionRequestStatus,
            specifiedType: const FullType(BuiltMap, const [
              const FullType(GetDiscussionRequest),
              const FullType(LoadingStatus)
            ])));
    }

    return result;
  }

  @override
  DiscussionState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DiscussionStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'results':
          result.results.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(GetDiscussionRequest),
                const FullType(GetDiscussionResponse)
              ])) as BuiltMap);
          break;
        case 'getDiscussionRequestStatus':
          result.getDiscussionRequestStatus.replace(serializers.deserialize(
              value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(GetDiscussionRequest),
                const FullType(LoadingStatus)
              ])) as BuiltMap);
          break;
      }
    }

    return result.build();
  }
}

class _$DiscussionState extends DiscussionState {
  @override
  final BuiltMap<GetDiscussionRequest, GetDiscussionResponse> results;
  @override
  final BuiltMap<GetDiscussionRequest, LoadingStatus>
      getDiscussionRequestStatus;

  factory _$DiscussionState([void Function(DiscussionStateBuilder) updates]) =>
      (new DiscussionStateBuilder()..update(updates)).build();

  _$DiscussionState._({this.results, this.getDiscussionRequestStatus})
      : super._() {
    if (results == null) {
      throw new BuiltValueNullFieldError('DiscussionState', 'results');
    }
  }

  @override
  DiscussionState rebuild(void Function(DiscussionStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiscussionStateBuilder toBuilder() =>
      new DiscussionStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscussionState &&
        results == other.results &&
        getDiscussionRequestStatus == other.getDiscussionRequestStatus;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc(0, results.hashCode), getDiscussionRequestStatus.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DiscussionState')
          ..add('results', results)
          ..add('getDiscussionRequestStatus', getDiscussionRequestStatus))
        .toString();
  }
}

class DiscussionStateBuilder
    implements Builder<DiscussionState, DiscussionStateBuilder> {
  _$DiscussionState _$v;

  MapBuilder<GetDiscussionRequest, GetDiscussionResponse> _results;
  MapBuilder<GetDiscussionRequest, GetDiscussionResponse> get results =>
      _$this._results ??=
          new MapBuilder<GetDiscussionRequest, GetDiscussionResponse>();
  set results(
          MapBuilder<GetDiscussionRequest, GetDiscussionResponse> results) =>
      _$this._results = results;

  MapBuilder<GetDiscussionRequest, LoadingStatus> _getDiscussionRequestStatus;
  MapBuilder<GetDiscussionRequest, LoadingStatus>
      get getDiscussionRequestStatus => _$this._getDiscussionRequestStatus ??=
          new MapBuilder<GetDiscussionRequest, LoadingStatus>();
  set getDiscussionRequestStatus(
          MapBuilder<GetDiscussionRequest, LoadingStatus>
              getDiscussionRequestStatus) =>
      _$this._getDiscussionRequestStatus = getDiscussionRequestStatus;

  DiscussionStateBuilder();

  DiscussionStateBuilder get _$this {
    if (_$v != null) {
      _results = _$v.results?.toBuilder();
      _getDiscussionRequestStatus = _$v.getDiscussionRequestStatus?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiscussionState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DiscussionState;
  }

  @override
  void update(void Function(DiscussionStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DiscussionState build() {
    _$DiscussionState _$result;
    try {
      _$result = _$v ??
          new _$DiscussionState._(
              results: results.build(),
              getDiscussionRequestStatus: _getDiscussionRequestStatus?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'results';
        results.build();
        _$failedField = 'getDiscussionRequestStatus';
        _getDiscussionRequestStatus?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'DiscussionState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
