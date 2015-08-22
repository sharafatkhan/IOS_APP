//
//  KXPlayViewController.m
//  P2PCamera
//
//  Created by kaven on 15/3/10.
//
//

#import "KXPlayViewController.h"
#include "IpCameraClientAppDelegate.h"
#import "obj_common.h"
#import "PPPPDefine.h"
#import "mytoast.h"
#import "cmdhead.h"
#import "moto.h"
#import "CustomToast.h"
#import <sys/time.h>
#import "APICommon.h"
#include "time.h"
#import <QuartzCore/QuartzCore.h>
#import "KavenToast.h"
#import "KXToast.h"
@interface KXPlayViewController ()

@end

@implementation KXPlayViewController
@synthesize m_pPPPPChannelMgt;
@synthesize imgView;
@synthesize cameraName;
@synthesize strDID;
@synthesize progressView;
@synthesize LblProgress;

@synthesize timeoutLabel;
@synthesize m_nP2PMode;


@synthesize imgVGA;
@synthesize img720P;
@synthesize imgQVGA;

@synthesize imgNormal;
@synthesize imgEnlarge;
@synthesize imgFullScreen;
@synthesize imageSnapshot;
@synthesize m_pPicPathMgt;

@synthesize imageUp;
@synthesize imageDown;
@synthesize imageLeft;
@synthesize imageRight;
@synthesize m_pRecPathMgt;
@synthesize PicNotifyDelegate;
@synthesize RecNotifyDelegate;

@synthesize isRecording;
@synthesize recordFileName;
@synthesize recordFilePath;
@synthesize recordFileDate;
@synthesize recordNum;

@synthesize preDialog;
@synthesize setDialog;
@synthesize isP2P;

@synthesize m_strIp;
@synthesize m_strPort;
@synthesize m_strPwd;
@synthesize m_strUser;
@synthesize netUtiles;

@synthesize seeMoreDialog;
@synthesize frameDialog;

@synthesize btnMicrophone;
@synthesize btnDown;
@synthesize btnLeft;
@synthesize btnRight;
@synthesize btnUp;
@synthesize isMoreView;

@synthesize labelRecord;
@synthesize labelNetworkSpeed;

@synthesize strOSD;

@synthesize playViewResultDelegate;


@synthesize playBottomToolBar;
@synthesize playTopToolBar;
@synthesize verScrollToolBar;
@synthesize waveDialog;
@synthesize alarmDialog;
@synthesize userDefault;

@synthesize mAuthority;

@synthesize mModal;


#pragma mark---------viewDidLoad

- (void)dealloc {
    NSLog(@"PlayViewController dealloc");
    
    if (OSDLabel != nil) {
        [OSDLabel release];
        OSDLabel = nil;
    }
    if (TimeStampLabel != nil) {
        [TimeStampLabel release];
        TimeStampLabel = nil;
    }
    
    self.cameraName = nil;
    self.strDID = nil;
    if (alarmDialog!=nil) {
        [alarmDialog release];
        alarmDialog=nil;
    }
    
    [sliderContrast release];
    [labelContrast release];
    
    [sliderBrightness release];
    [labelBrightness release];
    self.imgVGA = nil;
    self.imgQVGA = nil;
    self.img720P = nil;
    
    self.imgEnlarge = nil;
    self.imgFullScreen = nil;
    self.imgNormal = nil;
    self.imageSnapshot = nil;
    
    self.btnUp=nil;
    self.btnDown=nil;
    self.btnRight=nil;
    self.btnLeft=nil;
    
    if (verScrollToolBar!=nil) {
        [verScrollToolBar release];
        verScrollToolBar=nil;
    }
    if (playTopToolBar!=nil) {
        [playTopToolBar release];
        playTopToolBar=nil;
    }
    
    if (playBottomToolBar!=nil) {
        [playBottomToolBar release];
        playBottomToolBar=nil;
    }
    if (m_RecordLock != nil) {
        [m_RecordLock release];
        m_RecordLock = nil;
        
    }
    
    self.m_pPicPathMgt = nil;
    self.m_pRecPathMgt = nil;
    self.PicNotifyDelegate = nil;
    if (myGLViewController != nil) {
        [myGLViewController release];
        myGLViewController = nil;
    }
    if (m_YUVDataLock != nil) {
        [m_YUVDataLock release];
        m_YUVDataLock = nil;
    }
    
    SAFE_DELETE(m_pYUVData);
    verScrollToolBar=nil;
    playBottomToolBar=nil;
    playTopToolBar=nil;
    waveDialog=nil;
    userDefault=nil;
    
    NSLog(@"PlayViewController dealloc   end");
    [super dealloc];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //    if (version >= 6.0) {
    //        [self.view setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    //
    //        CGRect rectScreen = [[UIScreen mainScreen] applicationFrame];
    //
    //        self.view.frame = rectScreen;//CGRectMake(0,0,480,320);
    //    }
    
    if (isMoreView) {
        NSLog(@"PlayView...more  viewWillAppear --->>> %d",isMoreView);
        
        IpCameraClientAppDelegate *IPCAMDelegate = [[UIApplication sharedApplication] delegate];
        IPCAMDelegate.moreViewPlayProtocol=self;
        [IpCameraClientAppDelegate setFourBackground:YES];
        
    }
    
}

-(void)popToHome{
    
    [self StopPlay:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    mainScreen=[[UIScreen mainScreen]bounds];
    NSLog(@"KXPlayViewController....w=%f h=%f",mainScreen.size.width,mainScreen.size.height);
    
    if (mainScreen.size.width>mainScreen.size.height) {
        int h=mainScreen.size.height;
        mainScreen.size.height=mainScreen.size.width;
        mainScreen.size.width=h;
    }
    
    m_nScreenHeight = mainScreen.size.width;
    m_nScreenWidth = mainScreen.size.height;
    
    imgStartWidth=m_nScreenWidth;
    imgStartHeight=m_nScreenHeight;
    
    [self initView];
    [self initTopBarView];
    [self initBottomBarView];
    [self initDialog];
    [self initLeftMenuView];
    
    
    
    strOSD=@"";
    isStop=NO;
    writeAudioDataNumber=0;
    recordNum=0;
    isRecording=NO;
    isTakepicturing=NO;
    m_videoFormat = -1;
    nUpdataImageCount = 0;
    m_bTalkStarted = NO;
    m_bAudioStarted = NO;
    m_bPtzIsUpDown = NO;
    m_bPtzIsLeftRight = NO;
    m_nDisplayMode = 0;
    m_nVideoWidth = 0;
    m_nVideoHeight = 0;
    m_pCustomRecorder = NULL;
    m_pYUVData = NULL;
    m_nWidth = 0;
    m_nHeight = 0;
    m_YUVDataLock = [[NSCondition alloc] init];
    m_RecordLock = [[NSCondition alloc] init];
    myGLViewController = nil;
    
    
    self.imgVGA = [UIImage imageNamed:@"resolution_vga_pressed"];
    self.imgQVGA = [UIImage imageNamed:@"resolution_qvga"];
    self.img720P = [UIImage imageNamed:@"resolution_720p_pressed"];
    self.imgNormal = [UIImage imageNamed:@"ptz_playmode_standard"];
    self.imgEnlarge = [UIImage imageNamed:@"ptz_playmode_enlarge"];
    self.imgFullScreen = [UIImage imageNamed:@"ptz_playmode_fullscreen"];
    
    //==========================================================
    [self setFirstEnterFullScreen:YES];
    
    m_pPPPPChannelMgt->SetDateTimeDelegate((char*)[strDID UTF8String], self);
    m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    if( m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self) == 0 ){
        [self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self getCameraParams];
    [self performSelector:@selector(playViewTouch:) withObject:nil afterDelay:1];
    timerCheckData=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkDataCome) userInfo:nil repeats:YES];
    
}

#pragma mark-------initView
-(void)initView{
    
    imgView=[[UIImageView alloc]init];
    imgView.frame=CGRectMake(0, 0, mainScreen.size.height, mainScreen.size.width);
    imgView.backgroundColor=[UIColor blackColor];
    imgView.userInteractionEnabled=YES;
    [self.view addSubview:imgView];
    [imgView release];
    
    
    labelRecord=[[UILabel alloc]init];
    labelRecord.frame=CGRectMake(mainScreen.size.height-120, 40, 100, 20);
    labelRecord.adjustsFontSizeToFitWidth=YES;
    labelRecord.textColor=[UIColor redColor];
    labelRecord.text=NSLocalizedStringFromTable(@"play_recording", @STR_LOCALIZED_FILE_NAME, nil);
    labelRecord.hidden=YES;
    [self.view addSubview:labelRecord];
    [labelRecord release];
    
    self.btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btnUp=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btnDown=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLeft setImage:[UIImage imageNamed:@"playleft.png"] forState:UIControlStateNormal];
    [self.btnRight setImage:[UIImage imageNamed:@"playright.png"] forState:UIControlStateNormal];
    [self.btnUp setImage:[UIImage imageNamed:@"playup.png"] forState:UIControlStateNormal];
    [self.btnDown setImage:[UIImage imageNamed:@"playdown.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnLeft];
    [self.view addSubview:btnRight];
    [self.view addSubview:btnUp];
    [self.view addSubview:btnDown];
    
    btnLeft.frame=CGRectMake(0, (mainScreen.size.width-45)/2, 45, 45);
    btnRight.frame=CGRectMake(mainScreen.size.height-45, (mainScreen.size.width-45)/2, 45, 45);
    btnUp.frame=CGRectMake((mainScreen.size.height-45)/2, 0, 45, 45);
    btnDown.frame=CGRectMake((mainScreen.size.height-45)/2, mainScreen.size.width-45, 45, 45);
    
    [btnLeft addTarget:self action:@selector(btnLeftDown) forControlEvents:UIControlEventTouchDown];
    [btnLeft addTarget:self action:@selector(btnLeftUp) forControlEvents:UIControlEventTouchUpInside];
    [btnRight addTarget:self action:@selector(btnRightDown) forControlEvents:UIControlEventTouchDown];
    [btnRight addTarget:self action:@selector(btnRightUp) forControlEvents:UIControlEventTouchUpInside];
    [btnUp addTarget:self action:@selector(btnUpDown) forControlEvents:UIControlEventTouchDown];
    [btnUp addTarget:self action:@selector(btnUpUp) forControlEvents:UIControlEventTouchUpInside];
    [btnDown addTarget:self action:@selector(btnDownDown) forControlEvents:UIControlEventTouchDown];
    [btnDown addTarget:self action:@selector(btnDownUp) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnMicrophone=[UIButton buttonWithType:UIButtonTypeCustom];
    btnMicrophone.frame=CGRectMake(mainScreen.size.height+60, mainScreen.size.width-190, 72, 72);
    [btnMicrophone setBackgroundImage:[UIImage imageNamed:@"microphoneselected.png"] forState:UIControlStateHighlighted];
    [btnMicrophone setBackgroundImage:[UIImage imageNamed:@"microphone.png"] forState:UIControlStateNormal];
    [btnMicrophone addTarget:self action:@selector(btnOpenTalkCloseListen) forControlEvents:UIControlEventTouchDown];
    [btnMicrophone addTarget:self action:@selector(btnOpenListenCloseTalk) forControlEvents:UIControlEventTouchUpInside];
    btnMicrophone.backgroundColor=[UIColor clearColor];
    [self.view addSubview:btnMicrophone];
    
    
    labelContrast  = [[UILabel alloc] initWithFrame:CGRectMake(100, (mainScreen.size.width-170)/2, 30, 170)];
    UIColor *labelColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    labelContrast.backgroundColor = labelColor;
    labelContrast.layer.masksToBounds = YES;
    labelContrast.userInteractionEnabled=YES;
    [self.view addSubview:labelContrast];
    [labelContrast setHidden:YES];
    
    sliderContrast = [[UISlider alloc] init];
    [sliderContrast setMaximumValue:255.0];
    [sliderContrast setMinimumValue:1.0];
    CGAffineTransform rotation = CGAffineTransformMakeRotation(-1.57079633);
    sliderContrast.transform = rotation;
    [sliderContrast setFrame:CGRectMake(100,  (mainScreen.size.width-160)/2, 30, 160)];
    [self.view addSubview:sliderContrast];
    [sliderContrast setHidden:YES];
    [sliderContrast addTarget:self action:@selector(updateContrast:) forControlEvents:UIControlEventTouchUpInside];
    
    m_bContrastShow = NO;
    labelBrightness  = [[UILabel alloc] initWithFrame:CGRectMake(mainScreen.size.height - 50, (mainScreen.size.width-170)/2, 30, 170)];
    labelBrightness.backgroundColor = labelColor;
    labelContrast.layer.masksToBounds = YES;
    labelBrightness.userInteractionEnabled=YES;
    [self.view addSubview:labelBrightness];
    [labelBrightness setHidden:YES];
    
    sliderBrightness = [[UISlider alloc] init];
    [sliderBrightness setMaximumValue:255.0];
    [sliderBrightness setMinimumValue:1.0];
    sliderBrightness.transform = rotation;
    [sliderBrightness setFrame:CGRectMake(mainScreen.size.height - 50, (mainScreen.size.width-160)/2, 30, 160)];
    [self.view addSubview:sliderBrightness];
    [sliderBrightness setHidden:YES];
    [sliderBrightness addTarget:self action:@selector(updateBrightness:) forControlEvents:UIControlEventTouchUpInside];
    
    m_bBrightnessShow = NO;
    
    m_bToolBarShow = YES;
    
    
    UIColor *osdColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.3f];
    
    ///////////////////////////////////////////////////////////////////
    OSDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [OSDLabel setNumberOfLines:0];
    UIFont *font = [UIFont fontWithName:@"Arial" size:18];
    CGSize size = CGSizeMake(170,100);
    OSDLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSString *s = cameraName;
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [OSDLabel setFrame: CGRectMake(10, 10, labelsize.width, labelsize.height)];
    OSDLabel.text = cameraName;
    OSDLabel.font = font;
    OSDLabel.layer.masksToBounds = YES;
    OSDLabel.layer.cornerRadius = 2.0;
    OSDLabel.backgroundColor = osdColor;
    [self.view addSubview:OSDLabel];
    [OSDLabel setHidden:YES];
    ///////////////////////////////////////////////////////////////////
    
    ///////////////////////////////////////////////////////////////////
    TimeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    TimeStampLabel.lineBreakMode = UILineBreakModeWordWrap;
    [TimeStampLabel setFrame: CGRectMake(mainScreen.size.height -220, 10, 210, 20)];
    TimeStampLabel.layer.masksToBounds = YES;
    TimeStampLabel.layer.cornerRadius = 2.0;
    TimeStampLabel.backgroundColor = osdColor;
    [self.view addSubview:TimeStampLabel];
    [TimeStampLabel setHidden:YES];
    
    
    [timeoutLabel setHidden:YES];
    //timeoutLabel.backgroundColor = osdColor;
    m_nTimeoutSec = 180;
    timeoutTimer = nil;
    
    //imgView.userInteractionEnabled = YES;
    bGetVideoParams = NO;
    bManualStop = NO;
    m_bGetStreamCodecType = NO;
    
    
    
    self.progressView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.progressView];
    [self.progressView setHidden:NO];
    [self.progressView startAnimating];
    CGRect frame=progressView.frame;
    progressView.frame=CGRectMake((mainScreen.size.height-frame.size.width)/2, (mainScreen.size.width-frame.size.height)/2, frame.size.width, frame.size.height);
    
    self.LblProgress=[[UILabel alloc]init];
    [self.view addSubview:self.LblProgress];
    CGRect frame2=LblProgress.frame;
    self.LblProgress.text = NSLocalizedStringFromTable(@"Connecting", @STR_LOCALIZED_FILE_NAME,nil);
    LblProgress.frame=CGRectMake((mainScreen.size.height-frame2.size.width)/2, (mainScreen.size.width-frame2.size.height)/2+frame.size.height+5, frame2.size.width, frame2.size.height);
    
    
    
    UIImageView *imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainScreen.size.height, mainScreen.size.width)];
    imageBg.backgroundColor = [UIColor blackColor];
    imageBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playViewTouch:)];
    [tapGes1 setNumberOfTapsRequired:1];
    [imageBg addGestureRecognizer:tapGes1];
    [tapGes1 release];
    
    UITapGestureRecognizer *tapGes2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playViewTouch:)];
    [tapGes2 setNumberOfTapsRequired:1];
    [imgView addGestureRecognizer:tapGes2];
    [tapGes2 release];
    
    [self.view addSubview:imageBg];
    [self.view sendSubviewToBack:imageBg];
    [imageBg release];
}

