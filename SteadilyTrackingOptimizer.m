//
//  SteadilyTrackingHelper.m
//  Face_meal
//
//  Created by 沙少盼 on 2017/11/6.
//  Copyright © 2017年 fu. All rights reserved.
//

#import "SteadilyTrackingOptimizer.h"

#define DEFULT_MAX_QUEUE_COUNT 100
@interface SteadilyTrackingOptimizer ()
{
    CFRunLoopRef _runloop;
    CFRunLoopObserverRef _runloopO;
}
@property (nonatomic,copy)NSMutableDictionary *tasks;

//@property (nonatomic,strong)NSTimer *timer;
@end

@implementation SteadilyTrackingOptimizer

- (instancetype)init{
    if (self = [super init]) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(runloopTimer) userInfo:nil repeats:YES];
        [self initObserver];
    }
    return self;
}
//- (void)runloopTimer{}

- (NSMutableDictionary *)tasks{
    if (!_tasks) {
        _tasks = @{}.mutableCopy;
    }
    return _tasks;
}

- (void)addTaskInTime:(CFRunLoopActivity)activity
             maxQueue:(NSUInteger)maxQueue
           isTracking:(BOOL)isTrcking
                 task:(taskBlock)task{
    
    NSMutableArray *tasks = [self.tasks objectForKey:@(activity)];
    if (!tasks) {
        tasks = @[].mutableCopy;
    }
    [tasks addObject:task];
    
    if (isTrcking && tasks.count > (maxQueue ? maxQueue : DEFULT_MAX_QUEUE_COUNT)) {
        [tasks removeObjectAtIndex:0];
    }
    [self.tasks setObject:tasks forKey:@(activity)];
}

static void CallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    SteadilyTrackingOptimizer *optimizer = (__bridge SteadilyTrackingOptimizer *)info;
    NSMutableArray *tasks = [optimizer.tasks objectForKey:@(activity)];
    if (tasks.count == 0) {
        return;
    }
    taskBlock task = tasks.firstObject;
    if (task) {
        task();
        [tasks removeObject:task];
        [optimizer.tasks setObject:tasks forKey:@(activity)];
    }
}
- (void)initObserver{
    //拿到当前runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    _runloop = runloop;
    //定义一个观察者
    static CFRunLoopObserverRef defultModeO;
    //定义一个上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    defultModeO = CFRunLoopObserverCreate(NULL, kCFRunLoopAllActivities, YES, 0, &CallBack, &context);
    _runloopO = defultModeO;
}
- (void)addOptimizer{
    //添加观察者
    if (!_runloopO || !_runloop) {
        [self initObserver];
    }
    CFRunLoopAddObserver(_runloop, _runloopO, kCFRunLoopCommonModes);
}
- (void)removeOptimizer{
    //移除观察者
    CFRunLoopRemoveObserver(_runloop, _runloopO, kCFRunLoopCommonModes);
}
- (void)dealloc{
    NSLog(@"Optimizer dealloc");
}
@end
