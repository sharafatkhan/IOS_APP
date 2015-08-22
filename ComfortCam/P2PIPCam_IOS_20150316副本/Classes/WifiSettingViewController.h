//
//  WifiSettingViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPPPChannelManagement.h"
#import "NetWorkUtiles.h"
#import "PPPPObjectProtocol.h"
#import "CameraListMgt.h"
@interface WifiSettingViewController : UIViewController <UITableViewDataSource, 
UITableViewDelegate, PPPPObjectProtocol, UIAlertViewDelegate, UINavigationBarDelegate>
{
    CPPPPChannelManagement *m_pPPPPChannelMgt;   
    
    //wifi参数需要保存的
    NSString *m_strSSID;
    int m_authtype;
    int m_channel;
    NSString *m_strWEPKey;
    NSString *m_strWPA_PSK;
    int m_wifi_link_status;
    BOOL m_bFinished; 
    
    NSMutableArray *m_wifiScanResult;
    NSString *m_strDID;
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *wifiTableView;
    
    int m_currentIndex;
    NSTimer *m_timer;
    NSCondition *m_timerLock;
    BOOL isSetOver;
    BOOL isP2P;
    NetWorkUtiles *netUtiles;
    NSString *m_strIp;
    NSString *m_strPort;
    NSString *m_strUser;
    NSString *m_strPwd;
    CameraListMgt *cameraListMgt;
    int mModal;
}
@property BOOL isP2P;
@property (nonatomic, assign) NetWorkUtiles *netUtiles;
@property (nonatomic, copy)NSString *m_strIp;
@property (nonatomic, copy)NSString *m_strPort;
@property (nonatomic, copy)NSString *m_strUser;
@property (nonatomic, copy)NSString *m_strPwd;
@property BOOL isSetOver;
@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPChannelMgt;
@property (copy,nonatomic) NSString *m_strSSID;
@property (copy,nonatomic) NSString *m_strWEPKey;
@property (copy,nonatomic) NSString *m_strWPA_PSK;
@property (copy,nonatomic) NSString *m_strDID;
@property (retain, nonatomic) UITableView *wifiTableView;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, assign) CameraListMgt *cameraListMgt;
@property int mModal;
@end
