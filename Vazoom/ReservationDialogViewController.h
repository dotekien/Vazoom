//
//  ReservationDialogViewController.h
//  Vazoom
//
//  Created by Kien Do on 7/6/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VZParking;

@interface ReservationDialogViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
-(void)setSelectedParking: (VZParking *)parking;
@end
