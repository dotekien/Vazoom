//
//  MainNavigationController.m
//  Vazoom
//
//  Created by Kien Do on 6/28/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "MainNavigationController.h"
#import "MenuViewController.h"
#import "CustomTransitioning.h"

@interface MainNavigationController ()

//@property (weak, nonatomic) MapViewController *mapViewController;
//@property (weak, nonatomic) ReservationViewController *reservationViewController;

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:
(UINavigationController *)navigationController
                                  animationControllerForOperation:
(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    NSLog(@"%@",[self viewControllers]);
    CustomTransitioning *transitioning = [[CustomTransitioning alloc] init];
    if ([fromVC isKindOfClass:[MenuViewController class]] ||
        [toVC isKindOfClass:[MenuViewController class]]) {
        NSLog(@"custom transition");
        NSLog(@"from: %@",fromVC);
        NSLog(@"to: %@",toVC);
        BOOL forward = operation == UINavigationControllerOperationPush;
        transitioning.transitionType = forward ? kCustomSlideDownTransition : kCustomSlideUpTransition;
        transitioning.duration = 0.6;
    } else {
        NSLog(@"Default transition");
        transitioning.transitionType = kCustomFadeInTransition;
        transitioning.duration = 0.6;
        NSLog(@"from: %@",fromVC);
        NSLog(@"to: %@",toVC);
    }
    return transitioning;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
