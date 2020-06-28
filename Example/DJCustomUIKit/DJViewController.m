//
//  DJViewController.m
//  DJCustomUIKit
//
//  Created by jaeysun on 06/28/2020.
//  Copyright (c) 2020 jaeysun. All rights reserved.
//

#import "DJViewController.h"

#import <DJCustomUIKit/DJCustomUIKit.h>
#import <Masonry/Masonry.h>

@interface DJViewController ()

@end

@implementation DJViewController

#pragma mark-
- (void)buttonAction:(UIButton *)sender {
    // 证件相机
    DJImagePickerController *imgPicker = [[DJImagePickerController alloc] initWithType:DJImagePickerTypeIDCard];
    imgPicker.pickedComplete = ^(UIImage * _Nonnull image) {
    };
    imgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    DJMarqueeView *marqueeView = [[DJMarqueeView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 100)];
    [self.view addSubview:marqueeView];
    marqueeView.messages = @[@"Dispose of any resources that can be recreated.",@"Dispose of",@"any resources that can be recreated."];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100.0, 40.0));
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
