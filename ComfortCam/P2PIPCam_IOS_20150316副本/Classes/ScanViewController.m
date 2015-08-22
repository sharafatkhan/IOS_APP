//
//  ScanViewController.m
//  二维码生成和扫描
//
//  Created by king on 14/12/31.
//  Copyright (c) 2014年 East. All rights reserved.
//

#import "ScanViewController.h"
#import "ZBarSDK.h"
#import "IpCameraClientAppDelegate.h"
#define SCANVIEW_EdgeTop 40.0
#define SCANVIEW_EdgeLeft 50.0
#define SCANVIEW_WH 200
@interface ScanViewController ()<ZBarReaderViewDelegate>
{
    
    UIImageView *_QrCodeline;
    NSTimer *_timer;
    //设置扫描画面
    UIView *_scanView;
    ZBarReaderView *_readerView;
    NSString *symbolStr;
    CGRect mainScreen;
    
    UIImageView *bottomRight;
    UIImageView *topLeft ;
    
    UIButton *btnRight;
}

@end

@implementation ScanViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_readerView start];
    
    [self createTimer];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    mainScreen=[[UIScreen mainScreen] applicationFrame];

    
    //初始化扫描界面
    [self setScanView];
    int top=0;
    if ([IpCameraClientAppDelegate isIOS7Version])top=20;
    if(!_readerView){
        _readerView= [[ZBarReaderView alloc]init];
        _readerView.frame =CGRectMake(0,top, self.view.frame.size.width,self.view.frame.size.height);
        _readerView.tracksSymbols=NO;
        _readerView.readerDelegate =self;
        [_readerView addSubview:_scanView];
    }
    
    //关闭闪光灯
    _readerView.torchMode =0;
    [self.view addSubview:_readerView];
    
    [self drawAngle];
    
    
    
    //用于说明的label
    UILabel *labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(0,CGRectGetMaxY(bottomRight.frame)+10, self.view.frame.size.width,20);
    labIntroudction.numberOfLines=1;
    labIntroudction.font=[UIFont boldSystemFontOfSize:15.0];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor greenColor];
    labIntroudction.text=NSLocalizedStringFromTable(@"scanID_Prompt", @STR_LOCALIZED_FILE_NAME, nil);
    
    [self.view addSubview:labIntroudction];
    [self createTopBar];
}

-(void)createTopBar{
    int top=0;
    if ([IpCameraClientAppDelegate isIOS7Version])top=20;
    
    UIImageView *topNavView=[[UIImageView alloc]initWithFrame:CGRectMake(0, top, mainScreen.size.width, 44)];
    topNavView.image=[UIImage imageNamed:@"top_bg_blue.png"];
    topNavView.userInteractionEnabled=YES;
    [self.view addSubview:topNavView];
    
    [topNavView release];
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(10,7,60,30);
    [btnLeft addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topNavView addSubview:btnLeft];
    
    btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"topbar_icon_light_off.png"] forState:UIControlStateNormal];
    ;
    btnRight.frame=CGRectMake(topNavView.frame.size.width-36,(topNavView.frame.size.height-30)/2,30,30);
    [btnRight addTarget:self action:@selector(openLight) forControlEvents:UIControlEventTouchUpInside];
    [topNavView addSubview:btnRight];
    
    UILabel *lbTitle=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btnLeft.frame), 0, (CGRectGetMinX(btnRight.frame)-CGRectGetMaxX(btnLeft.frame)), topNavView.frame.size.height)];
    lbTitle.textColor=[UIColor whiteColor];
    lbTitle.textAlignment=NSTextAlignmentCenter;
    lbTitle.font=[UIFont systemFontOfSize:18];
    lbTitle.backgroundColor=[UIColor clearColor];
    lbTitle.text=NSLocalizedStringFromTable(@"scanID", @STR_LOCALIZED_FILE_NAME, nil);
    [topNavView addSubview:lbTitle];
    [lbTitle release];
    

}

#pragma mark - 画扫描区域四个角

