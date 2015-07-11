//
//  LocationService.m
//  Vazoom
//
//  Created by Kien Do on 7/8/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "LocationService.h"

@interface LocationService()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign) BOOL isAuthorized;
@end

@implementation LocationService
+(LocationService*)service
{
    static LocationService *locationService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationService = [[self alloc] init];
    });
    return locationService;
}

-(void)requestWhenInUseAuthorization
{
    if (!self.locationManager) {
        CLLocationManager* theManager = [[CLLocationManager alloc] init];
        self.locationManager = theManager;
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.delegate = self;
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        self.isAuthorized = YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    //NSLog(@"%@",self.currentLocation);
}
@end
