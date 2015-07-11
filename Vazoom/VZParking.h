//
//  VZParking.h
//  Vazoom
//
//  Created by Kien Do on 6/27/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFGeoPoint;
@class ParkingAddress;
@class ParkingSchedule;

@interface VZParking : NSObject
@property (strong, nonatomic) NSString *parkingName;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSNumber *slotAvailability;
@property (strong, nonatomic) NSNumber *slotCapacity;
@property (strong, nonatomic) PFGeoPoint *location;
@property (strong, nonatomic) ParkingAddress *address;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) ParkingSchedule *schedule;
@end

