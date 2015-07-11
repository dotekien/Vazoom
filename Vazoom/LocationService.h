//
//  LocationService.h
//  Vazoom
//
//  Created by Kien Do on 7/8/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationService : NSObject<CLLocationManagerDelegate>
+(LocationService*)service;

@property (strong, nonatomic,readonly) CLLocation *currentLocation;
@property (assign, readonly) BOOL isAuthorized;

-(void)requestWhenInUseAuthorization;
@end
