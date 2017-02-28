//
//  SwapDeviceViewController.m
//  欧深特GPS
//
//  Created by joe on 2016/12/7.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "SwapDeviceViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AddDeviceViewController.h"

#define QRCodeWidth  260.0   //正方形二维码的边长
#define SCREENWidth  [UIScreen mainScreen].bounds.size.width   //设备屏幕的宽度
#define SCREENHeight [UIScreen mainScreen].bounds.size.height //设备屏幕的高度


@interface SwapDeviceViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,strong)AVCaptureSession *session;
@end

@implementation SwapDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self onSetTitleView:@"二维码扫描结果"type:TitleLogo];//调用根视图的方法，自定义导航控制器的样式。这个根据读者的实际情况而定。
//    self.navigationController.toolbarHidden = YES;//如果你的根视图有底部工具栏，这行代码可以隐藏底部的工具栏
    
    self.title = NSLocalizedString(@"swap QRcode", "扫描二维码");
    
    [self setupMaskView];//设置扫描区域之外的阴影视图
    
    [self setupScanWindowView];//设置扫描二维码区域的视图
    
    [self beginScanning];//开始扫二维码
}

- (void)setupMaskView
{
    //设置统一的视图颜色和视图的透明度
    UIColor *color = [UIColor blackColor];
    float alpha = 0.7;
    
    //设置扫描区域外部上部的视图
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 64, SCREENWidth, (SCREENHeight-64-QRCodeWidth)/2.0-64);
    topView.backgroundColor = color;
    topView.alpha = alpha;
    
    //设置扫描区域外部左边的视图
    UIView *leftView = [[UIView alloc]init];
    leftView.frame = CGRectMake(0, 64+topView.frame.size.height, (SCREENWidth-QRCodeWidth)/2.0,QRCodeWidth);
    leftView.backgroundColor = color;
    leftView.alpha = alpha;
    
    //设置扫描区域外部右边的视图
    UIView *rightView = [[UIView alloc]init];
    rightView.frame = CGRectMake((SCREENWidth-QRCodeWidth)/2.0+QRCodeWidth,64+topView.frame.size.height, (SCREENWidth-QRCodeWidth)/2.0,QRCodeWidth);
    rightView.backgroundColor = color;
    rightView.alpha = alpha;
    
    //设置扫描区域外部底部的视图
    UIView *botView = [[UIView alloc]init];
    botView.frame = CGRectMake(0, 64+QRCodeWidth+topView.frame.size.height,SCREENWidth,SCREENHeight-64-QRCodeWidth-topView.frame.size.height);
    botView.backgroundColor = color;
    botView.alpha = alpha;
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WindowWidth, 30)];
    lable.center = CGPointMake(WindowWidth/2.0, 64+QRCodeWidth+topView.frame.size.height + 40);
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:14.0];
    lable.text = NSLocalizedString(@"put the two-dimensional code in the box", "将二维码置于框内，系统将自动识别");
    //将设置好的扫描二维码区域之外的视图添加到视图图层上
    [self.view addSubview:topView];
    [self.view addSubview:leftView];
    [self.view addSubview:rightView];
    [self.view addSubview:botView];
    
    [self.view addSubview:lable];

}



- (void)setupScanWindowView
{
    //设置扫描区域的位置(考虑导航栏和电池条的高度为64)
    UIView *scanWindow = [[UIView alloc]initWithFrame:CGRectMake((SCREENWidth-QRCodeWidth)/2.0,(SCREENHeight-QRCodeWidth-64)/2.0,QRCodeWidth,QRCodeWidth)];
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    
    //设置扫描区域的动画效果
    CGFloat scanNetImageViewH = 241;
    CGFloat scanNetImageViewW = scanWindow.frame.size.width;
    UIImageView *scanNetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_net"]];
    scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath =@"transform.translation.y";
    scanNetAnimation.byValue = @(QRCodeWidth);
    scanNetAnimation.duration = 2.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
    
    //设置扫描区域的四个角的边框
    CGFloat buttonWH = 18;
    UIButton *topLeft = [[UIButton alloc]initWithFrame:CGRectMake(0,0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1.png"]forState:UIControlStateNormal];
    [scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc]initWithFrame:CGRectMake(QRCodeWidth - buttonWH,0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"]forState:UIControlStateNormal];
    [scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc]initWithFrame:CGRectMake(0,QRCodeWidth - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"]forState:UIControlStateNormal];
    [scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc]initWithFrame:CGRectMake(QRCodeWidth-buttonWH,QRCodeWidth-buttonWH, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"]forState:UIControlStateNormal];
    [scanWindow addSubview:bottomRight];
}

- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //特别注意的地方：有效的扫描区域，定位是以设置的右顶点为原点。屏幕宽所在的那条线为y轴，屏幕高所在的线为x轴
    CGFloat x = ((SCREENHeight-QRCodeWidth-64)/2.0)/SCREENHeight;
    CGFloat y = ((SCREENWidth-QRCodeWidth)/2.0)/SCREENWidth;
    CGFloat width = QRCodeWidth/SCREENHeight;
    CGFloat height = QRCodeWidth/SCREENWidth;
    output.rectOfInterest = CGRectMake(x, y, width, height);
    
    //设置代理在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
    
}



-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSString *value = metadataObject.stringValue;
        
        
        if (![value containsString:@"ID"] || ![value containsString:@"SN"] || value.length != 25) {
            [CommonFunction showWrongMessagewithtext:NSLocalizedString(@"The format is not correct", nil) completionBlock:^{
                
            }];
            
            return;
        }else{
            NSString *ID = [value substringWithRange:NSMakeRange(3, 11)];
            NSString *SN = [value substringWithRange:NSMakeRange(18, 7)];
        
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[AddDeviceViewController class]]) {
    
                   AddDeviceViewController *vc1 = (AddDeviceViewController *)vc;
                    vc1.imeiTextField.text = ID;
                    vc1.IDTextFied.text = SN;
    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }


        }
        
        

        
        
        
    }
}


@end
