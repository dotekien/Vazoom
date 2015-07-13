//
//  LoginViewController.h
//  Vazoom
//
//  Created by Kien Do on 7/12/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^successActionBlock)(void);

@interface LoginViewController : UIViewController
@property (nonatomic, strong) successActionBlock successAction;

@end