-(void)initDialog{
    isSetDialogShow=NO;
    isPresetDialogShow=NO;
    isCallPreset=YES;
    isSeeMoreDialogShow=NO;
    isFrameDialogShow=NO;
    isAlarmDialogShow=NO;
    
    
    setDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(-80, 50, 80, 180) Btn:4];
    setDialog.mType=1;
    [self.view addSubview:setDialog];
    setDialog.diaDelegate=self;
    setDialog.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
    [setDialog setBtnImag:[UIImage imageNamed:@"Led.png"] Index:0];
    [setDialog setBtnImag:[UIImage imageNamed:@"led_open.png"] Index:1];
    [setDialog setBtnTitle:NSLocalizedStringFromTable(@"preset", @STR_LOCALIZED_FILE_NAME, nil) Index:2];
    [setDialog setBtnTitle:NSLocalizedStringFromTable(@"play_watchmode", @STR_LOCALIZED_FILE_NAME, nil) Index:3];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
        preDialog=[[PresetDialog alloc]initWithFrame:CGRectMake(mainScreen.size.height-240,-190, 200, 190) Num:4 DID:strDID];
    }else{
        preDialog=[[PresetDialog alloc]initWithFrame:CGRectMake(mainScreen.size.height-231,-190, 200, 190) Num:4 DID:strDID];
    }
    [self.view addSubview:preDialog];
    preDialog.diaDelegate=self;
    preDialog.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
    
    
    seeMoreDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(100, -130, 120, 90) Btn:3];
    seeMoreDialog.mType=2;
    [self.view addSubview:seeMoreDialog];
    //    [seeMoreDialog setBtnTitle:NSLocalizedStringFromTable(@"play_goodvalue", @STR_LOCALIZED_FILE_NAME, nil) Index:0];
    [seeMoreDialog setBtnTitle:NSLocalizedStringFromTable(@"play_fastspeed", @STR_LOCALIZED_FILE_NAME, nil) Index:0];
    [seeMoreDialog setBtnTitle:NSLocalizedStringFromTable(@"play_goodfast", @STR_LOCALIZED_FILE_NAME, nil) Index:1];
    seeMoreDialog.diaDelegate=self;
    
    
    waveDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(100, -180, 120, 90) Btn:2];
    waveDialog.mType=4;
    [waveDialog setBtnTitle:@"50Hz" Index:0];
    [waveDialog setBtnTitle:@"60Hz" Index:1];
    waveDialog.diaDelegate=self;
    [self.view addSubview:waveDialog];
    
    
    alarmDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(100, -130, 120, 90) Btn:2];
    [alarmDialog setBtnTitle:NSLocalizedStringFromTable(@"play_alarmopen", @STR_LOCALIZED_FILE_NAME, nil) Index:0];
    [alarmDialog setBtnTitle:NSLocalizedStringFromTable(@"play_alarmclose", @STR_LOCALIZED_FILE_NAME, nil) Index:1];
    alarmDialog.mType=5;
    alarmDialog.diaDelegate=self;
    [self.view addSubview:alarmDialog];
    
    ledDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(100, -130, 120, 120) Btn:2];
    [ledDialog setBtnTitle:NSLocalizedStringFromTable(@"play_ledopen", @STR_LOCALIZED_FILE_NAME, nil) Index:0];
    [ledDialog setBtnTitle:NSLocalizedStringFromTable(@"play_ledclose", @STR_LOCALIZED_FILE_NAME, nil) Index:1];
    //    [ledDialog setBtnTitle:NSLocalizedStringFromTable(@"play_ledauto", @STR_LOCALIZED_FILE_NAME, nil) Index:2];
    ledDialog.mType=6;
    ledDialog.diaDelegate=self;
    [self.view addSubview:ledDialog];
    
    gpioDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(100, -130, 120, 90) Btn:2];
    [gpioDialog setBtnTitle:NSLocalizedStringFromTable(@"play_gpioopen", @STR_LOCALIZED_FILE_NAME, nil) Index:0];
    [gpioDialog setBtnTitle:NSLocalizedStringFromTable(@"play_gpioclose", @STR_LOCALIZED_FILE_NAME, nil) Index:1];
    gpioDialog.mType=7;
    gpioDialog.diaDelegate=self;
    [self.view addSubview:gpioDialog];
}
-(void)initTopBarView{
    playTopToolBar=[[MyPlayToolbar alloc]initWithFrame:CGRectMake(0, 0, mainScreen.size.height, 40) WithBtnNumber:8];
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
        playTopToolBar.mSpace=10;
    }
    [playTopToolBar SetBtnWidth:60 WithIndex:6];
    
    
    playTopToolBar.delegate=self;
    playTopToolBar.mType=0;
    [self.view addSubview:playTopToolBar];
    
    [playTopToolBar SetBtnImage:[UIImage imageNamed:@"more.png"] ForState:UIControlStateNormal WithIndex:0];
    [playTopToolBar SetBtnImage:[UIImage imageNamed:@"vert_tour.png"] ForState:UIControlStateNormal WithIndex:1];
    [playTopToolBar SetBtnImage:[UIImage imageNamed:@"hori_tour.png"] ForState:UIControlStateNormal WithIndex:2];
    [playTopToolBar SetBtnImage:[UIImage imageNamed:@"hori_mirror.png"] ForState:UIControlStateNormal WithIndex:3];
    [playTopToolBar SetBtnImage:[UIImage imageNamed:@"vert_mirror.png"] ForState:UIControlStateNormal WithIndex:4];
    [playTopToolBar SetBtnTitle:NSLocalizedStringFromTable(@"preset", @STR_LOCALIZED_FILE_NAME, nil) WithIndex:6];
    [playTopToolBar SetBtnImage:[UIImage imageNamed:@"exitbutton.png"] ForState:UIControlStateNormal WithIndex:7];
    
    [playTopToolBar SetBtnTitle:cameraName WithIndex:5];
    [playTopToolBar SetBtnTitleColor:[UIColor whiteColor] ForState:UIControlStateNormal WithIndex:5];
    [playTopToolBar SetBtnEnable:NO WithIndex:5];
    [playTopToolBar SetBtnBackgroudColor:[UIColor clearColor] WithIndex:5];
    [playTopToolBar SetBtnBackgroudImage:nil ForState:UIControlStateNormal WithIndex:5];
    
    
}
-(void)initBottomBarView{
    playBottomToolBar=[[MyPlayToolbar alloc]initWithFrame:CGRectMake(0, mainScreen.size.width-40, mainScreen.size.height, 40) WithBtnNumber:8];
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
        playBottomToolBar.mSpace=10;
    }
    [playBottomToolBar SetBtnWidth:60 WithIndex:6];
    
    playBottomToolBar.delegate=self;
    playBottomToolBar.mType=1;
    [self.view addSubview:playBottomToolBar];
    
    
    [playBottomToolBar SetBtnImage:[UIImage imageNamed:@"takepic.png"] ForState:UIControlStateNormal WithIndex:0];
    [playBottomToolBar SetBtnImage:[UIImage imageNamed:@"record.png"] ForState:UIControlStateNormal WithIndex:1];
    [playBottomToolBar SetBtnImage:[UIImage imageNamed:@"audio.png"] ForState:UIControlStateNormal WithIndex:2];
    //    [playBottomToolBar SetBtnImage:[UIImage imageNamed:@"zoomadd.png"] ForState:UIControlStateNormal WithIndex:3];
    //    [playBottomToolBar SetBtnImage:[UIImage imageNamed:@"zoom.png"] ForState:UIControlStateNormal WithIndex:4];
    
    [playBottomToolBar SetBtnEnable:NO WithIndex:3];
    [playBottomToolBar SetBtnEnable:NO WithIndex:4];
    [playBottomToolBar SetBtnTitle:@"QVGA" WithIndex:6];
    [playBottomToolBar SetBtnTitleColor:[UIColor whiteColor] ForState:UIControlStateNormal WithIndex:6];
    [playBottomToolBar SetBtnImage:[UIImage imageNamed:@"ptz_playmode_enlarge.png"] ForState:UIControlStateNormal WithIndex:7];
    [playBottomToolBar SetBtnEnable:NO WithIndex:0];
    [playBottomToolBar SetBtnEnable:NO WithIndex:1];
    [playBottomToolBar SetBtnEnable:NO WithIndex:5];
    [playBottomToolBar SetBtnBackgroudColor:[UIColor clearColor] WithIndex:5];
    [playBottomToolBar SetBtnBackgroudImage:nil ForState:UIControlStateNormal WithIndex:5];
}

