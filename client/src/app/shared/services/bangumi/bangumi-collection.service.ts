import {Injectable} from '@angular/core';
import {StorageService} from '../storage.service';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {environment} from '../../../../environments/environment';
import {map} from 'rxjs/operators';
import {Observable} from 'rxjs/Observable';
import {CollectionResponse} from '../../models/collection/collection-response';
import {CollectionRequest} from '../../models/collection/collection-request';

@Injectable()
export class BangumiCollectionService {

  constructor(private http: HttpClient,
              private storageService: StorageService) {

  }

  /**
   * get user collection status
   * only collection that's being watched will be returned per api
   */
  public getOngoingCollectionStatus(username: string, category: string) {
    return this.http.get(`${environment.BANGUMI_API_URL}/user/${username}/collection?cat=${category}&app_id=${environment.BANGUMI_APP_ID}`);
  }

  /**
   * get user collection status
   * only collection that's being watched will be returned per api
   */
  public getSubjectCollectionStatus(subjectId: string): Observable<CollectionResponse> {
    return this.http.get(`${environment.BANGUMI_API_URL}/collection/${subjectId}?app_id=${environment.BANGUMI_APP_ID}`)
      .pipe(
        map(res => {
            if (res['code'] && res['code'] !== 200) {
              return new CollectionResponse();
            } else {
              return new CollectionResponse().deserialize(res);
            }
          }
        )
      );
  }

  /**
   * create or update user collection status
   * it's a 'upsert' action per doc so :action will be fixed to update
   */
  public upsertSubjectCollectionStatus(
    subjectId: string, collectionRequest: CollectionRequest,
    action = 'update'): Observable<CollectionResponse> {
    const collectionRequestBody = new URLSearchParams();
    collectionRequestBody.set('status', collectionRequest.status);
    collectionRequestBody.set('comment', collectionRequest.comment);
    collectionRequestBody.set('tags', collectionRequest.tags);
    collectionRequestBody.set('rating', collectionRequest.rating.toString());
    collectionRequestBody.set('privacy', collectionRequest.privacy.toString());


    const headers = new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded');

    return this.http.post<CollectionResponse>
    (`${environment.BANGUMI_API_URL}/collection/${subjectId}/update?app_id=${environment.BANGUMI_APP_ID}&status=do`,
      collectionRequestBody.toString(), {headers: headers})
      .pipe(
        map(res => {
          return res;
          }
        )
      );
  }

}
