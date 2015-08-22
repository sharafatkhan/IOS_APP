//
//  UserPwdSetViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "PPPPObjectProtocol.h"
#import "NetWorkUtiles.h"
#import "CameraListMgt.h"
#define TAG_USER 0
#define TAG_PWD 1

@interface UserPwdSetViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate,PPPPObjectProtocol>{
    
    NSString *m_user1;
    NSString *m_pwd1;
    NSString *m_user2;
    NSString *m_pwd2;

    
    NSString *m_strDID;
    CPPPPChannelManagement *m_pChannelMgt;
    
    CGFloat textFieldAnimatedDistance;
    
    NSString *m_strUser;
    NSString *m_strPwd;
    UITextField *currentTextField;
    UITextField *textUser;
    UITextField *textPassword;
    UITextField *textOperUser;
    UITextField *textOperPwd;
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;
    int textfield_tg;
    CGRect oldtableFrame;
    BOOL isSetOver;
    BOOL isP2P;
    NetWorkUtiles *netUtiles;
    NSString *m_strIp;
    NSString *m_strPort;
    NSString *m_User;
    NSString *m_Pwd;
    NSString *m_strName;
    CameraListMgt *cameraListMgt;
    
    int mModal;
}
@property BOOL isP2P;
@property (nonatomic, assign) NetWorkUtiles *netUtiles;
@property (nonatomic, copy)NSString *m_strIp;
@property (nonatomic, copy)NSString *m_strPort;
@property (copy, nonatomic) NSString *m_User;
@property (copy, nonatomic) NSString *m_Pwd;

@property BOOL isSetOver;
@property (copy,nonatomic) NSString *m_strDID;

@property (copy,nonatomic) NSString *m_user1;
@property (copy,nonatomic) NSString *m_pwd1;
@property (copy,nonatomic) NSString *m_user2;
@property (copy,nonatomic) NSString *m_pwd2;
@property (copy,nonatomic)NSString *m_strName;

@property (nonatomic, assign) CPPPPChannelManagement *m_pChannelMgt;
@property (copy, nonatomic) NSString *m_strUser;
@property (copy, nonatomic) NSString *m_strPwd;
@property (nonatomic, retain) UITextField *currentTextField;
@property (retain, nonatomic) UITextField *textUser;
@property (retain, nonatomic) UITextField *textPassword;
@property (nonatomic,retain)UITextField *textOperUser;
@property (nonatomic,retain)UITextField *textOperPwd;


@property (nonatomic, retain) UITableView *tableView;
@property (retain, nonatomic) UINavigationBar *navigationBar;
@property (nonatomic, assign) CameraListMgt *cameraListMgt;
@property int mModal;
- (void)keyboardWillShowNotification:(NSNotification *)aNotification;
- (void)keyboardWillHideNotification:(NSNotification* )aNotification;
- (void) btnSetUserPwd:(id) sender;

@end
