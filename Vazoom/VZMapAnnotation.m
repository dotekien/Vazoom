//
//  VZMapAnnotation.m
//  Vazoom
//
//  Created by Kien Do on 7/10/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "VZMapAnnotation.h"
#import "Constants.h"

@implementation VZMapAnnotation

-(id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description parkingPrice:(NSString *)price
{
    if (self=[super init]) {
        _coordinate = location;
        _title = placeName;
        _subTitle = description;
        _price = price;
    }
    return self;
}
-(MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:kVZMapAnnotationIdentifier];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"pin"];
    //annotationView.backgroundColor = [UIColor blackColor];
    annotationView.tintColor = [UIColor orangeColor];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(annotationView.frame.size.width/2 - 10.0, 5, 20.0, 20.0)];
    priceLabel.textColor = [UIColor whiteColor];
    //priceLabel.backgroundColor = [UIColor greenColor];
    priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:(12.5)];
    priceLabel.text = self.price;
    priceLabel.tag = 1;
    [annotationView addSubview:priceLabel];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}
-(void)setSelectedView:(MKAnnotationView *)annotationView
{
    annotationView.image = [UIImage imageNamed:@"selectedPin"];
    //UILabel *priceLabel = (UILabel *)[annotationView viewWithTag:1];
    //priceLabel.textColor = [UIColor blueColor];
}
-(void)setDeselectedView:(MKAnnotationView *)annotationView
{
    annotationView.image = [UIImage imageNamed:@"pin"];
}
@end

