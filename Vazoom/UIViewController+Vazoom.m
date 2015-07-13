//
//  UIViewController+Vazoom.m
//  Vazoom
//
//  Created by Kien Do on 7/12/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "UIViewController+Vazoom.h"

@implementation UIViewController (Vazoom)
+(void)showUIAlertActionTitle:(NSString *)title message:(NSString *)message from:(UIViewController *)vc
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [vc presentViewController:alertController animated:YES completion:nil];
}
@end
