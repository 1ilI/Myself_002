//
//  ViewController.m
//  Y_SecureTextFieldExample
//
//  Created by Yue on 2020/11/17.
//

#import "ViewController.h"
#import "Y_SecureTextField.h"

#define ColorsArr @[[UIColor blackColor], [UIColor redColor], [UIColor blueColor], [UIColor brownColor], [UIColor orangeColor], [UIColor purpleColor]]
#define ColorsStrArr @[@"黑色", @"红色",@"蓝色",@"棕色",@"橘色",@"紫色"]
@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField           *tf;
@property (nonatomic, strong) UIButton              *hiddenKeyboardBtn;
@property (nonatomic, strong) UILabel               *resultLab;
@property (nonatomic, strong) Y_SecureTextField     *inputTextField;
@property (nonatomic, strong) UISegmentedControl    *showSecureTextControl;
@property (nonatomic, strong) UISegmentedControl    *showCursorControl;
@property (nonatomic, strong) UILabel               *boxColorLab;
@property (nonatomic, strong) UISegmentedControl    *boxColorControl;
@property (nonatomic, strong) UILabel               *cursorColorLab;
@property (nonatomic, strong) UISegmentedControl    *cursorColorControl;
@property (nonatomic, strong) UILabel               *dotColorLab;
@property (nonatomic, strong) UISegmentedControl    *dotColorControl;
@property (nonatomic, strong) UILabel               *textColorLab;
@property (nonatomic, strong) UISegmentedControl    *textColorControl;
@property (nonatomic, strong) UILabel               *boxSpaceLab;
@property (nonatomic, strong) UISlider              *boxSpaceSlider;
@property (nonatomic, strong) UILabel               *dotRadiuLab;
@property (nonatomic, strong) UISlider              *dotRadiuSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    [self.view addSubview:self.hiddenKeyboardBtn];
    [self.view addSubview:self.resultLab];
    [self.view addSubview:self.inputTextField];
    [self.view addSubview:self.boxSpaceLab];
    [self.view addSubview:self.boxSpaceSlider];
    [self.view addSubview:self.dotRadiuLab];
    [self.view addSubview:self.dotRadiuSlider];
    [self.view addSubview:self.showSecureTextControl];
    [self.view addSubview:self.showCursorControl];
    [self.view addSubview:self.boxColorLab];
    [self.view addSubview:self.boxColorControl];
    [self.view addSubview:self.cursorColorLab];
    [self.view addSubview:self.cursorColorControl];
    [self.view addSubview:self.dotColorLab];
    [self.view addSubview:self.dotColorControl];
    [self.view addSubview:self.textColorLab];
    [self.view addSubview:self.textColorControl];
}

- (void)inputTextFieldChanged:(Y_SecureTextField *)sender isComplete:(BOOL)isComplete {
    _resultLab.text = [NSString stringWithFormat:@"%@：%@", isComplete ? @"输入完成" : @"正在输入", sender.text];
}

#pragma mark - ===== frame =====
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat width = self.view.frame.size.width;
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.hiddenKeyboardBtn.frame = CGRectMake(width - 75, statusH, 75, 30);
    self.resultLab.frame = CGRectMake(0, 80, width, 50);
    self.inputTextField.frame = CGRectMake(0, 130, width, 50);
    CGFloat showItemW = (width - 60)/2;
    self.showSecureTextControl.frame = CGRectMake(20, 190, showItemW, 30);
    self.showCursorControl.frame = CGRectMake(showItemW + 40, 190, showItemW, 30);
    self.boxSpaceLab.frame = CGRectMake(0, 230, 80, 30);
    self.boxSpaceSlider.frame = CGRectMake(90, 230, width - 100, 30);
    self.dotRadiuLab.frame = CGRectMake(0, 270, 80, 30);
    self.dotRadiuSlider.frame = CGRectMake(90, 270, width - 100, 30);
    self.boxColorLab.frame = CGRectMake(0, 310, 80, 30);
    self.boxColorControl.frame = CGRectMake(90, 310, width - 100, 30);
    self.cursorColorLab.frame = CGRectMake(0, 350, 80, 30);
    self.cursorColorControl.frame = CGRectMake(90, 350, width - 100, 30);
    self.dotColorLab.frame = CGRectMake(0, 390, 80, 30);
    self.dotColorControl.frame = CGRectMake(90, 390, width - 100, 30);
    self.textColorLab.frame = CGRectMake(0, 430, 80, 30);
    self.textColorControl.frame = CGRectMake(90, 430, width - 100, 30);
}

