//
//  MainViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/4/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "MapViewController.h"
#import "CustomTransitioning.h"
#import "ReservationViewController.h"
#import "PaymentMethodViewController.h"
#import "AccountViewController.h"
#import "PromotionViewController.h"
#import "ShareViewController.h"
#import "HelpViewController.h"
#import "Constants.h"
@interface MainViewController ()
@property (strong, nonatomic) MapViewController *mapViewController;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    [self.navigationController pushViewController:self.mapViewController animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openMapView:(id)sender
{
    if ([sender isKindOfClass:[MenuViewController class]]) {
        [self.navigationController popToViewController:self animated:YES];
    }
    [self.navigationController pushViewController:self.mapViewController animated:YES];
}

-(void)openMenuView:(id)sender
{
    [self performSegueWithIdentifier:kSegueID_openMenuView sender:sender];
}

-(void)openReservationView:(id)sender
{
    [self.navigationController popToViewController:self animated:YES];
    [self performSegueWithIdentifier:kSegueID_openReservationView sender:sender];
}

-(void)openPickMyCarView:(id)sender
{
    [self.navigationController popToViewController:self animated:YES];
    [self performSegueWithIdentifier:kSegueID_openPickMyCarView sender:sender];
}
-(void)openPaymentMethodView:(id)sender
{
    [self.navigationController popToViewController:self animated:YES];
    [self performSegueWithIdentifier:kSegueID_openPaymentMethodView sender:sender];
}

-(void)openAccountView:(id)sender
{
    [self.navigationController popToViewController:self animated:YES];
    [self performSegueWithIdentifier:kSegueID_openAccountView sender:sender];
}

-(void)openPromotionView:(id)sender
{
    [self.navigationController popToViewController:self animated:YES];
    [self performSegueWithIdentifier:kSegueID_openPromotionView sender:sender];
}
-(void)openShareView:(id)sender
{
    [self.navigationController popToViewController:self animated:YES];
    [self performSegueWithIdentifier:kSegueID_openShareView sender:sender];
}

-(void)openHelpView:(id)sender
{
    [self.navigationController popToViewController:self animated:YES];
    [self performSegueWithIdentifier:kSegueID_openHelpView sender:sender];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:kSegueID_openMenuView]) {
        MenuViewController * menuViewController = (MenuViewController *)segue.destinationViewController;
        if ([sender isKindOfClass:[MapViewController class]])
        {
            menuViewController.senderSegueIdentifier = kSegueID_openMapView;
        } else if ([sender isKindOfClass:[ReservationViewController class]])
        {
            menuViewController.senderSegueIdentifier = kSegueID_openReservationView;
        } else if ([sender isKindOfClass:[PaymentMethodViewController class]])
        {
            menuViewController.senderSegueIdentifier = kSegueID_openPaymentMethodView;
        } else if ([sender isKindOfClass:[AccountViewController class]])
        {
            menuViewController.senderSegueIdentifier = kSegueID_openAccountView;
        } else if ([sender isKindOfClass:[PromotionViewController class]])
        {
            menuViewController.senderSegueIdentifier = kSegueID_openPromotionView;
        } else if ([sender isKindOfClass:[ShareViewController class]])
        {
            menuViewController.senderSegueIdentifier = kSegueID_openShareView;
        } else if ([sender isKindOfClass:[HelpViewController class]])
        {
            menuViewController.senderSegueIdentifier = kSegueID_openHelpView;
        }
        
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