-(void)drawAngle
{
    int top=(mainScreen.size.height-SCANVIEW_WH)/2-22;
    int left=(mainScreen.size.width-SCANVIEW_WH-22)/2;
    //上左
    topLeft = [[UIImageView alloc]init];
    topLeft.image = [UIImage imageNamed:@"scan_coremark01"];
    topLeft.frame = CGRectMake(left-2, top, 22, 22);
    [self.view addSubview:topLeft];
    
    //下左
    UIImageView *bottomLeft = [[UIImageView alloc]init];
    bottomLeft.image = [UIImage imageNamed:@"scan_coremark04"];
    bottomLeft.frame = CGRectMake(left, CGRectGetMaxY(topLeft.frame)+SCANVIEW_WH, 22, 22);
    [self.view addSubview:bottomLeft];
    //上右
    UIImageView *topRight = [[UIImageView alloc]init];
    topRight.image = [UIImage imageNamed:@"scan_coremark02"];
    topRight.frame = CGRectMake(CGRectGetMaxX(topLeft.frame)+SCANVIEW_WH, top, 22, 22);
    [self.view addSubview:topRight];
    //下右
    bottomRight = [[UIImageView alloc]init];
    bottomRight.image = [UIImage imageNamed:@"scan_coremark03"];
    bottomRight.frame = CGRectMake(topRight.frame.origin.x, bottomLeft.frame.origin.y, 22, 22);
    [self.view addSubview:bottomRight];
    
    
}



#pragma mark -- ZBarReaderViewDelegate

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image

{
    
    //初始化
    ZBarReaderController * read = [ZBarReaderController new];
    CGImageRef cgImageRef = image.CGImage;
    ZBarSymbol * symbol = nil;
    id <NSFastEnumeration> results = [read scanImage:cgImageRef];
    for (symbol in results)
    {
        break;
    }
    NSString * result;
    if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
        
    {
        result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    else
    {
        result = symbol.data;
    }
    
     NSLog(@"result=%@",result);
    [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
    
}

-(void)showResult:(NSString*)result{
    if (delegate) {
        [delegate scanQRCodeResult:result];
    }
    [self leftButtonClick];
}

-(void)leftButtonClick
{
    NSLog(@"leftButtonClick.....");
    
    if (_readerView.torchMode ==1) {
        _readerView.torchMode =0;
        
        [btnRight setBackgroundImage:[UIImage imageNamed:@"topbar_icon_light_off.png"] forState:UIControlStateNormal];
        
    }
    [self stopTimer];
    [_readerView stop];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


//二维码的扫描区域

- (void)setScanView

{
    
    _scanView=[[UIView alloc] initWithFrame:CGRectMake(0,0,  self.view.frame.size.width,self.view.frame.size.width)];
    _scanView.backgroundColor=[UIColor clearColor];
    
    /******************中间扫描区域****************************/
    
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.width)];
    
    //scanCropView.image=[UIImage imageNamed:@""];
    
    scanCropView.layer.borderColor=[UIColor clearColor].CGColor;
    
    scanCropView.layer.borderWidth=2.0;
    
    scanCropView.backgroundColor=[UIColor clearColor];
    
    [_scanView addSubview:scanCropView];

    //画中间的基准线
    int top=(mainScreen.size.height-SCANVIEW_WH)/2-22;
    int left=(mainScreen.size.width-SCANVIEW_WH-22)/2+22;
    
    _QrCodeline = [[UIImageView alloc] initWithFrame:CGRectMake(left,top, SCANVIEW_WH,3)];
    _QrCodeline.backgroundColor=[UIColor greenColor];
    [_scanView addSubview:_QrCodeline];
    
}

- (void)openLight

{
    
    if (_readerView.torchMode ==0) {
        
        _readerView.torchMode =1;
        
        [btnRight setBackgroundImage:[UIImage imageNamed:@"topbar_icon_light_on.png"] forState:UIControlStateNormal];
        
    }else
        
    {
        
        _readerView.torchMode =0;
        [btnRight setBackgroundImage:[UIImage imageNamed:@"topbar_icon_light_off.png"] forState:UIControlStateNormal];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated

{
    
    [super viewWillDisappear:animated];
    
    
    
}

//二维码的横线移动

- (void)moveUpAndDownLine

{
    
    CGFloat Y=_QrCodeline.frame.origin.y;
    int top=topLeft.frame.origin.y;
    int left=CGRectGetMaxX(topLeft.frame);
    int bottom=CGRectGetMaxY(bottomRight.frame);
    if (Y==bottom) {
        _QrCodeline.frame=CGRectMake(left,top, SCANVIEW_WH,3);
    }else{
        [UIView beginAnimations:@"asa" context:nil];
        
        [UIView setAnimationDuration:2];
        
        _QrCodeline.frame=CGRectMake(left,bottom,  SCANVIEW_WH,3);
        
        [UIView commitAnimations];
    }
 
}


- (void)createTimer

{
    
    //创建一个时间计数
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
    
}


- (void)stopTimer

{
    
    if ([_timer isValid] == YES) {
        
        [_timer invalidate];
        
        _timer =nil;
        
    }
    
}





@end
