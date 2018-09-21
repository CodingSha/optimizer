//
//  GCDTimer.m
//  Face_meal
//
//  Created by funny on 2017/12/20.
//  Copyright © 2017年 fu. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer ()

/**
 定时器
 */
@property (nonatomic)dispatch_source_t timer;
@end

@implementation GCDTimer

/**
 init

 @param sec 延迟多久执行，单位为s
 @param padding_sec 计时间隔，单位为s
 @param task 执行的任务
 @return
 */
- (instancetype)initWithStartAfter:(CGFloat)sec
                           padding:(CGFloat)padding_sec
                              task:(task)task{
    if (self = [super init]) {
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                            0,
                                            0,
                                            queue);
        //开始时间
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW,
                                              sec * NSEC_PER_SEC);
        //间隔时间
        uint64_t interval = padding_sec * NSEC_PER_SEC;
        dispatch_source_set_timer(self.timer,
                                  start,
                                  interval,
                                  0);
        //设置回调
        if (task) {
            dispatch_source_set_event_handler(self.timer,
                                              task);
        }
        self.statues = GCDTimerNeedResume;
    }
    return self;
}

/**
 恢复
 */
- (void)resume{
    if (self.timer && (self.statues == GCDTimerNeedResume ||self.statues == GCDTimerSuspend)) {
        dispatch_resume(self.timer);
        self.statues = GCDTimerWorking;
    }
}

/**
 挂起
 */
- (void)suspend{
    if (self.timer) {
        dispatch_suspend(self.timer);
        self.statues = GCDTimerSuspend;
    }
}

- (void)cancle{
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
}
@end
