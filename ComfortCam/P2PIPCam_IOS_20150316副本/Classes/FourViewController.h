//
//  FourViewController.h
//  P2PCamera
//
//  Created by kaven on 15/3/10.
//
//

#import <UIKit/UIKit.h>
#import "CameraListMgt.h"
#import "PPPPChannelManagement.h"
#import "PicPathManagement.h"
#import "NotifyEventProtocol.h"
#import "RecPathManagement.h"
#import "PictureViewController.h"
#import "RecordViewController.h"
#import "CustomToast.h"
#import "PlayViewResultProtocol.h"
#import "MoreViewExitProtocol.h"
#import "PPPPObjectProtocol.h"
@interface FourViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,PlayViewResultProtocol,PPPPObjectProtocol>
{
    BOOL bEditMode;
    CameraListMgt *cameraListMgt;
    PicPathManagement *m_pPicPathMgt;
    RecPathManagement *m_pRecPathMgt;
    CPPPPChannelManagement *pPPPPChannelMgt;
    id<NotifyEventProtocol> PicNotifyEventDelegate;
    id<NotifyEventProtocol> RecordNotifyEventDelegate;
    id<MoreViewExitProtocol>moreViewExitDelegate;
    PictureViewController *picViewController;
    RecordViewController *recViewController;
    
    UIImageView *topBarView;
    UITableView *cameraList;
    UIImageView *firstImgView;
    UIImageView *secondImgView;
    UIImageView *thirdImgView;
    UIImageView *fourImgView;
    
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLabel;
    UILabel *fourLabel;
    
    UIActivityIndicatorView *processView1;
    UIActivityIndicatorView *processView2;
    UIActivityIndicatorView *processView3;
    UIActivityIndicatorView *processView4;
    
    UIButton *btnPush;
    
    UIAlertView *alertView;
    NSTimer *timer;
    BOOL isFirstLoad;
    UIImage *defaultImg;
    NSMutableDictionary *playDictionary;
    int playNum;
    
    NSString *firstID;
    NSString *secondID;
    NSString *thirdID;
    NSString *fourID;
    
    
    BOOL isShowingDialog;
    BOOL isFullScreen;
    BOOL isShowTableView;
    CGRect mainScreen;
    int moreW;//用来缩放四个画面计算的差值
    BOOL isMoreViewOver;
    int tableViewOrigionX;
    BOOL waitMoment;
    
    UIImage *firstImg;
    UIImage *secondImg;
    UIImage *thirdImg;
    UIImage *fourImg;
    BOOL isViewDisappear;
    
    int mAuthority;
    
    // Code Begin
    NSInteger cameraIndex;
    int requestType;
    BOOL isUserLoggedIn;
    // Code Ends
}


@property (nonatomic,retain)UIActivityIndicatorView *processView1;
@property (nonatomic,retain)UIActivityIndicatorView *processView2;
@property (nonatomic,retain)UIActivityIndicatorView *processView3;
@property (nonatomic,retain)UIActivityIndicatorView *processView4;

@property (nonatomic,retain)UILabel *firstLabel;
@property (nonatomic,retain)UILabel *secondLabel;
@property (nonatomic,retain)UILabel *thirdLabel;
@property (nonatomic,retain)UILabel *fourLabel;

@property (nonatomic,retain)UIButton *btnPush;

@property (nonatomic,copy)NSString *firstID;
@property (nonatomic,copy)NSString *secondID;
@property (nonatomic,copy)NSString *thirdID;
@property (nonatomic,copy)NSString *fourID;

@property (nonatomic,retain)NSMutableDictionary *playDictionary;
@property (nonatomic,retain)UIImage *defaultImg;
@property (nonatomic,retain) PictureViewController *picViewController;
@property (nonatomic,retain) RecordViewController *recViewController;
@property (nonatomic, retain)UIImageView *firstImgView;
@property (nonatomic, retain)UIImageView *secondImgView;
@property (nonatomic, retain)UIImageView *thirdImgView;
@property (nonatomic, retain)UIImageView *fourImgView;

@property (nonatomic, retain) UITableView *cameraList;
@property (nonatomic, retain) UINavigationBar *navigationBar;

@property (nonatomic, retain) UIButton *btnAddCamera;
@property (nonatomic,retain)  UIAlertView *alertView;
@property (nonatomic, assign) CameraListMgt *cameraListMgt;
@property (nonatomic, assign) PicPathManagement *m_pPicPathMgt;
@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, assign) id<NotifyEventProtocol> PicNotifyEventDelegate;
@property (nonatomic, assign) id<NotifyEventProtocol> RecordNotifyEventDelegate;
@property (nonatomic, assign) CPPPPChannelManagement *pPPPPChannelMgt;
@property (nonatomic, assign) id<MoreViewExitProtocol>moreViewExitDelegate;

@property int mAuthority;

// Code Begin
- (IBAction)tapOnInAppAlert:(id)sender;
// Code Ends

@end
