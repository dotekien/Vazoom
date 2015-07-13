//
//  SignUpViewController.h
//  Vazoom
//
//  Created by Kien Do on 7/7/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic)NSString *userName;
@property (strong, nonatomic)NSString *passwordText;
@property BOOL isSuccessfulRegistration;
@end
