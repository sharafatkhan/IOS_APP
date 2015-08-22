//
//  FourViewController.m
//  P2PCamera
//
//  Created by kaven on 15/3/10.
//
//

#import "FourViewController.h"
#import "CameraEditViewController.h"
#import "CameraListCell.h"
#import "IpCameraClientAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PPPPDefine.h"
#import "mytoast.h"
#import "CustomToast.h"
#include "MyAudioSession.h"
#import "SettingViewController.h"
#import "AddCameraCell.h"
#import "CameraEditViewController.h"
#import "APICommon.h"
#import "morelistcell.h"

// Code Begin

#import "RequestClass.h"
#import "SubscriptionViewController.h"
#import "InAppAlertView.h"

#define loginRequest 1
#define cameraAccessRequest 2


@interface FourViewController ()<RequestClassDelegate>
{
    NSInteger isUserSubscribed;
    InAppAlertView *objInAppAlertView;
    NSInteger subscriptonStatus;
}
@property (nonatomic, retain) RequestClass *connection;
@end
// Code Ends

@interface FourViewController ()

@end

@implementation FourViewController
@synthesize cameraList;
@synthesize navigationBar;

@synthesize btnAddCamera;
@synthesize alertView;

@synthesize cameraListMgt;
@synthesize m_pPicPathMgt;
@synthesize PicNotifyEventDelegate;
@synthesize RecordNotifyEventDelegate;
@synthesize m_pRecPathMgt;
@synthesize pPPPPChannelMgt;

@synthesize picViewController;
@synthesize recViewController;

@synthesize firstImgView;
@synthesize secondImgView;
@synthesize thirdImgView;
@synthesize fourImgView;
@synthesize defaultImg;
@synthesize playDictionary;
@synthesize firstID;
@synthesize secondID;
@synthesize thirdID;
@synthesize fourID;

@synthesize processView1;
@synthesize processView2;
@synthesize processView3;
@synthesize processView4;

@synthesize firstLabel;
@synthesize secondLabel;
@synthesize thirdLabel;
@synthesize fourLabel;


@synthesize btnPush;
@synthesize mAuthority;

@synthesize moreViewExitDelegate;

- (void)dealloc {
    NSLog(@"fourView   dealloc");
    isMoreViewOver=YES;
    
    self.cameraList = nil;
    
    cameraListMgt=nil;
    pPPPPChannelMgt=nil;
    m_pPicPathMgt=nil;
    m_pRecPathMgt=nil;
    
    self.navigationBar = nil;
    self.cameraListMgt = nil;
    self.PicNotifyEventDelegate = nil;
    self.RecordNotifyEventDelegate = nil;
    self.m_pPicPathMgt = nil;
    self.alertView=nil;
    
    firstID=nil;
    secondID=nil;
    thirdID=nil;
    fourID=nil;
    
    btnPush=nil;
    [super dealloc];
}


