//
//  PaymentMethodViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/1/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "PaymentMethodViewController.h"
#import "MainViewController.h"
#import "PaymentTableViewCell.h"
#import "Payment.h"
#import "AccountService.h"
#import "AddPaymentMethodViewController.h"
#import <libextobjc/EXTScope.h>

@interface PaymentMethodViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPaymentMethod:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // set separator width full
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (IBAction)openMenuView:(id)sender {
    [(MainViewController *)self.navigationController.viewControllers[0] openMenuView: self];
}

#pragma mark - table

-(NSArray *)dataSource
{
    return [AccountService service].paymentMethods;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:@"paymentHeaderCell"];
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self dataSource].count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"paymentTableCell";
    
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[PaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Payment *payment = [[self dataSource] objectAtIndex:indexPath.row];
    cell.nickname.text = payment.nickName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // Payment *vehicle = [[self dataSource] objectAtIndex:indexPath.row];
   // [self performSegueWithIdentifier:@"openEditPaymentMethodView" sender:vehicle];
    
}

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
*/

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        Payment *payment = [[self dataSource] objectAtIndex:indexPath.row];
        dispatch_queue_t serial_q = dispatch_queue_create("serial_q_payment", DISPATCH_QUEUE_SERIAL);
        @weakify(self)
        dispatch_async(serial_q, ^{
            [[AccountService service] deletePaymentMethod:payment];
        });
        dispatch_async(serial_q, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self.tableView reloadData];
            });
        });
    }
}

#pragma mark -
-(void)addPaymentMethod:(id)sender
{
    [self performSegueWithIdentifier:@"openAddPaymentMethodView" sender:self];
}

- (IBAction)unwindFromAddPayment:(UIStoryboardSegue*)sender
{
    [self.tableView reloadData];
}

@end
