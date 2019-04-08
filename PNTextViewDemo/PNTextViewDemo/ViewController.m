//
//  ViewController.m
//  PNTextViewDemo
//
//  Created by 刘攀妞 on 2019/4/8.
//  Copyright © 2019年 刘攀妞. All rights reserved.
//

#import "ViewController.h"
#import "PNTextView.h"
#import "Masonry.h"
#import <SafariServices/SafariServices.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


@interface ViewController ()<SFSafariViewControllerDelegate>
@property (nonatomic, weak) PNTextView *textView;
/// 显示剩余字数
@property (nonatomic, weak) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///1  文本框
    PNTextView *textView = [[PNTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:18.0];
    textView.placeholderText = @"请输入姓名";
    textView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:textView];
    self.textView = textView;
    textView.maxTextLength = 30;  // 输入最大长度
    textView.emoticonsDisEnable = YES;  // 是否可输入表情
    
    // textView与masonry绝配 高度不固定
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.left.mas_equalTo(10);
        make.width.mas_offset(SCREEN_WIDTH - 10 * 2);
        
    }];
    
    
    
    //2  分割线1
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor redColor];
    [self.view addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(5);
        make.left.equalTo(self.view).mas_offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 10 * 2);
        make.height.mas_equalTo(1);
    }];
    
    
    ///3  显示剩余个数
    UILabel *lastLength = [[UILabel alloc] init];
    lastLength.backgroundColor = [UIColor greenColor];
    lastLength.text = textView.maxTextLength == -1 ? @"未设定最大输入数" : [NSString stringWithFormat:@"剩余可输入字数：%tu", textView.maxTextLength];
    [self.view addSubview:lastLength];
    [lastLength mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).offset(30);
        make.centerX.mas_equalTo(textView);
    }];
    
    ///4  显示剩余个数的block
    textView.lastTextLength = ^(NSInteger length) {
        lastLength.text = [NSString stringWithFormat:@"剩余可输入字数：%tu", length];
    };
    
    
    
}


@end
