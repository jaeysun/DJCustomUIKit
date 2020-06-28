//
//  DJViewController.m
//  DJCustomUIKit
//
//  Created by jaeysun on 06/28/2020.
//  Copyright (c) 2020 jaeysun. All rights reserved.
//

#import "DJViewController.h"

#import <DJCustomUIKit/DJCustomUIKit.h>

@interface DJViewController ()

@end

@implementation DJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    DJMarqueeView *marqueeView = [[DJMarqueeView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 100)];
    [self.view addSubview:marqueeView];
    
    marqueeView.messages = @[@"Dispose of any resources that can be recreated.",@"Dispose of",@"any resources that can be recreated."];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
