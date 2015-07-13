//
//  AccountController.m
//  Vazoom
//
//  Created by Kien Do on 7/1/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "AccountViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PFUser.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![PFUser currentUser]) {
        [self performSegueWithIdentifier:@"openLoginView" sender:self];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
