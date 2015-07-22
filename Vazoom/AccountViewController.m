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
#import "UIViewController+Vazoom.h"
#import "LoginViewController.h"
#import "AccountService.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *signOutBtn;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveBtn.layer.cornerRadius = 10;
    self.signOutBtn.layer.cornerRadius = 10;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        PFUser *user = [PFUser currentUser];
        self.email.text = user[@"email"];
        self.firstName.text = user[@"firstName"];
        self.lastName.text = user[@"lastName"];
        self.phone.text = user[@"phone"];
    } else {
        [self performSegueWithIdentifier:@"openLoginView" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openMenuView:(id)sender {
    [(MainViewController *)self.navigationController.viewControllers[0] openMenuView: self];
}
- (IBAction)saveUserInfoChange:(id)sender {
    PFUser *user = [PFUser currentUser];
    user[@"email"] = self.email.text;
    user[@"firstName"] = self.firstName.text;
    user[@"lastName"] = self.lastName.text;
    user[@"phone"] = self.phone.text;
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [UIViewController showUIAlertActionTitle:@"Save" message:@"Your information is updated" from:self];
        } else {
            [UIViewController showUIAlertActionTitle:@"Save failed" message:[error userInfo][@"error"] from:self];
        }
    }];
}
- (IBAction)resetPassword:(id)sender {
    PFUser *user = [PFUser currentUser];
    [PFUser requestPasswordResetForEmailInBackground:user[@"email"] block:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            [UIViewController showUIAlertActionTitle:@"Reset Succeed!" message:@"Please check your email to reset your password." from:self];
        } else {
            [UIViewController showUIAlertActionTitle:@"Reset Failed!" message:[error userInfo][@"error"] from:self];
        }
    }];
}

- (IBAction)signOut:(id)sender {
    [PFUser logOut];
    if (![PFUser currentUser]) {
        self.email.text = @"";
        self.firstName.text = @"";
        self.lastName.text = @"";
        self.phone.text = @"";
        [AccountService service].isLogIn = NO;
    }
    
}

- (IBAction)unwindFromLoginToAccount:(UIStoryboardSegue*)sender
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"openLoginView"]) {
        ((LoginViewController *)segue.destinationViewController).isSignInFromAccountView = YES;
    }
}


@end
