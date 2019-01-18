//
//  ViewController.m
//  TestAspects
//
//  Created by wdfang122 on 2019/1/18.
//  Copyright © 2019 王定方. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "MightyCrash.h"
#import "WPTHFix.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupSubviews];
    
    [self fixCrash];
}


- (void)setupSubviews {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"carsh" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testCrash:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 4;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(100);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(150);
    }];
}

- (void)testCrash:(id)sender {
    float result = [MightyCrash divideUsingDenominator:3];
    NSLog(@"result: %.3f", result);
    result = [MightyCrash divideUsingDenominator:0];
    NSLog(@"won't crash");
}


- (void)fixCrash {
    NSString *fixScriptString = @" \
    fixClassMethodReplace('MightyCrash', 'divideUsingDenominator:', function(instance, originInvocation, originArguments){ \
    if (originArguments[0] == 0) { \
    console.log('zero goes here'); \
    } else { \
    runInvocation(originInvocation); \
    runNativeMethod('MightyCrash', 'testJSCallClassNativeMethod:otherParams:', 'One', 'Two', 'Three'); \
    runInstanceNativeMethod('MightyCrash', 'testJSCallInstanceNativeMethod:otherParams:', 'One', 'Two', 'Three'); \
    } \
    }); ";
    
    [WPTHFix evalString:fixScriptString];

}

@end
