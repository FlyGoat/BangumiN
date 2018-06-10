import {Component, Input, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {MatSidenav} from '@angular/material';
import {SidenavService} from '../../shared/services/sidenav.service';
import {AuthenticationService} from '../../shared/services/auth.service';
import {filter, first, takeUntil} from 'rxjs/operators';
import {Subject} from 'rxjs/index';
import {LayoutService} from '../../shared/services/layout/layout.service';
import {DeviceWidth} from '../../shared/enums/device-width.enum';

@Component({
  selector: 'app-side-nav-content',
  templateUrl: './side-nav-content.component.html',
  styleUrls: ['./side-nav-content.component.scss']
})
export class SideNavContentComponent implements OnInit {

  private userID: string;

  @Input()
  private currentDeviceWidth: DeviceWidth;

  @ViewChild('sidenav') public sidenav: MatSidenav;

  constructor(private sidenavService: SidenavService,
              private authenticationService: AuthenticationService,
              private layoutService: LayoutService) {
    this.authenticationService.userSubject.pipe(
        filter( res => res !== null),
        first()
    ).subscribe( res => {
      this.userID = res.user_id.toString();
    });
  }

  ngOnInit() {
    this.sidenavService
      .setSidenav(this.sidenav);
  }

  get DeviceWidth() {
    return DeviceWidth;
  }

}
