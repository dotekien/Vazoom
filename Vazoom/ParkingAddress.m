//
//  ParkingAddress.m
//  Vazoom
//
//  Created by Kien Do on 6/27/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "ParkingAddress.h"

@implementation ParkingAddress

- (id)jsonObject
{
    return @{@"propertyNumber": self.propertyNumber,
             @"street": self.street,
             @"city": self.city,
             @"state":  self.state,
             @"zipcode": self.zipcode,
             @"country": self.country};
}
@end
