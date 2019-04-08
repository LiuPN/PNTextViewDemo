//
//  PNTextView.h
//  PNTextView
//
//  Created by 刘攀妞 on 2018/9/3.
//  Copyright © 2018年 刘攀妞. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PNTextView : UITextView
/// 最大输入个数 默认-1 maxfloat
@property (nonatomic, assign) NSInteger maxTextLength;
/// 占位符颜色
@property (nonatomic, strong) UIColor *placeholderColor;
/// 占位符字体大小
@property (nonatomic, strong) UIFont *placeholderFont;
/// 占位字体内容
@property (nonatomic, copy) NSString *placeholderText;

/// 是否不可输入表情：默认是No 可输入表情
@property (nonatomic, assign, getter=isEmoticonsDisEnable) BOOL emoticonsDisEnable;

/// 剩余个数block
@property (nonatomic, copy) void (^lastTextLength)(NSInteger length);

@end
