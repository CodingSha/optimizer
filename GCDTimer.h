//
//  GCDTimer.h
//  Face_meal
//
//  Created by funny on 2017/12/20.
//  Copyright © 2017年 fu. All rights reserved.
//  GCD计时器封装

#import <Foundation/Foundation.h>

typedef void (^task)();
typedef NS_ENUM(NSUInteger,GCDTimerStatues) {
    GCDTimerNeedResume,
    GCDTimerWorking,
    GCDTimerSuspend,
};
@interface GCDTimer : NSObject
@property (nonatomic, assign)GCDTimerStatues statues;
/**
 init

 @param sec 延迟多少s执行
 @param padding_sec 间隔多少秒
 @param task 要执行的任务
 @return instancetype id
 */
- (instancetype)initWithStartAfter:(CGFloat)sec
                           padding:(CGFloat)padding_sec
                              task:(task)task;

/**
 启动或恢复启动
 */
- (void)resume;

/**
 挂起
 */
- (void)suspend;
- (void)cancle;
@end
