//
//  SignUpViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/7/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/PFUser.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIViewController+Vazoom.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *inviteCode;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registerBtn.layer.cornerRadius = 10;
    self.email.delegate = self;
    self.password.delegate = self;
    self.confirmPassword.delegate = self;
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.phone.delegate = self;
    self.inviteCode.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerUser:(id)sender {
    BOOL validationFlag = YES;
    if ([self isEmailValid:self.email.text] &&
        [self isPasswordValid:self.password.text] &&
        [self isConfirmPassword:self.confirmPassword.text indentifyTo:self.password.text]) {
        
        if (self.firstName.text.length > 0 && ![self isNameValid:self.firstName.text]) {
            validationFlag = NO;
        }
        if (self.lastName.text.length > 0 && ![self isNameValid:self.lastName.text]) {
            validationFlag = NO;
        }
        if (self.phone.text.length > 0 && ![self isPhoneNumberValid:self.phone.text]) {
            validationFlag = NO;
        }
    } else {
        validationFlag = NO;
    }
    
    if (validationFlag) {
        PFUser *user = [PFUser user];
        user.username = self.email.text;
        user.password = self.password.text;
        user.email = self.email.text;
        if (self.phone.text.length >0 ) {
            user[@"phone"] = self.phone.text;
        }
        @weakify(self)
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            @strongify(self)
            if (!error) {
                self.userName = self.email.text;
                self.passwordText = self.password.text;
                self.isSuccessfulRegistration = YES;
                [self performSegueWithIdentifier:@"unwindFromRegistration" sender:self];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@",errorString);
                [UIViewController showUIAlertActionTitle:@"Registration failed!" message:errorString from:self];
            }
        }];
    } else {
        [UIViewController showUIAlertActionTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" from:self];
    }
}

#pragma mark - Validation
-(BOOL) isEmailValid:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    }
    else
        return YES;
}

- (BOOL)isPasswordValid:(NSString *)password
{

    NSString *regex = @"^[a-zA-Z0-9]{8,16}$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![passwordPredicate evaluateWithObject:password]) {
        return NO;
    }
    
    NSCharacterSet * characterSet = [NSCharacterSet uppercaseLetterCharacterSet] ;
    NSRange range = [password rangeOfCharacterFromSet:characterSet] ;
    if (range.location == NSNotFound) {
        return NO ;
    }
    characterSet = [NSCharacterSet lowercaseLetterCharacterSet] ;
    range = [password rangeOfCharacterFromSet:characterSet] ;
    if (range.location == NSNotFound) {
        return NO ;
    }
    
    characterSet = [NSCharacterSet decimalDigitCharacterSet] ;
    range = [password rangeOfCharacterFromSet:characterSet] ;
    if (range.location == NSNotFound) {
        return NO ;
    }
    
    
    /*characterSet = [NSCharacterSet characterSetWithCharactersInString:@"!@#$%"] ;
    range = [password rangeOfCharacterFromSet:characterSet] ;
    if (range.location == NSNotFound) {
        return NO ;
    }*/
    return YES ;
}

- (BOOL)isConfirmPassword:(NSString *)confirmPassword indentifyTo:(NSString *)password
{
    return [confirmPassword isEqualToString:password];
}

- (BOOL)isNameValid:(NSString *)name
{
    NSString *regex = @"^[a-zA-Z]{1,10}$";
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [namePredicate evaluateWithObject:name];
}

- (BOOL)isPhoneNumberValid:(NSString *)phone
{
    NSString *regex = @"^[0-9-()]{6,20}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [phonePredicate evaluateWithObject:phone];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BOOL validFlag = YES;
    if (textField == self.email &&
        ![self isEmailValid:textField.text]) {
        validFlag = NO;
    } else if (textField == self.password &&
               ![self isPasswordValid:textField.text]) {
        validFlag = NO;
    } else if (textField == self.confirmPassword &&
               ![self isConfirmPassword:textField.text indentifyTo:self.password.text]) {
        validFlag = NO;
    } else if (textField == self.firstName &&
               ![self isNameValid:textField.text]) {
        validFlag = NO;
    } else if (textField == self.lastName &&
               ![self isNameValid:textField.text]) {
        validFlag = NO;
    } else if (textField == self.phone &&
               ![self isPhoneNumberValid:textField.text]) {
        validFlag = NO;
    }
    
    
    if (textField.text.length > 0) {
        textField.layer.borderWidth=1.0;
        textField.layer.cornerRadius = 6;
        if (!validFlag) {
            textField.layer.borderColor = [[UIColor redColor] CGColor];
        } else {
            textField.layer.borderColor = [[UIColor greenColor] CGColor];
        }
    } else {
        textField.layer.borderWidth=1.0;
        textField.layer.cornerRadius = 6;
        textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
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
