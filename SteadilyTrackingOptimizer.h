//
//  SteadilyTrackingHelper.h
//  Face_meal
//
//  Created by 沙少盼 on 2017/11/6.
//  Copyright © 2017年 fu. All rights reserved.

/**
 滑动视图滑动优化器，解决滑动时某些耗时加载卡顿滑动手感，比如加载大图等
 maxQueueCount表示最大处理任务数，此数据最好是当前页面显示的cell个数+1行，以保证页面数据正常刷新显示
 一般使用方式是先初始化一个优化器 --> 添加优化器 --> 在滑动试图中，将耗时的UI加载操作丢到addTask方法的block中即可优化完成，尽量减少task中的任务数。
 */

#import <Foundation/Foundation.h>

typedef void(^taskBlock)(void);

@interface SteadilyTrackingOptimizer : NSObject
/**
 将任务添加到优化器中

 @param task 要执行的UI任务
 @param activity 选择在runloop的什么状态下执行此任务
 @param maxQueue 此任务的最大任务数
 @param isTrcking 是否是滑动视图的tracking模式
 */
- (void)addTaskInTime:(CFRunLoopActivity)activity
             maxQueue:(NSUInteger)maxQueue
           isTracking:(BOOL)isTrcking
                 task:(taskBlock)task;

/**
 添加优化器，最好在viewWillApper中执行
 */
- (void)addOptimizer;

/**
 移除优化器，最好在界面消失时执行
 */
- (void)removeOptimizer;
@end
