//
//  DJimagePickerMacro.h
//  Util_SJAuditPhotoPickerDemo
//
//  Created by Jaesun on 2019/7/18.
//  Copyright © 2019 jae. All rights reserved.
//

#ifndef DJImagePickerMacro_h
#define DJImagePickerMacro_h

typedef enum : NSUInteger {
    DJImagePickerTypeDefault = 2019,
    DJImagePickerTypeIDCard,
} DJImagePickerType;

typedef enum : NSUInteger {
    DJImagePickerMaskViewOperateTypeCancel = 2019,
    DJImagePickerMaskViewOperateTypeTakePhoto,
} DJImagePickerMaskViewOperateType;

typedef enum : NSUInteger {
    DJImagePickerPreViewOperateTypeDone = 2019,
    DJImagePickerPreViewOperateTypeCancel,
} DJImagePickerPreViewOperateType;


#endif /* DJImagePickerMacro_h */
