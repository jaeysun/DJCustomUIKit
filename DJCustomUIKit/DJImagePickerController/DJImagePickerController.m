//
//  DJImagePickerController.m
//  Util_SJAuditPhotoPickerDemo
//
//  Created by Jaesun on 2019/7/17.
//  Copyright © 2019 jae. All rights reserved.
//

#import "DJImagePickerController.h"
#import <Masonry/Masonry.h>
#import "DJImagePickerPreView.h"
#import "DJImagePickerMaskView.h"

@interface DJImagePickerController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DJImagePickerPreViewDelegate,DJImagePickerMaskViewDelegate>
@property (nonatomic, assign) DJImagePickerType type;
// session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *captureSession;
/** 预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
// 输出图片
@property (nonatomic ,strong) AVCaptureStillImageOutput *imgOutput;

@property (nonatomic, assign) CGRect rect;
/* 遮罩层和操作栏 **/
@property (nonatomic, strong) DJImagePickerMaskView *maskView;
/** 预览图片 */
@property (nonatomic, strong) DJImagePickerPreView *preView;
/** 拍照完成的图片 */
@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) UIImage *curImage;

@end

@implementation DJImagePickerController

//Interface的方向是否会跟随设备方向自动旋转，如果返回NO,后两个方法不会再调用
- (BOOL)shouldAutorotate {
    return YES;
}

// 返回直接支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
}

- (instancetype)initWithType:(DJImagePickerType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

// 根据设备方向更新相机方向
- (void)deviceOrientationDidChange {
    AVCaptureVideoOrientation orientation =  AVCaptureVideoOrientationLandscapeRight;
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        orientation = AVCaptureVideoOrientationLandscapeRight;

    }
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        orientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    [[self.videoPreviewLayer connection] setVideoOrientation:orientation];
}

- (void)dealloc {
    [self.captureSession stopRunning];
    self.captureSession = nil;
    self.videoPreviewLayer = nil;
    self.imgOutput = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.rect = CGRectMake((self.view.bounds.size.width  - 500) * 0.5, (self.view.bounds.size.height - 315) * 0.5, 500, 315);
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self configDevice];
    self.photos = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark- Protocol
#pragma mark DJImagePickerPreViewDelegate
- (void)imagePickerPreView:(UIView *)preView operateWithType:(DJImagePickerPreViewOperateType)type {
    if (type == DJImagePickerPreViewOperateTypeCancel) {
        [self dismissPreView];
        self.curImage = nil;
    }
    else {
        [self.photos addObject:self.curImage];
        [self dismissPreView];
        if (self.type == DJImagePickerTypeDefault) {
           [self dismissViewControllerAnimated:YES completion:nil];
            if (self.pickedComplete) {
                self.pickedComplete([self.photos firstObject]);
            }
        }
        else if (self.type == DJImagePickerTypeIDCard){
            if (self.photos.count == 1) {
                self.maskView.curIndex = 1;
            }
            else if (self.photos.count == 2) {
                [self dismissViewControllerAnimated:YES completion:nil];
                UIImage *reslutImg = [self composeImage:self.photos[0] secondImage:self.photos[1]];
                if (self.pickedComplete) {
                    self.pickedComplete(reslutImg);
                }
            }
        }
    }
}

#pragma mark DJImagePickerMaskViewDelegate
- (void)imagePickerMaskView:(DJImagePickerMaskView *)maskView operateWithType:(DJImagePickerMaskViewOperateType)type {
    if (type == DJImagePickerMaskViewOperateTypeTakePhoto) {
        [self takePhoto];
    }
    else if (type == DJImagePickerMaskViewOperateTypeCancel) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark- Private Method
#pragma mark 拍照
- (void)takePhoto {
    AVCaptureConnection *conntion = [self.imgOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!conntion) {
        NSLog(@"拍照失败!");
        return;
    }
    [self.imgOutput captureStillImageAsynchronouslyFromConnection:conntion completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == nil) {
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        [self captureFinishWithImage:image];
    }];
}

// 处理图片
- (void)captureFinishWithImage:(UIImage *)image {
    // 因为拍照后的imageOrientation与实际不一致，所以宽高对调
    CGFloat scale = image.size.width / [UIScreen mainScreen].bounds.size.height;
    CGFloat width = self.rect.size.height * scale;
    CGFloat height = self.rect.size.width * scale;
    
    CGFloat x = self.rect.origin.y * scale;
    CGFloat y = self.rect.origin.x * scale;
    CGRect rect = CGRectMake(y, x, height, width); // 图片rect
    
    CGImageRef cgRef0 = image.CGImage;
    CGImageRef cgRef1 = CGImageCreateWithImageInRect(cgRef0, rect);
    UIImageOrientation orientation = UIImageOrientationUp; // 根据相机的方向，调整图片方向
    if ([self.videoPreviewLayer connection].videoOrientation == AVCaptureVideoOrientationLandscapeLeft) {
        orientation = UIImageOrientationDown;
    }
    UIImage *scaleImage = [UIImage imageWithCGImage:cgRef1 scale:1.0 orientation:orientation];
    CGImageRelease(cgRef1);
    [self showPreViewWithImg:scaleImage];
}

// 合成图片
- (UIImage *)composeImage:(UIImage*)firstImage secondImage:(UIImage*)secondImage {

    CGSize size = CGSizeMake(firstImage.size.width, firstImage.size.height + secondImage.size.height);
    // 创建画布
    UIGraphicsBeginImageContext(size);
    // 水印身份证正面
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    // 水印身份证反面
    [secondImage drawInRect:CGRectMake(0, firstImage.size.height, secondImage.size.width, secondImage.size.height)];
    // 生成图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); // 结束画图

    return resultImage;
}

- (void)showPreViewWithImg:(UIImage *)image {
    self.curImage = image;
    [self.view addSubview:self.preView];
    [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.preView.image = image;
}

- (void)dismissPreView {
    [self.preView removeFromSuperview];
}

#pragma mark 初始化设备会话
- (void)configDevice {
    // 1.实例化捕捉会话
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto; // 设置拿到的图像的大小
    // 2.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
    // 3.为会话添加输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    [self.captureSession addInput:input];
    // 4.为会话添加输出流
    self.imgOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.captureSession addOutput:self.imgOutput]; // 先添加后设置属性
    
    // 5.实例化预览图层
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill]; // 设置预览图层填充方式
    [self.videoPreviewLayer setFrame:self.view.bounds];                           // 设置图层的frame
    [self.view.layer insertSublayer:self.videoPreviewLayer atIndex:0];
    // 初始化摄像头的方向
    [self deviceOrientationDidChange];
    // 6.AVCaptureSession的 startRunning是阻挡主线程的一个耗时操作，所以我们放到另外的queue中操作，能够避免阻挡主线程
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(sessionQueue, ^{
        if (self.captureSession) {
            [self.captureSession startRunning];
        }
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark- Property Accessor
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
        if (device.position == position) {
            return device;
        }
    return nil;
}

- (DJImagePickerPreView *)preView {
    if (!_preView) {
        _preView = [[DJImagePickerPreView alloc] initWithImageSize:self.rect.size];
        _preView.delegate = self;
    }
    return _preView;
}

- (DJImagePickerMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[DJImagePickerMaskView alloc] initWithEffectiveSize:self.rect.size type:self.type];
        _maskView.delegate = self;
        _maskView.curIndex = 0;
    }
    return _maskView;
}

@end
