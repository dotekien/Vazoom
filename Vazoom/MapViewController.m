//
//  MapViewController.m
//  Vazoom
//
//  Created by Kien Do on 6/28/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MainNavigationController.h"
#import "MainViewController.h"
#import "ValetParkingLocationCell.h"
#import "LocationService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "Constants.h"
#import "VZParking.h"
#import "ParkingAddress.h"
#import "ParkingSchedule.h"
#import "VZMapAnnotation.h"
#import "LocationSearchResultTableViewController.h"

@interface MapViewController ()

@property (strong, nonatomic, readonly) UISearchController *searchController;
@property (strong, nonatomic) NSArray *locationSearchResults;
@property (weak, nonatomic) UIView *currentView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *listButton;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) BOOL allowUpdateSearchLocation;

@property (strong, nonatomic) NSMutableArray *valetParkings;
@property NSInteger valetParkingsUpdateCount;
@property (nonatomic) BOOL unableToAccessSearchService;
@property (nonatomic) BOOL noVZParking;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) CLLocation *searchLocation;

@end

@implementation MapViewController
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        //_searchResults = [NSMutableArray new];
        
        
        _valetParkings = [NSMutableArray new];
        _valetParkingsUpdateCount = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.allowUpdateSearchLocation = YES;
    
    [self initRefreshControl];
    
    [self setupSearchController];
    
    self.geoCoder = [[CLGeocoder alloc] init];
    
    [self setDefaultCurrentView];
    
    //location service
    [[LocationService service] requestWhenInUseAuthorization];
    
    //binding
    [self RACBinding];
}
-(void) setupSearchController
{
    //setup searchController
    LocationSearchResultTableViewController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"LocationSearchResultTableViewController"];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = false;
    _searchController.hidesNavigationBarDuringPresentation = false;
    
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.backgroundColor = [UIColor clearColor];
    _searchController.searchBar.backgroundImage = [UIImage new];
    self.navigationItem.titleView = _searchController.searchBar;
}

-(void) RACBinding
{
    @weakify(self)
    [RACObserve([LocationService service], isAuthorized) subscribeNext:^(id x) {
         @strongify(self)
        self.mapView.showsUserLocation = (BOOL)x;
    }];
    
    [[[RACObserve([LocationService service], currentLocation)ignore:nil] filter:^BOOL(id value) {
        @strongify(self)
        return self.allowUpdateSearchLocation;
    }]subscribeNext:^(id x) {
        @strongify(self)
        if (self.searchLocation == nil || ([self.searchLocation distanceFromLocation:[LocationService service].currentLocation] > MilesToMeters(kMapRegionDelta_miles))) {
            self.searchLocation = (CLLocation *)x;
        }
    }];
    
    [[RACObserve(self, searchLocation) ignore:nil] subscribeNext:^(id x) {
        @strongify(self)
            NSLog(@"search location: %@",self.searchLocation);
            [self focusMaptoLocation:(CLLocation *)x];
            [[self queryForTable:self.searchLocation] findObjectsInBackgroundWithTarget:self selector:@selector(extractToVZParkingList:error:)];

    }];
    
    [RACObserve(self, valetParkingsUpdateCount) subscribeNext:^(id x) {
        @strongify(self)
        if (self.valetParkings.count > 0) {
            [self showOnMapSearchResults:self.valetParkings];
            [self reloadData];
        }
    }];
}
-(void)extractToVZParkingList:(id)results error:(NSError *)error
{
    if (!error) {
        NSArray *objects = results;
        NSLog(@"Successfully retrieved %lu.", (unsigned long)objects.count);
        if (objects.count > 0) {
            self.valetParkings = [[NSMutableArray alloc] initWithCapacity:objects.count];
            [self convertParseVZParkingSearchResultsToObject:objects];
        } else {
            self.noVZParking = YES;
        }
    } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        self.unableToAccessSearchService = YES;
    }
}