-(void)initLeftMenuView{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        verScrollToolBar=[[MyVerticalScrollToolBar alloc]initWithFrame:CGRectMake(-100, 41, 90, 200) Btn:8 BtnSpace:1 WithIphone:YES];
    }else{
        verScrollToolBar=[[MyVerticalScrollToolBar alloc]initWithFrame:CGRectMake(-100, 41, 90, 440) Btn:8 BtnSpace:1 WithIphone:NO];
    }
    
    verScrollToolBar.delegate=self;
    //    [verScrollToolBar setBtnTitle:NSLocalizedStringFromTable(@"play_mode", @STR_LOCALIZED_FILE_NAME, nil) Index:0];
    //    [verScrollToolBar setBtnTitleColor:[UIColor whiteColor] ForState:UIControlStateNormal WithIndex:0];
    [verScrollToolBar setBtnImag:[UIImage imageNamed:@"contrast.png"] Index:0];
    [verScrollToolBar setBtnImag:[UIImage imageNamed:@"brightness.png"] Index:1];
    [verScrollToolBar setBtnImag:[UIImage imageNamed:@"ptzdefault.png"] Index:2];
    [verScrollToolBar setBtnImag:[UIImage imageNamed:@"led_open.png"] Index:3];
    //    [verScrollToolBar setBtnImag:[UIImage imageNamed:@"gpio_close.png"] Index:5];
    //    [verScrollToolBar setBtnImag:[UIImage imageNamed:@"waves.png"] Index:6];
    [verScrollToolBar setBtnImag:[UIImage imageNamed:@"playalarm.png"] Index:4];
    [self.view addSubview:verScrollToolBar];
}
#pragma mark------CreateOpenGl
- (void) CreateGLView
{
    NSLog(@">>>>>>>>>>>>>>>CreateGLView");
    
    imgView.hidden=YES;
    myGLViewController = [[MyGLViewController alloc] init];
    myGLViewController.view.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
    [self.view addSubview:myGLViewController.view];
    [self.view bringSubviewToFront:OSDLabel];
    [self.view bringSubviewToFront:TimeStampLabel];
    
    [self.view bringSubviewToFront:labelBrightness];
    [self.view bringSubviewToFront:labelContrast];
    [self.view bringSubviewToFront:sliderBrightness];
    [self.view bringSubviewToFront:sliderContrast];
    [self.view bringSubviewToFront:timeoutLabel];
    [self.view bringSubviewToFront:setDialog];
    [self.view bringSubviewToFront:preDialog];
    [self.view bringSubviewToFront:seeMoreDialog];
    [self.view bringSubviewToFront:frameDialog];
    [self.view bringSubviewToFront:progressView];
    [self.view bringSubviewToFront:btnMicrophone];
    [self.view bringSubviewToFront:labelNetworkSpeed];
    [self.view bringSubviewToFront:labelRecord];
    [self.view bringSubviewToFront:verScrollToolBar];
    [self.view bringSubviewToFront:playTopToolBar];
    [self.view bringSubviewToFront:playBottomToolBar];
    [self.view bringSubviewToFront:waveDialog];
    [self.view bringSubviewToFront:btnLeft];
    [self.view bringSubviewToFront:btnRight];
    [self.view bringSubviewToFront:btnUp];
    [self.view bringSubviewToFront:btnDown];
    [self.view bringSubviewToFront:alarmDialog];
    [self.view bringSubviewToFront:ledDialog];
    [self.view bringSubviewToFront:gpioDialog];
    
}

#pragma mark------startAudio/Talk
- (void) StartAudio
{
    m_pPPPPChannelMgt->StartPPPPAudio([strDID UTF8String]);
}

- (void) StopAudio
{
    m_pPPPPChannelMgt->StopPPPPAudio([strDID UTF8String]);
}

- (void) StartTalk
{
    m_pPPPPChannelMgt->StartPPPPTalk([strDID UTF8String]);
}

- (void) StopTalk
{
    m_pPPPPChannelMgt->StopPPPPTalk([strDID UTF8String]);
}
#pragma mark--------StopPlay
//停止播放，并返回到设备列表界面
- (void) StopPlay:(int)bForce
{
    NSLog(@"StopPlay....");
    
    if (timerCheckData!=nil) {
        [timerCheckData invalidate];
        timerCheckData=nil;
    }
    
    if (isRecording) {
        m_pPPPPChannelMgt->stopRecordAVI((char*)[strDID UTF8String]);
    }
    
    isStop=YES;
    
    isDataComeback=NO;
    if (m_pCustomRecorder != nil) {
        isRecording=NO;
        SAFE_DELETE(m_pCustomRecorder);
        [RecNotifyDelegate NotifyReloadData];
    }
    if (m_pPPPPChannelMgt != NULL) {
        m_pPPPPChannelMgt->StopPPPPAudio([strDID UTF8String]);
        m_pPPPPChannelMgt->StopPPPPTalk([strDID UTF8String]);
        m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, nil);
        m_pPPPPChannelMgt->StopPPPPLivestream([strDID UTF8String]);
        m_pPPPPChannelMgt->SetDateTimeDelegate((char*)[strDID UTF8String], nil);
    }
    
    if (timeoutTimer != nil) {
        [timeoutTimer invalidate];
        timeoutTimer = nil;
    }
    if (isMoreView) {
        IpCameraClientAppDelegate *IPCAMDelegate = [[UIApplication sharedApplication] delegate];
        IPCAMDelegate.moreViewPlayProtocol=nil;
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
        
        if ([IpCameraClientAppDelegate getFourBackground]==YES) {
            [IPCAMDelegate switchBack];
           
        }else
            [IPCAMDelegate playEnterFourView];
        
         NSLog(@"~~~~~~Kplay~~~~getFourBackground(%d)",[IpCameraClientAppDelegate getFourBackground]);
        
    }else{
        IpCameraClientAppDelegate *IPCAMDelegate = [[UIApplication sharedApplication] delegate];
        [IPCAMDelegate switchBack];
    }
    
    if (bForce != 1 && bManualStop == NO) {
        if (isMoreView) {
            [CustomToast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)
                            superView:self.view
                            bLandScap:YES];
        }else{
            [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
        }
    }
}
#pragma mark--------BtnClick


