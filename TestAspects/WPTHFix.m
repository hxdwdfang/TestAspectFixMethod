//
//  WPTHFix.m
//  TestAspects
//
//  Created by wdfang122 on 2019/1/18.
//  Copyright © 2019 王定方. All rights reserved.
//

#import "WPTHFix.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation WPTHFix
///注入修复JS文件
+ (void)evalString:(NSString *)javascriptString {
    [[self context] evaluateScript:javascriptString];
}

+ (JSContext *)context {
    static JSContext *_context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      _context = [[JSContext alloc] init];
      [_context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"Oops: %@", value);
      }];
    });
    return _context;
}
@end

