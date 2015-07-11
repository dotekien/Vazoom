//
//  PickMyCarViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/7/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "PickMyCarViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PickMyCarViewController ()
@property (strong, nonatomic) IBOutlet UIView *pickMyCarBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *paymentMethod;
@property (strong, nonatomic) NSMutableArray *paymentPickerData;
@property (strong, nonatomic) NSString *selectedPayment;
@end

@implementation PickMyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _paymentPickerData = [[NSMutableArray alloc] initWithObjects:@"Cash", @"Visa-1208",@"Add Credit Card",nil];
    [self.paymentMethod selectRow:0 inComponent:0 animated:NO];
    self.selectedPayment = self.paymentPickerData[0];
    self.pickMyCarBtn.layer.cornerRadius = 10;
}

-(void)viewWillAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openMenuView:(id)sender {
    [(MainViewController*)self.navigationController.viewControllers[0] openMenuView: self];
}

- (IBAction)pickMyCar:(id)sender {
    [self performSegueWithIdentifier:@"openCountDownView" sender:self];
}
#pragma mark - Picker API
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.paymentPickerData.count;

}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.paymentPickerData[row];
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
    // Fill the label text here
    tView.text=[self.paymentPickerData objectAtIndex:row];
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *selectedPayment = [self.paymentPickerData objectAtIndex:row];
    if ([selectedPayment isEqualToString:@"Add Credit Card"]) {
        [self performSegueWithIdentifier:@"openAddCreditCardView" sender:self];
    } else {
        self.selectedPayment = [self.paymentPickerData objectAtIndex:row];
        NSLog(@"payment: %@", self.selectedPayment);
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
