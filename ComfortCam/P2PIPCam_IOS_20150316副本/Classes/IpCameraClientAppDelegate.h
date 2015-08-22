//
//  IpCameraClientAppDelegate.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//strDID[obj20173bbadd],m_strUser[testcamera],m_strPwd[123456]
#import <UIKit/UIKit.h>
#import "StartViewController.h"
#import "PlayViewController.h"

#import "CameraViewController.h"
#import "CameraListMgt.h"
#import "PicPathManagement.h"
#import "RecPathManagement.h"
#import "PlaybackViewController.h"
#import "PictureViewController.h"
#import "RecordViewController.h"
#import "PPPPChannelManagement.h"
#import "RemotePlaybackViewController.h"
#import "MyTabBarViewController.h"
#import "NetWorkUtiles.h"
#import "MoreViewPlayProtocol.h"
#import "AlarmViewController.h"
#import "KXStatusBar.h"
#import "FourViewController.h"
#import "Reachability.h"
#import "KXNavViewController.h"
#import "KXPlayViewController.h"
#import "APService.h"

// Code Begin
#import "LoginViewController.h"
// Code Ends

#define TITLE_WITH  120

#define JPUSH_APPKEY "e2566c5e652c2834bef816ec"
#define JPUSH_MASTER "3226e166f7a986c0ea69ba12"

#define UPDATAURL1 "http://itunes.apple.com/lookup?id=890823406"
#define UPDATAURL2 "https://itunes.apple.com/us/app/shu-bin/id890823406?ls=1&mt=8"

@interface IpCameraClientAppDelegate : NSObject <UIApplicationDelegate> {
    
    IBOutlet UIWindow *window;
    KXNavViewController *navigationController;
    StartViewController *startViewController;    
    KXPlayViewController *playViewController;
    CameraViewController *cameraViewController;
    PlaybackViewController *playbackViewController;
    AlarmViewController *alarmViewController;
    PictureViewController *picViewController;
    RecordViewController *recViewController;
    RemotePlaybackViewController *remotePlaybackViewController;
    FourViewController *fourViewController;
    
    
    CameraListMgt *m_pCameraListMgt;
    PicPathManagement *m_pPicPathMgt;
    RecPathManagement *m_pRecPathMgt;
    
    CPPPPChannelManagement *m_pPPPPChannelMgt ;
    
    MyTabBarViewController *myTabViewController ;
    NetWorkUtiles *netWorkUtile;
    id<MoreViewPlayProtocol> moreViewPlayProtocol;
    KXStatusBar *kxStatusBar;
    
    BOOL isOnPlayView;
    BOOL isBizInitSuccess;
    
    NetworkStatus netStatus;
    BOOL isFirstStartApp;
    
    // Code Begin
    LoginViewController *loginViewCntrl;
    UINavigationController *nav;
    
    UIView *activityView;
    UIView *loadingView;
    UILabel *lblLoad;
    
    // Code Ends
}

@property (nonatomic,assign) id<MoreViewPlayProtocol> moreViewPlayProtocol;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) KXNavViewController *navigationController;
@property (nonatomic, retain) StartViewController *startViewController;
@property (nonatomic, retain) KXPlayViewController *playViewController;
@property (nonatomic, retain) PlaybackViewController *playbackViewController;
@property (nonatomic, retain) RemotePlaybackViewController *remotePlaybackViewController;
@property (nonatomic, retain) MyTabBarViewController *myTabViewController ;
@property (nonatomic, retain) FourViewController *fourViewController;
@property BOOL isOnPlayView;
- (void) switchPlayView: (KXPlayViewController *)playViewController;
- (void) switchPlaybackView: (PlaybackViewController*)_playbackViewController;
- (void) switchRemotePlaybackView: (RemotePlaybackViewController*)_remotePlaybackViewController;
- (void) switchBack;

-(void)addDeviceToBizServer:(NSDictionary *)dic;
-(void)deleteDeviceFromBizServer:(NSDictionary*)dic;

+(BOOL)is43Version;
+(BOOL)isIOS7Version;
+(BOOL)isiPhone;

-(void) changeP2PAndDDNS:(BOOL)isP2P;
-(void)loginInBizSever;
-(void)openOrCloseAlarmPush:(BOOL)isOpen;


-(void)enterMoreView:(FourViewController*)vc;
-(void)playEnterFourView;


-(void)setJPushAlias;
-(NSString*)getJPushAlias;

+(void)setFourBackground:(BOOL)flag;
+(BOOL)getFourBackground;

// Code Begin

- (void)addLoginView;

// Loading view methods

-(void) showLoadingView;
-(void) hideLoadingView;

+(IpCameraClientAppDelegate *)sharedAppDelegate;
// Code Ends

@end