-(void)viewWillAppear:(BOOL)animated{
    //NSLog(@"init viewWillAppear");
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (isFullScreen) {
        isFullScreen=NO;
        isViewDisappear=NO;
        if (firstID!=nil) {
            pPPPPChannelMgt->CameraControl([firstID UTF8String], 0, 1);
            pPPPPChannelMgt->StartPPPPLivestream([firstID UTF8String], 10, self);
        }
        if (secondID!=nil) {
            pPPPPChannelMgt->CameraControl([secondID UTF8String], 0, 1);
            pPPPPChannelMgt->StartPPPPLivestream([secondID UTF8String], 10, self);
        }
        
        if (thirdID!=nil) {
            pPPPPChannelMgt->CameraControl([thirdID UTF8String], 0, 1);
            pPPPPChannelMgt->StartPPPPLivestream([thirdID UTF8String], 10, self);
        }
        
        if (fourID!=nil) {
            pPPPPChannelMgt->CameraControl([fourID UTF8String], 0, 1);
            pPPPPChannelMgt->StartPPPPLivestream([fourID UTF8String], 10, self);
        }
        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(EnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Enterforeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    processView4.hidden=YES;
    processView3.hidden=YES;
    processView2.hidden=YES;
    processView1.hidden=YES;
}

-(void)EnterBackground{
    isViewDisappear=YES;
    if (self.processView1.hidden==NO) {
         [self.processView1 stopAnimating];
    }
    if (self.processView2.hidden==NO) {
        [self.processView2 stopAnimating];
    }
    if (self.processView3.hidden==NO) {
        [self.processView3 stopAnimating];
    }
    if (self.processView4.hidden==NO) {
        [self.processView4 stopAnimating];
    }

    
}
-(void)Enterforeground{
    isViewDisappear=NO;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (isFirstLoad) {
        isFirstLoad=false;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isShowTableView=YES;
    isMoreViewOver=NO;
    isShowTableView=YES;
    isFullScreen=NO;
    playNum=0;
    isFirstLoad=true;
    bEditMode = NO;
    pPPPPChannelMgt->pCameraViewController = self;
    mainScreen=[[UIScreen mainScreen]bounds];
    defaultImg=[UIImage imageNamed:@"moreviewback.png"];
    
    [IpCameraClientAppDelegate setFourBackground:YES];
    
    self.wantsFullScreenLayout = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor=[UIColor blackColor];
    
    [self initTopBar];
    [self initViews];
    
    // code begins
    self.connection = [[RequestClass alloc] init];
    self.connection.delegate = self;
    // code end

}
-(void)initTopBar{
    topBarView=[[UIImageView alloc]init];
    topBarView.frame=CGRectMake(0, 0, mainScreen.size.height, 30);
    [topBarView setImage:[UIImage imageNamed:@"top_bg_blue.png"]];
    topBarView.userInteractionEnabled=YES;
    [self.view addSubview:topBarView];
    [topBarView release];
    
    UILabel *labelTitle=[[UILabel alloc]init];
    labelTitle.frame=CGRectMake(30, 0, 150, 30);
    labelTitle.backgroundColor=[UIColor clearColor];
    labelTitle.text=NSLocalizedStringFromTable(@"fourviews", @STR_LOCALIZED_FILE_NAME, nil);
    labelTitle.textAlignment=NSTextAlignmentLeft;
    labelTitle.textColor=[UIColor whiteColor];
    labelTitle.font=[UIFont boldSystemFontOfSize:18];
    [topBarView addSubview:labelTitle];
    [labelTitle release];
    
    UIButton *btnExit=[UIButton buttonWithType:UIButtonTypeCustom];
    btnExit.frame=CGRectMake(mainScreen.size.height-40, 0, 40, 30);
    [btnExit setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
    
    [btnExit setImage:[UIImage imageNamed:@"exitbutton.png"] forState:UIControlStateNormal];
    [btnExit addTarget:self action:@selector(btnExit) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:btnExit];
    
    
}
-(void)initViews{
    float topMaxY=CGRectGetMaxY(topBarView.frame);
    float imgW=(mainScreen.size.height-200)/2;
    float imgH=(mainScreen.size.width-topMaxY)/2;
    
    cameraList=[[UITableView alloc] init];
    cameraList.frame=CGRectMake(imgW*2, topMaxY, 200, imgH*2);
    cameraList.layer.borderColor=[[UIColor blackColor] CGColor];
    cameraList.layer.borderWidth=1.0;
    cameraList.separatorStyle=UITableViewCellSeparatorStyleNone;
    cameraList.delegate=self;
    cameraList.dataSource=self;
    [self.view addSubview:cameraList];
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=cameraList.frame;
    imgView.center=cameraList.center;
    cameraList.backgroundView=imgView;
    [imgView release];
    
    firstImgView=[[UIImageView alloc]init];
    firstImgView.frame=CGRectMake(0, topMaxY, imgW, imgH);
    secondImgView=[[UIImageView alloc]init];
    secondImgView.frame=CGRectMake(CGRectGetMaxX(firstImgView.frame), firstImgView.frame.origin.y, imgW,imgH);
    thirdImgView=[[UIImageView alloc]init];
    thirdImgView.frame=CGRectMake(firstImgView.frame.origin.x,CGRectGetMaxY(firstImgView.frame), imgW,imgH);
    fourImgView=[[UIImageView alloc]init];
    fourImgView.frame=CGRectMake(CGRectGetMaxX(thirdImgView.frame),CGRectGetMaxY(firstImgView.frame), imgW,imgH);
    
    [self.view addSubview:firstImgView];
    [self.view addSubview:secondImgView];
    [self.view addSubview:thirdImgView];
    [self.view addSubview:fourImgView];
    
    
    firstImgView.userInteractionEnabled=YES;
    secondImgView.userInteractionEnabled=YES;
    thirdImgView.userInteractionEnabled=YES;
    fourImgView.userInteractionEnabled=YES;
    
    firstImgView.layer.borderColor=[[UIColor blackColor] CGColor];
    firstImgView.layer.borderWidth=1.0;
    secondImgView.layer.borderColor=[[UIColor blackColor] CGColor];
    secondImgView.layer.borderWidth=1.0;
    thirdImgView.layer.borderColor=[[UIColor blackColor] CGColor];
    thirdImgView.layer.borderWidth=1.0;
    fourImgView.layer.borderColor=[[UIColor blackColor] CGColor];
    fourImgView.layer.borderWidth=1.0;
    UILongPressGestureRecognizer *longGesture1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewLongPressed:)];
    [firstImgView addGestureRecognizer:longGesture1];
    [longGesture1 release];
    longGesture1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewLongPressed:)];
    [secondImgView addGestureRecognizer:longGesture1];
    [longGesture1 release];
    longGesture1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewLongPressed:)];
    [thirdImgView addGestureRecognizer:longGesture1];
    [longGesture1 release];
    longGesture1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewLongPressed:)];
    [fourImgView addGestureRecognizer:longGesture1];
    [longGesture1 release];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewDoubleTapped:)];
    [singleTap setNumberOfTapsRequired:2];
    [firstImgView addGestureRecognizer:singleTap];
    [singleTap release];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewDoubleTapped:)];
    [singleTap setNumberOfTapsRequired:2];
    [secondImgView addGestureRecognizer:singleTap];
    [singleTap release];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewDoubleTapped:)];
    [singleTap setNumberOfTapsRequired:2];
    [thirdImgView addGestureRecognizer:singleTap];
    [singleTap release];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewDoubleTapped:)];
    [singleTap setNumberOfTapsRequired:2];
    [fourImgView addGestureRecognizer:singleTap];
    [singleTap release];
    

    [firstImgView setImage:defaultImg];
    [secondImgView setImage:defaultImg];
    [thirdImgView setImage:defaultImg];
    [fourImgView setImage:defaultImg];
    
    firstImgView.tag=1;
    secondImgView.tag=2;
    thirdImgView.tag=3;
    fourImgView.tag=4;
    
    
    
    firstLabel=[[UILabel alloc]init];
    firstLabel.frame=CGRectMake(5, firstImgView.frame.origin.y+5, firstImgView.frame.size.width-10, 20);
    firstLabel.backgroundColor=[UIColor clearColor];
    firstLabel.textColor=[UIColor blackColor];
    firstLabel.adjustsFontSizeToFitWidth=YES;
    
    secondLabel=[[UILabel alloc]init];
    secondLabel.backgroundColor=[UIColor clearColor];
    secondLabel.textColor=[UIColor blackColor];
    secondLabel.frame=CGRectMake(secondImgView.frame.origin.x+5, firstLabel.frame.origin.y, firstLabel.frame.size.width, firstLabel.frame.size.height);
    secondLabel.adjustsFontSizeToFitWidth=YES;
    
    thirdLabel=[[UILabel alloc]init];
    thirdLabel.backgroundColor=[UIColor clearColor];
    thirdLabel.textColor=[UIColor blackColor];
    thirdLabel.frame=CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(firstImgView.frame)+5, firstLabel.frame.size.width, firstLabel.frame.size.height);
    thirdLabel.adjustsFontSizeToFitWidth=YES;
    
    fourLabel=[[UILabel alloc]init];
    fourLabel.backgroundColor=[UIColor clearColor];
    fourLabel.textColor=[UIColor blackColor];
    fourLabel.frame=CGRectMake(secondLabel.frame.origin.x, thirdLabel.frame.origin.y, firstLabel.frame.size.width, firstLabel.frame.size.height);
    fourLabel.adjustsFontSizeToFitWidth=YES;
    
    [self.view addSubview:firstLabel];
    [self.view addSubview:secondLabel];
    [self.view addSubview:thirdLabel];
    [self.view addSubview:fourLabel];
    
    
    firstLabel.hidden=YES;
    secondLabel.hidden=YES;
    thirdLabel.hidden=YES;
    fourLabel.hidden=YES;

    
    processView1=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    processView1.frame=CGRectMake(0, 0, 60, 60);
    processView1.center=firstImgView.center;
    
    processView2=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    processView2.frame=CGRectMake(0, 0, 60, 60);
    processView2.center=secondImgView.center;
    
    processView3=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    processView3.frame=CGRectMake(0, 0, 60, 60);
    processView3.center=thirdImgView.center;
    
    processView4=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    processView4.frame=CGRectMake(0, 0, 60, 60);
    processView4.center=fourImgView.center;
    
    processView1.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    processView1.layer.cornerRadius=3;
    processView2.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    processView2.layer.cornerRadius=3;
    processView3.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    processView3.layer.cornerRadius=3;
    processView4.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    processView4.layer.cornerRadius=3;
    
    
    [self.view addSubview:processView1];
    [self.view addSubview:processView2];
    [self.view addSubview:processView3];
    [self.view addSubview:processView4];

    processView4.hidden=YES;
    processView3.hidden=YES;
    processView2.hidden=YES;
    processView1.hidden=YES;

    btnPush=[UIButton buttonWithType:UIButtonTypeCustom];
    btnPush.frame=CGRectMake(CGRectGetMaxX(secondImgView.frame)-36, secondImgView.frame.origin.y+5, 28, 28);
    [btnPush setBackgroundImage:[UIImage imageNamed:@"push.png"] forState:UIControlStateNormal];
    [btnPush addTarget:self action:@selector(btnPushAndPull) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPush];
 
}

