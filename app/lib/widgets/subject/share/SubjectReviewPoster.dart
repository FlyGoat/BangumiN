import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:munin/models/bangumi/collection/CollectionStatus.dart';
import 'package:munin/models/bangumi/subject/BangumiSubject.dart';
import 'package:munin/models/bangumi/subject/comment/SubjectReview.dart';
import 'package:munin/models/bangumi/subject/common/SubjectType.dart';
import 'package:munin/shared/utils/time/TimeUtils.dart';
import 'package:munin/styles/theme/common.dart';
import 'package:munin/widgets/shared/avatar/CachedCircleAvatar.dart';
import 'package:munin/widgets/shared/common/SubjectStars.dart';
import 'package:munin/widgets/shared/text/WrappableText.dart';
import 'package:munin/widgets/subject/MainPage/SubjectCoverAndBasicInfo.dart';

class SubjectReviewPoster extends StatefulWidget {
  /// Lightness ratio of topColor/BottomColor for the background
  /// Lightness of top color is calculated based on bottom color
  /// This value might not be observed if top lightness is higher than 1
  /// Or bottom color lightness is higher than [maxThemeColorLightness]
  /// See [SubjectReviewPosterState._calculateGradientColors]
  static const topBottomColorLightnessRatio = 1.5;
  static const maxThemeColorLightness = 0.9;

  static const commentMaxLines = 20;

  /// Padding between color background and inner content
  static const double posterOuterVerticalPadding = 24;
  static const double posterOuterHorizontalPadding =
      defaultDensePortraitHorizontalPadding;

  final BangumiSubject subject;
  final Color themeColor;
  final SubjectReview review;

  const SubjectReviewPoster(
      {Key key,
      @required this.subject,
      @required this.themeColor,
      @required this.review})
      : super(key: key);

  @override
  SubjectReviewPosterState createState() => SubjectReviewPosterState();
}

class SubjectReviewPosterState extends State<SubjectReviewPoster> {
  GlobalKey _globalKey = new GlobalKey();

  Future<Uint8List> capturePng() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(
        pixelRatio: MediaQuery.of(context).devicePixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  /// Generates a list of background gradient color, from top to bottom
  /// Currently this list contains two colors, top color, bottom color
  /// Bottom color is [widget.themeColor]
  /// Top color is calculated as:
  /// 1. If bottom color lightness is higher than [SubjectReviewPoster.maxThemeColorLightness]
  /// two bottom color will be returned
  /// 2. If top color lightness is higher than [SubjectReviewPoster.maxThemeColorLightness]
  /// bottom color with [SubjectReviewPoster.maxThemeColorLightness] will be used as top color
  /// 3. Otherwise, [bottomHslColor.lightness *  SubjectReviewPoster.topBottomColorLightnessRatio]
  /// for bottom color will be used as top color
  List<Color> _calculateGradientColors() {
    Color bottomColor = widget.themeColor;
    HSLColor bottomHslColor = HSLColor.fromColor(bottomColor);
    if (bottomHslColor.lightness >=
        SubjectReviewPoster.maxThemeColorLightness) {
      return [bottomColor, bottomColor];
    }

    double maxLightness = SubjectReviewPoster.maxThemeColorLightness;
    double calculatedTopLightness = bottomHslColor.lightness *
        SubjectReviewPoster.topBottomColorLightnessRatio;
    Color topColor = bottomHslColor
        .withLightness(min(maxLightness, calculatedTopLightness))
        .toColor();

    return [topColor, bottomColor];
  }

  /// Generate user action on poster based on the following rows
  /// 1. If score is invalid
  ///   1.1 If CollectionStatus is something we are not sure how to handle, just
  ///   returns empty string
  ///   1.2 If CollectionStatus is predictable, returns something like '想看'
  ///
  /// 2. If score is valid
  ///   1.1 If CollectionStatus is something we are not sure how to handle, returns
  ///   something like '对这部动画评分'
  ///   1.2 If CollectionStatus is predictable, return something like '想看'
  String _getUserActionNameOnPoster(
      SubjectType subjectType, CollectionStatus status, double score) {
    bool isUndecidableStatus = status == null ||
        status == CollectionStatus.Untouched ||
        status == CollectionStatus.Unknown;
    bool isInvalidScore = score == null || score <= 0.0 || score > 10.0;

    if (isInvalidScore) {
      if (isUndecidableStatus) {
        return '';
      }

      return '${CollectionStatus.chineseNameWithSubjectType(status, subjectType)}这${subjectType.quantifiedChineseNameByType}';
    }

    if (isUndecidableStatus) {
      return '对这${subjectType.quantifiedChineseNameByType}评分';
    }

    return '${CollectionStatus.chineseNameWithSubjectType(status, subjectType)}这${subjectType.quantifiedChineseNameByType}';
  }

  @override
  Widget build(BuildContext context) {
    TextStyle captionStyle = Theme.of(context).textTheme.caption;
    return RepaintBoundary(
        key: _globalKey,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: SubjectReviewPoster.posterOuterVerticalPadding,
              horizontal: SubjectReviewPoster.posterOuterHorizontalPadding),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _calculateGradientColors(),
          )),
          child: Center(
            child: FractionallySizedBox(
              child: Container(
                // This ensures that the Card's children are clipped correctly.
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SubjectCoverAndBasicInfo(
                        subject: widget.subject,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CachedCircleAvatar(
                                imageUrl:
                                    widget.review.metaInfo.userAvatars.medium,
                                radius: 15,
                                navigateToUserRouteOnTap: false,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3),
                              ),
                              WrappableText(
                                widget.review.metaInfo.nickName,
                                fit: FlexFit.tight,
                              ),
                              Text(
                                TimeUtils.formatMilliSecondsEpochTime(
                                    widget.review.metaInfo.updatedAt,
                                    displayTimeIn: DisplayTimeIn.AlwaysAbsolute,
                                    formatAbsoluteTimeAs:
                                        AbsoluteTimeFormat.DateOnly),
                                style: captionStyle,
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              WrappableText(
                                widget.review.content ?? '',
                                maxLines: SubjectReviewPoster.commentMaxLines,
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                _getUserActionNameOnPoster(
                                    widget.subject.type,
                                    widget.review.metaInfo.collectionStatus,
                                    widget.review.metaInfo.score),
                                style: captionStyle,
                              ),
                              SubjectStars(
                                  subjectScore: widget.review.metaInfo.score,
                                  starSize: captionStyle.fontSize)
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'By BangumiN',
                            style: captionStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
