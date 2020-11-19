//
//  Y_SecureTextField.h
//  Y_SecureTextField
//
//  Created by Yue on 2019/4/12.
//  Copyright © 2019 Yue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Y_SecureTextField;

/**
 输入文字改变的回调
 @param sender Y_SecureTextField
 @param isComplete 输入完成
 */
typedef void(^InputTextChanged)(Y_SecureTextField *sender, BOOL isComplete);

@interface Y_SecureTextField : UITextField

/**
 显示闪烁的光标，默认显示
*/
@property (nonatomic, assign) BOOL showCursor;

/**
 显示圆点，YES：圆点  NO：原文
 */
@property (nonatomic, assign) BOOL showSecureTextDot;

/**
 文本长度，默认 6
 */
@property (assign, nonatomic) NSUInteger codeLength;

/**
 盒子的宽度， 默认 44 (当总盒子宽度+间隙 < 本身的宽度时，boxWidth 自动缩小)
 */
@property (assign, nonatomic) CGFloat boxWidth;

/**
 盒子之间的间隙宽度，默认 0
 */
@property (assign, nonatomic) CGFloat boxSpace;

/**
 边框线条的颜色，默认 darkGrayColor
 */
@property (strong, nonatomic) UIColor *borderLineColor;

/**
 边框线条的宽度， 默认 1
 */
@property (assign, nonatomic) CGFloat borderLineWidth;

/**
 密码圆点的颜色，默认 black
 */
@property (strong, nonatomic) UIColor *dotFillColor;

/**
 密码圆点的半径，默认 5
 */
@property (assign, nonatomic) CGFloat dotRadius;

/**
 填充文字颜色，默认 black
 */
@property (strong, nonatomic) UIColor *textFillColor;

/**
 光标颜色，默认 blue
 */
@property (strong, nonatomic) UIColor *cursorColor;

/**
 输入文字改变的回调
 */
@property (copy, nonatomic) InputTextChanged textChangeBlock;

@end
