//
//  Y_SecureTextField.m
//  Y_SecureTextField
//
//  Created by Yue on 2019/4/12.
//  Copyright © 2019 Yue. All rights reserved.
//

#import "Y_SecureTextField.h"

static const CGFloat cursorW = 2.f;/**<光标宽度 */
@interface Y_SecureTextField ()<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableString   *innerText;
@property (nonatomic, strong) CAShapeLayer      *cursorLayer;
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>   *boxLayers;
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>   *dotsLayers;
@property (nonatomic, strong) NSMutableArray <CATextLayer *>    *subTextLayers;

@end

@implementation Y_SecureTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:[UIColor clearColor]];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:[UIColor clearColor]];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
}

- (void)setupUI {
    self.delegate = self;
    self.font = [UIFont systemFontOfSize:17];
    self.tintColor = [UIColor clearColor];
    self.textColor = [UIColor clearColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.returnKeyType = UIReturnKeyDone;
    if (@available(iOS 12.0, *)) {
        self.textContentType = UITextContentTypeOneTimeCode;
    }
    [self addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _showCursor = YES;
    _showSecureTextDot = YES;
    _codeLength = 6;
    _boxWidth = 44.f;
    _boxSpace = 0.f;
    _dotRadius = 5.f;
    _borderLineWidth = 1.f;
    _innerText = [NSMutableString new];
    _dotsLayers = [NSMutableArray arrayWithCapacity:6];
    _subTextLayers = [NSMutableArray arrayWithCapacity:6];
    _boxLayers = [NSMutableArray arrayWithCapacity:6];
    _textFillColor = [UIColor blackColor];
    _dotFillColor = [UIColor blackColor];
    _borderLineColor = [UIColor darkGrayColor];
    _cursorColor = [UIColor blueColor];
    
    // 光标
    self.cursorLayer = [CAShapeLayer layer];
    self.cursorLayer.backgroundColor = _cursorColor.CGColor;
    [self.layer addSublayer:self.cursorLayer];
    [self showCursorAnimation];
}

- (void)setShowCursor:(BOOL)showCursor {
    _showCursor = showCursor;
    _cursorLayer.hidden = !_showCursor;
    [self setCursorFrame];
}

- (void)setCursorColor:(UIColor *)cursorColor {
    _cursorColor = cursorColor;
    if (_showCursor) {
        self.cursorLayer.backgroundColor = _cursorColor.CGColor;
    }
}

- (void)showCursorAnimation {
    [self.cursorLayer addAnimation:[self flashingForeverAnimation:0.5] forKey:@"CursorAnimation"];
}

- (void)stopCursorAnimation {
    [self.cursorLayer removeAnimationForKey:@"CursorAnimation"];
}

// 闪烁动画，用于光标闪烁
- (CABasicAnimation *)flashingForeverAnimation:(float)time {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}

- (void)setCodeLength:(NSUInteger)passwordLength {
    _codeLength = passwordLength;
    for (CAShapeLayer *boxLay in _boxLayers) {
        [boxLay removeFromSuperlayer];
    }
    [_boxLayers removeAllObjects];
    for (NSInteger i = 0; i != _codeLength; i++) {
        CAShapeLayer *boxLayer = [CAShapeLayer layer];
        boxLayer.fillColor = [UIColor clearColor].CGColor;
        boxLayer.borderColor = _borderLineColor.CGColor;
        boxLayer.borderWidth = _borderLineWidth;
        [self.layer addSublayer:boxLayer];
        [_boxLayers addObject:boxLayer];
    }
}

- (void)setShowSecureTextDot:(BOOL)showSecureTextDot {
    _showSecureTextDot = showSecureTextDot;
    [_dotsLayers enumerateObjectsUsingBlock:^(CAShapeLayer *dotLay, NSUInteger idx, BOOL * _Nonnull stop) {
        dotLay.hidden = !_showSecureTextDot;
    }];
    [_subTextLayers enumerateObjectsUsingBlock:^(CATextLayer *textLay, NSUInteger idx, BOOL * _Nonnull stop) {
        textLay.hidden = _showSecureTextDot;
    }];
}

- (void)setBorderLineColor:(UIColor *)borderLineColor {
    _borderLineColor = borderLineColor;
    [_boxLayers enumerateObjectsUsingBlock:^(CAShapeLayer *boxLay, NSUInteger idx, BOOL * _Nonnull stop) {
        boxLay.borderColor = self.borderLineColor.CGColor;
    }];
}

- (void)setDotFillColor:(UIColor *)dotFillColor {
    _dotFillColor = dotFillColor;
    [_dotsLayers enumerateObjectsUsingBlock:^(CAShapeLayer *dotLay, NSUInteger idx, BOOL * _Nonnull stop) {
        dotLay.fillColor = self.dotFillColor.CGColor;
    }];
}

- (void)setTextFillColor:(UIColor *)textFillColor {
    _textFillColor = textFillColor;
    [_subTextLayers enumerateObjectsUsingBlock:^(CATextLayer *textLay, NSUInteger idx, BOOL * _Nonnull stop) {
        textLay.foregroundColor = self.textFillColor.CGColor;
    }];
}

- (void)setDotRadius:(CGFloat)dotRadius {
    _dotRadius = dotRadius;
    [_dotsLayers enumerateObjectsUsingBlock:^(CAShapeLayer *dotLay, NSUInteger idx, BOOL * _Nonnull stop) {
        dotLay.fillColor = self.dotFillColor.CGColor;
        dotLay.path = [self circlePathWithCenter:CGPointMake(dotLay.frame.size.width/2.0, dotLay.frame.size.height/2.0)].CGPath;
    }];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat left = (width - (_codeLength*(_boxWidth + _boxSpace) - _boxSpace)) / 2;
    if (left < 0) {
        left = 0;
        self.boxWidth = (width - (_codeLength-1)*_boxSpace) / _codeLength;
    }
    // 设置 box 框框的 frame
    [_boxLayers enumerateObjectsUsingBlock:^(CAShapeLayer *boxLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        boxLayer.frame = CGRectMake(left + idx*(_boxWidth + (_boxSpace ? : -(_borderLineWidth))), 0, _boxWidth, height);
        UIBezierPath *boxPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _boxWidth, height)];
        boxLayer.path = boxPath.CGPath;
    }];
    // 设置光标 frame
    [self setCursorFrame];
    // 设置圆点或文字 frame
    [self setDotsOrTextFrame];
}

