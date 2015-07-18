//
//  AddVehicleViewController.h
//  Vazoom
//
//  Created by Kien Do on 7/16/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Vehicle;

@interface AddVehicleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *licensePlate;
@property (weak, nonatomic) IBOutlet UITextField *carMake;
@property (weak, nonatomic) IBOutlet UISwitch *mainSelectCar;
@property (weak, nonatomic) IBOutlet UITextField *nickName;

@property (weak, nonatomic) Vehicle *editingVehicle;
@property BOOL commingFromReservation;
@end
