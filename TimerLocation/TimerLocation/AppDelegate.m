//
//  AppDelegate.m
//  TimerLocation
//
//  Created by xiaerfei on 15/6/15.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//

#import "AppDelegate.h"
#import "TimerLocation.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{
        // When there is a significant changes of the location,
        // The key UIApplicationLaunchOptionsLocationKey will be returned from didFinishLaunchingWithOptions
        // When the app is receiving the key, it must reinitiate the locationManager and get
        // the latest location updates
        
        // This UIApplicationLaunchOptionsLocationKey key enables the location update even when
        // the app has been killed/terminated (Not in th background) by iOS or the user.
        if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
            //you are given a small amount of time (around 10 seconds) to manually restart location services and process the location data
            // When an app is relaunched because of a location update, the launch options dictionary passed to your "application:willFinishLaunchingWithOptions: "or "application:didFinishLaunchingWithOptions: "method contains the "UIApplicationLaunchOptionsLocationKey" key
            TimerLocation *timerLocation = [TimerLocation shareInstance];
            timerLocation.isAfterResume  = YES;
            timerLocation.shouldStartMonitoringSignificantLocation = YES;
            timerLocation.loactionManager = nil;
            [timerLocation configTimerAndLocation];
        }
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    TimerLocation *timerLocation = [TimerLocation shareInstance];
    [timerLocation stopLocation];
    timerLocation.shouldStartMonitoringSignificantLocation = YES;
    timerLocation.loactionManager = nil;
    [timerLocation configTimerAndLocation];

    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    TimerLocation *timerLocation = [TimerLocation shareInstance];
    timerLocation.shouldStartMonitoringSignificantLocation = NO;
    timerLocation.loactionManager = nil;
    [timerLocation configTimerAndLocation];

    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {

    NSLog(@"applicationWillTerminate");
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    TimerLocation *timerLocation = [TimerLocation shareInstance];
    [timerLocation configTimerAndLocation];
    [timerLocation setBackgroundFetch:^{
        NSLog(@"结束----->UIBackgroundFetchResultNewData");
        completionHandler(UIBackgroundFetchResultNewData);
    }];
}


@end
