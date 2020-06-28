//
//  DJImagePickerMaskView.m
//  Util_SJAuditPhotoPickerDemo
//
//  Created by Jaesun on 2019/7/17.
//  Copyright © 2019 jae. All rights reserved.
//

#import "DJImagePickerMaskView.h"
#import <Masonry/Masonry.h>
#import "DJCustomUIUtil.h"

@interface DJImagePickerMaskView()

@property (nonatomic, assign) CGSize effectiveSize;
/* 相机类型 **/
@property (nonatomic, assign) DJImagePickerType type;

/* 工具栏 **/
@property (nonatomic, strong) UIView *toolBar;
/* 取消按钮 **/
@property (nonatomic, strong) UIButton *cancelButton;
/* 拍照按钮 **/
@property (nonatomic, strong) UIButton *takePhotoButton;
// 正面
@property (nonatomic, strong) UIButton *frontButton;
// 反面
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation DJImagePickerMaskView

- (instancetype)initWithEffectiveSize:(CGSize)size type:(DJImagePickerType)type {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.effectiveSize = size;
        self.type = type;
        [self configSubviews];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGRect effectiveRect = CGRectMake(0.5 * (rect.size.width - self.effectiveSize.width), 0.5 * (rect.size.height -self.effectiveSize.height), self.effectiveSize.width, self.effectiveSize.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 半透明背景
    CGContextAddRect(context, rect);
    [[UIColor colorWithWhite:0 alpha:0.3] set];
    CGContextFillPath(context);
    // 扫码框透明
    CGContextSetBlendMode(context, kCGBlendModeClear); // 叠加模式设置
    CGRect holeRection = effectiveRect;
    CGContextAddRect(context,holeRection);
    // 设置属性
    [[UIColor clearColor] setFill];
    CGContextFillPath(context);
    // 画白色边框
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextAddRect(context,effectiveRect);
    [[UIColor whiteColor] setStroke];
    CGContextStrokePath(context);
    // 四个角
    CGFloat lineWidth  = 15.f;
    CGFloat lineHeight = 3.f;
    CGFloat maxX = CGRectGetMaxX(effectiveRect);
    CGFloat maxY = CGRectGetMaxY(effectiveRect);
    CGFloat minX = CGRectGetMinX(effectiveRect);
    CGFloat minY = CGRectGetMinY(effectiveRect);
    CGContextSetBlendMode(context, kCGBlendModeCopy);  // 叠加模式
    // 左上
    CGContextMoveToPoint(context, minX, minY + lineWidth);
    CGContextAddLineToPoint(context, minX, minY);
    CGContextAddLineToPoint(context, minX + lineWidth, minY);
    // 左下
    CGContextMoveToPoint(context, minX, maxY - lineWidth);
    CGContextAddLineToPoint(context, minX, maxY);
    CGContextAddLineToPoint(context, minX + lineWidth, maxY);
    // 右上
    CGContextMoveToPoint(context, maxX - lineWidth, effectiveRect.origin.y);
    CGContextAddLineToPoint(context, maxX, effectiveRect.origin.y);
    CGContextAddLineToPoint(context, maxX, effectiveRect.origin.y + lineWidth);
    // 右下
    CGContextMoveToPoint(context, maxX - lineWidth, maxY);
    CGContextAddLineToPoint(context, maxX, maxY);
    CGContextAddLineToPoint(context, maxX, maxY - lineWidth);
    
    CGContextSetLineWidth(context, lineHeight);
    [[UIColor colorWithRed:0 green:0.5 blue:1 alpha:1] setStroke];
    CGContextStrokePath(context);
}

#pragma mark- Action
- (void)buttonAction:(UIButton *)sender {
    DJImagePickerMaskViewOperateType type = DJImagePickerMaskViewOperateTypeCancel;
    if (sender == self.takePhotoButton) {
        type = DJImagePickerMaskViewOperateTypeTakePhoto;
    }
    if (self.delegate  && [self.delegate respondsToSelector:@selector(imagePickerMaskView:operateWithType:)]) {
        [self.delegate imagePickerMaskView:self operateWithType:type];
    }
}

#pragma mark- Private Method
/** 初始化配置视图 */
- (void)configSubviews {
    [self addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.mas_equalTo(103);
    }];
    
    [self.toolBar addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolBar).offset(30);
        make.centerX.equalTo(self.toolBar);
    }];
    
    [self.toolBar addSubview:self.takePhotoButton];
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.toolBar);
    }];
    
    if (self.type == DJImagePickerTypeIDCard) {
        [self.toolBar addSubview:self.backButton];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.toolBar);
            make.bottom.equalTo(self.toolBar).offset(-120);
        }];
        
        [self.toolBar addSubview:self.frontButton];
        [self.frontButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.toolBar);
            make.bottom.equalTo(self.backButton.mas_top).offset(-30);
        }];
    }
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _toolBar;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)takePhotoButton {
    if (!_takePhotoButton) {
        _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePhotoButton setImage:[DJCustomUIUtil imageNamed:@"btn_take_photo"] forState:UIControlStateNormal];
        [_takePhotoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoButton;
}

- (UIButton *)frontButton {
    if (!_frontButton) {
        _frontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _frontButton.userInteractionEnabled = NO;
        [_frontButton setBackgroundImage:[DJCustomUIUtil imageNamed:@"btn_back_fb"] forState:UIControlStateSelected];
        [_frontButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal];
        [_frontButton setTitleColor:[UIColor colorWithRed:244/255.0 green:207/255.0 blue:53/255.0 alpha:1] forState:UIControlStateSelected];
        [_frontButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_frontButton setTitle:@"正面" forState:UIControlStateNormal];
        _frontButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _frontButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.userInteractionEnabled = NO;
        [_backButton setBackgroundImage:[DJCustomUIUtil imageNamed:@"btn_back_fb"] forState:UIControlStateSelected];
        [_backButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor colorWithRed:244/255.0 green:207/255.0 blue:53/255.0 alpha:1] forState:UIControlStateSelected];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton setTitle:@"反面" forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _backButton;
}

- (void)setCurIndex:(NSInteger)curIndex {
    _curIndex = curIndex;
    _frontButton.selected = (curIndex == 0);
    _backButton.selected  = (curIndex == 1);
}

@end
