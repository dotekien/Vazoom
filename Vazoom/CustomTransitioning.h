//
//  SlideDownTransition.h
//  Vazoom
//
//  Created by Kien Do on 6/30/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    kCustomSlideDownTransition,
    kCustomSlideUpTransition,
    kCustomFadeInTransition,
    kCustomFadeOutTransition
} CustomTransitionType;
@interface CustomTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic) CGFloat duration;
@property (nonatomic) CustomTransitionType transitionType;
@end
