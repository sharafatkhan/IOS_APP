//
//  FtpSettingViewController.h
//  P2PCamera
//
//  Created by Tsang on 12-12-12.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"

#import "NetWorkUtiles.h"
#import "PPPPObjectProtocol.h"
@interface FtpSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,
UITextFieldDelegate, UINavigationBarDelegate, PPPPObjectProtocol>{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *tableView;
    
    CGFloat textFieldAnimatedDistance;
    UITextField *currentTextField;
    
    NSString *m_strFTPSvr;
    NSString *m_strUser;
    NSString *m_strPwd;
    int m_nFTPPort;
    int m_nUploadInterval;
    
    CPPPPChannelManagement *m_pChannelMgt;
    NSString *m_strDID;
    
    BOOL isSetOver;
    BOOL isP2P;
    NetWorkUtiles *netUtiles;
    NSString *m_strIp;
    NSString *m_strPort;
    NSString *m_User;
    NSString *m_Pwd;
}
@property BOOL isP2P;
@property (nonatomic, assign) NetWorkUtiles *netUtiles;
@property (nonatomic, copy)NSString *m_strIp;
@property (nonatomic, copy)NSString *m_strPort;
@property (nonatomic, copy)NSString *m_User;
@property (nonatomic, copy)NSString *m_Pwd;

@property BOOL isSetOver;

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITextField *currentTextField;
@property (nonatomic, copy) NSString *m_strFTPSvr;
@property (nonatomic, copy) NSString *m_strUser;
@property (nonatomic, copy) NSString *m_strPwd;
@property (nonatomic,assign) CPPPPChannelManagement *m_pChannelMgt;
@property (nonatomic, copy) NSString *m_strDID;


@end
