//
//  DJImagePickerPreView.h
//  Util_SJAuditPhotoPickerDemo
//
//  Created by Jaesun on 2019/7/17.
//  Copyright © 2019 jae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJimagePickerMacro.h"

@protocol DJImagePickerPreViewDelegate <NSObject>

- (void)imagePickerPreView:(UIView *_Nullable)preView operateWithType:(DJImagePickerPreViewOperateType)type;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DJImagePickerPreView : UIView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, weak) id<DJImagePickerPreViewDelegate> delegate;

- (instancetype)initWithImageSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