-(void)playToolbarDownClick:(int)type Index:(int)index{
    switch (type) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            switch (index) {
                case 3:
                {
                    isZoomPlus=YES;
                    [self btnZoomPlus];
                }
                    break;
                case 4:
                {
                    isZoomMinus=YES;
                    [self btnZoomMinus];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}
-(void)playToolbarClick:(int)type Index:(int)index{
    NSLog(@"－－－－－－－－－mAuthority[%d],index[%d]",mAuthority,index);
    
    
    switch (type) {
        case 0://PlayTopBar
        {
            if (mAuthority==USER_VISITOR && index !=7) {
                [CustomToast showWithText:NSLocalizedStringFromTable(@"not_authority", @STR_LOCALIZED_FILE_NAME, nil)
                                superView:self.view
                                bLandScap:YES];
                return;
            }
            
            switch (index) {
                case 0://menu
                {
                    
                    
                    [self btnMenu];
                }
                    break;
                case 1://tourVertical
                {
                    [self btnTourVertical];
                }
                    break;
                case 2://tourHorizonal
                {
                    [self btnTourHorizonal];
                }
                    break;
                case 3://verticalMirror
                {
                    [self btnHorizonalMirror];
                }
                    break;
                case 4://horizonalMirror
                {
                    
                    
                    [self btnVerticalMirror];
                }
                    break;
                case 5://cameraName
                {
                    
                }
                    break;
                case 6://preset
                {
//                    if (mAuthority==USER_OPERATOR) {
//                        [CustomToast showWithText:NSLocalizedStringFromTable(@"not_authority", @STR_LOCALIZED_FILE_NAME, nil)
//                                        superView:self.view
//                                        bLandScap:YES];
//                        return;
//                    }
                    
                    [self btnPreset];
                }
                    break;
                case 7://exit
                {
                    [self btnExit];
                }
                    
                    
                default:
                    break;
            }
        }
            break;
        case 1://PlayBottomBar
        {
            if (mAuthority==USER_VISITOR && index !=7) {
                [CustomToast showWithText:NSLocalizedStringFromTable(@"not_authority", @STR_LOCALIZED_FILE_NAME, nil)
                                superView:self.view
                                bLandScap:YES];
                return;
            }
            
            switch (index) {
                case 0://takePicture
                {
                    [self btnTakePicture];
                }
                    break;
                case 1://recordVideo
                {
                    [self btnRecordVidoe];
                }
                    break;
                case 2://Speak
                {
//                    if (mAuthority==USER_OPERATOR) {
//                        [CustomToast showWithText:NSLocalizedStringFromTable(@"not_authority", @STR_LOCALIZED_FILE_NAME, nil)
//                                        superView:self.view
//                                        bLandScap:YES];
//                        return;
//                    }
                    [self btnSpeak];
                }
                    break;
                case 3://zoomPlus
                {
                    isZoomPlus=NO;
                    [self btnZoomPlus];
                }
                    break;
                case 4://zoomMinus
                {
                    isZoomMinus=NO;
                    [self btnZoomMinus];
                }
                    break;
                case 5://space
                {
                    
                }
                    break;
                case 6://resolution
                {
//                    if (mAuthority==USER_OPERATOR) {
//                        [CustomToast showWithText:NSLocalizedStringFromTable(@"not_authority", @STR_LOCALIZED_FILE_NAME, nil)
//                                        superView:self.view
//                                        bLandScap:YES];
//                        return;
//                    }
                    [self btnResolution];
                }
                    break;
                case 7://switchScreen
                {
                    
                    [self btnSwitchScreen];
                }
                    
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}
-(void)VerScrollBarClick:(int)type Index:(int)index{
    switch (index) {
            /*case 0://playmode
             {
             [self btnPlayMode];
             }
             break;*/
        case 0://contrast
        {
            [self btnContranst];
        }
            break;
            
        case 1://brightness
        {
            [self btnBrightness];
        }
            
            break;
            
        case 2://setdefault
        {
            [self btnDefaultCameraParam];
        }
            break;
        case 3://led
        {
            [self btnLed];
        }
            break;
            
            /*case 5://GPIO
             {
             [self btnGPIO];
             }
             break;*/
            
            /*case 6://waves
             {
             [self btnWaves];
             }
             break;*/
            
        case 4://alarm
        {
            [self btnAlarm];
        }
            break;
            
        case 5://Waves
        {
            
        }
            break;
            
        case 6://alarm
        {
            NSLog(@"btnAlarm");
            
            
        }
            break;
            
            
        default:
            break;
    }
}

- (IBAction) btnMore:(id)sender{
    if (isSeeMoreDialogShow) {
        [self showSeeMoreDialog:isSeeMoreDialogShow];
        isSeeMoreDialogShow=!isSeeMoreDialogShow;
    }
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
    
    if (isAlarmDialogShow) {
        [self showAlarmDialog:isAlarmDialogShow];
        isAlarmDialogShow=!isAlarmDialogShow;
    }
    if (isWaveDialogShow) {
        [self showWaveDialog:isWaveDialogShow];
        isWaveDialogShow=!isWaveDialogShow;
    }
    if (isGPIODilaogShow) {
        [self showGPIODialog:isGPIODilaogShow];
        isGPIODilaogShow=!isGPIODilaogShow;
    }
    if (isLedDialogShow) {
        [self showLedDialog:isLedDialogShow];
        isLedDialogShow=!isLedDialogShow;
    }
    
    [self showSetDialog:isSetDialogShow];
    isSetDialogShow=!isSetDialogShow;
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
}
-(void)btnMenu{
    [self showSetDialog:isSetDialogShow];
    isSetDialogShow=!isSetDialogShow;
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
}
-(void)btnTourVertical{
    if (m_bPtzIsUpDown) {
        if (isP2P) {
            m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_UP_DOWN_STOP);
        }else{
            [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:CMD_PTZ_UP_DOWN_STOP Step:0];
            
        }
        [playTopToolBar SetBtnSelect:NO WithIndex:1];
        
    }else {
        if (isP2P) {
            m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_UP_DOWN);
        }else{
            [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:CMD_PTZ_UP_DOWN Step:0];
            
        }
        [playTopToolBar SetBtnSelect:YES WithIndex:1];
    }
    m_bPtzIsUpDown = !m_bPtzIsUpDown;
}
-(void)btnTourHorizonal{
    if (m_bPtzIsLeftRight) {
        if (isP2P) {
            m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_LEFT_RIGHT_STOP);
        }else{
            [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:CMD_PTZ_LEFT_RIGHT_STOP Step:0];
            
        }
        
        
        [playTopToolBar SetBtnSelect:NO WithIndex:2];
    }else {
        if (isP2P) {
            m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_LEFT_RIGHT);
        }else{
            [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:CMD_PTZ_LEFT_RIGHT Step:0];
            
        }
        
        [playTopToolBar SetBtnSelect:YES WithIndex:2];
    }
    m_bPtzIsLeftRight = !m_bPtzIsLeftRight;
}
-(void)btnVerticalMirror{
    int value;
    
    if (m_bUpDownMirror) {
        [playTopToolBar SetBtnSelect:NO WithIndex:4];
        
        if (m_bLeftRightMirror) {
            value = 2;
        }else {
            value = 0;
        }
    }else {
        
        [playTopToolBar SetBtnSelect:YES WithIndex:4];
        if (m_bLeftRightMirror) {
            value = 3;
        }else {
            value = 1;
        }
    }
    
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 5, value);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:5 Value:value];
    }
    m_bUpDownMirror = !m_bUpDownMirror;
}
-(void)btnHorizonalMirror{
    int value;
    
    if (m_bLeftRightMirror) {
        
        [playTopToolBar SetBtnSelect:NO WithIndex:3];
        if (m_bUpDownMirror) {
            value = 1;
        }else {
            value = 0;
        }
    }else {
        
        
        [playTopToolBar SetBtnSelect:YES WithIndex:3];
        if (m_bUpDownMirror) {
            value = 3;
        }else {
            value = 2;
        }
    }
    
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 5, value);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:5 Value:value];
    }
    m_bLeftRightMirror = !m_bLeftRightMirror;
}
-(void)btnPreset{
    if (isFrameDialogShow) {
        [self showFrameDialog:isFrameDialogShow];
        isFrameDialogShow=!isFrameDialogShow;
    }
    if (isSeeMoreDialogShow) {
        [self showSeeMoreDialog:isSeeMoreDialogShow];
        isSeeMoreDialogShow=!isSeeMoreDialogShow;
    }
    if (isWaveDialogShow) {
        [self showWaveDialog:isWaveDialogShow];
        isWaveDialogShow=!isWaveDialogShow;
    }
    if (isAlarmDialogShow) {
        [self showAlarmDialog:isAlarmDialogShow];
        isAlarmDialogShow=!isAlarmDialogShow;
    }
    
    if (isLedDialogShow) {
        [self showLedDialog:isLedDialogShow];
        isLedDialogShow=!isLedDialogShow;
    }
    
    if (isGPIODilaogShow) {
        [self showGPIODialog:isGPIODilaogShow];
        isGPIODilaogShow=!isGPIODilaogShow;
    }
    
    [self showPresetDialog:isPresetDialogShow];
    isPresetDialogShow=!isPresetDialogShow;
}
-(void)btnExit{
    if (isRecording) {
        //
        [CustomToast showWithText:NSLocalizedStringFromTable(@"play_stop_record_p", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        //[KXToast showWithText:NSLocalizedStringFromTable(@"play_stop_record_p", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    isDelayOpenAudio=NO;
    bManualStop = YES;
    
    if (playViewResultDelegate!=nil&&bPlaying) {
        UIImage *image = nil;
        if (m_videoFormat == 3) {//MJPEG
            image = imageSnapshot;
        }else{//H264
            [m_YUVDataLock lock];
            //yuv->image
            image = [APICommon YUV420ToImage:m_pYUVData width:m_nWidth height:m_nHeight];
            [m_YUVDataLock unlock];
        }
        [playViewResultDelegate playViewExitResultImg:image DID:strDID];
    }
    
    [self StopPlay: 0];
    
}
-(void)btnTakePicture{
    if (isTakepicturing) {
        
        return ;
    }
    //[NSThread detachNewThreadSelector:@selector(takePicProcess) toTarget:self withObject:nil];
    isTakepicturing=YES;
}
-(void)takePicProcess:(UIImage*)img{
    
    UIImage *image = img;
    if(m_videoFormat!= 3 && m_videoFormat != 2) //MJPEG && H264
    {
        return ;
    }
    
    
    if (takePicNumber>8) {
        takePicNumber=0;
    }
    takePicNumber++;
    //------save image--------
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath=nil;
    if (isP2P) {
        strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    }else{
        strPath = [documentsDirectory stringByAppendingPathComponent:m_strIp];
    }
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //[fileManager createDirectoryAtPath:strPath attributes:nil];
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    strDateTime=[NSString stringWithFormat:@"%@_%d",strDateTime,takePicNumber];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* strDate = [formatter stringFromDate:date];
    
    NSString *strFileName =nil;
    if (isP2P) {
        strFileName = [NSString stringWithFormat:@"%@_%@.jpg", strDID, strDateTime];
    }else{
        strFileName = [NSString stringWithFormat:@"%@_%@.jpg", m_strIp, strDateTime];
        
    }
    strPath = [strPath stringByAppendingPathComponent:strFileName];
    //NSLog(@"strPath: %@", strPath);
    
    //NSData *dataImage = UIImageJPEGRepresentation(imageSnapshot, 1.0);
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    if([dataImage writeToFile:strPath atomically:YES ])
    {
        if (isP2P) {
            if (m_pPicPathMgt!=nil) {
                [m_pPicPathMgt InsertPicPath:strDID PicDate:strDate PicPath:strFileName];
            }
            
        }else{
            if (m_pPicPathMgt!=nil) {
                [m_pPicPathMgt InsertPicPath:m_strIp PicDate:strDate PicPath:strFileName];
            }
            
        }
    }
    
    [pool release];
    
    [formatter release];
    isTakepicturing=NO;
    [self performSelectorOnMainThread:@selector(showTakePicResult) withObject:nil waitUntilDone:NO];
    
}

-(void)showTakePicResult{
    //[KXToast showWithText:NSLocalizedStringFromTable(@"TakePictureSuccess", @STR_LOCALIZED_FILE_NAME, nil)];
    [CustomToast showWithText:NSLocalizedStringFromTable(@"TakePictureSuccess", @STR_LOCALIZED_FILE_NAME, nil)
                    superView:self.view
                    bLandScap:YES];
    NSLog(@"拍照完成....");
    if (PicNotifyDelegate!=nil) {
        [PicNotifyDelegate NotifyReloadData];
    }
}

-(void)btnRecordVidoe{
    if (m_videoFormat == -1) {
        return ;
    }
    
    [m_RecordLock lock];
    
    if (m_pCustomRecorder == NULL) {
        BOOL flag=[self isOutOfMemory];
        if (flag) {
            [CustomToast showWithText:NSLocalizedStringFromTable(@"deviceMemoryOver", @STR_LOCALIZED_FILE_NAME, nil)
                            superView:self.view
                            bLandScap:YES];
            return;
        }
        labelRecord.hidden=NO;
        m_pCustomRecorder = new CCustomAVRecorder();
        recordFileName = [self GetRecordFileName];
        recordFilePath = [self GetRecordPath: [NSString stringWithFormat:@"%@.avi",recordFileName] andType:1];
        //        NSLog(@"录像。。。recordFilePath=%@  cameraName=%@",recordFilePath,cameraName);
        //录制AVI
        NSString *strFormat=@"h264";
        if (m_videoFormat==3)
        {
            strFormat=@"mjpg";
        }
        m_pPPPPChannelMgt->startRecordAVI((char*)[strDID UTF8String], (char*)[recordFilePath UTF8String], (char*)[strFormat UTF8String], aviWidth, aviHeight);
        
        
        recordFilePath = [self GetRecordPath: [NSString stringWithFormat:@"%@.obj",recordFileName] andType:0];
        
        if(m_pCustomRecorder->StartRecord((char*)[recordFilePath UTF8String], m_videoFormat, (char*)[strDID UTF8String]))
        {
            NSDate* date = [NSDate date];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            recordFileDate = [formatter stringFromDate:date];
            if (isP2P) {
                if (m_pRecPathMgt!=nil) {
                    [m_pRecPathMgt InsertPath:strDID Date:recordFileDate Path:[NSString stringWithFormat:@"%@.obj",recordFileName]];
                }
                
                
            }else{
                if (m_pRecPathMgt!=nil) {
                    [m_pRecPathMgt InsertPath:m_strIp Date:recordFileDate Path:[NSString stringWithFormat:@"%@.obj",recordFileName]];
                }
                
                
            }
            [formatter release];
        }
        
        [playBottomToolBar SetBtnSelect:YES WithIndex:1];
        [playBottomToolBar SetBtnEnable:NO WithIndex:6];
        [playBottomToolBar SetBtnTitleColor:[UIColor grayColor] ForState:UIControlStateNormal WithIndex:6];
        
        isRecording=YES;
    }else {
        labelRecord.hidden=YES;
        isRecording=NO;
        m_pPPPPChannelMgt->stopRecordAVI((char*)[strDID UTF8String]);
        
        [playBottomToolBar SetBtnEnable:YES WithIndex:6];
        [playBottomToolBar SetBtnTitleColor:[UIColor whiteColor] ForState:UIControlStateNormal WithIndex:6];
        
        SAFE_DELETE(m_pCustomRecorder);
        [RecNotifyDelegate NotifyReloadData];
        [playBottomToolBar SetBtnSelect:NO WithIndex:1];
        recordNum=0;
    }
    
    [m_RecordLock unlock];
}
-(void)btnSpeak{
    isDelayOpenAudio=NO;
    if (isMicrophoneShow) {
        
        [self StopTalk];
        [self StopAudio];
        [playBottomToolBar SetBtnSelect:NO WithIndex:2];
    }else{
        [self StopTalk];
        [self StartAudio];
        
        [playBottomToolBar SetBtnSelect:YES WithIndex:2];
    }
    [self showBtnMicrophone:isMicrophoneShow];
    isMicrophoneShow=!isMicrophoneShow;
}
-(void)btnResolution{
    if (isP2P) {
        if (bGetVideoParams == NO || m_bGetStreamCodecType == NO) {
            return ;
        }
    }
    
    int resolution = 0;
    if (m_StreamCodecType == STREAM_CODEC_TYPE_JPEG) {
        if (nResolution == 0) {
            resolution = 1;
            
        }else {
            resolution = 0;
        }
    }else {
        switch (nResolution) {
            case 0:
                resolution = 1;
                break;
            case 1:
                resolution = 3;
                break;
            case 3:
                resolution = 0;
                break;
            default:
                return;
        }
    }
    
    progressView.hidden=NO;
    [progressView startAnimating];
    
    nResolution = resolution;
    
    NSLog(@"CameraControl resolution[%d]",resolution);
    //    if (isP2P) {
    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, resolution);
    //    }else{
    //        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:0 Value:resolution];
    //
    //    }
    nUpdataImageCount = 0;
    [self performSelector:@selector(getCameraParams) withObject:nil afterDelay:3.0];
}
-(void)btnSwitchScreen{
    switch (m_nDisplayMode) {
        case 0:
            m_nDisplayMode = 2;
            break;
            
        case 2:
            m_nDisplayMode = 0;
            break;
        default:
            m_nDisplayMode = 0;
            break;
    }
    
    [self setDisplayMode];
}
-(void)btnContranst{
    if (m_bContrastShow) {
        [self showContrastSlider:NO];
    }else {
        [self showContrastSlider:YES];
    }
    m_bContrastShow = !m_bContrastShow;
}
-(void)btnBrightness{
    if (m_bBrightnessShow) {
        [self showBrightnessSlider:NO];
    }else {
        [self showBrightnessSlider:YES];
    }
    m_bBrightnessShow = !m_bBrightnessShow;
}
-(void)btnDefaultCameraParam{
    sliderBrightness.value = 1;
    sliderContrast.value = 128;
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 7, 1);
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 7, 128);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:1 Value:1];
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:2 Value:128];
    }
    [CustomToast showWithText:NSLocalizedStringFromTable(@"DefaultVideoParams", @STR_LOCALIZED_FILE_NAME, nil)
                    superView:self.view
                    bLandScap:YES];
    int delay=0;
    if (mModal==1) {
        delay=2;
    }
    [self performSelector:@selector(getCameraParams) withObject:nil afterDelay:delay];
    
}
-(void)btnLed{
    
    
    if (isSeeMoreDialogShow) {
        [self showSeeMoreDialog:isSeeMoreDialogShow];
        isSeeMoreDialogShow=!isSeeMoreDialogShow;
    }
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
    
    if (isAlarmDialogShow) {
        [self showAlarmDialog:isAlarmDialogShow];
        isAlarmDialogShow=!isAlarmDialogShow;
    }
    if (isWaveDialogShow) {
        [self showWaveDialog:isWaveDialogShow];
        isWaveDialogShow=!isWaveDialogShow;
    }
    if (isGPIODilaogShow) {
        [self showGPIODialog:isGPIODilaogShow];
        isGPIODilaogShow=!isGPIODilaogShow;
    }
    [self showLedDialog:isLedDialogShow];
    isLedDialogShow=!isLedDialogShow;
    
}
-(void)btnLedOpen{
    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 14, 1);
    
}
-(void)btnGPIO{
    
    
    if (isSeeMoreDialogShow) {
        [self showSeeMoreDialog:isSeeMoreDialogShow];
        isSeeMoreDialogShow=!isSeeMoreDialogShow;
    }
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
    
    if (isAlarmDialogShow) {
        [self showAlarmDialog:isAlarmDialogShow];
        isAlarmDialogShow=!isAlarmDialogShow;
    }
    if (isWaveDialogShow) {
        [self showWaveDialog:isWaveDialogShow];
        isWaveDialogShow=!isWaveDialogShow;
    }
    if (isLedDialogShow) {
        [self showLedDialog:isLedDialogShow];
        isLedDialogShow=!isLedDialogShow;
    }
    
    
    [self showGPIODialog:isGPIODilaogShow];
    isGPIODilaogShow=!isGPIODilaogShow;
    
}
-(void)btnGPIOOpen{
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], 94);
    
}
-(void)btnWaves{
    if (isSeeMoreDialogShow) {
        [self showSeeMoreDialog:isSeeMoreDialogShow];
        isSeeMoreDialogShow=!isSeeMoreDialogShow;
    }
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
    
    if (isAlarmDialogShow) {
        [self showAlarmDialog:isAlarmDialogShow];
        isAlarmDialogShow=!isAlarmDialogShow;
    }
    if (isLedDialogShow) {
        [self showLedDialog:isLedDialogShow];
        isLedDialogShow=!isLedDialogShow;
    }
    
    if (isGPIODilaogShow) {
        [self showGPIODialog:isGPIODilaogShow];
        isGPIODilaogShow=!isGPIODilaogShow;
    }
    
    [self showWaveDialog:isWaveDialogShow];
    isWaveDialogShow=!isWaveDialogShow;
}
-(void)btnAlarm{
    if (isSeeMoreDialogShow) {
        [self showSeeMoreDialog:isSeeMoreDialogShow];
        isSeeMoreDialogShow=!isSeeMoreDialogShow;
    }
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
    if (isWaveDialogShow) {
        [self showWaveDialog:isWaveDialogShow];
        isWaveDialogShow=!isWaveDialogShow;
    }
    if (isLedDialogShow) {
        [self showLedDialog:isLedDialogShow];
        isLedDialogShow=!isLedDialogShow;
    }
    
    if (isGPIODilaogShow) {
        [self showGPIODialog:isGPIODilaogShow];
        isGPIODilaogShow=!isGPIODilaogShow;
    }
    [self showAlarmDialog:isAlarmDialogShow];
    isAlarmDialogShow=!isAlarmDialogShow;
}

