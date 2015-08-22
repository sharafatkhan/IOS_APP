//
//  PlaybackViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RemotePlaybackViewController.h"
#import "obj_common.h"
#import "IpCameraClientAppDelegate.h"
#import "APICommon.h"
#import <QuartzCore/QuartzCore.h>
#import "mytoast.h"
@interface RemotePlaybackViewController ()

@end

@implementation RemotePlaybackViewController

@synthesize navigationBar;
@synthesize imageView;
@synthesize strDID;
@synthesize m_strFileName;
@synthesize m_pPPPPMgnt;
@synthesize m_strName;
@synthesize progressView;
@synthesize LblProgress;
@synthesize isP2P;
@synthesize TimeStampLabel;
@synthesize mFileSize;
@synthesize mModal;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) StopPlayback
{
    [mTimer invalidate];
    [m_playbackstoplock lock];
    
    m_pPPPPMgnt->StopPPPPAudio([strDID UTF8String]);
    m_pPPPPMgnt->SetDateTimeDelegate((char*)[strDID UTF8String], nil);
    m_pPPPPMgnt->PPPPStopPlayback((char*)[strDID UTF8String]);
    m_pPPPPMgnt->SetPlaybackDelegate((char*)[strDID UTF8String], nil);
    
    
    IpCameraClientAppDelegate *IPCamDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
    [IPCamDelegate switchBack];
    
    [m_playbackstoplock unlock];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isFirstFrame=YES;
    CGRect mainScreen=[[UIScreen mainScreen]bounds];
    CGRect frame=progressView.frame;
    progressView.frame=CGRectMake((mainScreen.size.height-frame.size.width)/2, (mainScreen.size.width-frame.size.height)/2, frame.size.width, frame.size.height);
    CGRect frame2=LblProgress.frame;
    
    LblProgress.frame=CGRectMake((mainScreen.size.height-frame2.size.width)/2, (mainScreen.size.width-frame2.size.height)/2+frame.size.height+5, frame2.size.width, frame2.size.height);
    
    
    UIColor *osdColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.3f];
    TimeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [TimeStampLabel setNumberOfLines:0];
    UIFont *font = [UIFont fontWithName:@"Arial" size:18];
    TimeStampLabel.lineBreakMode = UILineBreakModeWordWrap;
    NSString *s = @"2012-07-04 08:05:30";
    CGSize size = CGSizeMake(170,100);
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [TimeStampLabel setFrame: CGRectMake(mainScreen.size.height - 10 - labelsize.width, 10, labelsize.width, labelsize.height)];
    TimeStampLabel.font = font;
    TimeStampLabel.layer.masksToBounds = YES;
    TimeStampLabel.layer.cornerRadius = 2.0;
    TimeStampLabel.backgroundColor = osdColor;
    [self.view addSubview:TimeStampLabel];
    [TimeStampLabel setHidden:YES];
    
    
    m_bPlayPause = NO;
    m_bHideToolBar = NO;
    myGLViewController = nil;
    
    self.imageView.backgroundColor = [UIColor grayColor];
    
    m_playbackstoplock = [[NSCondition alloc] init];
    
    
    CGRect getFrame = [[UIScreen mainScreen]applicationFrame];
    m_nScreenHeight = getFrame.size.width;
    m_nScreenWidth = getFrame.size.height;
    
    navigationBar.barStyle = UIBarStyleBlackTranslucent;
    navigationBar.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"navbk.png"];
    
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationBar.alpha = 0.6f;
    
    UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:m_strName];
    
    NSArray *array = [NSArray arrayWithObjects:back, item, nil];
    [navigationBar setItems:array];
    
    [item release];
    [back release];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouched:)];
    [imageGR setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:imageGR];
    [imageGR release];
    
    
    //-------------bottomView--------------------------------------
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame] ;
    float bottomViewHeight = 60 ;
    float bottomViewX = 0;
    float bottomViewY = screenRect.size.width - bottomViewHeight ;
    float bottomViewWidth = screenRect.size.height;
    
    //NSLog(@"bottomViewX: %f, bottomViewY: %f, bottomViewWidth: %f, bottomViewHeight: %f", bottomViewX, bottomViewY, bottomViewWidth, bottomViewHeight);
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewWidth, bottomViewHeight)];
    bottomView.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    bottomView.alpha = 0.6f ;
    
    CGRect rectLabel = bottomView.bounds;
    
    UILabel *fileNameLabel = [[UILabel alloc] initWithFrame:rectLabel];
    fileNameLabel.textAlignment = UITextAlignmentCenter;
    fileNameLabel.text = m_strFileName;
    fileNameLabel.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    fileNameLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:fileNameLabel];
    [fileNameLabel release];
    
    [self.view addSubview:bottomView];
    
    self.LblProgress.text = NSLocalizedStringFromTable(@"Connecting", @STR_LOCALIZED_FILE_NAME,nil);
    self.LblProgress.textColor = [UIColor whiteColor];
    [self.progressView startAnimating];
    
    //=====================================================================
    m_pPPPPMgnt->SetDateTimeDelegate((char*)[strDID UTF8String], self);
    m_pPPPPMgnt->PPPPSetSystemParams((char*)[strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    m_pPPPPMgnt->SetPlaybackDelegate((char*)[strDID UTF8String], self);
    if (!m_pPPPPMgnt->PPPPStartPlayback((char*)[strDID UTF8String],(char*)[m_strFileName UTF8String], 0)) {
        [self performSelectorOnMainThread:@selector(StopPlayback) withObject:nil waitUntilDone:NO];
    }
    
    m_pPPPPMgnt->StartPPPPAudio([strDID UTF8String]);
    
    mTimer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkPlayOver) userInfo:nil repeats:YES];
    
}