#pragma mark - ===== event =====
// box 边距
- (void)boxSpaceSliderChanged:(UISlider *)sender {
    _inputTextField.boxSpace = sender.value;
    [_inputTextField setNeedsLayout];
}

// 圆点半径
- (void)dotRadiuChanged:(UISlider *)sender {
    _inputTextField.dotRadius = sender.value;
}

// 文字/圆点
- (void)showSecureTextControlClicked:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _inputTextField.showSecureTextDot = NO;
    }
    else if (sender.selectedSegmentIndex == 1) {
        _inputTextField.showSecureTextDot = YES;
    }
}

// 光标显/隐
- (void)showCursorControlClicked:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _inputTextField.showCursor = YES;
    }
    else if (sender.selectedSegmentIndex == 1) {
        _inputTextField.showCursor = NO;
    }
}

// 改变颜色
- (void)changeColorWithControl:(UISegmentedControl *)sender {
    UIColor *color = [ColorsArr objectAtIndex:sender.selectedSegmentIndex];
    if (sender == _boxColorControl) {
        _inputTextField.borderLineColor = color;
    }
    else if (sender == _cursorColorControl) {
        _inputTextField.cursorColor = color;
    }
    else if (sender == _dotColorControl) {
        _inputTextField.dotFillColor = color;
    }
    else if (sender == _textColorControl) {
        _inputTextField.textFillColor = color;
    }
}

// 键盘
- (void)hiddenKeyboard:(UIButton *)sender {
    sender.selected ? [_inputTextField becomeFirstResponder] : [_inputTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _hiddenKeyboardBtn.selected = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _hiddenKeyboardBtn.selected = YES;
}

#pragma mark - ===== lazyload =====
- (Y_SecureTextField *)inputTextField {
    if (!_inputTextField) {
        Y_SecureTextField *tf = [Y_SecureTextField new];
        tf.boxSpace = 12;
        tf.boxWidth = 50;
        tf.codeLength = 4;
        tf.showSecureTextDot = NO;
        tf.delegate = self;
        tf.font = [UIFont systemFontOfSize:30];
        [tf becomeFirstResponder];
        if (@available(iOS 12.0, *)) {
            tf.textContentType = UITextContentTypeOneTimeCode;
        }
        __weak typeof(self) weakSelf = self;
        [tf setTextChangeBlock:^(Y_SecureTextField *sender, BOOL isComplete) {
            [weakSelf inputTextFieldChanged:sender isComplete:isComplete];
        }];
        _inputTextField = tf;
    }
    return _inputTextField;
}

- (UIButton *)hiddenKeyboardBtn {
    if (!_hiddenKeyboardBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.selected = NO;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(hiddenKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"收起键盘" forState:UIControlStateNormal];
        [btn setTitle:@"唤起键盘" forState:UIControlStateSelected];
        _hiddenKeyboardBtn = btn;
    }
    return _hiddenKeyboardBtn;
}

- (UILabel *)createLabelWithTitle:(NSString *)title {
    UILabel *lab = [UILabel new];
    lab.textAlignment = NSTextAlignmentRight;
    lab.text = title;
    return lab;
}

- (UISegmentedControl *)createSegmentedControlWithItems:(NSArray *)items {
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:items];
    sc.selectedSegmentIndex = 0;
    return sc;
}

- (UILabel *)resultLab {
    if (!_resultLab) {
        _resultLab = [self createLabelWithTitle:@"正在输入："];
        _resultLab.font = [UIFont systemFontOfSize:20];
        _resultLab.textAlignment = NSTextAlignmentCenter;
    }
    return _resultLab;
}

