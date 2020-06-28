//
//  DJImagePickerMaskView.h
//  Util_SJAuditPhotoPickerDemo
//
//  Created by Jaesun on 2019/7/17.
//  Copyright © 2019 jae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJimagePickerMacro.h"

NS_ASSUME_NONNULL_BEGIN

@class DJImagePickerMaskView;

@protocol DJImagePickerMaskViewDelegate <NSObject>

- (void)imagePickerMaskView:(DJImagePickerMaskView *)maskView operateWithType:(DJImagePickerMaskViewOperateType)type;

@end

@interface DJImagePickerMaskView : UIView


@property (nonatomic, weak) id<DJImagePickerMaskViewDelegate> delegate;

@property (nonatomic, assign) NSInteger curIndex;

- (instancetype)initWithEffectiveSize:(CGSize)size type:(DJImagePickerType)type;

@end

NS_ASSUME_NONNULL_END
