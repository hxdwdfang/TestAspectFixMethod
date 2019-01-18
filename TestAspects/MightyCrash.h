//
//  MightyCrash.h
//  TestAspects
//
//  Created by wdfang122 on 2019/1/18.
//  Copyright © 2019 王定方. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MightyCrash : NSObject
+ (float)divideUsingDenominator:(NSInteger)denominator;
///测试JS调native的方法
+ (id)testJSCallClassNativeMethod:(id)firstParam otherParams:(id)otherParams;
- (id)testJSCallInstanceNativeMethod:(id)firstParam otherParams:(id)otherParams;
@end

NS_ASSUME_NONNULL_END
