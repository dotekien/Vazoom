//
//  ReservationViewController.m
//  Vazoom
//
//  Created by Kien Do on 6/30/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "ReservationViewController.h"
#import "MainViewController.h"

@interface ReservationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrCode;
@property (weak, nonatomic) IBOutlet UILabel *nameLocation;
@property (weak, nonatomic) IBOutlet UILabel *carTitlePlate;
@property (weak, nonatomic) IBOutlet UILabel *paymentAmount;

@end

@implementation ReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.qrCode setImage:[UIImage imageNamed:@"qrCode"]];
    
    self.nameLocation.text = @"Towson University Marriott Conference Hotel\n@ 10 Burke Ave, Towson, MD 21204";
    self.carTitlePlate.text = @"BMW-MD1234";
    self.paymentAmount.text = @"Visa-1208 - $12.00";
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
