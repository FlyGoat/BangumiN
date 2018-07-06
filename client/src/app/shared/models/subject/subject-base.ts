import {Serializable} from '../Serializable';
import {Images} from '../common/images';

export class SubjectBase implements Serializable<SubjectBase> {
  /**
   * 条目 ID
   * example: 12
   * format: int32
   */
  id?: number;
  /**
   * 条目地址
   * example: http://bgm.tv/subject/12
   */
  url?: string;
  type?: number;
  /**
   * 条目名称
   * example: ちょびっツ
   */
  name?: string;
  /**
   * 条目中文名称
   * example: 人形电脑天使心
   */
  nameCN?: string;
  /**
   * 剧情简介
   */
  summary?: string;
  /**
   * 放送开始日期
   * example: 2002-04-02
   */
  airDate?: string;
  /**
   * 放送星期
   * example: 2
   * format: int32
   */
  airWeekday?: number;

  images?: Images;

  constructor() {
    this.id = 0;
    this.url = '';
    this.type = 0;
    this.name = '';
    this.nameCN = '';
    this.summary = '';
    this.airDate = null;
    this.airWeekday = null;
    this.images = new Images();
  }

  deserialize(input) {
    this.id = input.id || 0;
    this.url = input.url === undefined ? '' : input.url.replace(/^http:/, 'https:');
    this.type = input.type || 0;
    this.name = input.name || '';
    this.nameCN = input.name_cn || '';
    this.summary = input.summary || '';
    // bangumi will set null start date to 0000-00-00, since a normal YYYY or MM or DD will not start with 00, any dates that start with 00 should
    // be a invalid one
    this.airDate = input.air_date && !input.air_date.startsWith('00') ? input.air_date : null;
    this.airWeekday = input.air_weekday || null;
    this.images = input.images === undefined ? new Images() : new Images().deserialize(input.images);
    return this;
  }

}
