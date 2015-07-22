//
//  Vehicles.m
//  Vazoom
//
//  Created by Kien Do on 7/14/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "Vehicle.h"

@implementation Vehicle
-(void)initWith:(NSString *)vehicleId user:(PFUser *)user license:(NSString *)licensePlate carMake:(NSString *)carMake nickName:(NSString *)nickName isDefault:(BOOL)isDefault
{
    _vehicleId = vehicleId;
    _user = user;
    _licensePlate = licensePlate;
    _carMake = carMake;
    _nickName = nickName;
    _isDefault = isDefault;
}
@end
