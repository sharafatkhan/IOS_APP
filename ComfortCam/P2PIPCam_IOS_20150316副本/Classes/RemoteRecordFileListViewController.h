//
//  RemoteRecordFileListViewController.h
//  P2PCamera
//
//  Created by Tsang on 12-12-14.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "SDCardRecordFileSearchProtocol.h"

@interface RemoteRecordFileListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UINavigationBarDelegate,SDCardRecordFileSearchProtocol>
{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *tableView;
    
    NSCondition *m_timerLock;
    NSTimer *m_timer;
    BOOL m_bFinished;
    
    CPPPPChannelManagement *m_pPPPPChannelMgt;
    NSString *m_strDID;
    NSString *m_strName;
    
    NSMutableArray *m_RecordFileList;
    NSMutableDictionary *m_CurAllDic;
    
    CGRect mainScreen;
    int isSDcardPage;
    
    int mPageTime;
    int mModal;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPChannelMgt;
@property (nonatomic, copy) NSString *m_strDID;
@property (nonatomic, copy) NSString *m_strName;

@property int mModal;

@end
