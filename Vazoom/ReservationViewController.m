//
//  ReservationViewController.m
//  Vazoom
//
//  Created by Kien Do on 6/30/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "ReservationViewController.h"
#import "MainViewController.h"
#import "AccountService.h"
#import "Reservation.h"
#import <Parse/PFObject.h>

@interface ReservationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrCode;
@property (weak, nonatomic) IBOutlet UILabel *nameLocation;
@property (weak, nonatomic) IBOutlet UILabel *carTitlePlate;
@property (weak, nonatomic) IBOutlet UILabel *paymentAmount;
@property (weak, nonatomic) IBOutlet UILabel *bookTime;

@end

@implementation ReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([AccountService service].reservations.count > 0) {
        Reservation *reservation = [AccountService service].reservations[0];
        [self.qrCode setImage: reservation.qrcode];
        
        self.nameLocation.text = reservation.parking[@"parkingName"];
        self.carTitlePlate.text = reservation.vehicle[@"licensePlate"];
        self.paymentAmount.text = reservation.parking[@"parkingPrice"];
        self.bookTime.text = [NSDateFormatter localizedStringFromDate:reservation.bookingTime
                                                            dateStyle:NSDateFormatterMediumStyle
                                                            timeStyle:NSDateFormatterShortStyle];
    }
}

- (void)viewDidLayoutSubviews
{
    //[super viewDidLayoutSubviews];
    if ([AccountService service].reservations.count == 0) {
        UIViewController *noreservation = [self.storyboard instantiateViewControllerWithIdentifier:@"NoReservation"];
        noreservation.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:noreservation.view];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:noreservation.view attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:noreservation.view attribute:NSLayoutAttributeTrailing
                                                  relatedBy:NSLayoutRelationEqual toItem:self.view
                                                  attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        [self.view addConstraint:constraint];
        constraint =  [NSLayoutConstraint constraintWithItem:noreservation.view
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.view
                                                   attribute:NSLayoutAttributeTop
                                                  multiplier:1
                                                    constant:0];
        [self.view addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:noreservation.view attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual toItem:self.view
                                                  attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self.view addConstraint:constraint];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openMenuView:(id)sender {
    [(MainViewController*)self.navigationController.viewControllers[0] openMenuView: self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
