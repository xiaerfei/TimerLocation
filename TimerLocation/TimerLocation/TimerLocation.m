//
//  TimerLocation.m
//  TimerLocation
//
//  Created by xiaerfei on 15/6/15.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//工作时间内（9：00-18：00），app每隔一段时间（如1小时），上传Location信息至服务器

#import "TimerLocation.h"

#define kLastTime @"LastTime"

@interface TimerLocation ()<CLLocationManagerDelegate>

@property (nonatomic,assign) BOOL timerIsValid;

@end

@implementation TimerLocation
{
    NSInteger _timerCount;
    BOOL      _isWriteToServer;
}

+ (id)shareInstance
{
    static id _f = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!_f) {
            _f = [[TimerLocation alloc] init];
        }
    });
    return _f;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _beginTime = 0;
        _endTime   = 60;
    }
    return self;
}


- (void)configTimerAndLocation
{
    [self initLocation];
}
#pragma mark - 获取系统时间
- (BOOL)systemTime
{
    NSString *lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastTime];
    NSArray *timeArr = [[self getCurrentTime] componentsSeparatedByString:@"-"];
    
    NSInteger time = [timeArr[3] integerValue];
    //判断是否在工作时间内
    if (time < _beginTime || time > _endTime) {
        return NO;
    }
    //判断与上一次的间隔时间
    if (lastTime.length != 0) {
        double timeInterval = [self getTimeIntervalWithDate:lastTime];
        if (timeInterval < 10) {
            return NO;
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:[self getCurrentTime] forKey:kLastTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

- (double)getTimeIntervalWithDate:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSDate *date1 = [formatter dateFromString:date];
    NSDate *date2 = [NSDate date];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    
    return aTimer;
}


#pragma mark - CLLocationManager
- (void)initLocation
{
    if (!_loactionManager) {
        _loactionManager = [[CLLocationManager alloc] init];
        _loactionManager.delegate = self;
        [self beginLocation];
    } else {
            [self startLocation];
    }
}

- (void)beginLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        //定位功能可用，开始定位
        if ( [[UIDevice currentDevice].systemVersion floatValue] > 7.99) {
            [_loactionManager requestAlwaysAuthorization];
        } else {
            if (_shouldStartMonitoringSignificantLocation) {
                [_loactionManager startMonitoringSignificantLocationChanges];
            } else {
                [_loactionManager startUpdatingLocation];
            }
        }
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"定位功能不可用，提示用户或忽略");
    }
}

- (void)startLocation
{
    if (_shouldStartMonitoringSignificantLocation) {
        _loactionManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _loactionManager.activityType = CLActivityTypeOtherNavigation;
        [_loactionManager startMonitoringSignificantLocationChanges];
    } else {
        [_loactionManager startUpdatingLocation];
    }
}


- (void)stopLocation
{
    if (_shouldStartMonitoringSignificantLocation) {

    } else {
        [_loactionManager stopUpdatingLocation];
    }
}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        if ([_loactionManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_loactionManager requestAlwaysAuthorization];
            [self startLocation];
        }
    } else if (status == kCLAuthorizationStatusDenied) {
        //用户不允许使用应用
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self stopLocation];
    CLLocationCoordinate2D coordinate;
    for (CLLocation *loc in locations) {
        coordinate.longitude = loc.coordinate.longitude;
        coordinate.latitude  = loc.coordinate.latitude;
        NSLog(@"经度:%f,纬度:%f",loc.coordinate.longitude,loc.coordinate.latitude);
    }

    
    if ([_delegate respondsToSelector:@selector(timerLocation:location:)]) {
        [_delegate timerLocation:self location:coordinate];
    }
    
//    BOOL timeRet = [self systemTime];
    // TODO: 是否在工作时间内
    if (1) {
        // TODO: 上传数据
        NSDictionary *dic = @{[self getCurrentTime]:@{@"longitude":@(coordinate.longitude),
                                                      @"latitude":@(coordinate.latitude),
                                                      @"isAfterResume":@(_isAfterResume),
                                                      @"isBackgroundFetch":@(_isBackgroundFetch),
                                                      @"appstate":_appstate}};
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *docPath = [paths lastObject];
        NSString *path = [docPath stringByAppendingPathComponent:@"loc.plist"];
        
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        if (!mutableDict) {
            mutableDict = [[NSMutableDictionary alloc] init];
        }
        [mutableDict addEntriesFromDictionary:dic];
        NSLog(@"%@",path);
        
        BOOL ret = [mutableDict writeToFile:path atomically:NO];
        if (ret) {
            NSLog(@"写成功");
        } else {
            NSLog(@"写失败");
        }
        if (_backgroundFetch) {
            _backgroundFetch();
        }
    }
}

@end
