//
//  DJMarqueeView.m
//  WiseWing-iOS
//
//  Created by Jaesun on 2020/5/16.
//  Copyright © 2020 W.W. All rights reserved.
//

#import "DJMarqueeView.h"

@interface DJMarqueeView()<CAAnimationDelegate>

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *oldMessages;
@property (nonatomic, copy) NSString *timeSep;
@end

@implementation DJMarqueeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configSubviews];
    }
    
    return self;
}

#pragma mark- Action
- (void)animationTimeAction {
    if (self.currentIndex >= self.messages.count) {
        self.currentIndex = 0;
    }
    [self startAnimation];
    self.currentIndex ++;
}

#pragma mark- Private Method
// 开始label平移动画动画
- (void)startAnimation {
    [self.textLabel.layer removeAnimationForKey:@"DJMarqueeView"];
    // 消息数组为空
    if (!self.messages || !self.messages.count) {
        return;
    }
    if (self.messages.count < self.currentIndex) {
        return;
    }
    // NSLog(@"currentIndex: %ld",(long)self.currentIndex);
    // message 为空消息(空字符串)
    NSString *message = self.messages[self.currentIndex];
    if (message.length == 0) {
        return;
    }
    self.textLabel.text = message;
    // 字符串长度
    CGRect rect = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.textLabel.font} context:nil];
    CGFloat textWidth = rect.size.width;
    // 跑马灯视图区域长度
    CGFloat viewWidth = self.bounds.size.width;
    // 创建动画对象
    CABasicAnimation *basicAni = [CABasicAnimation animation];
    // 设置动画属性
    basicAni.keyPath = @"transform.translation.x";
    // 设置动画的起始位置。也就是动画从哪里到哪里
    basicAni.fromValue = @(0);
    // 动画结束后，layer所在的位置
    basicAni.toValue = @(-viewWidth-textWidth);
    // 动画持续时间
    double duration = (viewWidth+textWidth)/100.0;
    basicAni.duration = duration;
    // 动画填充模式,动画结束后回到初始位置
    basicAni.fillMode = kCAFillModeRemoved;
    basicAni.removedOnCompletion = NO;
    // 代理
    basicAni.delegate = self;
    // 把动画添加到要作用的Layer上面
    [self.textLabel.layer addAnimation:basicAni forKey:@"DJMarqueeView"];
    // animationDidStop 各种坑点，自己写定时器，完成该次动画后进行下一次动画
    // 如果上一次定时任务，还未执行，就从新开始了动画，就把上一次的定时任务取消了。例如，messages刷新
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationTimeAction) object:self.timeSep];// 取消定时任务
    self.timeSep = [NSString stringWithFormat:@"%u",arc4random()%100000000];
    // 开启下一次定时任务
    [self performSelector:@selector(animationTimeAction) withObject:self.timeSep afterDelay:duration];
}

- (void)configSubviews {
    [self addSubview:self.textLabel];
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.bounds), 0, CGRectGetWidth(self.bounds), 100);
    self.clipsToBounds = YES;
}

#pragma mark- Property Accessor
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _textLabel;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textLabel.textColor = textColor;
}

- (void)setMessages:(NSArray<NSString *> *)messages {
    // 有新的消息就更新，没有新的消息，就不更新
    if ([self array:self.oldMessages isEqualTo:messages]) {
        return;
    }
    else {
        NSMutableArray *tempMsgs = [NSMutableArray arrayWithCapacity:0];
        for (NSString *msg in messages) {
            if (msg && msg.length) {
                [tempMsgs addObject:msg];
            }
        }
        _messages = tempMsgs.copy;
        self.currentIndex = 0;// 从头开始显示消息
    }
    if (!self.oldMessages) { // 第一次赋值数据，启动动画
       [self animationTimeAction];
    }
    self.oldMessages = _messages;
}

- (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count) {
        return NO;
    }
    for (NSString *str in array1) {
        if (![array2 containsObject:str]) {
            return NO;
        }
    }
    return YES;
}

@end
