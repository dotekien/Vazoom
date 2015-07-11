//
//  VZMapAnnotation.h
//  Vazoom
//
//  Created by Kien Do on 7/10/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VZMapAnnotation : NSObject<MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subTitle;
@property (nonatomic, readonly, copy) NSString *price;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description parkingPrice:(NSString*) price;
-(MKAnnotationView *)annotationView;
-(void)setSelectedView:(MKAnnotationView *)annotationView;
-(void)setDeselectedView:(MKAnnotationView *)annotationView;
@end
