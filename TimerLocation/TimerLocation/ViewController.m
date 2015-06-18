//
//  ViewController.m
//  TimerLocation
//
//  Created by xiaerfei on 15/6/15.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//

#import "ViewController.h"
#import "TimerLocation.h"

@interface ViewController ()
- (IBAction)startLocation:(id)sender;
- (IBAction)stopLocation:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    TimerLocation *timerLocation = [TimerLocation shareInstance];
//    [timerLocation configTimerAndLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startLocation:(id)sender {
    TimerLocation *timerLocation = [TimerLocation shareInstance];
    [timerLocation startLocation];
    
}

- (IBAction)stopLocation:(id)sender {
    TimerLocation *timerLocation = [TimerLocation shareInstance];
    [timerLocation stopLocation];
}
@end
