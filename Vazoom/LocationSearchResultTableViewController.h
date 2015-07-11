//
//  LocationSearchResultTableViewController.h
//  Vazoom
//
//  Created by Kien Do on 7/10/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationSearchResultTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, weak) UIViewController *callViewController;
@end
