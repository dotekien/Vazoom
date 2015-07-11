//
//  MapViewController.h
//  Vazoom
//
//  Created by Kien Do on 6/28/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Bolts/Bolts.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate, UISearchBarDelegate, MKMapViewDelegate>

-(void)setSelectedLocationSearch:(CLLocation*)locationSearchResult;
@end
