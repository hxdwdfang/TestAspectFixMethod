//
//  MightyCrash.m
//  TestAspects
//
//  Created by wdfang122 on 2019/1/18.
//  Copyright © 2019 王定方. All rights reserved.
//

#import "MightyCrash.h"

@implementation MightyCrash
// 传一个 0 就 gg 了
+ (float)divideUsingDenominator:(NSInteger)denominator {
    return 1.f / denominator;
}


+ (id)testJSCallClassNativeMethod:(id)firstParam otherParams:(id)otherParams {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"firstParams = %@, otherParams = %@", firstParam, otherParams);
    
    return @"result";
}

- (id)testJSCallInstanceNativeMethod:(id)firstParam otherParams:(id)otherParams {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"firstParams = %@, otherParams = %@", firstParam, otherParams);
    
    return @"result";
}
@end
