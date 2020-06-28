//
//  DJImagePickerController.h
//  Util_SJAuditPhotoPickerDemo
//
//  Created by Jaesun on 2019/7/17.
//  Copyright © 2019 jae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "DJImagePickerMacro.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DJPickedComplete)(UIImage *image);

@interface DJImagePickerController : UIViewController

- (instancetype)initWithType:(DJImagePickerType)type;

/* 完成回调 **/
@property (nonatomic, copy) DJPickedComplete pickedComplete;

@end

NS_ASSUME_NONNULL_END
