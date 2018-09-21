//
//  BDLAlertSequenceManager.h
//  TangTradePlatform
//
//  Created by flh-qkl on 2018/9/20.
//  Copyright © 2018年 com.tang.trade. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Transaction)();
@interface BDLAlertSequenceManager : NSObject
+ (instancetype)shareInstance;
- (void)commitTransaction:(Transaction)transaction;
- (void)free;
@end
