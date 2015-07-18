//
//  Reservation.h
//  Vazoom
//
//  Created by Kien Do on 7/17/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFUser;
@class Vehicle;
@class VZParking;
@class UIImage;
@class PFObject;

@interface Reservation : NSObject
@property (strong, nonatomic) NSString *resvervationId;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFObject *vehicle;
@property (strong, nonatomic) PFObject *parking;
@property (strong, nonatomic) NSDate *bookingTime;
@property (strong, nonatomic) UIImage *qrcode;

@end
