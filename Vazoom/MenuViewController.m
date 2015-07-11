//
//  MenuViewController.m
//  Vazoom
//
//  Created by Kien Do on 6/30/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "MainNavigationController.h"
#import "Constants.h"
#import "MainViewController.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSDictionary *menuItemIcon;
@property (strong, nonatomic) NSDictionary *menuItemSegueIdentifer;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.menuItems = @[kMenuItem_find_parking, kMenuItem_reservations, kMenuItem_pick_my_car, kMenuItem_payment_methods, kMenuItem_account, kMenuItem_promotions, kMenuItem_share, kMenuItem_help];
    self.menuItemIcon = @{kMenuItem_find_parking: @"findParking",
                          kMenuItem_reservations: @"reservations",
                          kMenuItem_pick_my_car: @"pickMyCar",
                          kMenuItem_payment_methods: @"paymentMethods",
                          kMenuItem_account: @"account",
                          kMenuItem_promotions: @"promotions",
                          kMenuItem_share: @"share",
                          kMenuItem_help: @"help"};
    
    self.menuItemSegueIdentifer = @{kMenuItem_find_parking: kSegueID_openMapView,
                                    kMenuItem_reservations: kSegueID_openReservationView,
                                    kMenuItem_pick_my_car: kSegueID_openPickMyCarView,
                                    kMenuItem_payment_methods: kSegueID_openPaymentMethodView,
                                    kMenuItem_account: kSegueID_openAccountView,
                                    kMenuItem_promotions: kSegueID_openPromotionView,
                                    kMenuItem_share: kSegueID_openShareView,
                                    kMenuItem_help: kSegueID_openHelpView};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MenuCell";
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSString *item = [self.menuItems objectAtIndex:indexPath.row];
    
    cell.icon.image = [UIImage imageNamed:self.menuItemIcon[item]];
    cell.menuItem.text = [item capitalizedString];
    
    //set selected background orange color
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor orangeColor];
    cell.selectedBackgroundView = v;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *item = [self.menuItems objectAtIndex:indexPath.row];
    MainViewController *mainViewController = (MainViewController *)self.navigationController.viewControllers[0];
    if ([self.menuItemSegueIdentifer[item] isEqualToString:kSegueID_openMapView]) {
        [mainViewController openMapView: self];
    } else if ([self.menuItemSegueIdentifer[item] isEqualToString:kSegueID_openReservationView]) {
        [mainViewController openReservationView: self];
    } else if ([self.menuItemSegueIdentifer[item] isEqualToString:kSegueID_openPaymentMethodView]) {
        [mainViewController openPaymentMethodView: self];
    } else if ([self.menuItemSegueIdentifer[item] isEqualToString:kSegueID_openPickMyCarView]) {
        [mainViewController openPickMyCarView: self];
    } else if ([self.menuItemSegueIdentifer[item] isEqualToString:kSegueID_openAccountView]) {
        [mainViewController openAccountView: self];
    } else if ([self.menuItemSegueIdentifer[item] isEqualToString:kSegueID_openPromotionView]) {
        [mainViewController openPromotionView: self];
    } else if ([self.menuItemSegueIdentifer[item] isEqualToString:kSegueID_openShareView]) {
        [mainViewController openShareView: self];
    } else if ([self.menuItemSegueIdentifer[item] isEqualToString:kSegueID_openHelpView]) {
        [mainViewController openHelpView: self];
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
