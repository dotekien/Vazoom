//
//  AccountService.h
//  Vazoom
//
//  Created by Kien Do on 7/12/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFUser;
@class Vehicle;
@class Reservation;

typedef void(^CompletionBlock)(NSError *error);

@interface AccountService : NSObject
@property (strong, nonatomic, readonly) NSMutableArray * vehicles;
@property (strong, nonatomic, readonly) NSMutableArray * reservations;

+(AccountService*)service;

-(void)loginWithUserName:(NSString *)userName password:(NSString *)password completionBlock:(CompletionBlock)compBlock;
-(void)initService;
-(BOOL)isRegisteredVehicleListEmpty;
-(void)addVehicle:(Vehicle *)vehicle;
-(void)addReservation:(Reservation *)reservation;
@end
