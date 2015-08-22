//
//  CameraViewController.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCameraProtocol.h"
#import "CameraListMgt.h"
#import "PPPPChannelManagement.h"


#import "PicPathManagement.h"
#import "NotifyEventProtocol.h"
#import "RecPathManagement.h"
#import "PictureViewController.h"
#import "RecordViewController.h"
#import "MySetDialog.h"
#import "NetWorkUtiles.h"
#import "NetworkUtilesProtocol.h"
#import "PlayViewResultProtocol.h"
#import "MoreViewExitProtocol.h"
#import "PPPPObjectProtocol.h"
@interface CameraViewController : UIViewController  
<UITableViewDelegate, UITableViewDataSource, EditCameraProtocol,UIAlertViewDelegate,MySetDialogDelegate,NetworkUtilesProtocol,PlayViewResultProtocol,MoreViewExitProtocol,PPPPObjectProtocol>{
    
    BOOL bEditMode;
    CameraListMgt *cameraListMgt;   
    PicPathManagement *m_pPicPathMgt;
    RecPathManagement *m_pRecPathMgt;
    CPPPPChannelManagement *pPPPPChannelMgt;
    NSCondition *ppppChannelMgntCondition;
    
    IBOutlet UITableView *cameraList;
    IBOutlet UINavigationBar *navigationBar;
    
    IBOutlet UIButton *btnAddCamera;
    
    id<NotifyEventProtocol> PicNotifyEventDelegate;
    id<NotifyEventProtocol> RecordNotifyEventDelegate;
    id<NotifyEventProtocol> alarmNotifyEventDelegate;
    IBOutlet UIAlertView *alertView;
    NSTimer *timer;
    BOOL isFirstLoad;
    
    PictureViewController *picViewController;
    RecordViewController *recViewController;
    
    MySetDialog *setDialog;
    BOOL isSetDialogShow;
    BOOL isP2P;
    NetWorkUtiles *netWorkUtile;
    CGRect mainScreen;
    
    BOOL isMoreViewLoad;
     NSString *appStoreVersion;
    BOOL isStartPPPPOver;
    BOOL isIOS7;
    
    NSMutableArray *locakDeviceArr;
    
    BOOL isSearchDevice;
    
    // Code Begin
    NSInteger cameraIndex;
    int requestType;
    BOOL isUserLoggedIn;
    // Code Ends
}
@property (nonatomic,copy)NSString *appStoreVersion;
@property (nonatomic,assign)NetWorkUtiles *netWorkUtile;
@property BOOL isP2P;
@property (nonatomic,retain)MySetDialog *setDialog;
@property (nonatomic,retain) PictureViewController *picViewController;
@property (nonatomic,retain) RecordViewController *recViewController;


@property (nonatomic, retain) UITableView *cameraList;
@property (nonatomic, retain) UINavigationBar *navigationBar;

@property (nonatomic, retain) UIButton *btnAddCamera;
@property (nonatomic,retain) IBOutlet UIAlertView *alertView;
@property (nonatomic, assign) CameraListMgt *cameraListMgt;
@property (nonatomic, assign) PicPathManagement *m_pPicPathMgt;
@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, assign) id<NotifyEventProtocol> PicNotifyEventDelegate;
@property (nonatomic, assign) id<NotifyEventProtocol> RecordNotifyEventDelegate;
@property (nonatomic, assign) id<NotifyEventProtocol> alarmNotifyEventDelegate;
@property (nonatomic, assign) CPPPPChannelManagement *pPPPPChannelMgt;


- (void) StopPPPP;
- (void) StartPPPPThread;

- (IBAction)btnAddCameraTouchDown:(id)sender;
- (IBAction)btnAddCameraTouchUp:(id)sender;
-(void)reStartThread;

-(void)networkChangeReStartDevice;

// Code Begin
- (IBAction)tapOnInAppAlert:(id)sender;
// Code Ends

@end
