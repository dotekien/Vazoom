//
//  PickMyCarViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/7/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "PickMyCarViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AddPaymentMethodViewController.h"
#import "AccountService.h"
#import "Payment.h"
#import "PFCloud.h"
#import "PFUser.h"
#import <libextobjc/EXTScope.h>
#import "Reservation.h"

@interface PickMyCarViewController ()
@property (strong, nonatomic) IBOutlet UIView *pickMyCarBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *paymentMethodPicker;
@property (strong, nonatomic) NSMutableArray *payments;
@property (strong, nonatomic) Payment *selectedPayment;
@end

@implementation PickMyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickMyCarBtn.layer.cornerRadius = 10;
    if (![[AccountService service] isPaymentMethodListEmpty]) {
        [self.paymentMethodPicker selectRow:3 inComponent:0 animated:NO];
        self.selectedPayment = self.paymentMethodPickerData[3];
    } else {
        [self.paymentMethodPicker selectRow:0 inComponent:0 animated:NO];
        self.selectedPayment = self.paymentMethodPickerData[0];
    }
}

- (void)viewDidLayoutSubviews
{
    //[super viewDidLayoutSubviews];
    if ([AccountService service].reservations.count == 0) {
        UIViewController *noreservation = [self.storyboard instantiateViewControllerWithIdentifier:@"NoReservationCar"];
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

- (IBAction)pickMyCar:(id)sender {
    Reservation * reservation = (Reservation *)[AccountService service].reservations[0];
    [PFCloud callFunctionInBackground:@"payValetParking"
                       withParameters:@{@"userId": [PFUser currentUser].objectId,
                                        @"reservationId": reservation.resvervationId,
                                        @"price": @"1",//reservation.parking[@"parkingPrice"]
                                        @"tokenId": self.selectedPayment.token}
                                block:^(id results, NSError *error) {
                                    if (!error) {
                                        @weakify(self)
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            @strongify(self)
                                            NSLog(@"Successfully retrieved: %@", results);
                                            [self performSegueWithIdentifier:@"openCountDownView" sender:self];
                                        });
                                    } else {
                                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                        NSLog(@"Error: %@", errorString);
                                    }
                                }];
    
}
#pragma mark - Picker API

-(NSArray *)paymentMethodPickerData
{
    if (!self.payments) {
        Payment *cash = [Payment new]; cash.nickName = @"Cash"; cash.token = @"Cash";
        //Payment *applePay = [Payment new]; applePay.nickName = @"Apple Pay";
        Payment *addCreditCard = [Payment new]; addCreditCard.nickName = @"Add Credit Card";
        self.payments = [[NSMutableArray alloc] initWithObjects:cash, addCreditCard, nil];
        [self.payments addObjectsFromArray:[AccountService service].paymentMethods];
    } else {
        self.payments = [[NSMutableArray alloc] initWithObjects:self.payments[0], self.payments[1], self.payments[2], nil];
        [self.payments addObjectsFromArray:[AccountService service].paymentMethods];
    }
    return self.payments;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self paymentMethodPickerData].count;

}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self paymentMethodPickerData][row];
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
    // Fill the label text here
    Payment *payment =[[self paymentMethodPickerData] objectAtIndex:row];
    tView.text = payment.nickName;
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Payment *selectedPayment = [[self paymentMethodPickerData] objectAtIndex:row];
    if ([selectedPayment.nickName isEqualToString:@"Add Credit Card"]) {
        [self performSegueWithIdentifier:@"openAddPaymentMethodViewFromPickMyCarView" sender:self];
    } else if ([selectedPayment.nickName isEqualToString:@"Cash"]) {
        self.selectedPayment = [[self paymentMethodPickerData] objectAtIndex:row];
    } else if ([selectedPayment.nickName isEqualToString:@"Apple Pay"]) {
        
    } else {
        self.selectedPayment = [[self paymentMethodPickerData] objectAtIndex:row];
        NSLog(@"payment: %@", self.selectedPayment);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openAddPaymentMethodViewFromPickMyCarView"]) {
        AddPaymentMethodViewController *addPaymentMethodViewController = (AddPaymentMethodViewController *)segue.destinationViewController;
        addPaymentMethodViewController.commingFromPickMyCar = YES;
    }
    
}
- (IBAction)unwindFromAddPaymentMethodToPickMyCar:(UIStoryboardSegue*)sender
{
    NSLog(@"unwindFromAddPaymentMethodToPickMyCar");
    [self.paymentMethodPicker reloadAllComponents];
}
@end
