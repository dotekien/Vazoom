//
//  AddVehicleViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/16/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "AddVehicleViewController.h"
#import "UIViewController+Vazoom.h"
#import "Vehicle.h"
#import "AccountService.h"
#import <QuartzCore/QuartzCore.h>
#import "PFUser.h"

@interface AddVehicleViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveVehicleBtn;
@property (weak, nonatomic) IBOutlet UIButton *deletePaymentBtn;

@end

@implementation AddVehicleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveVehicleBtn.layer.cornerRadius = 10;
    self.deletePaymentBtn.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveVehile:(id)sender {
    if ([self.licensePlate.text isEqualToString:@""]) {
        [UIViewController showUIAlertActionTitle:@"License plate is empty" message:@"Please enter your vehicle license plate." from:self];
    }
    
    if ([self.carMake.text isEqualToString:@""]) {
        [UIViewController showUIAlertActionTitle:@"Vehicle Make is empty" message:@"Please enter your vehicle vehicle Make." from:self];
    }
    
    Vehicle *newVechicle = nil;
    if (self.editingVehicle) {
        newVechicle = self.editingVehicle;
        [newVechicle initWith:self.editingVehicle.vehicleId user:[PFUser currentUser] license:self.licensePlate.text carMake:self.carMake.text nickName:self.nickName.text isDefault:(self.mainSelectCar.on == TRUE)?YES:NO];
        [[AccountService service] saveVehicle:self.editingVehicle];
    } else {
        newVechicle = [Vehicle new];
        [newVechicle initWith:nil user:[PFUser currentUser] license:self.licensePlate.text carMake:self.carMake.text nickName:self.nickName.text isDefault:(self.mainSelectCar.on == TRUE)?YES:NO];
        [[AccountService service] addVehicle:newVechicle];
    }
    
    if (self.commingFromReservation) {
        [self performSegueWithIdentifier:@"unwindFromAddVehicleToReservation" sender:self];
    } else {
        [self performSegueWithIdentifier:@"unwindFromAddVehicle" sender:self];
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

@end