#pragma mark------ExitBtnClick
- (void) btnExit
{
    if (moreViewExitDelegate!=nil) {
        [moreViewExitDelegate moreViewExit];
    }
    isMoreViewOver=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (firstID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([firstID UTF8String]);
        firstID=nil;
    }
    
    if (secondID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([secondID UTF8String]);
        secondID=nil;
    }
    
    if (thirdID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([thirdID UTF8String]);
        thirdID=nil;
    }
    
    if (fourID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([fourID UTF8String]);
        fourID=nil;
    }

    IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    [delegate switchBack];
    return;
}

#pragma mark-----PullBtn
- (void)btnPushAndPull{
    NSLog(@"MoreViewController.....btnPushAndPull()");
    [self showTableView];
    [self showFourViewFrame];
}

-(void)showTableView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    CGRect frame=cameraList.frame;
    NSLog(@"frame.origin.x1=%f",frame.origin.x);
    if (isShowTableView) {
        isShowTableView=NO;
        frame.origin.x+=200;
    }else{
        isShowTableView=YES;
        frame.origin.x-=200;
    }
    NSLog(@"frame.origin.x2=%f",frame.origin.x);
    cameraList.frame=frame;
    
    [UIView commitAnimations];
}
-(void)showFourViewFrame{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    
    CGRect firstFrame=firstImgView.frame;
    CGRect secondFrame=secondImgView.frame;
    CGRect thirdFrame=thirdImgView.frame;
    CGRect fourFrame=fourImgView.frame;
    CGRect btnPushFrame=btnPush.frame;
    CGRect secondLabelFrame=secondLabel.frame;
    CGRect fourLabelFrame=fourLabel.frame;
    
    
    CGRect progressView1Frame=processView1.frame;
    CGRect progressView2Frame=processView2.frame;
    CGRect progressView3Frame=processView3.frame;
    CGRect progressView4Frame=processView4.frame;
    
    if (isShowTableView) {
        NSLog(@"push....moreW=%d",moreW);
        [btnPush setBackgroundImage:[UIImage imageNamed:@"push.png"] forState:UIControlStateNormal];
        btnPushFrame.origin.x-=200;
        
        firstFrame.size.width-=100;
        thirdFrame.size.width-=100;
        
        secondFrame.origin.x-=100;
        secondFrame.size.width-=100;
        
        fourFrame.origin.x-=100;
        fourFrame.size.width-=100;
        
        secondLabelFrame.origin.x-=100;
        fourLabelFrame.origin.x-=100;
        
        progressView1Frame.origin.x-=50;
        progressView2Frame.origin.x-=150;
        progressView3Frame.origin.x-=50;
        progressView4Frame.origin.x-=150;
        
      
    }else{
        NSLog(@"pull....moreW=%d",moreW);
        [btnPush setBackgroundImage:[UIImage imageNamed:@"pull.png"] forState:UIControlStateNormal];
        btnPushFrame.origin.x+=200;
        
        firstFrame.size.width+=100;
        thirdFrame.size.width+=100;
        
        secondFrame.origin.x+=100;
        secondFrame.size.width+=100;
        
        fourFrame.origin.x+=100;
        fourFrame.size.width+=100;
        
        secondLabelFrame.origin.x+=100;
        fourLabelFrame.origin.x+=100;
        
        progressView1Frame.origin.x+=50;
        progressView2Frame.origin.x+=150;
        progressView3Frame.origin.x+=50;
        progressView4Frame.origin.x+=150;
        
       
    }
    btnPush.frame=btnPushFrame;
    firstImgView.frame=firstFrame;
    secondImgView.frame=secondFrame;
    thirdImgView.frame=thirdFrame;
    fourImgView.frame=fourFrame;
    secondLabel.frame=secondLabelFrame;
    fourLabel.frame=fourLabelFrame;
    
    processView1.frame=progressView1Frame;
    processView2.frame=progressView2Frame;
    processView3.frame=progressView3Frame;
    processView4.frame=progressView4Frame;
    
    [UIView commitAnimations];
}

