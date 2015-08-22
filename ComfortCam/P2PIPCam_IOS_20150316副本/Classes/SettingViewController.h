//
//  SettingViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "NetWorkUtiles.h"
#import "CameraListMgt.h"
@interface SettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate,UIAlertViewDelegate>{
    CPPPPChannelManagement *m_pPPPPChannelMgt;
    IBOutlet UITableView *mTableView;
    NSString *m_strDID;
    NSString *mName;
    IBOutlet UINavigationBar *navigationBar;
  
    NSString *m_strIp;
    NSString *m_strPort;
    NSString *m_strUser;
    NSString *m_strPwd;
    BOOL isP2P;
    NetWorkUtiles *netUtiles;
    UIAlertView *alertViewRestart;
    BOOL isIOS7;
    CGRect mainScreen;
    CameraListMgt *cameraListMgt;
    int mModal;
}
@property BOOL isP2P;
@property (copy, nonatomic) NSString *m_strIp;
@property (copy, nonatomic) NSString *m_strPort;
@property (copy, nonatomic) NSString *m_strUser;
@property (copy, nonatomic) NSString *m_strPwd;
@property (nonatomic, assign) NetWorkUtiles *netUtiles;

@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPChannelMgt;
@property (nonatomic, assign)IBOutlet UITableView *mTableView;
@property (copy, nonatomic) NSString *m_strDID;
@property (copy, nonatomic) NSString *mName;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic,retain)UIAlertView *alertViewRestart;
@property (nonatomic, assign) CameraListMgt *cameraListMgt;
@property int mModal;
@end
