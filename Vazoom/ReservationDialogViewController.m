//
//  ReservationDialogViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/6/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "ReservationDialogViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AccountService.h"
#import <Parse/PFUser.h>
#import "LoginViewController.h"
#import "AddVehicleViewController.h"
#import "Vehicle.h"
#import <Parse/PFCloud.h>
#import "VZParking.h"
#import "Reservation.h"
#import <libextobjc/EXTScope.h>

@interface ReservationDialogViewController ()
@property (weak, nonatomic) IBOutlet UIButton *parkMyCarBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *carPicker;
@property (strong, nonatomic) Vehicle *selectedCar;
@property (strong, nonatomic) VZParking *parking;
@end

@implementation ReservationDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parkMyCarBtn.layer.cornerRadius = 10;
    if (![[AccountService service] isRegisteredVehicleListEmpty]) {
        [self.carPicker selectRow:0 inComponent:0 animated:NO];
        self.selectedCar = self.carPickerData[0];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![PFUser currentUser]) {
        [self performSegueWithIdentifier:@"openLoginViewFromReservationView" sender:self];
    } else {
        if ([[AccountService service] isRegisteredVehicleListEmpty]) {
            [self performSegueWithIdentifier:@"openAddVehicleViewFromReservationView" sender:self];
        } else {
            [self.carPicker selectRow:0 inComponent:0 animated:NO];
            self.selectedCar = self.carPickerData[0];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)carPickerData
{
    return [AccountService service].vehicles;
}

-(void)setSelectedParking:(VZParking *)parking {
    self.parking = parking;
}

- (IBAction)parkMyCar:(id)sender {
    //submit the reservation with paramas{user, car, parking, time(option)}
    NSLog(@"userId: %@ - carId: %@ - parkingId: %@", [PFUser currentUser].objectId, self.selectedCar.vehicleId, self.parking.parkingId);
    
    [PFCloud callFunctionInBackground:@"makeReservation"
                       withParameters:@{@"userId": [PFUser currentUser].objectId,
                                        @"carId": self.selectedCar.vehicleId,
                                        @"parkingId": self.parking.parkingId}
                                block:^(PFObject *reservationResult, NSError *error) {
                                    if (!error) {
                                       
                                        Reservation *reservation = [Reservation new];
                                        reservation.resvervationId = reservationResult.objectId;
                                        reservation.user = reservationResult[@"user"];
                                        reservation.parking = reservationResult[@"parking"];
                                        reservation.vehicle = reservationResult[@"vehicle"];
                                        reservation.bookingTime = reservationResult.createdAt;
                                        NSLog(@"reservation Id: %@",reservation.resvervationId);
                                        dispatch_queue_t serial_q = dispatch_queue_create("serial_q_reservation", DISPATCH_QUEUE_SERIAL);
                                         @weakify(self)
                                        dispatch_async(serial_q, ^{
                                            [[AccountService service] addReservation:reservation];
                                        });
                                        dispatch_async(serial_q, ^{
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                @strongify(self)
                                                MainViewController *mainViewController = (MainViewController *)self.navigationController.viewControllers[0];
                                                [mainViewController openReservationView:self];
                                            });
                                        });
                                    } else {
                                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                        NSLog(@"Error: %@", errorString);
                                    }
                                }];
}

#pragma mark - Picker API
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.carPickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.carPickerData[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"System" size:17]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=1;
    }
    Vehicle *vehicle = [self.carPickerData objectAtIndex:row];
    NSString *vehicleLabelPicker = @"";
    if ([vehicle.nickName isEqualToString:@""]) {
        vehicleLabelPicker = [NSString stringWithFormat:@"%@ - %@",vehicle.licensePlate, vehicle.carMake];
    } else {
        vehicleLabelPicker = [NSString stringWithFormat:@"%@ - %@",vehicle.nickName, vehicle.licensePlate];
    }
    
    tView.text = vehicleLabelPicker;
    
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedCar = [self.carPickerData objectAtIndex:row];

    NSLog(@"car: %@",self.selectedCar);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openLoginViewFromReservationView"]) {
        LoginViewController *loginViewController = (LoginViewController *)segue.destinationViewController;
        UIButton *signInBtn = (UIButton *)[loginViewController.view viewWithTag:2];
        [signInBtn setTitle:@"Sign In to Reserve" forState:UIControlStateNormal];
        
        UIButton *signInAsGuest = (UIButton *)[loginViewController.view viewWithTag:4];
        [signInAsGuest setTitle:@"Reserve as Guest" forState:UIControlStateNormal];
        signInAsGuest.hidden = NO;
        
        loginViewController.isSignInFromReservationView = YES;
    } else if ([segue.identifier isEqualToString:@"openAddVehicleViewFromReservationView"]) {
        AddVehicleViewController *addVehicleViewController = (AddVehicleViewController *)segue.destinationViewController;
        addVehicleViewController.commingFromReservation = YES;
    }
    
}

- (IBAction)unwindFromLogin:(UIStoryboardSegue*)sender
{
    NSLog(@"unwindFromLogin");
}
- (IBAction)unwindFromAddVehicleToReservation:(UIStoryboardSegue*)sender
{
     NSLog(@"unwindFromReservation");
    [self.carPicker reloadAllComponents];
}
@end
