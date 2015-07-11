//
//  SlideDownTransition.m
//  Vazoom
//
//  Created by Kien Do on 6/30/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "CustomTransitioning.h"
@import CoreGraphics;

@implementation CustomTransitioning
- (instancetype) init
{
    if (!(self = [super init])) return self;
    _duration = 1.0; // default
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (_transitionType)
    {
        case kCustomFadeInTransition:
            [self animateFadeInTransition:transitionContext];
            break;
        case kCustomFadeOutTransition:
            [self animateFadeOutTransition:transitionContext];
            break;
        case kCustomSlideDownTransition:
            [self animateSlideDownTransition:transitionContext];
            break;
        case kCustomSlideUpTransition:
            [self animateSlideUpTransition:transitionContext];
            break;
        default:
            [self animateFadeOutTransition:transitionContext];
            break;
    }
}

- (void)animateSlideDownTransition:
(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];

    toViewController.view.transform = CGAffineTransformMakeTranslation(0, -fromViewController.view.frame.size.height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)animateSlideUpTransition:
(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    [[transitionContext containerView] addSubview:fromViewController.view];
    fromViewController.view.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation(0, -fromViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        [fromViewController.view removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)animateFadeOutTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Retrieve context players
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // Set up container
    //[containerView addSubview:fromController.view];
    [containerView addSubview:toController.view];
    
    // Establish initial state
    toController.view.alpha = 1.0f;
    
    // Perform animation
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        toController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)animateFadeInTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Retrieve context players
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // Set up container
    //[containerView addSubview:fromControlle
    [containerView addSubview:toController.view];
    
    // Establish initial state
    toController.view.alpha = 0.5f;
    
    // Perform animation
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        toController.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}
@end
