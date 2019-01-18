//
//  WPTHFix+CallNative.m
//  TestAspects
//
//  Created by wdfang122 on 2019/1/18.
//  Copyright © 2019 王定方. All rights reserved.
//

#import "WPTHFix+CallNative.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>

@implementation WPTHFix (CallNative)

///启动注册
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [WPTHFix injectCallNativeMethods];
    });
}

+ (void)injectCallNativeMethods {
    ///js里调用native方法
    [self context][@"runNativeMethod"] = ^id(NSString *className, NSString *selectorName, id firstParam, ...) {
        ///获取js所有参数
        NSArray *args = [JSContext currentArguments];
        return [self invocationMethod:className selectorName:selectorName params:args];
    };
    
    [self context][@"runVoidNativeMethod"] = ^(NSString *className, NSString *selectorName, id firstParam, ...) {
        ///获取js所有参数
        NSArray *args = [JSContext currentArguments];
        [self invocationMethod:className selectorName:selectorName params:args];
    };
    
    [self context][@"runInstanceNativeMethod"] = ^id(id instance, NSString *selectorName, id firstParam, ...) {
        ///获取js所有参数
        NSArray *args = [JSContext currentArguments];
        return [self invocationInstanceMethod:instance selectorName:selectorName params:args];
    };
    
    [self context][@"runVoidInstanceNativeMethod"] = ^(id instance, NSString *selectorName, id firstParam, ...) {
        ///获取js所有参数
        NSArray *args = [JSContext currentArguments];
        [self invocationInstanceMethod:instance selectorName:selectorName params:args];
    };
    
    [self context][@"runInvocation"] = ^(NSInvocation *invocation) {
        [invocation invoke];
    };
    
    // helper
    [[self context] evaluateScript:@"var console = {}"];
    [self context][@"console"][@"log"] = ^(id message) {
        NSLog(@"Javascript log: %@",message);
    };
}


+ (id)invocationMethod:(NSString *)className selectorName:(NSString *)selectorName params:(NSArray *)params {
    Class class = NSClassFromString(className);
    return [self invocationMetohdWithTarget:class selectorName:selectorName params:params];
}

+ (id)invocationInstanceMethod:(id)instance selectorName:(NSString *)selectorName params:(NSArray *)params {
    ///如果是字符串的，先转成类,再创建实例
    if ([instance isKindOfClass:[NSString class]]) {
        instance = NSClassFromString(instance);
    }
    typeof(instance) instanceOf = [instance new];
    return [self invocationMetohdWithTarget:instanceOf selectorName:selectorName params:params];
}

///类方法与实例方法生成的invocation不一样，调用都是一样的
+ (id)invocationMetohdWithTarget:(id)target selectorName:(NSString *)selectorName params:(NSArray *)params {
    if (!target || !selectorName.length) {
        NSLog(@"parameter invaildate");
        return nil;
    }
    SEL sel = NSSelectorFromString(selectorName);
    NSMethodSignature *signature = [target methodSignatureForSelector:sel];
    if (!signature) {
        NSLog(@"No NSMethodSignature from selector");
        return nil;
    }
    ///NSinvocation不支持可变参数，带查找一个通过可变参数拼接一个signature的方法
    //根据方法签名创建一个NSInvocation
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    
    //设置被调用的消息
    [invocation setSelector:sel];
    
    //如果此消息有参数需要传入，那么就需要按照如下方法进行参数设置，需要注意的是，atIndex的下标必须从2开始。原因为：0 1 两个参数已经被target 和selector占用
    NSInteger count = [signature numberOfArguments];
    ///前面有target与selector，所以index是从2开始的
    for (NSInteger index = 2; index < params.count && index < count; index++) {
        JSValue *value = params[index];
        id param = value.toObject;
        NSLog(@"%@",param);
        [invocation setArgument:&param atIndex:index];
    }
    
    //retain 所有参数，防止参数被释放dealloc
    [invocation retainArguments];
    //消息调用
    [invocation invoke];
    
    void * returnValue = NULL;
    if (signature.methodReturnLength) {
        [invocation getReturnValue:&returnValue];
        NSLog(@"%@",returnValue);
    }
    
    return (__bridge id)returnValue;
}


@end