-(void)btnZoomMinus{
    if (isZoomMinus) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 17, 1);
    }else{
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 17, 0);
    }
    //    isZoomMinus=!isZoomMinus;
    //    [playBottomToolBar SetBtnSelect:isZoomMinus WithIndex:4];
}
-(void)btnZoomPlus{
    if (isZoomPlus) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 18, 1);
    }else{
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 18, 0);
    }
    //    isZoomPlus=!isZoomPlus;
    //    [playBottomToolBar SetBtnSelect:isZoomPlus WithIndex:3];
}

-(void)btnPlayMode{
    if (isLedDialogShow) {
        [self showLedDialog:isLedDialogShow];
        isLedDialogShow=!isLedDialogShow;
    }
    if (isAlarmDialogShow) {
        [self showAlarmDialog:isAlarmDialogShow];
        isAlarmDialogShow=!isAlarmDialogShow;
    }
    if (isGPIODilaogShow) {
        [self showGPIODialog:isGPIODilaogShow];
        isGPIODilaogShow=!isGPIODilaogShow;
    }
    if (isWaveDialogShow) {
        [self showWaveDialog:isWaveDialogShow];
        isWaveDialogShow=!isWaveDialogShow;
    }
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
    [self showSeeMoreDialog:isSeeMoreDialogShow];
    isSeeMoreDialogShow=!isSeeMoreDialogShow;
}

-(void)btnOpenListenCloseTalk{
    NSLog(@"btnOpenListenCloseTalk");
    [self StopTalk];
    isDelayOpenAudio=YES;
    [self performSelector:@selector(delayOpenAudio) withObject:nil afterDelay:3];
    [playBottomToolBar SetBtnImage:[UIImage imageNamed:@"audio.png"] ForState:UIControlStateSelected WithIndex:2];
}
-(void)btnOpenTalkCloseListen{
    NSLog(@"btnOpenTalkCloseListen");
    [self StopAudio];
    [self StartTalk];
    
    [playBottomToolBar SetBtnImage:[UIImage imageNamed:@"micro_on.png"] ForState:UIControlStateSelected WithIndex:2];
}
-(void)delayOpenAudio{
    if (isDelayOpenAudio) {
        [self StartAudio];
    }
    
}

-(void)btnLeftDown{
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_LEFT_RUN);
}
-(void)btnLeftUp{
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_LEFT_STOP);
}
-(void)btnRightDown{
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_RIGHT_RUN);
}
-(void)btnRightUp{
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_RIGHT_STOP);
}
-(void)btnUpDown{
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_UP_RUN);
}
-(void)btnUpUp{
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_UP_STOP);
}
-(void)btnDownDown{
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_DOWN_RUN);
}
-(void)btnDownUp{
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_DOWN_STOP);
}

#pragma mark-------ImageViewTouch
- (void) playViewTouch: (id) param
{
    //NSLog(@"touch....");
    m_bToolBarShow = !m_bToolBarShow;
    [self ShowToolBar:m_bToolBarShow];
    
    
    
    [self showFourBtn:isFoutBtnShow];
    isFoutBtnShow=!isFoutBtnShow;
    
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
    if (isFrameDialogShow) {
        [self showFrameDialog:isFrameDialogShow];
        isFrameDialogShow=!isFrameDialogShow;
    }
    if (isSeeMoreDialogShow) {
        [self showSeeMoreDialog:isSeeMoreDialogShow];
        isSeeMoreDialogShow=!isSeeMoreDialogShow;
    }
    if (isSetDialogShow) {
        [self showSetDialog:isSetDialogShow];
        isSetDialogShow=!isSetDialogShow;
    }
    if (isGPIODilaogShow) {
        [self showGPIODialog:isGPIODilaogShow];
        isGPIODilaogShow=!isGPIODilaogShow;
    }
    if (isLedDialogShow) {
        [self showLedDialog:isLedDialogShow];
        isLedDialogShow=!isLedDialogShow;
    }
    if (isAlarmDialogShow) {
        [self showAlarmDialog:isAlarmDialogShow];
        isAlarmDialogShow=!isAlarmDialogShow;
    }
    
    if (isWaveDialogShow) {
        [self showWaveDialog:isWaveDialogShow];
        isWaveDialogShow=!isWaveDialogShow;
    }
    
    
    //    if (isMicrophoneShow) {
    //        [self showBtnMicrophone:isMicrophoneShow];
    //        isMicrophoneShow=!isMicrophoneShow;
    //    }
    
    if (m_bToolBarShow) {
        [OSDLabel setHidden:YES];
        [TimeStampLabel setHidden:YES];
        
    }else {
        m_bContrastShow = NO;
        m_bBrightnessShow = NO;
        [self showBrightnessSlider:NO];
        [self showContrastSlider:NO];
        
    }
}

#pragma mark--------ShowDialog
-(void)showAlarmDialog:(BOOL)bShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=alarmDialog.frame;
    if (bShow) {
        frame.origin.y-=160;
    }else{
        frame.origin.y+=160;
    }
    alarmDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}
-(void)showPresetDialog:(BOOL)bShow{
    NSLog(@"showPresetDialog...");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=preDialog.frame;
    if (bShow) {
        frame.origin.y-=240;
    }else{
        frame.origin.y+=240;
    }
    preDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}

-(void)showSetDialog:(BOOL)bShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDuration:0.4];
    CGRect frame=verScrollToolBar.frame;
    if (bShow) {
        frame.origin.x-=100;
    }else{
        frame.origin.x+=100;
    }
    verScrollToolBar.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}
-(void)showSeeMoreDialog:(BOOL)bShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=seeMoreDialog.frame;
    if (bShow) {
        frame.origin.y-=175;
    }else{
        frame.origin.y+=175;
    }
    seeMoreDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}
-(void)showLedDialog:(BOOL)bShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=ledDialog.frame;
    if (bShow) {
        frame.origin.y-=175;
    }else{
        frame.origin.y+=175;
    }
    ledDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}
-(void)showGPIODialog:(BOOL)bShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=gpioDialog.frame;
    if (bShow) {
        frame.origin.y-=175;
    }else{
        frame.origin.y+=175;
    }
    gpioDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}

-(void)showFrameDialog:(BOOL)bShow{
    NSLog(@"showFrameDialog...start");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=frameDialog.frame;
    if (bShow) {
        frame.origin.y-=225;
    }else{
        frame.origin.y+=225;
    }
    frameDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
    // NSLog(@"showFrameDialog...end");
}

-(void)showBtnMicrophone:(BOOL)bShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=btnMicrophone.frame;
    if (bShow) {
        frame.origin.x+=150;
    }else{
        frame.origin.x-=150;
    }
    btnMicrophone.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}
-(void)showWaveDialog:(BOOL)bShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=waveDialog.frame;
    if (bShow) {
        frame.origin.y-=225;
    }else{
        frame.origin.y+=225;
    }
    waveDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}