- (UILabel *)boxSpaceLab {
    if (!_boxSpaceLab) {
        _boxSpaceLab = [self createLabelWithTitle:@"边框距离"];
    }
    return _boxSpaceLab;
}

- (UISlider *)boxSpaceSlider {
    if (!_boxSpaceSlider) {
        UISlider *slider = [UISlider new];
        slider.minimumValue = 0.f;
        slider.maximumValue = 30.f;
        slider.value = 12.f;
        [slider addTarget:self action:@selector(boxSpaceSliderChanged:) forControlEvents:UIControlEventValueChanged];
        _boxSpaceSlider = slider;
    }
    return _boxSpaceSlider;
}

- (UILabel *)dotRadiuLab {
    if (!_dotRadiuLab) {
        _dotRadiuLab = [self createLabelWithTitle:@"圆点半径"];
    }
    return _dotRadiuLab;
}

- (UISlider *)dotRadiuSlider {
    if (!_dotRadiuSlider) {
        UISlider *slider = [UISlider new];
        slider.minimumValue = 0.f;
        slider.maximumValue = 25.f;
        slider.value = 5.f;
        [slider addTarget:self action:@selector(dotRadiuChanged:) forControlEvents:UIControlEventValueChanged];
        _dotRadiuSlider = slider;
    }
    return _dotRadiuSlider;
}

- (UISegmentedControl *)showSecureTextControl {
    if (!_showSecureTextControl) {
        _showSecureTextControl = [self createSegmentedControlWithItems:@[@"显示文字", @"显示圆点"]];
        [_showSecureTextControl addTarget:self action:@selector(showSecureTextControlClicked:) forControlEvents:UIControlEventValueChanged];
    }
    return _showSecureTextControl;
}

- (UISegmentedControl *)showCursorControl {
    if (!_showCursorControl) {
        _showCursorControl = [self createSegmentedControlWithItems:@[@"显示光标", @"隐藏光标"]];
        [_showCursorControl addTarget:self action:@selector(showCursorControlClicked:) forControlEvents:UIControlEventValueChanged];
    }
    return _showCursorControl;
}

- (UILabel *)boxColorLab {
    if (!_boxColorLab) {
        _boxColorLab = [self createLabelWithTitle:@"边框颜色"];
    }
    return _boxColorLab;
}

- (UISegmentedControl *)boxColorControl {
    if (!_boxColorControl) {
        _boxColorControl = [self createSegmentedControlWithItems:ColorsStrArr];
        [_boxColorControl addTarget:self action:@selector(changeColorWithControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _boxColorControl;
}

- (UILabel *)cursorColorLab {
    if (!_cursorColorLab) {
        _cursorColorLab = [self createLabelWithTitle:@"光标颜色"];
    }
    return _cursorColorLab;
}

- (UISegmentedControl *)cursorColorControl {
    if (!_cursorColorControl) {
        _cursorColorControl = [self createSegmentedControlWithItems:ColorsStrArr];
        _cursorColorControl.selectedSegmentIndex = 2;
        [_cursorColorControl addTarget:self action:@selector(changeColorWithControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _cursorColorControl;
}

- (UILabel *)dotColorLab {
    if (!_dotColorLab) {
        _dotColorLab = [self createLabelWithTitle:@"圆点颜色"];
    }
    return _dotColorLab;
}

- (UISegmentedControl *)dotColorControl {
    if (!_dotColorControl) {
        _dotColorControl = [self createSegmentedControlWithItems:ColorsStrArr];
        [_dotColorControl addTarget:self action:@selector(changeColorWithControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _dotColorControl;
}

- (UILabel *)textColorLab {
    if (!_textColorLab) {
        _textColorLab = [self createLabelWithTitle:@"文字颜色"];
    }
    return _textColorLab;
}

- (UISegmentedControl *)textColorControl {
    if (!_textColorControl) {
        _textColorControl = [self createSegmentedControlWithItems:ColorsStrArr];
        [_textColorControl addTarget:self action:@selector(changeColorWithControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _textColorControl;
}
@end
