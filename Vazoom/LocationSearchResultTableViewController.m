//
//  LocationSearchResultTableViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/10/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "LocationSearchResultTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MapViewController.h"

@interface LocationSearchResultTableViewController ()

@end

@implementation LocationSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *simpleTableIdentifier = @"LocationSearchResultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self _addressStringAtIndexPath:indexPath];
    NSLog(@"address: %@",[self _addressStringAtIndexPath:indexPath]);
    //cell.imageView.image = [UIImage imageNamed:@"creme_brelee.jpg"];
    return cell;
}

- (NSString *)_addressStringAtIndexPath:(NSIndexPath *)indexPath
{
    CLPlacemark *placemark = _searchResults[indexPath.row];
    NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
    NSString *addressString = [lines componentsJoinedByString:@","];
    NSLog(@"Address: %@", addressString);
    NSLog(@"Address: %@", addressString);
    return addressString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.hidden = YES;
    if ([self.callViewController isKindOfClass:[MapViewController class]])
    {
        CLPlacemark *placemark = _searchResults[indexPath.row];
        NSLog(@"%@",placemark.location);
        [((MapViewController*)self.callViewController) setSelectedLocationSearch:[[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude]];
    }
}
@end