#pragma mark------ImageViewLongTapped
-(void)ImageViewLongPressed:(UILongPressGestureRecognizer *)recognizer{
    NSLog(@"ImageViewLongPressed.....");
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        UIView *view = [recognizer view];
        NSString *did=nil;
        switch (view.tag) {
            case 1:
                if (firstID!=nil) {
                    did=firstID;
                    firstID=nil;
                }
                firstImgView.image=[UIImage imageNamed:@"moreviewback.png"];
                firstLabel.hidden=YES;
                processView1.hidden=YES;
                break;
            case 2:
                if (secondID!=nil) {
                    did=secondID;
                    secondID=nil;
                }
                secondImgView.image=[UIImage imageNamed:@"moreviewback.png"];
                secondLabel.hidden=YES;
                processView2.hidden=YES;
                break;
            case 3:
                if (thirdID!=nil) {
                    did=thirdID;
                    thirdID=nil;
                }
                thirdImgView.image=[UIImage imageNamed:@"moreviewback.png"];
                thirdLabel.hidden=YES;
                processView3.hidden=YES;
                break;
            case 4:
                if (fourID!=nil) {
                    did=fourID;
                    fourID=nil;
                }
                fourImgView.image=[UIImage imageNamed:@"moreviewback.png"];
                fourLabel.hidden=YES;
                processView4.hidden=YES;
                break;
            default:
                break;
        }
        if (did!=nil) {
            pPPPPChannelMgt->StopPPPPLivestream([did UTF8String]);
        }
    }
}


