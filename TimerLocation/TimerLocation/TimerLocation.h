//
//  TimerLocation.h
//  TimerLocation
//
//  Created by xiaerfei on 15/6/15.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class TimerLocation;
@protocol TimerLocationDelegate <NSObject>

@optional
- (void)timerLocation:(TimerLocation *)timerLocation location:(CLLocationCoordinate2D)coordinate;

@end

@interface TimerLocation : NSObject

/// 开始时间 默认 09:00
@property (nonatomic,assign) NSInteger beginTime;
/// 结束时间 默认 18:00
@property (nonatomic,assign) NSInteger endTime;
/// 上传数据时间间隔 以秒为单位 默认一小时  3600秒
@property (nonatomic,assign) NSInteger timerInterval;
/// app 是否被kill
@property (nonatomic,assign) BOOL isAfterResume;

@property (nonatomic,assign) BOOL isBackgroundFetch;

@property (nonatomic,copy) NSString *appstate;
/// background fetch 回调
@property (nonatomic,copy) void (^backgroundFetch)();

@property (nonatomic,assign) BOOL shouldStartMonitoringSignificantLocation;

@property (nonatomic,strong) CLLocationManager *loactionManager;

/// TimerLocationDelegate
@property (nonatomic,assign) id <TimerLocationDelegate> delegate;

+ (id)shareInstance;

- (void)configTimerAndLocation;

///注： stop 之后重新启动定位才能使用
- (void)startLocation;

- (void)stopLocation;

- (NSString *)getCurrentTime;

@end
