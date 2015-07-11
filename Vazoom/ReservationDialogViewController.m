//
//  ReservationDialogViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/6/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "ReservationDialogViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ReservationDialogViewController ()
@property (weak, nonatomic) IBOutlet UIButton *parkMyCarBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *carPicker;

@property (strong, nonatomic) NSMutableArray *carPickerData;
@property (strong, nonatomic) NSString *selectedCar;

@end

@implementation ReservationDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _carPickerData = [[NSMutableArray alloc] initWithObjects:@"BMW-MD1234",@"Lexus-VA4567",nil];

    [self.carPicker selectRow:0 inComponent:0 animated:NO];
    self.selectedCar = self.carPickerData[0];
    
    self.parkMyCarBtn.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)parkMyCar:(id)sender {
    MainViewController *mainViewController = (MainViewController *)self.navigationController.viewControllers[0];
    [mainViewController openReservationView:self];
}

#pragma mark - Picker API
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.carPickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.carPickerData[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"System" size:17]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=1;
    }
    tView.text=[self.carPickerData objectAtIndex:row];
    
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedCar = [self.carPickerData objectAtIndex:row];

    NSLog(@"car: %@",self.selectedCar);
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
