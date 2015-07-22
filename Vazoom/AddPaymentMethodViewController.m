//
//  AddPaymentMethodViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/18/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "AddPaymentMethodViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PTKView.h"
#import "Payment.h"
#import "STPCard.h"
#import "STPAPIClient.h"
#import <Parse/PFObject.h>
#import "AccountService.h"
#import "UIViewController+Vazoom.h"
#import "STPToken.h"

@interface AddPaymentMethodViewController ()<PTKViewDelegate>
@property (weak, nonatomic) IBOutlet PTKView *ptkView;
@property (weak, nonatomic) IBOutlet UIButton *savePaymentBtn;
@property (strong, nonatomic) Payment *currentPayment;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *zipcode;
@end

@implementation AddPaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ptkView.delegate = self;
    self.savePaymentBtn.layer.cornerRadius = 10;
    self.savePaymentBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)paymentView:(PTKView *)view withCard:(PTKCard *)card isValid:(BOOL)valid
{
    self.savePaymentBtn.enabled = valid;
    NSLog(@"valid: %@", [NSNumber numberWithBool:valid]);
}
- (IBAction)savePaymentAction:(id)sender
{
    PTKAddressZip *zip = [[PTKAddressZip alloc] initWithString:self.zipcode.text];
    if ([zip isValid]) {
        STPCard *card = [[STPCard alloc] init];
        card.number = self.ptkView.card.number;
        card.expMonth = self.ptkView.card.expMonth;
        card.expYear = self.ptkView.card.expYear;
        card.cvc = self.ptkView.card.cvc;
        card.addressZip = self.zipcode.text;
        [[STPAPIClient sharedClient] createTokenWithCard:card
                                              completion:^(STPToken *token, NSError *error) {
                                                  if (error) {
                                                      [self handleError:error];
                                                  } else {
                                                      [self createBackendChargeWithToken:token];
                                                  }
                                              }];

    }
}


-(void)createBackendChargeWithToken: (STPToken *)token
{
    self.currentPayment = [Payment new];
    self.currentPayment.token = token.tokenId;
    self.currentPayment.last4 = token.card.last4;

    if ([self.nickName.text isEqualToString:@""]) {
        self.currentPayment.nickName = [NSString stringWithFormat:@"*%@",self.ptkView.card.last4];
    } else {
        self.currentPayment.nickName = [NSString stringWithFormat:@"%@-%@",self.nickName.text, self.ptkView.card.last4];
    }
    [[AccountService service] addPaymentMethod:self.currentPayment];
    if (self.commingFromPickMyCar) {
        [self performSegueWithIdentifier:@"unwindFromAddPaymentToPickMyCar" sender:self];
    } else {
        [self performSegueWithIdentifier:@"unwindFromAddPayment" sender:self];
    }
}

-(void)handleError:(NSError *)error
{
    NSString *errorString = [[error userInfo] objectForKey:@"error"];
    NSLog(@"Error: %@", errorString);
    [UIViewController showUIAlertActionTitle:@"Failed to validate" message:@"Unable to validate credit card." from:self];
}

@end