- (void) imageTouched: (UITapGestureRecognizer*)sender
{
    m_bHideToolBar = !m_bHideToolBar ;
    
    [navigationBar setHidden:m_bHideToolBar];
    [bottomView setHidden:m_bHideToolBar];
    
}

- (void) viewWillAppear:(BOOL)animated
{
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (version >= 6.0) {//ios6
//        [self.view setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
//        
//        CGRect rectScreen = [[UIScreen mainScreen] applicationFrame];
//        
//        self.view.frame = rectScreen;//CGRectMake(0,0,480,320);
//    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(popToHome:)
     name:@"statuschange"
     object:nil];
}
- (void) viewWillDisappear:(BOOL)animated
{
    
    NSLog(@"viewWillDisappear");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"statuschange" object:nil];
    
}
-(void)popToHome:(NSNotification *)notification{//回到首页
    NSString *did=(NSString *)[notification object];
    NSLog(@"did=%@ m_strDID=%@",did,strDID);
    if ([strDID  caseInsensitiveCompare:did]==NSOrderedSame) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        //[mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (bottomView != nil) {
        [bottomView release];
        bottomView = nil;
    }
    if (playButton != nil) {
        [playButton release];
        playButton = nil;
    }
}

- (void) CreateGLView
{
    if (myGLViewController != nil) {
        return;
    }
    
    myGLViewController = [[MyGLViewController alloc] init];
    myGLViewController.view.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
    [self.view addSubview:myGLViewController.view];
    
    [self.view bringSubviewToFront:TimeStampLabel];
    [self.view bringSubviewToFront:navigationBar];
    [self.view bringSubviewToFront:bottomView];
}


#pragma mark------Orientations

- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void) dealloc
{
    self.navigationBar = nil;
    self.imageView = nil;
    self.strDID = nil;
    self.m_strFileName = nil;
    self.m_strName = nil;
    self.progressView = nil;
    self.LblProgress = nil;
    if (TimeStampLabel != nil) {
        [TimeStampLabel release];
        TimeStampLabel = nil;
    }
    
    if (bottomView != nil) {
        [bottomView release];
        bottomView = nil;
    }
    
    if (myGLViewController != nil) {
        [myGLViewController release];
        myGLViewController = nil;
    }
    
    if (m_playbackstoplock != nil) {
        [m_playbackstoplock release];
        m_playbackstoplock = nil;
    }
    [super dealloc];
}

#pragma mark -
#pragma mark performOnMainThread
- (void) updateImage: (UIImage*) image
{
    imageView.image = image;
    // [image release];
}

- (void) hideView
{
    [self.progressView setHidden:YES];
    [self.LblProgress setHidden:YES];
}
-(void)refreshOSDTime:(NSString *)osd{
    TimeStampLabel.text=osd;
    if (mModal==1) {
        TimeStampLabel.hidden=YES;
    }else{
        TimeStampLabel.hidden=NO;
    }
    
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self StopPlayback];
    return NO;
}


-(void)checkPlayOver{
    NSLog(@"checkPlayOver..999999999");
    if (isFirstFrame) {
        NSLog(@"checkPlayOver.还没有来第一帧");
        return;
    }
    if (isPlayOver) {
        
        [self performSelectorOnMainThread:@selector(StopPlayback) withObject:nil waitUntilDone:NO];
        NSLog(@"10还没有来数据结束回放");
    }else{
        isPlayOver=YES;
        NSLog(@"checkPlayOver..no over");
    }
}
#pragma mark -
#pragma mark- p2p回调
- (void)YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did
{
    // NSLog(@"YUVNotify......  length=%d width=%d height=%d",length,width,height);
    if (isFirstFrame) {
        isFirstFrame=NO;
    }
    isPlayOver=NO;
    
    NSTimeInterval se=(long)timestamp;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDate *dd=[date dateByAddingTimeInterval:-timezone];
    //NSLog(@"dd=%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]);
    NSString  *sOSD=[NSString stringWithFormat:@"%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]];
    // NSLog(@"sOSD=%@ YUV timstamp=%d TimeZone=%d",sOSD,timestamp,TimeZone);
    [self performSelectorOnMainThread:@selector(refreshOSDTime:) withObject:sOSD waitUntilDone:NO];
    
    if (![IpCameraClientAppDelegate is43Version]) {
        
        [self performSelectorOnMainThread:@selector(CreateGLView) withObject:nil waitUntilDone:NO];
        [myGLViewController WriteYUVFrame:yuv Len:length width:width height:height];
    }else{
        UIImage *image=[APICommon YUV420ToImage:yuv width:width height:height];
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
    }
    
    
    
    [self performSelectorOnMainThread:@selector(hideView) withObject:nil waitUntilDone:NO];
}

- (void)ImageNotify:(UIImage *)image timestamp:(NSInteger)timestamp DID:(NSString *)did
{
    NSLog(@"ImageNotify......image");
    if (isFirstFrame) {
        isFirstFrame=NO;
    }
    isPlayOver=NO;
    
    NSTimeInterval se=(long)timestamp;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDate *dd=[date dateByAddingTimeInterval:-timezone];
    //NSLog(@"dd=%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]);
    NSString  *sOSD=[NSString stringWithFormat:@"%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]];
    //NSLog(@"sOSD=%@  JPG  timstamp=%d TimeZone=%d",sOSD,timestamp,TimeZone);
    [self performSelectorOnMainThread:@selector(refreshOSDTime:) withObject:sOSD waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(hideView) withObject:nil waitUntilDone:NO];
}

- (void)H264Data:(Byte *)h264Frame length:(int)length type:(int)type timestamp:(NSInteger)timestamp DID:(NSString *)did
{
    
}
#pragma mark--DateTimeDelegate
-(void)DateTimeProtocolResult:(STRU_DATETIME_PARAMS)t{
    TimeZone=t.tz;
}
@end
