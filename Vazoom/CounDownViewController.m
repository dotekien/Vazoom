//
//  CounDownViewController.m
//  Vazoom
//
//  Created by Kien Do on 7/7/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "CounDownViewController.h"

@interface CounDownViewController ()
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *timeCoundownLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end
static float MAX_MINUTE = 5.0 * 60;
static int counter = 5 * 60;
static int minutes = 5;
static int seconds = 0;
@implementation CounDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showMinutes:minutes seconds:seconds];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateLabel:)
                                                userInfo:nil
                                                 repeats:YES ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLabel:(id)sender{
    if (counter == 0) {
        [self killTimer];
    } else {
        counter = counter -1;
        if (seconds == 0) {
            seconds = 60;
            minutes = minutes -1 ;
        }
        seconds = seconds -1;
        [self showMinutes:minutes seconds:seconds];
    }
}
-(void)showMinutes:(int)minuts seconds:(int)seconds
{
    NSString *secondText = [NSString stringWithFormat:@"%i",seconds];
    if (seconds<10) {
        secondText = [NSString stringWithFormat:@"0%i",seconds];
    }
    self.timeCoundownLabel.text = [NSString stringWithFormat:@"%i:%@",minuts,secondText];
    self.progressView.progress = counter/MAX_MINUTE;
}

- (void)killTimer{
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    [self showMinutes:0 seconds:0];
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