-(void)convertParseVZParkingSearchResultsToObject:(NSArray *)searchResults
{
    for (PFObject *object in searchResults) {
        VZParking *vzParking = [VZParking new];
        vzParking.parkingName = object[@"parkingName"];
        vzParking.phoneNumber = object[@"phoneNumber"];
        vzParking.location = object[@"location"];
        vzParking.slotAvailability = object[@"slotAvailability"];
        vzParking.price = object[@"parkingPrice"];
        
        ParkingAddress *parkingAddress = [ParkingAddress new];
        parkingAddress.propertyNumber = object[@"address"][@"propertyNumber"];
        parkingAddress.street = object[@"address"][@"street"];
        parkingAddress.city = object[@"address"][@"city"];
        parkingAddress.state = object[@"address"][@"state"];
        parkingAddress.zipcode = object[@"address"][@"zipcode"];
        parkingAddress.country = object[@"address"][@"country"];
        vzParking.address = parkingAddress;
        
        ParkingSchedule *parkingSchedule = [ParkingSchedule new];
        parkingSchedule.Mon = object[@"parkingSchedule"][@"Mon"];
        parkingSchedule.Tue = object[@"parkingSchedule"][@"Tue"];
        parkingSchedule.Wed = object[@"parkingSchedule"][@"Wed"];
        parkingSchedule.Thu = object[@"parkingSchedule"][@"Thu"];
        parkingSchedule.Fri = object[@"parkingSchedule"][@"Fri"];
        parkingSchedule.Sat = object[@"parkingSchedule"][@"Sat"];
        parkingSchedule.Sun = object[@"parkingSchedule"][@"Sun"];
        parkingSchedule.holidays = object[@"parkingSchedule"][@"holidays"];
        vzParking.schedule = parkingSchedule;
        
        [self.valetParkings addObject:vzParking];
    }
    self.valetParkingsUpdateCount++;
}

-(void)setSelectedLocationSearch:(CLLocation*)locationSearchResult
{
    [self.searchController.searchBar resignFirstResponder];
    [self.searchController.searchBar setShowsCancelButton:NO animated:NO];
    [self showCurrentView];
    
    self.searchLocation = locationSearchResult;
    self.allowUpdateSearchLocation = NO;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // set separator width full
    if ([self.searchTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.searchTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.searchTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.searchTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showCurrentView];
    [self toggleBtnListViewAndMapView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setDefaultCurrentView
{
    self.searchTableView.hidden = YES;
    self.currentView = self.mapView;
}

- (void)showCurrentView
{
    if (self.currentView == self.mapView) {
        self.searchTableView.hidden = YES;
        self.mapView.hidden = NO;
    } else {
        self.mapView.hidden = YES;
        self.searchTableView.hidden = NO;
    }
}

-(void)toggleBtnListViewAndMapView
{
    UIImage *icon = nil;
    if (self.currentView == self.mapView) {
        icon = [UIImage imageNamed:@"listIcon"];
    } else {
        icon = [UIImage imageNamed:@"mapIcon"];
    }
    [self.listButton setImage:icon];
}

-(void)initRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor orangeColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestVazoomParking)
                  forControlEvents:UIControlEventValueChanged];
    [self.searchTableView addSubview:self.refreshControl];
}
- (void)reloadData
{
    // Reload table data
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchTableView reloadData];
    });
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}
#pragma mark - Action

- (IBAction)switchingViews:(id)sender {
    if (self.currentView == self.mapView) {
        self.currentView = self.searchTableView;
    } else {
        self.currentView = self.mapView;
    }
    [self showCurrentView];
    [self toggleBtnListViewAndMapView];
}
- (IBAction)openMenuView:(id)sender {
    [(MainViewController*)self.navigationController.viewControllers[0] openMenuView: self];
}

#pragma mark - search

- (PFQuery *)queryForTable:(CLLocation *)location
{
    PFQuery *query = [PFQuery queryWithClassName:@"VZParking"];
    if ([self.valetParkings count] == 0) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    // And set the query to look by location
    PFGeoPoint *point =
    [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude
                           longitude:location.coordinate.longitude];
    
    [query whereKey:@"location" nearGeoPoint:point withinMiles:kMapRegionDelta_miles];
    [query includeKey:@"address"];
    [query includeKey:@"parkingSchedule"];
    return query;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    
    [self updateLocationSearchResult:searchString];
    
    if (self.searchController.searchResultsController) {
        
        LocationSearchResultTableViewController *vc = (LocationSearchResultTableViewController *)self.searchController.searchResultsController;
        
        // Update searchResults
        vc.searchResults = self.locationSearchResults;
        vc.callViewController = self;
        
        // And reload the tableView with the new data
        [vc.tableView reloadData]; 
    }
}

-(void)updateLocationSearchResult:(NSString *)searchString
{
    // cancel previous in flight geocoding
    [_geoCoder cancelGeocode];
    
    if ([searchString length]>=3) {
        // add minimal delay to search to avoid searching for something outdated
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(_performGeocodingForString:) withObject:searchString afterDelay:0.1];
    }
    else
    {
        // reset search results table immediately
        self.locationSearchResults = nil;
    }
}

