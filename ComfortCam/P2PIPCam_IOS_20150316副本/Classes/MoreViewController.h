//
//  MoreViewController.h
//  P2PCamera
//
//  Created by Tsang on 13-5-2.
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
#import "MyDialogView.h"
#import "PlayViewResultProtocol.h"
#import "MoreViewExitProtocol.h"
#import "PPPPObjectProtocol.h"
@interface MoreViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,MyDialogViewDelegate,PlayViewResultProtocol,PPPPObjectProtocol>{

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
    
    IBOutlet UIAlertView *alertView;
    NSTimer *timer;
    BOOL isFirstLoad;
    
    PictureViewController *picViewController;
    RecordViewController *recViewController;
    
    IBOutlet UIImageView *firstImgView;
    IBOutlet UIImageView *secondImgView;
    IBOutlet UIImageView *thirdImgView;
    IBOutlet UIImageView *fourImgView;
    
    UIImage *defaultImg;
    
    NSMutableDictionary *playDictionary;
    int playNum;
    
    NSString *firstID;
    NSString *secondID;
    NSString *thirdID;
    NSString *fourID;
    
    IBOutlet UIActivityIndicatorView *processView1;
    IBOutlet UIActivityIndicatorView *processView2;
    IBOutlet UIActivityIndicatorView *processView3;
    IBOutlet UIActivityIndicatorView *processView4;
    
    IBOutlet UILabel *firstLabel;
    IBOutlet UILabel *secondLabel;
    IBOutlet UILabel *thirdLabel;
    IBOutlet UILabel *fourLabel;
    
    IBOutlet UIButton *btnPush;
    
    MyDialogView *myDialogView;
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
    
    id<MoreViewExitProtocol>moreViewExitDelegate;
    
    
    BOOL isViewDisappear;
}
@property (nonatomic,retain)UIActivityIndicatorView *processView1;
@property (nonatomic,retain)UIActivityIndicatorView *processView2;
@property (nonatomic,retain)UIActivityIndicatorView *processView3;
@property (nonatomic,retain)UIActivityIndicatorView *processView4;

@property (nonatomic,retain)MyDialogView *myDialogView;

@property (nonatomic,retain)IBOutlet UILabel *firstLabel;
@property (nonatomic,retain)IBOutlet UILabel *secondLabel;
@property (nonatomic,retain)IBOutlet UILabel *thirdLabel;
@property (nonatomic,retain)IBOutlet UILabel *fourLabel;

@property (nonatomic,retain)IBOutlet UIButton *btnPush;

@property (nonatomic,copy)NSString *firstID;
@property (nonatomic,copy)NSString *secondID;
@property (nonatomic,copy)NSString *thirdID;
@property (nonatomic,copy)NSString *fourID;

@property (nonatomic,retain)NSMutableDictionary *playDictionary;
@property (nonatomic,retain)UIImage *defaultImg;
@property (nonatomic,retain) PictureViewController *picViewController;
@property (nonatomic,retain) RecordViewController *recViewController;
@property (nonatomic, retain) IBOutlet UIImageView *firstImgView;
@property (nonatomic, retain) IBOutlet UIImageView *secondImgView;
@property (nonatomic, retain) IBOutlet UIImageView *thirdImgView;
@property (nonatomic, retain) IBOutlet UIImageView *fourImgView;

@property (nonatomic, retain) UITableView *cameraList;
@property (nonatomic, retain) UINavigationBar *navigationBar;

@property (nonatomic, retain) UIButton *btnAddCamera;
@property (nonatomic,retain) IBOutlet UIAlertView *alertView;
@property (nonatomic, assign) CameraListMgt *cameraListMgt;
@property (nonatomic, assign) PicPathManagement *m_pPicPathMgt;
@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, assign) id<NotifyEventProtocol> PicNotifyEventDelegate;
@property (nonatomic, assign) id<NotifyEventProtocol> RecordNotifyEventDelegate;
@property (nonatomic, assign) CPPPPChannelManagement *pPPPPChannelMgt;
@property (nonatomic, assign) id<MoreViewExitProtocol>moreViewExitDelegate;


- (void) StopPPPP;
- (void) StartPPPPThread;

- (IBAction)btnAddCameraTouchDown:(id)sender;
- (IBAction)btnAddCameraTouchUp:(id)sender;

@end
