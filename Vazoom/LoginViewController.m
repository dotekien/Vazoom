//
//  LoginViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/12/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SignUpViewController.h"
#import "AccountService.h"
#import "UIViewController+Vazoom.h"
#import <Parse/PFUser.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *signInFB;
@property (weak, nonatomic) IBOutlet UIButton *signInAsGuest;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInBtn.layer.cornerRadius = 10;
    self.signInFB.layer.cornerRadius = 10;
    self.signUpBtn.layer.cornerRadius = 10;
    self.signInAsGuest.layer.cornerRadius = 10;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openSigUpView:(id)sender {
    [self performSegueWithIdentifier:@"openSignUpView" sender:self];
}

- (IBAction)signInAction:(id)sender {

}

- (IBAction)forgotPasswordAction:(id)sender {
}

- (IBAction)signInWithFaceBookAction:(id)sender {
    
}

- (IBAction)unwindFromRegistration:(UIStoryboardSegue*)sender
{
    SignUpViewController *sourceViewController = (SignUpViewController *)sender.sourceViewController;
    if (sourceViewController.isSuccessfulRegistration) {
        [[AccountService service] loginWithUserName:sourceViewController.userName password:sourceViewController.passwordText completionBlock:^(NSError *error) {
            if (error) {
                [UIViewController showUIAlertActionTitle:@"Login failed!" message:[error userInfo][@"error"] from:self];
            } else {
                NSLog(@"Sign in successfully");
                [self performSegueWithIdentifier:@"unwindFromLogin" sender:self];
            }
        }];
    }
}
@end
