//
//  AccountService.m
//  Vazoom
//
//  Created by Kien Do on 7/12/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "AccountService.h"
#import <PFUser.h>
#import "Vehicle.h"
#import "UIImage+MDQRCode.h"
#import "Reservation.h"
#import "VZParking.h"

@interface AccountService ()
@property (strong, nonatomic) PFUser *account;
@property (strong, nonatomic) NSMutableArray * vehicles;
@property (strong, nonatomic) NSMutableArray * reservations;
@end

@implementation AccountService
+(AccountService*)service
{
    static AccountService *accountService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountService = [[self alloc] init];
    });
    return accountService;
}

-(void)initService
{
    self.vehicles = [NSMutableArray new];
    self.reservations = [NSMutableArray new];
    
}

-(void)loginWithUserName:(NSString *)userName password:(NSString *)password completionBlock:(CompletionBlock)compBlock
{
    [PFUser logInWithUsernameInBackground:userName password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            //self.account = user;
                                        } else {
                                            
                                        }
                                        compBlock(error);
                                    }];
}

-(BOOL)isRegisteredVehicleListEmpty
{
    return (self.vehicles.count==0)?YES:NO;
}

-(void)addVehicle:(Vehicle *)vehicle
{
    [self.vehicles addObject:vehicle];
    
    PFObject *vehicleObject = [PFObject objectWithClassName:@"Vehicle"];
    vehicleObject[@"licensePlate"] = vehicle.licensePlate;
    vehicleObject[@"carMake"] = vehicle.carMake;
    vehicleObject[@"nickName"] = vehicle.nickName;
    vehicleObject[@"isDefault"] = [NSNumber numberWithBool:vehicle.isDefault];
    vehicleObject[@"user"] = [PFUser currentUser];
    
    [vehicleObject saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"vehical object: %@", vehicleObject.objectId);
            vehicle.vehicleId = vehicleObject.objectId;
        } else {
            // Log details of our failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
-(void)addReservation:(Reservation *)reservation
{
    NSString *qrCodeString = [NSString stringWithFormat:@"-username: %@ \n-car: %@ \n-parking: %@ \n-time: %@ \n-price: %@",reservation.user.username, reservation.vehicle[@"licensePlate"], reservation.parking[@"parkingName"], reservation.bookingTime, reservation.parking[@"parkingPrice"]];
    NSLog(@"qr code string: %@",qrCodeString);
    
    UIImage *image = [UIImage mdQRCodeForString:qrCodeString size:320.0 fillColor:[UIColor darkGrayColor]];
    reservation.qrcode = image;
    [self.reservations insertObject:reservation atIndex:0];
}
@end