#pragma mark------ImageViewDoubleTapped
-(void)ImageViewDoubleTapped:(UITapGestureRecognizer *)recognizer{
    NSLog(@"ImageViewDoubleTapped");
    
    if (isFullScreen) {
        NSLog(@"fullscreen");
        return;
    }
    
    UIView *view = [recognizer view];
    NSInteger index = view.tag;
    NSString *did=nil;
    isFullScreen=YES;
    
    switch (index) {
        case 1:
            if (firstID!=nil) {
                did=firstID;
                processView1.hidden=NO;
                [processView1 startAnimating];
            }else{
                isFullScreen=NO;
                return;
            }
            
            break;
        case 2:
            if (secondID!=nil) {
                did=secondID;
                processView2.hidden=NO;
                [processView2 startAnimating];
            }else{
                isFullScreen=NO;
                return;
            }
            
            break;
        case 3:
            if (thirdID!=nil) {
                did=thirdID;
                processView3.hidden=NO;
                [processView3 startAnimating];
            }else{
                isFullScreen=NO;
                return;
            }
            
            break;
        case 4:
            if (fourID!=nil) {
                did=fourID;
                processView4.hidden=NO;
                [processView4 startAnimating];
            }else{
                isFullScreen=NO;
                return;
            }
            
            break;
            
        default:
            break;
    }
    
    
    if (firstID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([firstID UTF8String]);
    }
    if (secondID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([secondID UTF8String]);
        
    }
    if (thirdID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([thirdID UTF8String]);
        
    }
    if (fourID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([fourID UTF8String]);
        
    }
    
    if (did==nil) {
        isFullScreen=NO;
        return;
    }
    
    [self performSelector:@selector(fullView:) withObject:did afterDelay:3];
    
    return;
    
}
-(void)fullView:(NSString *)did{
    
    if (!isShowTableView) {
        NSLog(@"在全屏下的全屏。。。");
        [self btnPushAndPull];
    }else{
        NSLog(@"不在全屏下的全屏。。。");
    }
    
    int count=[cameraListMgt GetCount];
    int authority;
    NSString *name=@"";
    for (int i=0; i<count; i++) {
        NSDictionary *dic=[cameraListMgt GetCameraAtIndex:i];
        NSString *_did=[dic objectForKey:@STR_DID];
        if ([_did caseInsensitiveCompare:did]==NSOrderedSame) {
            name=[dic objectForKey:@STR_NAME];
            authority=[[dic objectForKey:@STR_AUTHORITY] intValue];
            break;
        }
        
    }
    
    processView1.hidden=YES;
    processView2.hidden=YES;
    processView3.hidden=YES;
    processView4.hidden=YES;
    [btnPush setBackgroundImage:[UIImage imageNamed:@"push.png"] forState:UIControlStateNormal];
    
    
    KXPlayViewController *playViewController=[[KXPlayViewController alloc]init];
    playViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
    playViewController.m_pPicPathMgt = m_pPicPathMgt;
    playViewController.m_pRecPathMgt = m_pRecPathMgt;
    playViewController.PicNotifyDelegate = picViewController;
    playViewController.RecNotifyDelegate = recViewController;
    
    playViewController.strDID =did;
    playViewController.cameraName=name;
    playViewController.mAuthority=authority;
    playViewController.m_nP2PMode=1;
    playViewController.isMoreView=YES;
    playViewController.isP2P=YES;
    playViewController.playViewResultDelegate=self;
    
    
    [IpCameraClientAppDelegate setFourBackground:YES];
    
    IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    [delegate switchPlayView:playViewController];
    [playViewController release];
    
    NSLog(@"~~~~~~~~~fourView authority(%d)",authority);
}


