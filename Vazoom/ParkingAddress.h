//
//  ParkingAddress.h
//  Vazoom
//
//  Created by Kien Do on 6/27/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkingAddress : NSObject
@property (strong, nonatomic) NSString *propertyNumber;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) NSString *country;
- (id)jsonObject;
@end
