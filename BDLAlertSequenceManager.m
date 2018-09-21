//
//  BDLAlertSequenceManager.m
//  TangTradePlatform
//
//  Created by flh-qkl on 2018/9/20.
//  Copyright © 2018年 com.tang.trade. All rights reserved.
//

#import "BDLAlertSequenceManager.h"

static BDLAlertSequenceManager *manager = nil;
static BOOL isGenesis = YES;
@interface BDLAlertSequenceManager ()
@property (nonatomic)dispatch_semaphore_t sema;
@property (nonatomic)dispatch_queue_t sequenceQueue;
@end

@implementation BDLAlertSequenceManager
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [BDLAlertSequenceManager new];
        }
    });
    return manager;
}

- (void)commitTransaction:(Transaction)transaction{
    if (transaction) {
        dispatch_async(self.sequenceQueue, ^{
            if (!isGenesis) {
                dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
            }
            isGenesis = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                transaction();
            });
        });
    }
}

- (void)free{
    dispatch_semaphore_signal(self.sema);
}

#pragma mark - lazy loading
- (dispatch_queue_t)sequenceQueue{
    if (!_sequenceQueue) {
        _sequenceQueue = dispatch_queue_create("alert_sq_queue", DISPATCH_QUEUE_SERIAL);
    }
    return _sequenceQueue;
}
- (dispatch_semaphore_t)sema{
    if (!_sema) {
        _sema = dispatch_semaphore_create(0);
    }
    return _sema;
}
@end
