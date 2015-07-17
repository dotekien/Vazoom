//
//  Constants.h
//  Vazoom
//
//  Created by Kien Do on 7/1/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kSegueID_openMenuView;
extern NSString *const kSegueID_openMapView;
extern NSString *const kSegueID_openReservationView;
extern NSString *const kSegueID_openPickMyCarView;
extern NSString *const kSegueID_openVehiclesView;
extern NSString *const kSegueID_openPaymentMethodView;
extern NSString *const kSegueID_openAccountView;
extern NSString *const kSegueID_openPromotionView;
extern NSString *const kSegueID_openShareView;
extern NSString *const kSegueID_openHelpView;

extern NSString *const kMenuItem_find_parking;
extern NSString *const kMenuItem_reservations;
extern NSString *const kMenuItem_pick_my_car;
extern NSString *const kMenuItem_vehicles;
extern NSString *const kMenuItem_payment_methods;
extern NSString *const kMenuItem_account;
extern NSString *const kMenuItem_promotions;
extern NSString *const kMenuItem_share;
extern NSString *const kMenuItem_help;

extern float const kMapRegionDelta_miles;
extern NSString *const kVZMapAnnotationIdentifier;

@interface Constants : NSObject
@end
