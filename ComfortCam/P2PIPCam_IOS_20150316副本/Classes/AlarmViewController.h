//
//  AlarmViewController.h
//  P2PCamera
//
//  Created by Tsang on 14-6-18.
//
//

#import <UIKit/UIKit.h>
#import "CameraListMgt.h"
#import "NotifyEventProtocol.h"
#import "PPPPChannelManagement.h"
@interface AlarmViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NotifyEventProtocol>
{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *mTableView;
    CameraListMgt *m_pCameraListMgt;
    CGRect mainScreen;
    CPPPPChannelManagement *pPPPPChannelMgt;
    BOOL isIOS7;
    BOOL isScreenOnForeground;
    
    NSString *alarmDID;
}
@property (nonatomic,retain)UINavigationBar *navigationBar;
@property (nonatomic,retain)UITableView *mTableView;
@property (nonatomic, assign) CameraListMgt *m_pCameraListMgt;
@property (nonatomic, assign) CPPPPChannelManagement *pPPPPChannelMgt;

-(void)apsNotify:(NSString*)did;
@end
