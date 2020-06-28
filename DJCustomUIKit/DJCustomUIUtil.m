//
//  DJCustomUIUtil.m
//  DJCustomUIKit
//
//  Created by Jaesun on 2020/6/28.
//
#import "DJCustomUIUtil.h"

@implementation DJCustomUIUtil

+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DJCustomUIKit" ofType:@"bundle"]];
    });
    return bundle;
}

+ (UIImage *)imageNamed:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *n = [NSString stringWithFormat:@"%@@2x", name];
    UIImage *image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:n ofType:@"png"]];
    if (!image) image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:name ofType:@"png"]];
    return image;
}

@end
