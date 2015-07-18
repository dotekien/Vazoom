//
//  Vehicles.h
//  Vazoom
//
//  Created by Kien Do on 7/14/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFUser;

@interface Vehicle : NSObject
@property (strong, nonatomic) NSString *vehicleId;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSString *licensePlate;
@property (strong, nonatomic) NSString *carMake;
@property (strong, nonatomic) NSString *nickName;

@property BOOL isDefault;

@end