- (void)_performGeocodingForString:(NSString *)searchString
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [_geoCoder geocodeAddressString:searchString completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error)
        {
            self.locationSearchResults = placemarks;
        }
        else
        {
            NSLog(@"CLGeocoder error: %@", error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.navigationItem.leftBarButtonItems = @[];
    self.navigationItem.rightBarButtonItems = @[];
    self.navigationItem.hidesBackButton = YES;
    self.searchController.searchBar.showsCancelButton = YES;
    LocationSearchResultTableViewController *vc = (LocationSearchResultTableViewController *)self.searchController.searchResultsController;
    
    // Present SearchResultsTableViewController as the topViewController
    //LocationSearchResultTableViewController *vc = (LocationSearchResultTableViewController *)navController.topViewController;
    vc.tableView.hidden = NO;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.navigationItem.leftBarButtonItem = self.menuButton;
    self.navigationItem.rightBarButtonItem = self.listButton;
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
}
- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController.searchBar resignFirstResponder];
    [_searchController.searchBar setShowsCancelButton:NO animated:NO];
    //[self showCurrentView];
}

#pragma mark - table
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.valetParkings && self.valetParkings.count > 0) {
        self.searchTableView.backgroundView = nil;
        self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No Vazoom parking is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"System" size:20];
        [messageLabel sizeToFit];
        
        self.searchTableView.backgroundView = messageLabel;
        self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.valetParkings.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:false];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ValetParkingLocationCell";
    
    ValetParkingLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ValetParkingLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    VZParking *valetParking = [self.valetParkings objectAtIndex:indexPath.row];
    [self populateCell:cell with:valetParking];
    return cell;
}

-(void)populateCell:(ValetParkingLocationCell *)cell with:(VZParking *)valetParking
{
    cell.name.text = valetParking.parkingName;
    cell.address.text = [self getParkingAddressTextFormat:valetParking.address];
    cell.phone.text = valetParking.phoneNumber;
    cell.status.text = [self getParkingStatus:valetParking];
    cell.price.text = valetParking.price;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"openReservationDialog" sender:self];
}
-(void)getLatestVazoomParking
{
    NSLog(@"pull to refresh");
    [self reloadData];
}

#pragma mark - map
float MilesToMeters(float miles) {
    return 1609.344f * miles;
}
-(NSString *)getParkingAddressTextFormat:(ParkingAddress *)address
{
    return [NSString stringWithFormat:@"%@ %@, %@, %@ %@",address.propertyNumber,address.street, address.city, address.state, address.zipcode];
}

-(NSString *)getParkingStatus:(VZParking *)parking
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger _weekday = [calendar component:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSString *weekday = @"";
    switch (_weekday) {
        case 1: //sun
            weekday = [NSString stringWithFormat:@"Sun: %@",parking.schedule.Sun];
            break;
        case 2: //mon
            weekday = [NSString stringWithFormat:@"Mon: %@",parking.schedule.Mon];
            break;
        case 3: //tue
            weekday = [NSString stringWithFormat:@"Tue: %@",parking.schedule.Tue];
            break;
        case 4: //wed
            weekday = [NSString stringWithFormat:@"Wed: %@",parking.schedule.Wed];
            break;
        case 5: //thu
            weekday = [NSString stringWithFormat:@"Thu: %@",parking.schedule.Thu];
            break;
        case 6: //fri
            weekday = [NSString stringWithFormat:@"Fri: %@",parking.schedule.Fri];
            break;
        case 7: //sat
            weekday = [NSString stringWithFormat:@"Sat: %@",parking.schedule.Sat];
            break;
        default:
            break;
    }
    
    NSString *status = [NSString stringWithFormat:@"%@",weekday];
    return status;
}
-(void)focusMaptoLocation:(CLLocation *)location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, MilesToMeters(kMapRegionDelta_miles), MilesToMeters(kMapRegionDelta_miles));
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

-(void)showOnMapSearchResults:(NSArray *) parkings
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (VZParking *parking in parkings) {
        [self addAnnotation:parking];
    }
    
}
-(void)addAnnotation:(VZParking *)parking
{
    VZMapAnnotation *vzAnnotation =
    [[VZMapAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake(parking.location.latitude, parking.location.longitude)
                                       placeName:parking.parkingName
                                     description:[self getParkingAddressTextFormat:parking.address]
                                    parkingPrice:parking.price];
    [self.mapView addAnnotation:vzAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[VZMapAnnotation class]]) {
        VZMapAnnotation *vzMapAnnotation = (VZMapAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:kVZMapAnnotationIdentifier];
        if (annotationView == nil) {
            annotationView = vzMapAnnotation.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    } else {
        return nil;
    }
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[VZMapAnnotation class]]){
        VZMapAnnotation *annotation = (VZMapAnnotation *)view.annotation;
        [annotation setSelectedView:view];
        [self focusMaptoLocation:[[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude]];
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[VZMapAnnotation class]]){
        VZMapAnnotation *annotation = (VZMapAnnotation *)view.annotation;
        [annotation setDeselectedView:view];
    }
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"openReservationDialog" sender:self];
}
@end
