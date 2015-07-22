//
//  AccountService.m
//  Vazoom
//
//  Created by Kien Do on 7/12/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "AccountService.h"
#import "PFUser.h"
#import "Vehicle.h"
#import "UIImage+MDQRCode.h"
#import "Reservation.h"
#import "VZParking.h"
#import "Payment.h"
#import "PFQuery.h"
#import "BFTask.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

@interface AccountService ()
@property (strong, nonatomic) PFUser *account;
@property (strong, nonatomic) NSMutableArray * vehicles;
@property (strong, nonatomic) NSMutableArray * reservations;
@property (strong, nonatomic) NSMutableArray * paymentMethods;
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
    self.paymentMethods = [NSMutableArray new];
    
    if ([PFUser currentUser]) {
        self.isLogIn = YES;
    }
    @weakify(self)
    [RACObserve(self, isLogIn) subscribeNext:^(id x) {
        @strongify(self)
        if (self.isLogIn) {
            [self retrieveAllVehicles];
            [self retrieveAllPaymentMethods];
            [self retrieveAllReservations];
        } else {
            //clean
            [self.vehicles removeAllObjects];
            [self.paymentMethods removeAllObjects];
            [self.reservations removeAllObjects];
        }
    }];
    
}

-(void)loginWithUserName:(NSString *)userName password:(NSString *)password completionBlock:(CompletionBlock)compBlock
{
    [PFUser logInWithUsernameInBackground:userName password:password
                                    block:^(PFUser *user, NSError *error) {
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
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

-(void)saveVehicle:(Vehicle *)vehicle
{
    PFObject *vehicleObject = [PFObject objectWithClassName:@"Vehicle"];
    vehicleObject.objectId = vehicle.vehicleId;
    vehicleObject[@"licensePlate"] = vehicle.licensePlate;
    vehicleObject[@"carMake"] = vehicle.carMake;
    vehicleObject[@"nickName"] = vehicle.nickName;
    vehicleObject[@"isDefault"] = [NSNumber numberWithBool:vehicle.isDefault];
    vehicleObject[@"user"] = [PFUser currentUser];
    
    [vehicleObject saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"vehical object %@ is saved successfully.", vehicleObject.objectId);
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}
-(void)deleleVehicle:(Vehicle *)vehicle
{
    [[AccountService service].vehicles removeObject:vehicle];
    
    PFObject *vehicleObject = [PFObject objectWithClassName:@"Vehicle"];
    vehicleObject.objectId = vehicle.vehicleId;
    vehicleObject[@"licensePlate"] = vehicle.licensePlate;
    vehicleObject[@"carMake"] = vehicle.carMake;
    vehicleObject[@"nickName"] = vehicle.nickName;
    vehicleObject[@"isDefault"] = [NSNumber numberWithBool:vehicle.isDefault];
    vehicleObject[@"user"] = [PFUser currentUser];
    
    [vehicleObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Succeeded removing vehicle %@",vehicleObject.objectId);
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

-(void)retrieveAllVehicles
{
    PFQuery *query = [PFQuery queryWithClassName:@"Vehicle"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    @weakify(self)
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        @strongify(self)
        if (!error) {
            NSLog(@"Successfully retrieved: %@", results);
            for (PFObject *object in results) {
                Vehicle *vehicle = [Vehicle new];
                [vehicle initWith:object.objectId user:[PFUser currentUser] license:object[@"licensePlate"] carMake:object[@"carMake"] nickName:object[@"nickName"] isDefault:[((NSNumber *)object[@"isDefault"]) boolValue]];
                [self.vehicles addObject:vehicle];
            }
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

- (void)updateQRCode:(Reservation *)reservation
{
    NSString *qrCodeString = [NSString stringWithFormat:@"-username: %@ \n-car: %@ \n-parking: %@ \n-time: %@ \n-price: %@",[PFUser currentUser].username, reservation.vehicle[@"licensePlate"], reservation.parking[@"parkingName"], reservation.bookingTime, reservation.parking[@"parkingPrice"]];
    
    NSLog(@"qr code string: %@",qrCodeString);
    
    UIImage *image = [UIImage mdQRCodeForString:qrCodeString size:320.0 fillColor:[UIColor darkGrayColor]];
    reservation.qrcode = image;
}

-(void)addReservation:(Reservation *)reservation
{
    [self updateQRCode:reservation];
    [self.reservations insertObject:reservation atIndex:0];
}

-(void)retrieveAllReservations
{
    PFQuery *query = [PFQuery queryWithClassName:@"Reservation"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"updatedAt"];
    [query includeKey:@"parking"];
    [query includeKey:@"vehicle"];
    @weakify(self)
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        @strongify(self)
        if (!error) {
            NSLog(@"Successfully retrieved: %@", results);
            PFObject *_reservation = results[0];
            Reservation *reservation = [Reservation new];
            reservation.user = [PFUser currentUser];
            reservation.resvervationId = _reservation.objectId;
            reservation.vehicle = _reservation[@"vehicle"];
            reservation.parking = _reservation[@"parking"];
            reservation.bookingTime = _reservation.updatedAt;
            [self addReservation:reservation];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

-(Vehicle *)searchVehicleById:(NSString *)vehicleId
{
    Vehicle *vehicle = nil;
    for (Vehicle *vec in self.vehicles) {
        if ([vec.vehicleId isEqualToString:vehicleId]) {
            vehicle = vec;
            break;
        }
    }
    return vehicle;
}

-(Payment *)searchPaymentById:(NSString *)paymentMethodId
{
    Payment *payment = nil;
    for (Payment *paymentMethod in self.paymentMethods) {
        if ([paymentMethod.paymentMethodId isEqualToString:paymentMethodId]) {
            payment = paymentMethod;
            break;
        }
    }
    return payment;
}


-(void)addPaymentMethod:(Payment *)paymentMehthod
{
    [self.paymentMethods addObject:paymentMehthod];
    PFObject *payment = [PFObject objectWithClassName:@"Payment"];
    payment[@"last4"] = paymentMehthod.last4;
    payment[@"token"] = paymentMehthod.token;
    payment[@"nickName"] = paymentMehthod.nickName;
    payment[@"user"] = [PFUser currentUser];
    [payment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"payment is saved to cloud");
            paymentMehthod.paymentMethodId = payment.objectId;
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

-(void)deletePaymentMethod:(Payment *)payment
{
    [[AccountService service].paymentMethods removeObject:payment];
    PFObject *_payment = [PFObject objectWithClassName:@"Payment"];
    _payment.objectId = payment.paymentMethodId;
    _payment[@"last4"] = payment.last4;
    _payment[@"token"] = payment.token;
    _payment[@"nickName"] = payment.nickName;
    _payment[@"user"] = [PFUser currentUser];
    
    [_payment deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Succeeded removing payment %@",_payment.objectId);
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

-(void)retrieveAllPaymentMethods
{
    PFQuery *query = [PFQuery queryWithClassName:@"Payment"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved: %@", results);
            for (PFObject *object in results) {
                Payment *payment = [Payment new];
                payment.paymentMethodId = object.objectId;
                payment.nickName = object[@"nickName"];
                payment.last4 = object[@"last4"];
                payment.token = object[@"token"];
                payment.user = [PFUser currentUser];
                [self.paymentMethods addObject:payment];
            }
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

-(BOOL)isPaymentMethodListEmpty
{
    return (self.paymentMethods.count==3)?YES:NO;
}
@end
