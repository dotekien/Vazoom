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

@interface AddVehicleViewController ()
@end

@implementation AddVehicleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    Vehicle *newVechicle = [Vehicle new];
    if (self.editingVehicle) {
        newVechicle = self.editingVehicle;
    }
    newVechicle.licensePlate = self.licensePlate.text;
    newVechicle.carMake = self.carMake.text;
    newVechicle.isDefault = (self.mainSelectCar.on == TRUE)?YES:NO;
    newVechicle.nickName = self.nickName.text;
    if (!self.editingVehicle) {
        [[AccountService service] addVehicle:newVechicle];
    }
    
    if (self.commingFromReservation) {
        [self performSegueWithIdentifier:@"unwindFromAddVehicleToReservation" sender:self];
    } else {
        [self performSegueWithIdentifier:@"unwindFromAddVehicle" sender:self];
    }
}
- (IBAction)deleteVehicle:(id)sender {
    
    [[AccountService service].vehicles removeObject:self.editingVehicle];
    [self performSegueWithIdentifier:@"unwindFromAddVehicle" sender:self];
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
