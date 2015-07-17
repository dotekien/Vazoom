//
//  VehicleViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/13/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "VehicleViewController.h"
#import "MainViewController.h"
#import "AccountService.h"
#import "VehicleTableViewCell.h"
#import "Vehicle.h"
#import "AddVehicleViewController.h"

@interface VehicleViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VehicleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVehicle:)];
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
    [(MainViewController*)self.navigationController.viewControllers[0] openMenuView: self];
}
#pragma mark - table

-(NSArray *)dataSource
{
    return [AccountService service].vehicles;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:@"vehicleHeaderCell"];
    
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
    static NSString *simpleTableIdentifier = @"VehicleTableCell";
    
    VehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[VehicleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Vehicle *vehicle = [[self dataSource] objectAtIndex:indexPath.row];
    
    if ([vehicle.nickName isEqualToString:@""]) {
        cell.title.text = [NSString stringWithFormat:@"%@ - %@",vehicle.licensePlate, vehicle.carMake];
        cell.subTitle.text = @"";
    } else {
        cell.title.text = vehicle.nickName;
        cell.subTitle.text = [NSString stringWithFormat:@"%@ - %@",vehicle.licensePlate, vehicle.carMake];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Vehicle *vehicle = [[self dataSource] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"openEditVehicleView" sender:vehicle];
    
}

#pragma mark -
-(void)addVehicle:(id)sender
{
    [self performSegueWithIdentifier:@"openAddVehicleView" sender:self];
}

- (IBAction)unwindFromAddVehicle:(UIStoryboardSegue*)sender
{
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openEditVehicleView"]) {
        AddVehicleViewController * addVehicleViewController = (AddVehicleViewController *)segue.destinationViewController;
        UIButton *deleteBtn = (UIButton *)[addVehicleViewController.view viewWithTag:1];
        deleteBtn.hidden = NO;
        
        Vehicle *vehicle = (Vehicle *)sender;
        addVehicleViewController.editingVehicle = vehicle;
        addVehicleViewController.licensePlate.text = vehicle.licensePlate;
        addVehicleViewController.carMake.text = vehicle.carMake;
        addVehicleViewController.mainSelectCar.on = vehicle.isDefault;
        addVehicleViewController.nickName.text = vehicle.nickName;
    }
}
@end