#pragma mark--------PlayView
- (void) StartPlayView: (NSInteger)index
{
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    if (cameraDic == nil) {
        return;
    }
    
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    NSString *strName = [cameraDic objectForKey:@STR_NAME];
    
    //int  modal=[[cameraDic objectForKey:@STR_MODEL] intValue];
    if (firstID!=nil&&secondID!=nil&&thirdID!=nil&&fourID!=nil) {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"moreviewall", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    
    
    if ([strDID isEqualToString:firstID]) {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"moreviewadded", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    
    if ([strDID isEqualToString:secondID]) {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"moreviewadded", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    if ([strDID isEqualToString:thirdID]) {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"moreviewadded", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    if ([strDID isEqualToString:fourID]) {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"moreviewadded", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    
    if (firstID==nil) {
        firstLabel.text=strName;
        firstLabel.hidden=NO;
        firstID=strDID;
        pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
        pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self);
        processView1.hidden=NO;
        [processView1 startAnimating];
        return;
    }
    
    if (secondID==nil) {
        secondID=strDID;
        secondLabel.text=strName;
        secondLabel.hidden=NO;
        pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
        pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self);
        processView2.hidden=NO;
        [processView2 startAnimating];
        return;
    }
    
    if (thirdID==nil) {
        thirdID=strDID;
        thirdLabel.text=strName;
        thirdLabel.hidden=NO;
        pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
        pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self);
        processView3.hidden=NO;
        [processView3 startAnimating];
        return;
    }
    
    if (fourID==nil) {
        fourID=strDID;
        fourLabel.text=strName;
        fourLabel.hidden=NO;
        pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
        pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self);
        processView4.hidden=NO;
        [processView4 startAnimating];
        return;
    }
    
    //[mytoast showWithText:@"已经加满"];
    
    return;
}
#pragma mark------UpdateImage
-(void)updateImg:(NSMutableArray *)arr{
    if (isViewDisappear) {
        return;
    }
    NSString *did=[arr objectAtIndex:0];
    //NSLog(@"updateImg...did=%@",did);
    if (firstID!=nil) {
        if ([did isEqualToString:firstID]) {
            if (firstImg==nil) {
                NSLog(@"---------firstImg == nil (%@)",firstImg);
                return;
            }
            firstImgView.image=firstImg;
            processView1.hidden=YES;
            [firstImg release];
            firstImg=nil;
            
        }
    }
    if (secondID!=nil) {
        if ([did isEqualToString:secondID]) {
            if (secondImg==nil) {
                return;
            }
            secondImgView.image=secondImg;
            processView2.hidden=YES;
            [secondImg release];
            secondImg=nil;
            
        }
    }
    
    if (thirdID!=nil) {
        if ([did isEqualToString:thirdID]) {
            if (thirdImg==nil) {
                return;
            }
            thirdImgView.image=thirdImg;
            processView3.hidden=YES;
            [thirdImg release];
            thirdImg=nil;
            
        }
    }
    
    if (fourID!=nil) {
        if ([did isEqualToString:fourID]) {
            if (fourImg==nil) {
                return;
            }
            fourImgView.image=fourImg;
            processView4.hidden=YES;
            [fourImg release];
            fourImg=nil;
            
        }
    }
    
    [arr removeAllObjects];
    [arr release];
}
#pragma mark------ViewDataCallback
- (void) ParamNotify:(int)paramType params:(void *)params
{
    NSLog(@"paramType=%d",paramType);
}

-(void)ImageData:(Byte *)buf Length:(int)len timestamp:(NSInteger)timestamp{}
- (void) ImageNotify:(UIImage *)image timestamp:(NSInteger)timestamp DID:(NSString *)did
{
    if (isMoreViewOver) {
        return;
    }
    // NSLog(@"Img....did=%@  width=%f",did,image.size.width);
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    [image retain];
    
    if (firstID!=nil) {
        if ([did isEqualToString:firstID]) {
            firstImg=image;
        }
    }
    if (secondID!=nil) {
        if ([did isEqualToString:secondID]) {
            secondImg=image;
        }
    }
    
    if (thirdID!=nil) {
        if ([did isEqualToString:thirdID]) {
            thirdImg=image;
        }
    }
    
    if (fourID!=nil) {
        if ([did isEqualToString:fourID]) {
            fourImg=image;
        }
    }
    [arr addObject:did];
    [self performSelectorOnMainThread:@selector(updateImg:) withObject:arr waitUntilDone:NO];
}
- (void) YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did
{
    if (isMoreViewOver) {
        return;
    }
    // NSLog(@"YUV.....width=%d  did=%@",width,did);
    UIImage *image=[APICommon YUV420ToImage:yuv width:width height:height];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    [image retain];
    
    if (firstID!=nil) {
        if ([did isEqualToString:firstID]) {
            firstImg=image;
        }
    }
    if (secondID!=nil) {
        if ([did isEqualToString:secondID]) {
            secondImg=image;
        }
    }
    
    if (thirdID!=nil) {
        if ([did isEqualToString:thirdID]) {
            thirdImg=image;
        }
    }
    
    if (fourID!=nil) {
        if ([did isEqualToString:fourID]) {
            fourImg=image;
        }
    }
    [arr addObject:did];
    [self performSelectorOnMainThread:@selector(updateImg:) withObject:arr waitUntilDone:NO];
}
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp DID:(NSString *)did{
    
}

#pragma mark------TableViewDelegate
//删除设备的处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"commitEditingStyle");
    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:indexPath.row-1];
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    if(YES == [cameraListMgt RemoveCameraAtIndex:indexPath.row-1]){
        if ([cameraListMgt GetCount] > 0) {
            [cameraList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
            [cameraList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        //停止P2P
        pPPPPChannelMgt->Stop([strDID UTF8String]);
        
        [m_pPicPathMgt RemovePicPathByID:strDID];
        [m_pRecPathMgt RemovePathByID:strDID];
        
        [PicNotifyEventDelegate NotifyReloadData];
        [RecordNotifyEventDelegate NotifyReloadData];
        
        //        if ([cameraListMgt GetCount] == 0) {
        //            [self btnEdit:nil];
        //        }
        
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return NO;
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:indexPath.row-1];
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    if ([strDID isEqualToString:firstID]) {
        return UITableViewCellEditingStyleNone;
    }
    
    if ([strDID isEqualToString:secondID]) {
        return UITableViewCellEditingStyleNone;
    }
    if ([strDID isEqualToString:thirdID]) {
        return UITableViewCellEditingStyleNone;
    }
    if ([strDID isEqualToString:fourID]) {
        return UITableViewCellEditingStyleNone;
    }
    
    if (bEditMode == YES) {
        return UITableViewCellEditingStyleDelete;
    }
    
    if (indexPath.row==0) {
        return UITableViewCellEditingStyleNone;
    }
    
    if ([strDID isEqualToString:firstID]||[strDID isEqualToString:secondID]||[strDID isEqualToString:thirdID]||[strDID isEqualToString:fourID]) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
    //
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)anIndexPath
{
    NSInteger index = anIndexPath.row - 1;
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    if (cameraDic == nil) {
        return;
    }
    
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
    if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_USER_PWD) {
        //[mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil)];
        [CustomToast showWithText:NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
        //[mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
        [CustomToast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    
    NSNumber *num=[cameraDic objectForKey:@STR_AUTHORITY];
    BOOL authority=[num boolValue];
    if (!authority) {
        // [mytoast showWithText:NSLocalizedStringFromTable(@"noadmin", @STR_LOCALIZED_FILE_NAME, nil)];
        [CustomToast showWithText:NSLocalizedStringFromTable(@"noadmin", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:NO];
        return ;
    }
    SettingViewController *settingView = [[SettingViewController alloc] init];
    settingView.m_pPPPPChannelMgt = pPPPPChannelMgt;
    settingView.m_strDID = [cameraDic objectForKey:@STR_DID];
    //[self.navigationController pushViewController:settingView animated:YES];
    //[self presentModalViewController:settingView animated:YES];
    [settingView release];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    
    int count = [cameraListMgt GetCount];
    
    return count ;
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");
    
    NSInteger index = anIndexPath.row ;
    
    
    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    UIImage *img = [cameraDic objectForKey:@STR_IMG];
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
    //NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    
    NSString *cellIdentifier = @"CameraListCell";
    //当状态为显示当前的设备列表信息时
    morelistcell *cell =  (morelistcell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        
        UINib *nib=[UINib nibWithNibName:@"morelistcell" bundle:nil];
        [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell =  (morelistcell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    }
    
    
    
    int PPPPStatus = [nPPPPStatus intValue];
    
    
    if (img != nil) {
        cell.imageCamera.image = img;
        
    }else{
        cell.imageCamera.image= [UIImage imageNamed:@"back.png"];
    }
    
    cell.NameLable.text = name;
    cell.PPPPIDLable.text = did;
    
    
    float cellHeight = cell.frame.size.height;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cellHeight, mainScreen.size.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    [cellBgView addSubview:label];
    [label release];
    
    cell.backgroundView = cellBgView;
    [cellBgView release];
    
    
    NSString *strPPPPStatus = nil;
    switch (PPPPStatus) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus= NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_LAN:
            strPPPPStatus= NSLocalizedStringFromTable(@"PPPPStatusLanOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_WLAN:
            strPPPPStatus= NSLocalizedStringFromTable(@"PPPPStatusWLanOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    cell.PPPPStatusLable.text = strPPPPStatus;
    
   	return cell;
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    
    
    return 63;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    NSInteger index = anIndexPath.row;
    
    //  Code Begins
    cameraIndex = anIndexPath.row;
    //  Code Ends
    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    if (cameraDic == nil) {
        return;
    }
    
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
    if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
        return;
    }
    
    if ([nPPPPStatus intValue] != PPPP_STATUS_LAN&&[nPPPPStatus intValue] != PPPP_STATUS_WLAN) {
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
        
        pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
        
        return;
    }
    
    //  Code Begins
    if (!isUserLoggedIn)
    {
        [self validateUser];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isUserSubscribed"] == 0 && [nPPPPStatus intValue] == PPPP_STATUS_WLAN)
    {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:cameraIndex];
        
        NSString *strCameraUser = [cameraDic valueForKey:@"user"];
        NSString *strCameraUserPassword = [cameraDic valueForKey:@"pwd"];
        
        NSString *cameraId = [cameraDic valueForKey:@"did"];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"GET_CAMERA_ACCESS" forKey:@"action"];
        [param setValue:strCameraUser forKey:@"access_userid"];
        [param setValue:strCameraUserPassword forKey:@"password"];
        [param setValue:cameraId forKey:@"camera_id"];
        
        [self.connection makePostRequestFromDictionary:param];
        requestType = cameraAccessRequest;
    }
    else
    {
        [self StartPlayView:cameraIndex];
    }
    //  Code Ends
    
//    [self StartPlayView:index];
    
}

// Code Begin

-(void) validateUser
{
    NSString *strUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    NSString *strUserPassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserPassword"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"LOGIN" forKey:@"action"];
    [param setValue:strUserName forKey:@"email"];
    [param setValue:strUserPassword forKey:@"password"];
    [param setValue:@"2" forKey:@"platform"];
    [self.connection makePostRequestFromDictionary:param];
    requestType = loginRequest;
}
// Code Ends


#pragma mark--PlayViewExitResultProtocol
-(void)playViewExitResultImg:(UIImage *)img DID:(NSString *)did{
    
    NSLog(@"playViewExitResultImg...did=%@",did);
    if (img!=nil) {
        NSLog(@"playViewExitResultImg...img..");
        
        
        
        UIImage *imgScale = [self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];
        NSInteger index = [cameraListMgt UpdateCamereaImage:did  Image:imgScale] ;
        if (index>=0) {
            [self saveSnapshot:imgScale DID:did];
            
            [self performSelectorOnMainThread:@selector(ReloadCameraTableView) withObject:nil waitUntilDone:NO];
        }
        
        
    }else{
        NSLog(@"playViewExitResultImg...img＝＝nil..");
    }
    
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    NSData *dataImg = UIImageJPEGRepresentation(newImage, 0.0001);
    UIImage *imgOK = [UIImage imageWithData:dataImg];
    
    // Return the new image.
    return imgOK;
}

- (void) saveSnapshot: (UIImage*) image DID: (NSString*) strDID
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //[fileManager createDirectoryAtPath:strPath attributes:nil];
    
    
    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
    //NSLog(@"strPath: %@", strPath);
    
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    [dataImage writeToFile:strPath atomically:YES ];
    
    [pool release];
    
    
}
- (void) ReloadCameraTableView
{
    [cameraList reloadData];
}
#pragma mark -
#pragma mark SnapshotNotify

- (void) SnapshotNotify:(NSString *)strDID data:(char *)data length:(int)length
{
    //NSLog(@"CameraViewController SnapshotNotify... strDID: %@, length: %d", strDID, length);
    if (length < 20) {
        return;
    }
    
    //显示图片
    NSData *image = [[NSData alloc] initWithBytes:data length:length];
    if (image == nil) {
        //NSLog(@"SnapshotNotify image == nil");
        [image release];
        return;
    }
    
    UIImage *img = [[UIImage alloc] initWithData:image];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *imgScale = [self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];
    
    NSInteger index = [cameraListMgt UpdateCamereaImage:strDID  Image:imgScale] ;
    if (index >= 0) {
        
        [self saveSnapshot:imgScale DID:strDID];
        
        //NSLog(@"UpdateCamereaImage success!");
        [self performSelectorOnMainThread:@selector(ReloadCameraTableView) withObject:nil waitUntilDone:NO];
        //[self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
    }
    
    [pool release];
    
    [img release];
    [image release];
    
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
    
}


//  Code Begins

#pragma mark -  Request Delegate

- (void)connectionSuccess:(id)result andError:(NSError *)error
{
    if (!error)
    {
        switch (requestType)
        {
            case loginRequest:
            {
                isUserLoggedIn = YES;
                if ([result isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dictResponse = [result valueForKey:@"response"];
                    NSInteger isSubscribed = [[dictResponse valueForKey:@"isSubscribed"] intValue];
                    
                    subscriptonStatus = [[dictResponse valueForKey:@"subscription_status"] intValue];
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:isSubscribed forKey:@"isUserSubscribed"];
                    
                    isUserSubscribed = [[NSUserDefaults standardUserDefaults] integerForKey:@"isUserSubscribed"];;
                    
                    if (![[dictResponse valueForKey:@"subscriptionEndDate"] isKindOfClass:[NSNull class]]) {
                        NSString *str = [dictResponse valueForKey:@"subscriptionEndDate"];
                        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"subscriptionEndDate"];
                    }
                    
                    if (isSubscribed == 1)
                    {
                        [self StartPlayView:cameraIndex];
                    }
                    else
                    {
                        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:cameraIndex];
                        
                        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
                        if (subscriptonStatus == 1001 && [nPPPPStatus intValue] == PPPP_STATUS_WLAN)
                        {
                            NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:cameraIndex];
                            
                            NSString *strCameraUser = [cameraDic valueForKey:@"user"];
                            NSString *strCameraUserPassword = [cameraDic valueForKey:@"pwd"];
                            
                            NSString *cameraId = [cameraDic valueForKey:@"did"];
                            
                            NSMutableDictionary *param = [NSMutableDictionary dictionary];
                            [param setValue:@"GET_CAMERA_ACCESS" forKey:@"action"];
                            [param setValue:strCameraUser forKey:@"access_userid"];
                            [param setValue:strCameraUserPassword forKey:@"password"];
                            [param setValue:cameraId forKey:@"camera_id"];
                            
                            [self.connection makePostRequestFromDictionary:param];
                            requestType = cameraAccessRequest;
                        }
                        else
                        {
                            [self StartPlayView:cameraIndex];
                        }
                    }
                }
            }
                break;
                
            case cameraAccessRequest:
            {
                if ([result isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dictResponse = (NSDictionary *)result;
                    if ([[dictResponse valueForKey:@"code"] intValue] == 200)
                    {
                        if ([[dictResponse valueForKey:@"response"] intValue] == 1)
                        {
                            [self StartPlayView:cameraIndex];
                        }
                        else if ([[dictResponse valueForKey:@"response"] intValue] == 0)
                        {
                            // Show pop up
                            // Goto subscription page
                            NSLog(@"Goto subscription page");
                            objInAppAlertView = (InAppAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"InAppAlertView" owner:self options:nil] objectAtIndex:0];
                            [self.view addSubview:objInAppAlertView];
                            if (subscriptonStatus == 1003)
                            {
                                objInAppAlertView.lblSubscriptionMessage.text = NSLocalizedStringFromTable(@"renew", @STR_LOCALIZED_FILE_NAME, nil);;
                            }
                            objInAppAlertView.center = self.view.center;
                        }
                    }
                }
            }
                break;
            default:
                break;
        }
        
        
        
        //        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
        objInAppAlertView = (InAppAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"InAppAlertView" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:objInAppAlertView];
        
        objInAppAlertView.center = self.view.center;
        if (subscriptonStatus == 1003)
        {
            objInAppAlertView.lblSubscriptionMessage.text = NSLocalizedStringFromTable(@"renew", @STR_LOCALIZED_FILE_NAME, nil);;
        }
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
    }
}


- (IBAction)tapOnInAppAlert:(id)sender
{
    if ([objInAppAlertView isDescendantOfView:self.view])
    {
        [objInAppAlertView removeFromSuperview];
        objInAppAlertView = nil;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        SubscriptionViewController *rvc = [[SubscriptionViewController alloc] initWithNibName:@"SubscriptionViewController" bundle:nil];
        [self presentViewController:rvc animated:YES completion:nil];
        //        [self.navigationController pushViewController:rvc animated:YES];
        
    }
    else
    {
        SubscriptionViewController *rvc = [[SubscriptionViewController alloc] initWithNibName:@"SubscriptionViewController_iPad" bundle:nil];
        [self presentViewController:rvc animated:YES completion:nil];
        //        [self.navigationController pushViewController:rvc animated:YES];
    }
}

#pragma mark- In App Purchase Delegate -

- (void)completePayment:(SKPaymentTransaction *)transaction
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPRODUCT_PURCHASE];
    //    [ProgressHUD dismiss];
}
- (void)restoredPayment:(SKPaymentTransaction *)transactions
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPRODUCT_PURCHASE];
    //    [ProgressHUD dismiss];
}
- (void)failedPayment:(SKPaymentTransaction *)transaction
{
    //    [ProgressHUD dismiss];
}

//  Code Ends

@end