- (void)setCursorFrame {
    if (!_showCursor) {
        return;
    }
    if (self.innerText.length < _boxLayers.count) {
        _cursorLayer.hidden = NO;
        CAShapeLayer *boxLay = [_boxLayers objectAtIndex:self.innerText.length];
        CGFloat cursorY = 6;
        CGFloat cursorH = boxLay.frame.size.height - 2*cursorY;
        CGFloat cursorX = boxLay.frame.origin.x + (boxLay.frame.size.width - cursorW) / 2;
        _cursorLayer.frame = CGRectMake(cursorX, cursorY, cursorW, cursorH);;
    }
    else if (self.innerText.length == _boxLayers.count) {
        _cursorLayer.hidden = YES;
    }
}

- (void)setDotsOrTextFrame {
    [_dotsLayers enumerateObjectsUsingBlock:^(CAShapeLayer *dotLay, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *boxLay = [_boxLayers objectAtIndex:idx];
        dotLay.frame = boxLay.frame;
        dotLay.hidden = !_showSecureTextDot;
    }];
    [_subTextLayers enumerateObjectsUsingBlock:^(CATextLayer *textLay, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *boxLay = [_boxLayers objectAtIndex:idx];
        CGRect textLayFrame = textLay.frame;
        textLayFrame.origin.x = boxLay.frame.origin.x;
        textLay.frame = textLayFrame;
        textLay.hidden = _showSecureTextDot;
    }];
}

/**
 生成小黑点
 @param index index下标
 @return 当前小黑点
 */
