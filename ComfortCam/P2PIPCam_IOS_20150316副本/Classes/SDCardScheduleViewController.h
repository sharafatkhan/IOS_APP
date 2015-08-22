//
//  SDCardScheduleViewController.h
//  P2PCamera
//
//  Created by Tsang on 13-1-14.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "NetWorkUtiles.h"
#import "DropListProtocol.h"
#import "PPPPObjectProtocol.h"
#import "KXDialog.h"
@interface SDCardScheduleViewController : UIViewController<UITabBarControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PPPPObjectProtocol,UINavigationBarDelegate,DropListProtocol,KXDialogDelegate>{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *tableView;
    CPPPPChannelManagement *m_pChannelMgt;
    int total;
    int remain;
    int status;
    int conver_enable;
    int time_length;
    int record_enable;
    NSString *strDID;
    UITextField *timeTextField;
    
    CGRect tableoldFrame;
    BOOL isFirstShowing;
    CGFloat textFieldAnimatedDistance;
    
    
    BOOL isP2P;
    NetWorkUtiles *netUtiles;
    NSString *m_strIp;
    NSString *m_strPort;
    NSString *m_strUser;
    NSString *m_strPwd;
    
    int m_start_time;
    int m_end_time;
    
    int record_audio;
    KXDialog *dialog;
}
@property (nonatomic,copy) NSString *strDate;
@property BOOL isP2P;
@property (nonatomic, assign) NetWorkUtiles *netUtiles;
@property (nonatomic, copy)NSString *m_strIp;
@property (nonatomic, copy)NSString *m_strPort;
@property (nonatomic, copy)NSString *m_strUser;
@property (nonatomic, copy)NSString *m_strPwd;


@property (nonatomic,retain)IBOutlet UINavigationBar *navigationBar;
@property (nonatomic,retain)IBOutlet UITableView *tableView;
@property (nonatomic,retain)UITextField *timeTextField;
@property (nonatomic,copy) NSString *strDID;
@property (nonatomic, assign) CPPPPChannelManagement *m_pChannelMgt;
@end
