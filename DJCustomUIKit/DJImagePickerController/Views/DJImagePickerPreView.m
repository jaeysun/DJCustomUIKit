//
//  DJImagePickerPreView.m
//  Util_SJAuditPhotoPickerDemo
//
//  Created by Jaesun on 2019/7/17.
//  Copyright © 2019 jae. All rights reserved.
//

#import "DJImagePickerPreView.h"
#import <Masonry/Masonry.h>

@interface DJImagePickerPreView()
/* 图片 **/
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGSize imgSize;

@property (nonatomic, strong) UIView *toolBar;
/** 取消*/
@property (nonatomic, strong) UIButton *cancelButton;
/*使用照片*/
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation DJImagePickerPreView

- (instancetype)initWithImageSize:(CGSize)size {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.imgSize = size;
        [self configSubviews];
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender {
    DJImagePickerPreViewOperateType type = DJImagePickerPreViewOperateTypeDone;
    if (sender == self.cancelButton) {
        type = DJImagePickerPreViewOperateTypeCancel;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreView:operateWithType:)]) {
        [self.delegate imagePickerPreView:self operateWithType:type];
    }
}

#pragma mark- Private Method
/** 初始化配置视图 */
- (void)configSubviews {
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(self.imgSize);
    }];
    
    [self addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(73);
    }];
    
    [self.toolBar addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolBar).offset(20);
        make.centerY.equalTo(self.toolBar);
        make.height.equalTo(self.toolBar);
        make.width.mas_equalTo(100);
    }];
    
    [self.toolBar addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.toolBar).offset(-20);
        make.centerY.equalTo(self.toolBar);
        make.height.equalTo(self.toolBar);
        make.width.mas_equalTo(100);
    }];
   
}

#pragma mark- Property Accessor
- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _toolBar;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"使用照片" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}


- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"重拍" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

@end