- (void) ShowToolBar: (BOOL) bShow
{
    //开始动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStop)];
    
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    
    //动画的内容
    CGRect frame = playTopToolBar.frame;
    if (bShow == YES) {
        frame.origin.y += frame.size.height;
    }else {
        frame.origin.y -= frame.size.height;
    }
    [playTopToolBar setFrame:frame];
    
    CGRect frame2 = playTopToolBar.frame;
    CGRect frame3 = timeoutLabel.frame;
    
    if (bShow == YES) {
        frame3.origin.y -= frame2.size.height;
    }else {
        frame3.origin.y += frame2.size.height;
    }
    [timeoutLabel setFrame:frame3];
    
    
    CGRect bottomFrame=playBottomToolBar.frame;
    
    if (bShow == YES) {
        bottomFrame.origin.y -= bottomFrame.size.height;
    }else {
        bottomFrame.origin.y += bottomFrame.size.height;
    }
    [playBottomToolBar setFrame:bottomFrame];
    
    //动画结束
    [UIView commitAnimations];
}
- (void) animationStop
{
    //NSLog(@"animation stop");
    if (!m_bToolBarShow) {
        [self showOSD];
    }
}
#pragma mark--------DialogDelegate
-(void)mySetDialogOnClick:(int)tag Type:(int)type{//预置位和红外灯
    NSLog(@"mySetDialogOnClick type=%d tag=%d",type,tag);
    switch (type) {
        case 1:
            switch (tag) {
                case 0:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 14, 0);
                        [setDialog setBtnSelected:YES Index:0];
                        [setDialog setBtnSelected:NO Index:1];
                    }else{
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:14 Value:0];
                        [setDialog setBtnSelected:YES Index:0];
                        [setDialog setBtnSelected:NO Index:1];
                    }
                    
                    break;
                case 1:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 14, 1);
                        [setDialog setBtnSelected:NO Index:0];
                        [setDialog setBtnSelected:YES Index:1];
                    }else{
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:14 Value:1];
                        [setDialog setBtnSelected:NO Index:0];
                        [setDialog setBtnSelected:YES Index:1];
                    }
                    
                    
                    break;
                case 2:
                    NSLog(@"预置位。。。");
                    if (isFrameDialogShow) {
                        [self showFrameDialog:isFrameDialogShow];
                        isFrameDialogShow=!isFrameDialogShow;
                    }
                    if (isSeeMoreDialogShow) {
                        [self showSeeMoreDialog:isSeeMoreDialogShow];
                        isSeeMoreDialogShow=!isSeeMoreDialogShow;
                    }
                    
                    [self showPresetDialog:isPresetDialogShow];
                    isPresetDialogShow=!isPresetDialogShow;
                    break;
                case 3:
                    if (isFrameDialogShow) {
                        [self showFrameDialog:isFrameDialogShow];
                        isFrameDialogShow=!isFrameDialogShow;
                    }
                    if (isPresetDialogShow) {
                        [self showPresetDialog:isPresetDialogShow];
                        isPresetDialogShow=!isPresetDialogShow;
                    }
                    [self showSeeMoreDialog:isSeeMoreDialogShow];
                    isSeeMoreDialogShow=!isSeeMoreDialogShow;
                    break;
                case 4:
                    if (isSeeMoreDialogShow) {
                        [self showSeeMoreDialog:isSeeMoreDialogShow];
                        isSeeMoreDialogShow=!isSeeMoreDialogShow;
                    }
                    if (isPresetDialogShow) {
                        [self showPresetDialog:isPresetDialogShow];
                        isPresetDialogShow=!isPresetDialogShow;
                    }
                    [self showFrameDialog:isFrameDialogShow];
                    isFrameDialogShow=!isFrameDialogShow;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            [self showSeeMoreDialog:isSeeMoreDialogShow];
            isSeeMoreDialogShow=!isSeeMoreDialogShow;
            
            [self.progressView setHidden:NO];
            [self.progressView startAnimating];
            
            switch (tag) {
                case 10://质量优先
                    NSLog(@"质量优先");
                    [seeMoreDialog setBtnSelected:YES Index:0];
                    [seeMoreDialog setBtnSelected:NO Index:1];
                    //[seeMoreDialog setBtnSelected:NO Index:2];
                    
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 13, 2500);//码率
                        usleep(100);
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 10);//帧率
                    }else{
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:13 Value:2500];
                        usleep(100);
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:10];
                    }
                    nResolution=0;
                    [self performSelector:@selector(setResolution) withObject:nil afterDelay:10];
                    break;
                case 0://速度优先
                    [seeMoreDialog setBtnSelected:YES Index:0];
                    [seeMoreDialog setBtnSelected:NO Index:1];
                    ///ß[seeMoreDialog setBtnSelected:NO Index:2];
                    NSLog(@"速度优先");
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 13, 800);//码率
                        usleep(100);
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 20);//帧率
                    }else{
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:13 Value:800];
                        usleep(100);
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:20];
                    }
                    nResolution=1;
                    [self performSelector:@selector(setResolution) withObject:nil afterDelay:10];
                    break;
                case 1://画质中等
                    NSLog(@"画质中等");
                    [seeMoreDialog setBtnSelected:NO Index:0];
                    [seeMoreDialog setBtnSelected:YES Index:1];
                    //[seeMoreDialog setBtnSelected:YES Index:2];
                    
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 13, 1300);//码率
                        usleep(100);
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 15);//帧率
                    }else{
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:13 Value:1300];
                        usleep(100);
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:15];
                    }
                    nResolution=0;
                    [self performSelector:@selector(setResolution) withObject:nil afterDelay:10];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            [self showFrameDialog:isFrameDialogShow];
            isFrameDialogShow=!isFrameDialogShow;
            
            [self.progressView setHidden:NO];
            [self.progressView startAnimating];
            switch (tag) {
                case 0:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 5);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:5];
                    }
                    
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",5] Index:4];
                    break;
                case 1:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 10);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:10];
                    }
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",10] Index:4];
                    break;
                case 2:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 15);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:15];
                    }
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",15] Index:4];
                    break;
                case 3:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 20);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:20];
                    }
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",20] Index:4];
                    break;
                case 4:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 25);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:25];
                    }
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",25] Index:4];
                    break;
                case 5:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 30);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:30];
                    }
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",30] Index:4];
                    break;
                default:
                    break;
            }
            [self performSelector:@selector(hindeProgressView) withObject:nil afterDelay:5];
            break;
        case 4:
        {
            [self showWaveDialog:isWaveDialogShow];
            isWaveDialogShow=!isWaveDialogShow;
            switch (tag) {
                case 0:
                    [waveDialog setBtnSelected:YES Index:0];
                    [waveDialog setBtnSelected:NO Index:1];
                    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 3, 0);
                    break;
                case 1:
                    [waveDialog setBtnSelected:NO Index:0];
                    [waveDialog setBtnSelected:YES Index:1];
                    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 3, 1);
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 5:
        {
            switch (tag) {
                case 0:
                {
                    m_pPPPPChannelMgt->SetPlayAlarm((char*)[strDID UTF8String], 1, 1);
                }
                    break;
                case 1:
                {
                    m_pPPPPChannelMgt->SetPlayAlarm((char*)[strDID UTF8String], 0, 0);
                }
                    break;
                    
                default:
                    break;
            }
            
            [self showAlarmDialog:isAlarmDialogShow];
            isAlarmDialogShow=!isAlarmDialogShow;
        }
            break;
        case 6://Led
        {
            switch (tag) {
                case 0://红外灯开
                    [ledDialog setBtnSelected:YES Index:0];
                    [ledDialog setBtnSelected:NO Index:1];
                    //                    [ledDialog setBtnSelected:NO Index:2];
                    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 14, 1);
                    break;
                case 1://红外灯关
                    [ledDialog setBtnSelected:NO Index:0];
                    [ledDialog setBtnSelected:YES Index:1];
                    //                    [ledDialog setBtnSelected:NO Index:2];
                    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 14, 0);
                    break;
                case 2://红外灯自动
                    [ledDialog setBtnSelected:NO Index:0];
                    [ledDialog setBtnSelected:NO Index:1];
                    [ledDialog setBtnSelected:YES Index:2];
                    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 14,2);
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 7://GPIO
        {
            switch (tag) {
                case 0://GPIO开
                    [gpioDialog setBtnSelected:YES Index:0];
                    [gpioDialog setBtnSelected:NO Index:1];
                    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], 94);
                    break;
                case 1://GPIO关
                    [gpioDialog setBtnSelected:YES Index:1];
                    [gpioDialog setBtnSelected:NO Index:0];
                    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], 95);
                    break;
                    
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
}
#pragma mark--------PresetClick
-(void)presetDialogOnClick:(int)tag{
    NSLog(@"presetDialogOnClick  tag=%d",tag);
    
    switch (tag) {
        case 101:
            isCallPreset=YES;
            
            break;
        case 102:
        {
            isCallPreset=NO;
            
        }
            break;
        case 1:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 30);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:30 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 31);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:31 Step:0];
                }
                
            }
            break;
        case 2:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 32);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:32 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 33);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:33 Step:0];
                }
                
            }
            break;
        case 3:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 34);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:34 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 35);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:35 Step:0];
                }
                
            }
            break;
        case 4:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 36);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:36 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 37);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:37 Step:0];
                }
                
            }
            break;
        case 5:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 38);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:38 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 39);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:39 Step:0];
                }
                
            }
            break;
        case 6:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 40);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:40 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 41);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:41 Step:0];
                }
                
            }
            break;
        case 7:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 42);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:42 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 43);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:43 Step:0];
                }
                
            }
            break;
            
        case 8:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 44);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:44 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 45);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:45 Step:0];
                }
                
            }
            break;
        case 9:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 46);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:46 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 47);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:47 Step:0];
                }
                
            }
            break;
        case 10:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 48);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:48 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 49);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:49 Step:0];
                }
                
            }
            break;
        case 11:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 50);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:50 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 51);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:51 Step:0];
                }
                
            }
            break;
        case 12:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 52);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:52 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 53);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:53 Step:0];
                }
                
            }
            break;
        case 13:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 54);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:54 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 55);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:55 Step:0];
                }
                
            }
            break;
        case 14:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 56);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:56 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 57);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:57 Step:0];
                }
                
            }
            break;
        case 15:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 58);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:58 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 59);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:59 Step:0];
                }
                
            }
            break;
        case 16:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 60);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:60 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 61);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:61 Step:0];
                }
                
            }
            break;
            
        default:
            break;
    }
    if (tag!=101&&tag!=102) {
        [self showPresetDialog:YES];
        isPresetDialogShow=NO;
        UIImage *image=nil;
        if (!isCallPreset) {
            if (m_videoFormat==3) {
                image = imageSnapshot;
            }else{
                [m_YUVDataLock lock];
                if (m_YUVDataLock == NULL) {
                    [m_YUVDataLock unlock];
                    return;
                }
                //yuv->image
                image = [APICommon YUV420ToImage:m_pYUVData width:m_nWidth height:m_nHeight];
                [m_YUVDataLock unlock];
            }
        }
        [preDialog savePresetImage:image Index:tag];
    }
}

#pragma mark--------ShowOSD
- (void) showOSD
{
    if (mModal==1) {
        OSDLabel.hidden=YES;
        TimeStampLabel.hidden=YES;
    }else{
        [OSDLabel setHidden:NO];
        if (bPlaying == YES) {
            [TimeStampLabel setHidden:NO];
        }
    }
}
#pragma mark--------ShowBrightness/Contrast
- (void) showContrastSlider: (BOOL) bShow
{
    [labelContrast setHidden:!bShow];
    [sliderContrast setHidden:!bShow];
    
}

- (void) showBrightnessSlider: (BOOL) bShow
{
    [labelBrightness setHidden:!bShow];
    [sliderBrightness setHidden:!bShow];
}
- (void) updateContrast: (id) sender
{
    UISlider  *slider=(UISlider*)sender;
    float f = slider.value;
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 2, f);
        NSLog(@"sliderContrast....f=%f",f);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:2 Value:f];
    }
}

- (void) updateBrightness: (id) sender
{
    UISlider  *slider=(UISlider*)sender;
    
    float f = slider.value;
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 1, f);
        NSLog(@"updateBrightness....f=%f",f);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:1 Value:f];
    }
}
#pragma mark------UpdateOSD
- (void) updateTimestamp:(NSString *)osd
{
    //    if (mModal==1) {
    //        TimeStampLabel.hidden=YES;
    //        OSDLabel.hidden=YES;
    //    }else{
    //        if (TimeStampLabel!=nil) {
    //            TimeStampLabel.text = osd;
    //        }
    //    }
    if (mModal==1) {
        TimeStampLabel.hidden=YES;
        OSDLabel.hidden=YES;
    }else{
        if (TimeStampLabel!=nil) {
            NSString *strDate=[osd substringWithRange:NSMakeRange(0, 10)];
            NSString *strTime=[osd substringWithRange:NSMakeRange(11, 8)];
            int hour=[[strTime substringWithRange:NSMakeRange(0, 2)] intValue];
            NSString *timeRetain=[strTime substringFromIndex:2];
            //NSLog(@"timeRetain=%@",timeRetain);
            if (hour<=12) {
                osd=[NSString stringWithFormat:@" %@  AM  %@",strDate,strTime];
            }else{
                
                hour-=12;
                if (hour<10) {
                    osd=[NSString stringWithFormat:@" %@  PM  0%d%@",strDate,hour,timeRetain];
                }else{
                    osd=[NSString stringWithFormat:@" %@  PM  %d%@",strDate,hour,timeRetain];
                }
                
            }
            
            TimeStampLabel.text = osd;
        }
    }
}


#pragma mark------GetCameraParams
- (void) getCameraParams
{
    m_pPPPPChannelMgt->GetCGI([strDID UTF8String], CGI_IEGET_CAM_PARAMS);
}

#pragma mark------touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    beginPoint = [[touches anyObject] locationInView:imgView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesMoved");
    
    CGPoint p1;
    CGPoint p2;
    CGFloat sub_x;
    CGFloat sub_y;
    CGFloat currentDistance;
    CGRect imgFrame;
    
    NSArray * touchesArr=[[event allTouches] allObjects];
    
    //NSLog(@"手指个数%d",[touchesArr count]);
    //    NSLog(@"%@",touchesArr);
    
    if ([touchesArr count]>=2) {
        isScale=YES;
        p1=[[touchesArr objectAtIndex:0] locationInView:self.view];
        p2=[[touchesArr objectAtIndex:1] locationInView:self.view];
        
        sub_x=p1.x-p2.x;
        sub_y=p1.y-p2.y;
        
        currentDistance=sqrtf(sub_x*sub_x+sub_y*sub_y);
        
        if (lastDistance>0) {
            if (myGLViewController==nil) {
                imgFrame=imgView.frame;
            }else{
                imgFrame=myGLViewController.view.frame;
            }
            
            
            if (currentDistance>lastDistance+2) {
                NSLog(@"放大");
                
                imgFrame.size.width+=10;
                if (imgFrame.size.width>1000) {
                    imgFrame.size.width=1000;
                }
                
                lastDistance=currentDistance;
            }
            if (currentDistance<lastDistance-2) {
                NSLog(@"缩小");
                
                imgFrame.size.width-=10;
                
                if (imgFrame.size.width<50) {
                    imgFrame.size.width=50;
                }
                
                lastDistance=currentDistance;
            }
            
            if (lastDistance==currentDistance) {
                
                if (myGLViewController==nil) {
                    imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
                    
                    float addwidth=imgFrame.size.width-imgView.frame.size.width;
                    float addheight=imgFrame.size.height-imgView.frame.size.height;
                    
                    imgView.frame=CGRectMake(imgFrame.origin.x-addwidth/2.0f, imgFrame.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
                }else{
                    imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
                    
                    float addwidth=imgFrame.size.width-myGLViewController.view.frame.size.width;
                    float addheight=imgFrame.size.height-myGLViewController.view.frame.size.height;
                    
                    myGLViewController.view.frame=CGRectMake(imgFrame.origin.x-addwidth/2.0f, imgFrame.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
                }
                
            }
            
        }else {
            lastDistance=currentDistance;
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    lastDistance=0;
    
    
    
    if (isScale) {
        isScale=NO;
        return;
    }
    
    if (bPlaying == NO)
    {
        return;
    }
    
    
    
    CGPoint currPoint = [[touches anyObject] locationInView:imgView];
    const int EVENT_PTZ = 1;
    int curr_event = EVENT_PTZ;
    
    int x1 = beginPoint.x;
    int y1 = beginPoint.y;
    int x2 = currPoint.x;
    int y2 = currPoint.y;
    //NSLog(@"x1=%d y1=%d x2=%d y2=%d",x1,y1,x2,y2);
    int view_width = imgView.frame.size.width;
    int _width1 = 0;
    int _width2 = view_width  ;
    
    if(x1 >= _width1 && x1 <= _width2)
    {
        curr_event = EVENT_PTZ;
    }
    else
    {
        return;
    }
    
    const int MIN_X_LEN = 60;
    const int MIN_Y_LEN = 60;
    
    int len = (x1 > x2) ? (x1 - x2) : (x2 - x1) ;
    BOOL b_x_ok = (len >= MIN_X_LEN ) ? YES : NO ;
    len = (y1 > y2) ? (y1 - y2) : (y2 - y1) ;
    BOOL b_y_ok = (len > MIN_Y_LEN) ? YES : NO;
    
    BOOL bUp = NO;
    BOOL bDown = NO;
    BOOL bLeft = NO;
    BOOL bRight = NO;
    
    bDown = (y1 > y2) ? NO : YES;
    bUp = !bDown;
    bRight = (x1 > x2) ? NO : YES;
    bLeft = !bRight;
    
    int command = 0;
    
    switch (curr_event)
    {
        case EVENT_PTZ:
        {
            
            if (b_x_ok == YES)
            {
                if (bLeft == YES)
                {
                    NSLog(@"left");
                    //command = CMD_PTZ_LEFT;
                    command = CMD_PTZ_RIGHT;
                }
                else
                {
                    NSLog(@"right");
                    //command = CMD_PTZ_RIGHT;
                    command = CMD_PTZ_LEFT;
                }
                
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], command);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:command Step:1];
                    
                }
                if (isMove) {
                    return;
                }
                isMove=YES;
                progressView.hidden=NO;
                [progressView startAnimating];
                [self performSelector:@selector(hindeProgressView) withObject:nil afterDelay:2];
                
            }
            
            if (b_y_ok == YES)
            {
                
                if (bUp == YES)
                {
                    NSLog(@"up");
                    //command = CMD_PTZ_UP;
                    command = CMD_PTZ_DOWN;
                }
                else
                {
                    NSLog(@"down");
                    //command = CMD_PTZ_DOWN;
                    command = CMD_PTZ_UP;
                }
                
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], command);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:command Step:1];
                }
                if (isMove) {
                    return;
                }
                isMove=YES;
                progressView.hidden=NO;
                [progressView startAnimating];
                [self performSelector:@selector(hindeProgressView) withObject:nil afterDelay:2];
                
            }
        }
            break;
            
        default:
            return ;
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesCancelled");
}

