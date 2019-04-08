//
//  PNTextView.m
//  PNTextView
//
//  Created by 刘攀妞 on 2018/9/3.
//  Copyright © 2018年 刘攀妞. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#import "PNTextView.h"
#import "MBProgressHUD+MJ.h"

@interface PNTextView()<UITextViewDelegate>
/// 是否可输入
@property (nonatomic, assign) BOOL isContentTextViewEnable;
/// 占位控件
@property (nonatomic, weak) UILabel *placeholderLbl;
/// 剩余个数 -1代表不存在 最大输入个数 与 剩余个数
@property (nonatomic, assign) NSInteger lastTextLengh;
@end

@implementation PNTextView

- (instancetype)init{
  
    return [[PNTextView alloc] initWithFrame:CGRectZero];
 
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.isContentTextViewEnable = YES;
        self.maxTextLength = -1; // -1默认不限制输入个数
        self.delegate = self;
        [self setupPlaceholderLabel]; // 添加placeholderLabel
        self.scrollEnabled = NO;  // 重点, 改变高度
    }
    return self;
}

/// 添加占位控件
- (void)setupPlaceholderLabel{
    UILabel *placeholderLbl = [[UILabel alloc] init];
    placeholderLbl.backgroundColor = [UIColor clearColor];
    [self addSubview:placeholderLbl];
    self.placeholderLbl = placeholderLbl;

    self.placeholderFont = [UIFont systemFontOfSize:16.0];
    self.placeholderColor = [UIColor lightGrayColor];
    self.font = self.placeholderFont;
    
}



/// 设定最大输入数
- (void)setMaxTextLength:(NSInteger)maxTextLength{
    _maxTextLength = maxTextLength;
    if (_maxTextLength == -1) {
        self.lastTextLengh = -1;
        return;
    }
    self.lastTextLengh = _maxTextLength;
    
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholderFont = font;
}


/// 占位字体
- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    
    self.placeholderLbl.font = placeholderFont;
    [self setNeedsLayout];
}
/// 占位文本
- (void)setPlaceholderText:(NSString *)placeholderText{
    _placeholderText = placeholderText;
    
    self.placeholderLbl.text = placeholderText;
    [self setNeedsLayout];
}
/// 占位颜色
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    self.placeholderLbl.textColor = placeholderColor;
}
/// textview文本内容
- (void)setText:(NSString *)text{
    [super setText:text];
    
    [self textViewDidChange:self];
}
- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    
    [self textViewDidChange:self];
}

#pragma mark - UITextViewDelegate
/// 输入内容
- (void)textViewDidChange:(UITextView *)textView
{
    // 占位文字 输入文字就隐藏 清空就显示
    self.placeholderLbl.hidden = self.hasText;

    
    //获取当前键盘类型
    UITextInputMode *mode = (UITextInputMode *)[UITextInputMode activeInputModes][0];
    
    //获取当前键盘语言
    NSString *lang = mode.primaryLanguage;
    //如果语言是汉语(拼音)
    if ([lang isEqualToString:@"zh-Hans"])
    {
        //取到高亮部分范围
        UITextRange *selectedRange = [self markedTextRange];
        //取到高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        //如果取不到高亮部分,代表没有拼音，直接选择汉字
        if (!position){
            
            //当期超过最大限制时
            if (self.text.length > self.maxTextLength) {
                //对超出部分进行裁剪
                self.text = [self.text substringToIndex:self.maxTextLength];
                //同时对可继续书写属性设为否,shouldChangeTextInRange方法会调用
                self.isContentTextViewEnable = NO;
                [MBProgressHUD showError:@"输入汉字和字符个数已达上限"];
                self.lastTextLengh =  0;
                
            }else{ // 小于等于
                
                self.lastTextLengh = self.maxTextLength != -1 ? self.maxTextLength - self.text.length : -1;
                
            }
            
            //可继续编辑--但是不能输入到文本框内
            self.isContentTextViewEnable = YES;
            
            /// 计算剩余个数
            if(self.lastTextLength && self.maxTextLength != -1){
                self.lastTextLength(self.lastTextLengh);
            }
            
            
        }else{
            //表示还有高亮部分 什么都不用做
            NSLog(@"输入拼音-高亮部分");
            
        }
    }else{
        //如果语言不是汉语, 输入英文字符情况 ，没有高亮的情况，直接计算个数
        if (self.text.length > self.maxTextLength) {
            [MBProgressHUD showError:@"输入汉字和字符个数已达上限"];
            self.text = [textView.text substringToIndex:self.maxTextLength];
            self.isContentTextViewEnable = NO;
            
            self.lastTextLengh =  0;
            
        }else{
            
            self.lastTextLengh = self.maxTextLength != -1 ? self.maxTextLength - self.text.length : -1;
        }
        self.isContentTextViewEnable = YES;
        
        
        /// 计算剩余个数
        if(self.lastTextLength && self.maxTextLength != -1){
            self.lastTextLength(self.lastTextLengh);
        }
    }
    
  
   
}
/// 限制输入内容个数
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""]) { // 点击删除键 可删除
        
        return YES;
    }else if([text isEqualToString:@" "]){ // 不能输入空格,
        
        return NO;
    }else if([[self.textInputMode primaryLanguage] isEqualToString:@"emoji"] ||[self.textInputMode primaryLanguage] == nil){ //  表情:current.primaryLanguage是空
        
        return !self.emoticonsDisEnable; // 表情可输入就返回yes，表情不可输入就返回no
    }else if([text isEqualToString:@"\n"]){
        
        return [self endEditing:YES]; // 退出键盘
    }else{
        
        return self.isContentTextViewEnable; // 可编辑
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.placeholderLbl.frame;
    frame.origin.y = self.textContainerInset.top;
    frame.origin.x = self.textContainerInset.left + 6.0f;
    frame.size.width = self.frame.size.width - (self.textContainerInset.left + 6) * 2.0;
    
    CGSize maxSize = CGSizeMake(frame.size.width, MAXFLOAT);
    frame.size.height = [self.placeholderText boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLbl.font} context:nil].size.height;
    self.placeholderLbl.frame = frame;
    

    
    
    
}

@end