- (CAShapeLayer *)makeBlackDotLayerAtIndex:(NSUInteger)index {
    CAShapeLayer *boxLayer = [_boxLayers objectAtIndex:index];
    CGFloat width = boxLayer.bounds.size.width;
    CGFloat height = boxLayer.bounds.size.height;
    CGFloat x = boxLayer.frame.origin.x;
    CGFloat y = boxLayer.frame.origin.y;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(x, y, width, height);
    layer.fillColor = _dotFillColor.CGColor;
    layer.path = [self circlePathWithCenter:CGPointMake(width/2.0, height/2.0)].CGPath;
    return layer;
}

/**
 *  生成text 文本
 *  @param index 第几个
 *  @return 当前文本
 */
- (CATextLayer *)makeTextLayerAtIndex:(NSUInteger)index {
    CAShapeLayer *boxLayer = [_boxLayers objectAtIndex:index];
    CGFloat width = boxLayer.bounds.size.width;
    CGFloat height = boxLayer.bounds.size.height;
    CGFloat x = boxLayer.frame.origin.x;
    
    NSString *text = [self.innerText substringWithRange:NSMakeRange(index, 1)];
    CGFloat textH = [text sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
    CGFloat textY = (height - textH) /2;
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(x, textY, width, textH);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    textLayer.string = [self.innerText substringWithRange:NSMakeRange(index, 1)];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef fontName = (__bridge CFStringRef)self.font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = self.font.pointSize;
    textLayer.foregroundColor = self.textFillColor.CGColor;
    CGFontRelease(fontRef);
    
    return textLayer;
}

/**
 计算实心小圆点
 @param center 圆心
 @return 圆的路径
 */
- (UIBezierPath *)circlePathWithCenter:(CGPoint)center{
    return [UIBezierPath bezierPathWithArcCenter:center radius:_dotRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
}

/**
 添加小圆点和文本到相应的框内
 @param index 位置
 */
- (void)addBlackDotOrTextAtIndex:(NSUInteger)index {
    CAShapeLayer *dotLayer = [self makeBlackDotLayerAtIndex:index];
    dotLayer.hidden = !_showSecureTextDot;
    [self.layer addSublayer:dotLayer];
    [_dotsLayers addObject:dotLayer];

    CATextLayer *textLayer = [self makeTextLayerAtIndex:index];
    textLayer.hidden = _showSecureTextDot;
    [self.layer addSublayer:textLayer];
    [_subTextLayers addObject:textLayer];
}

/**
 删除文本
 */
- (void)deleteText {
    CAShapeLayer *dotLayer = [_dotsLayers lastObject];
    [dotLayer removeFromSuperlayer];
    [_dotsLayers removeLastObject];

    CATextLayer *textLayer = [_subTextLayers lastObject];
    [textLayer removeFromSuperlayer];
    [_subTextLayers removeLastObject];
}

#pragma mark - ===== UITextFieldDelegate =====
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return (self.codeLength >= textField.text.length + string.length);
}

- (void)textFieldValueChanged:(UITextField *)sender {
    BOOL inputEnd = NO;
    // 加字
    if (self.innerText.length < sender.text.length) {
        if (self.innerText.length == _codeLength) {
            return;
        }
        self.innerText = [NSMutableString stringWithString:sender.text];
        [self addBlackDotOrTextAtIndex:self.innerText.length-1];
        [self setCursorFrame];
        inputEnd = (self.innerText.length == _codeLength);
    }
    // 减字
    else if (self.innerText.length > sender.text.length) {
        if (self.innerText.length == 0) {
            return;
        }
        inputEnd = NO;
        [self.innerText deleteCharactersInRange:NSMakeRange(self.innerText.length-1, 1)];
        [self setCursorFrame];
        [self deleteText];
        self.innerText = [NSMutableString stringWithString:sender.text];
    }
    
    if (self.textChangeBlock) {
        self.textChangeBlock(self, inputEnd);
    }
}


@end