#pragma  mark--DateTimeProtoco
-(void)DateTimeProtocolResult:(STRU_DATETIME_PARAMS)t{
    NSLog(@"DateTimeProtocolResult timeZone=%d",t.tz);
    timezone=t.tz;
    
}

#pragma mark PPPPStatusDelegate
- (void) PPPPStatus:(NSString *)astrDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    //NSLog(@"PlayViewController strDID: %@, statusType: %d, status: %d", astrDID, statusType, status);
    //处理PPP的事件通知
    
    if (bManualStop == YES) {
        return;
    }
    
    if(isStop){
        return;
    }
    //这个一般情况下是不会发生的
    if ([astrDID isEqualToString:strDID] == NO) {
        return;
    }
    
    //如果是PPP断开，则停止播放
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS && status == PPPP_STATUS_DISCONNECT) {
        //[mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
        NSLog(@"断线。。。。。");
        isDataComeback=NO;
        [self performSelectorOnMainThread:@selector(onMainThread) withObject:nil waitUntilDone:NO];
        
    }
    
}
-(void)onMainThread{
    [self performSelector:@selector(reConnectLivestream) withObject:nil afterDelay:5];
}
-(void)reConnectLivestream{
    NSLog(@"reConnectLivestream...");
    if( m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self) == 0 ){
        [self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
        
        return;
    }
    
    [NSTimer  scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkReconnectOk) userInfo:nil repeats:NO];
}
-(void)checkReconnectOk{
    NSLog(@"checkReconnectOk...isDataComeback=%d",isDataComeback);
    if (!isDataComeback) {
        
        [self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
    }
}
- (void) ParamNotify:(int)paramType params:(void *)params
{
    //NSLog(@"PlayViewController ParamNotify");
    if(isStop){
        return;
    }
    
    if (paramType == CGI_IEGET_CAM_PARAMS) {
        PSTRU_CAMERA_PARAM pCameraParam = (PSTRU_CAMERA_PARAM)params;
        m_Contrast = pCameraParam->contrast;
        m_Brightness = pCameraParam->bright;
        nResolution = pCameraParam->resolution;
        m_nFlip = pCameraParam->flip;
        mFrame=pCameraParam->enc_framerate;
        bGetVideoParams = YES;
        NSLog(@"PlayViewController ParamNotify...nResolution=%d",nResolution);
        [self performSelectorOnMainThread:@selector(UpdateVieoDisplay) withObject:nil waitUntilDone:NO];
        
        
        return;
    }
    
    if (paramType == STREAM_CODEC_TYPE) {
        //NSLog(@"STREAM_CODEC_TYPE notify");
        m_StreamCodecType = *((int*)params);
        m_bGetStreamCodecType = YES;
        
    }
    
}

#pragma mark------CheckMemery
-(void)stopRecordForMemoryOver{
    [playBottomToolBar SetBtnEnable:YES WithIndex:6];
    [playBottomToolBar SetBtnTitleColor:[UIColor whiteColor] ForState:UIControlStateNormal WithIndex:6];
    isRecording=NO;
    SAFE_DELETE(m_pCustomRecorder);
    [RecNotifyDelegate NotifyReloadData];
    [playBottomToolBar SetBtnEnable:NO WithIndex:1];
    [CustomToast showWithText:NSLocalizedStringFromTable(@"deviceMemoryOver", @STR_LOCALIZED_FILE_NAME, nil)
                    superView:self.view
                    bLandScap:YES];
    recordNum=0;
}

-(BOOL)isOutOfMemory {
    
    //    return NO;
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    [fileManager release];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    float free=([freeSpace longLongValue])/1024.0/1024.0/1024.0;
    float total=([totalSpace longLongValue])/1024.0/1024.0/1024.0;
    NSString *memory=@"";
    if (free>1.0) {
        memory=[NSString stringWithFormat:@"%0.1fG/%0.1fG",free,total];
        //strMemory=[[NSString alloc]initWithFormat:@"%0.1fG/%0.1fG",free,total];
    }else{
        free=([freeSpace longLongValue])/1024.0/1024.0;
        memory=[NSString stringWithFormat:@"%0.1fM/%0.1fG",free,total];
        if (free<100.0) {
            [self performSelectorOnMainThread:@selector(showMemory:) withObject:memory waitUntilDone:NO];
            return YES;
        }
    }
    NSLog(@"memory=%@",memory);
    
    [self performSelectorOnMainThread:@selector(showMemory:) withObject:memory waitUntilDone:NO];
    
    return NO;
}

-(void)showMemory:(NSString *)memory{
    //labelRecord.text=[NSString stringWithFormat:@"%@ %@",memory,NSLocalizedStringFromTable(@"play_recording", @STR_LOCALIZED_FILE_NAME, nil)];
}
-(void)stopMoreViewPlay{
    NSLog(@"stopMoreViewPlay");
    [self StopPlay:1];
}

#pragma mark------VideoDataCallback


- (void) H264Data:(Byte *)h264Frame length:(int)length type:(int)type timestamp:(NSInteger) timestamp DID:(NSString *)did
{
    //NSLog(@"H264Data... length: %d, type: %d", length, type);
    NSTimeInterval se=(long)timestamp;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDate *dd=[date dateByAddingTimeInterval:-timezone];
    //NSLog(@"dd=%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]);
    NSString  *sOSD=[NSString stringWithFormat:@"%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]];
    //NSLog(@"h246...sOSD=%@",sOSD);
    
    if(isStop){
        return;
    }
    
    if (m_videoFormat == -1) {
        m_videoFormat = 2;
        [self performSelectorOnMainThread:@selector(enableButton) withObject:nil waitUntilDone:NO];
    }
    
    
    [m_RecordLock lock];
    if (m_pCustomRecorder != nil) {
        recordNum++;
        if (recordNum==100) {
            recordNum=0;
            BOOL flag=[self isOutOfMemory];
            if (flag) {
                [self performSelectorOnMainThread:@selector(stopRecordForMemoryOver) withObject:self waitUntilDone:NO];
            }
        }
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        unsigned int unTimestamp = 0;
        struct timeval tv;
        struct timezone tz;
        gettimeofday(&tv, &tz);
        unTimestamp = tv.tv_usec / 1000 + tv.tv_sec * 1000 ;
        if (type==0) {//i帧
            writeH264Number=0;
            writeAudioDataNumber=1;
            //NSLog(@"H264Data... 录像一i帧");
            m_pCustomRecorder->SendOneFrame((char*)h264Frame, length, unTimestamp, type,timezone,timestamp);
        }else {
            if (writeH264Number<5) {
                writeH264Number++;
                // NSLog(@"H264Data... 录像p帧 %d",writeH264Number);
                m_pCustomRecorder->SendOneFrame((char*)h264Frame, length, unTimestamp, type,timezone,timestamp);
            }
        }
        [pool release];
    }
    [m_RecordLock unlock];
}
-(void)AudioDataBack:(Byte *)data Length:(int)len{
    [m_RecordLock lock];
    if (m_pCustomRecorder != nil) {
        // NSLog(@"AudioDataBack.....len=%d",len);
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        unsigned int unTimestamp = 0;
        struct timeval tv;
        struct timezone tz;
        gettimeofday(&tv, &tz);
        unTimestamp = tv.tv_usec / 1000 + tv.tv_sec * 1000 ;
        if (writeAudioDataNumber>0) {//writeAudioDataNumber>0是为了保证录像文件的第一帧是视频
            m_pCustomRecorder->SendOneFrame((char*)data, len, unTimestamp, 6,0,0);
        }
        [pool release];
    }
    [m_RecordLock unlock];
    
}
- (void) YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did
{
    //NSLog(@"YUVNotify.... length: %d, timestamp: %d, width: %d, height: %d DID:%@", length, timestamp, width, height,did);
    
    if(isStop){
        return;
    }
    
    mDataComeDelayTime=0;
    
    if (aviWidth==0) {
        aviWidth=width;
        aviHeight=height;
    }else{
        if (isRecording)
        {
            if (aviWidth!=width)
            {
                NSLog(@"分辨率改变，需要重新录像");
                aviWidth=width;
                aviHeight=height;
                
                [self performSelectorOnMainThread:@selector(recordedResolutionChange) withObject:nil waitUntilDone:NO];
            }
        }
    }
    
    
    isDataComeback=YES;
    
    
    NSTimeInterval se=(long)timestamp;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDate *dd=[date dateByAddingTimeInterval:-timezone];
    //NSLog(@"dd=%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]);
    NSString  *sOSD=[NSString stringWithFormat:@"%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]];
    
    
    if (bPlaying == NO)
    {
        
        m_StreamCodecType=1;
        bPlaying = YES;
        [self performSelectorOnMainThread:@selector(CreateGLView) withObject:nil waitUntilDone:YES];
        [self updataResolution:width height:height];
        [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:NO];
        
    }
    
    
    [self performSelectorOnMainThread:@selector(updateTimestamp:) withObject:sOSD waitUntilDone:NO];
    
    
    
    [myGLViewController WriteYUVFrame:yuv Len:length width:width height:height];
    
    if (isTakepicturing) {
        UIImage *image=[APICommon YUV420ToImage:yuv width:width height:height];
        [self takePicProcess:image];
    }
    
    //NSDate *date=[NSDate date];
    //NSLog(@"高清   时间  date=%@",[date description]);
    [m_YUVDataLock lock];
    SAFE_DELETE(m_pYUVData);
    int yuvlength = width * height * 3 / 2;
    m_pYUVData = new Byte[yuvlength];
    m_nLength=yuvlength;
    memcpy(m_pYUVData, yuv, yuvlength);
    m_nWidth = width;
    m_nHeight = height;
    [m_YUVDataLock unlock];
    
    
}

- (void) ImageNotify:(UIImage *)image timestamp:(NSInteger)timestamp DID:(NSString *)did
{
    //  NSLog(@"ImageNotify...DID:%@...timestamp:%ld", did,timestamp);
    if(isStop){
        return;
    }
    
    mDataComeDelayTime=0;
    if (aviWidth==0) {
        aviWidth=image.size.width;
        aviHeight=image.size.height;
    }else{
        if (isRecording) {
            if (aviWidth!=image.size.width) {
                NSLog(@"分辨率改变，需要重新录像");
                aviWidth=image.size.width;
                aviHeight=image.size.height;
                
                [self performSelectorOnMainThread:@selector(recordedResolutionChange) withObject:nil waitUntilDone:NO];
            }
        }
    }
    
    isDataComeback=YES;
    NSTimeInterval se=(long)timestamp;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDate *dd=[date dateByAddingTimeInterval:-timezone];
    NSString *sOSD=[NSString stringWithFormat:@"%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]];
    
    if (m_videoFormat == -1) {
        m_videoFormat = 3;
        [self performSelectorOnMainThread:@selector(enableButton) withObject:nil waitUntilDone:NO];
    }
    
    if (bPlaying == NO)
    {
        bPlaying = YES;
        [self updateResolution:image];
        
        [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:NO];
        
    }
    
    [self performSelectorOnMainThread:@selector(updateTimestamp:) withObject:sOSD waitUntilDone:NO];
    
    if (image != nil) {
        [image retain];
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
        if (isTakepicturing) {
            [self takePicProcess:image];
        }
    }
    
}

-(void)ImageData:(Byte *)buf Length:(int)len timestamp:(NSInteger)timestamp{
    
    NSTimeInterval se=(long)timestamp;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDate *dd=[date dateByAddingTimeInterval:-timezone];
    NSString *sOSD=[NSString stringWithFormat:@"%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]];
    //NSLog(@"jpg  sOSD=%@",sOSD);
    
    
    [m_RecordLock lock];
    if (m_pCustomRecorder != nil) {
        NSLog(@"ImageData...len=%d",len);
        recordNum++;
        if (recordNum==100) {
            recordNum=0;
            BOOL flag=[self isOutOfMemory];
            if (flag) {
                [self performSelectorOnMainThread:@selector(stopRecordForMemoryOver) withObject:self waitUntilDone:NO];
            }
        }
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        unsigned int unTimestamp = 0;
        struct timeval tv;
        struct timezone tz;
        gettimeofday(&tv, &tz);
        unTimestamp = tv.tv_usec / 1000 + tv.tv_sec * 1000 ;
        writeAudioDataNumber=1;
        if (writeH264Number==4) {
            writeH264Number=0;
            m_pCustomRecorder->SendOneFrame((char*)buf, len, unTimestamp, 3,timezone,timestamp);
        }
        writeH264Number++;
        [pool release];
    }
    [m_RecordLock unlock];
}

-(void)recordedResolutionChange{
    NSLog(@"recordedResolutionChange......");
    
    m_pPPPPChannelMgt->stopRecordAVI((char*)[strDID UTF8String]);
    usleep(100000);
    recordFileName = [self GetRecordFileName];
    recordFilePath = [self GetRecordPath: [NSString stringWithFormat:@"%@.avi",recordFileName] andType:1];
    NSString *strFormat=@"h264";
    if (m_videoFormat==3) {
        strFormat=@"mjpg";
    }
    if (m_pPPPPChannelMgt->startRecordAVI((char*)[strDID UTF8String], (char*)[recordFilePath UTF8String], (char*)[strFormat UTF8String], aviWidth, aviHeight)) {
    }
}

- (void) updateImage:(id)data
{
    UIImage *img = (UIImage*)data;
    self.imageSnapshot = img;
    if (imgView!=nil) {
        imgView.image = img;
    }
    [img release];
}




#pragma mark---检查数据长时间没来重新获取视频
-(void)checkDataCome{
    if (mDataComeDelayTime==8) {
        m_pPPPPChannelMgt->Stop([strDID UTF8String]);
        m_pPPPPChannelMgt->Start([strDID UTF8String], [m_strUser UTF8String], [m_strPwd UTF8String]);
        NSLog(@"strDID[%@],m_strUser[%@],m_strPwd[%@]",strDID,m_strUser,m_strPwd);
    }
    if (mDataComeDelayTime>=10) {
        mDataComeDelayTime=0;
        
        NSLog(@">>>>>checkDataCome()>>>>30m没有来数据了，重新获取一次视频数据");
        //重新获取一次视频
        if (m_pPPPPChannelMgt != NULL) {
            //如果请求视频失败，则退出播放
            m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, nil);
            m_pPPPPChannelMgt->StopPPPPLivestream([strDID UTF8String]);
            sleep(2);
            if( m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self) == 0 ){
                [self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
                return;
            }
            [self getCameraParams];
        }
    }
    mDataComeDelayTime++;
}
#pragma mark---------others

- (void) setResolutionSize:(NSInteger) resolution
{
    switch (resolution) {
        case 0:
            m_nVideoWidth = 640;
            m_nVideoHeight = 480;
            break;
        case 1:
            m_nVideoWidth = 320;
            m_nVideoHeight = 240;
            break;
        case 3:
            m_nVideoWidth = 1280;
            m_nVideoHeight = 720;
            break;
            
        default:
            break;
    }
    
    [self setDisplayMode];
}




-(void) setResolution{
    NSLog(@"setResolution...nResolution=%d",nResolution);
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, nResolution);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:0 Value:nResolution];
        
    }
    
    [self performSelector:@selector(getCameraParams) withObject:nil afterDelay:3.0];
    self.progressView.hidden=YES;
}


- (void) hideProgress:(id)param
{
    NSLog(@"hideProgress...");
    [self.progressView setHidden:YES];
    [self.LblProgress setHidden:YES];
    
    if (NO == [OSDLabel isHidden]) {
        [TimeStampLabel setHidden:NO];
    }
}

- (void)enableButton
{
    [playBottomToolBar SetBtnEnable:YES WithIndex:0];
    [playBottomToolBar SetBtnEnable:YES WithIndex:1];
    
}



- (void) updateVideoResolution
{
    NSLog(@"updateVideoResolution  0 VGA  1 QVGA  3 720P nResolution: %d", nResolution);
    
    [self setResolutionSize:nResolution];
    
    switch (nResolution) {
        case 0:
            [playBottomToolBar SetBtnTitle:@"VGA" WithIndex:6];
            break;
        case 1:
            [playBottomToolBar SetBtnTitle:@"QVGA" WithIndex:6];
            break;
        case 2:
            
            break;
        case 3:
            [playBottomToolBar SetBtnTitle:@"720P" WithIndex:6];
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        default:
            break;
    }
}

- (void) UpdateVieoDisplay
{
    [self updateVideoResolution];
    
    if (bPlaying) {
        progressView.hidden=YES;
    }
    
    switch (m_nFlip) {
        case 0: // normal
            m_bUpDownMirror = NO;
            m_bLeftRightMirror = NO;
            
            [playTopToolBar SetBtnSelect:NO WithIndex:3];
            [playTopToolBar SetBtnSelect:NO WithIndex:4];
            
            
            break;
        case 1: //up down mirror
            m_bUpDownMirror = YES;
            m_bLeftRightMirror = NO;
            
            [playTopToolBar SetBtnSelect:YES WithIndex:3];
            [playTopToolBar SetBtnSelect:NO WithIndex:4];
            break;
        case 2: // left right mirror
            m_bUpDownMirror = NO;
            m_bLeftRightMirror = YES;
            
            [playTopToolBar SetBtnSelect:NO WithIndex:3];
            [playTopToolBar SetBtnSelect:YES WithIndex:4];
            break;
        case 3: //all mirror
            m_bUpDownMirror = YES;
            m_bLeftRightMirror = YES;
            
            [playTopToolBar SetBtnSelect:YES WithIndex:3];
            [playTopToolBar SetBtnSelect:YES WithIndex:4];
            break;
        default:
            break;
    }
    
    
    sliderContrast.value = m_Contrast;
    sliderBrightness.value = m_Brightness;
    if ([self getFirstEnterFullScreen]) {
        NSLog(@"全屏");
        m_nDisplayMode=2;//full screen
        [self setDisplayMode];
        
        [self setFirstEnterFullScreen:NO];
        m_nDisplayMode=0;
    }
    
}
-(void)setFirstEnterFullScreen:(BOOL)flag{
    NSLog(@"setFirstEnterFullScreen..flag=%d",flag);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:flag] forKey:@"isFullScreen"];
}
-(BOOL)getFirstEnterFullScreen{
    BOOL flag=[[NSUserDefaults standardUserDefaults]boolForKey:@"isFullScreen"];
    NSLog(@"getFirstEnterFullScreen....flag=%d",flag);
    return flag;
}
- (void) setDisplayModeImage
{
    switch (m_nDisplayMode) {
        case 0: //normal
            [playBottomToolBar SetBtnImage:imgNormal ForState:UIControlStateNormal WithIndex:7];
            break;
        case 2: //enlarge
            [playBottomToolBar SetBtnImage:imgFullScreen ForState:UIControlStateNormal WithIndex:7];
            break;
        case 1: //full screen
            [playBottomToolBar SetBtnImage:imgNormal ForState:UIControlStateNormal WithIndex:7];
            break;
            
        default:
            break;
    }
}

