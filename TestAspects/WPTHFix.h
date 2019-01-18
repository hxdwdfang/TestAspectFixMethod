//
//  WPTHFix.h
//  TestAspects
//
//  Created by wdfang122 on 2019/1/18.
//  Copyright © 2019 王定方. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JSContext;
@interface WPTHFix : NSObject
+ (JSContext *)context;
+ (void)evalString:(NSString *)javascriptString;
@end

NS_ASSUME_NONNULL_END
