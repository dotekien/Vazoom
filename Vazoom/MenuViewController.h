//
//  MenuViewController.h
//  Vazoom
//
//  Created by Kien Do on 6/30/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *senderSegueIdentifier;
@end
