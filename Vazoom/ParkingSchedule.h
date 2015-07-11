//
//  ParkingSchedule.h
//  Vazoom
//
//  Created by Kien Do on 7/10/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkingSchedule : NSObject
@property (strong, nonatomic) NSString *Mon;
@property (strong, nonatomic) NSString *Tue;
@property (strong, nonatomic) NSString *Wed;
@property (strong, nonatomic) NSString *Thu;
@property (strong, nonatomic) NSString *Fri;
@property (strong, nonatomic) NSString *Sat;
@property (strong, nonatomic) NSString *Sun;
@property (strong, nonatomic) NSArray *holidays;
@end
