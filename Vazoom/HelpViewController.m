//
//  HelpViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/1/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "HelpViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet UIButton *callUs;
@property (weak, nonatomic) IBOutlet UIButton *emailUs;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.callUs.layer.cornerRadius = 10;
    self.emailUs.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openMenuView:(id)sender {
    [(MainViewController *)self.navigationController.viewControllers[0] openMenuView: self];
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
