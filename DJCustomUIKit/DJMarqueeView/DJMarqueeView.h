//
//  WWMarqueeView.h
//  WiseWing-iOS
//
//  Created by Jaesun on 2020/5/16.
//  Copyright © 2020 W.W. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJMarqueeView : UIView

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, copy) NSArray <NSString *>* messages;

@end

NS_ASSUME_NONNULL_END
