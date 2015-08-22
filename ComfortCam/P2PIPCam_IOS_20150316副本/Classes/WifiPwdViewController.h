//
//  WifiPwdViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "NetWorkUtiles.h"
#import "PPPPObjectProtocol.h"
@interface WifiPwdViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate,PPPPObjectProtocol>{
    CPPPPChannelManagement *m_pChannelMgt;
    
    NSString *m_strSSID;
    int m_security;
    int m_channel;    
    NSString *m_strDID;
    NSString *m_strPwd;
    
    UITextField *textPassword;
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *tableView;
    BOOL isP2P;
    
    NetWorkUtiles *netUtiles;
    NSString *m_strIp;
    NSString *m_strPort;
    NSString *m_User;
    NSString *m_Pwd;
    BOOL isSetOver;
    
    int mEncrypt;
    int mKeyformat;
    
    NSTimer *setTimer;
    int mSetResult;
    int mModal;
}
@property BOOL isP2P;
@property (nonatomic, assign) NetWorkUtiles *netUtiles;
@property (nonatomic, copy)NSString *m_strIp;
@property (nonatomic, copy)NSString *m_strPort;
@property (nonatomic, copy)NSString *m_User;
@property (nonatomic, copy)NSString *m_Pwd;


@property (nonatomic, assign) CPPPPChannelManagement *m_pChannelMgt;
@property (copy, nonatomic) NSString *m_strSSID;
@property (copy, nonatomic) NSString *m_strDID;
@property (copy, nonatomic) NSString *m_strPwd;
@property (retain, nonatomic) UITextField *textPassword;
@property int m_security;
@property int m_channel;

@property (retain, nonatomic) UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
- (void) btnSetWifi:(id) sender;
@property int mSetResult;
@property int mModal;
@end
