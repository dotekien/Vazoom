//
//  AddCreditCardViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/7/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "AddCreditCardViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AddCreditCardViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addCreditCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation AddCreditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addCreditCardBtn.layer.cornerRadius = 10;
    self.cancelBtn.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addCreditCard:(id)sender {
    [self performSegueWithIdentifier:@"unwindToPickMyCarView" sender:self];
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