- (void) setDisplayMode
{
    //NSLog(@"setDisplayMode...m_nVideoWidth: %d, m_nVideoHeight: %d, m_nDisplayMode: %d", m_nVideoWidth, m_nVideoHeight, m_nDisplayMode);
    
    if (m_nVideoWidth == 0 || m_nVideoHeight == 0)
    {
        return;
    }
    
    int nDisplayWidth = 0;
    int nDisplayHeight = 0;
    
    
    switch (m_nDisplayMode)
    {
        case 0:
        {
            if (m_nVideoWidth > m_nScreenWidth || m_nVideoHeight > m_nScreenHeight) {
                nDisplayHeight = m_nScreenHeight;
                nDisplayWidth = m_nVideoWidth * m_nScreenHeight / m_nVideoHeight ;
                if (nDisplayWidth > m_nScreenWidth) {
                    nDisplayWidth = m_nScreenWidth;
                    nDisplayHeight = m_nVideoHeight * m_nScreenWidth / m_nVideoWidth;
                }
            }else {
                nDisplayWidth = m_nVideoWidth;
                nDisplayHeight = m_nVideoHeight;
            }
        }
            break;
        case 1:
        {
            nDisplayHeight = m_nScreenHeight;
            nDisplayWidth = m_nVideoWidth * m_nScreenHeight / m_nVideoHeight ;
            if (nDisplayWidth > m_nScreenWidth) {
                nDisplayWidth = m_nScreenWidth;
                nDisplayHeight = m_nVideoHeight * m_nScreenWidth / m_nVideoWidth;
            }
        }
            break;
        case 2:
        {
            nDisplayWidth = m_nScreenWidth;
            nDisplayHeight = m_nScreenHeight;
        }
            break;
        default:
            break;
    }
    
    
    
    int nCenterX = m_nScreenWidth / 2;
    int nCenterY = m_nScreenHeight / 2;
    
    
    
    int halfWidth = nDisplayWidth / 2;
    int halfHeight = nDisplayHeight / 2;
    
    int nDisplayX = nCenterX - halfWidth;
    int nDisplayY = nCenterY - halfHeight;
    
    //NSLog(@"halfWdith: %d, halfHeight: %d, nDisplayX: %d, nDisplayY: %d",
    //      halfWidth, halfHeight, nDisplayX, nDisplayY);
    
    CGRect imgViewFrame ;
    imgViewFrame.origin.x = nDisplayX;
    imgViewFrame.origin.y = nDisplayY;
    imgViewFrame.size.width = nDisplayWidth;
    imgViewFrame.size.height = nDisplayHeight;
    imgView.frame = imgViewFrame;
    myGLViewController.view.frame = imgViewFrame;
    [self setDisplayModeImage];
    
}



-(void)hindeProgressView{
    isMove=NO;
    [self.progressView setHidden:YES];
}
-(void)showFourBtn:(BOOL)bShow{
    btnLeft.hidden=bShow;
    btnRight.hidden=bShow;
    btnUp.hidden=bShow;
    btnDown.hidden=bShow;
}

- (void) updataResolution: (int) width height:(int)height
{
    m_nVideoWidth = width;
    m_nVideoHeight = height;
    
    if(m_nVideoWidth == 1280 && m_nVideoHeight == 720){
        nResolution = 3;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 640 && m_nVideoHeight == 480){
        nResolution = 0;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 320 && m_nVideoHeight == 240){
        nResolution = 1;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else {
        
    }
    
    [self performSelectorOnMainThread:@selector(setDisplayMode) withObject:nil waitUntilDone:NO];
    
}

- (void) updateResolution:(UIImage*)image
{
    //NSLog(@"updateResolution");
    m_nVideoWidth = image.size.width;
    m_nVideoHeight = image.size.height;
    
    //NSLog(@"m_nVideoWidth: %d, m_nVideoHeight: %d", m_nVideoWidth, m_nVideoHeight);
    
    if(m_nVideoWidth == 1280 && m_nVideoHeight == 720){
        nResolution = 3;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 640 && m_nVideoHeight == 480){
        nResolution = 0;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 320 && m_nVideoHeight == 240){
        nResolution = 1;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else {
        
    }
    
    [self performSelectorOnMainThread:@selector(setDisplayMode) withObject:nil waitUntilDone:NO];
}

#pragma mark-------FileCreate/Finder
- (NSString*) GetRecordFileName
{
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    NSString *strFileName =nil;
    if (isP2P) {
        strFileName = [NSString stringWithFormat:@"%@_%@", strDID, strDateTime];
    }else{
        strFileName = [NSString stringWithFormat:@"%@_%@", m_strIp, strDateTime];
    }
    [formatter release];
    
    return strFileName;
    
}

- (NSString*) GetRecordPath: (NSString*)strFileName andType:(int)nType
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath =nil;
    if (isP2P) {
        strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    }else{
        strPath = [documentsDirectory stringByAppendingPathComponent:m_strIp];
    }
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (nType==1) {//avi
        strPath=[strPath stringByAppendingPathComponent:@"avi"];
        [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
        strPath=[strPath stringByAppendingPathComponent:strFileName];
    }else{
        strPath = [strPath stringByAppendingPathComponent:strFileName];
    }
    
    return strPath;
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
