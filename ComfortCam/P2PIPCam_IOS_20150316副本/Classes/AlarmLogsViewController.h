//
//  AlarmLogsViewController.h
//  P2PCamera
//
//  Created by Tsang on 14-6-20.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "PPPPObjectProtocol.h"
@interface AlarmLogsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PPPPObjectProtocol>
{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *mTableView;
    CGRect mainScreen;
    CPPPPChannelManagement *pPPPPChannelMgt;
    BOOL isIOS7;
    NSMutableArray *mArr;
    NSString *strDID;
    NSString *strName;
    NSTimer *searchTimer;
}
@property (nonatomic,retain)UINavigationBar *navigationBar;
@property (nonatomic,retain)UITableView *mTableView;
@property (nonatomic, assign) CPPPPChannelManagement *pPPPPChannelMgt;
@property (nonatomic,copy)NSString *strDID;
@property (nonatomic,copy)NSString *strName;
@end
