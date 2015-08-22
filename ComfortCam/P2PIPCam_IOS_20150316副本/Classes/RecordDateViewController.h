//
//  RecordDateViewController.h
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecPathManagement.h"
#import "PPPPChannelManagement.h"
#import "NotifyEventProtocol.h"

@interface RecordDateViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, NotifyEventProtocol>{
    RecPathManagement *m_pRecPathMgt;
    NSString *strDID;
    NSString *strName;
    
    NSMutableArray *recDataArray;
    
    IBOutlet UINavigationBar *navigationBar;
    
    UIImage *imagePlay;
    UIImage *imageDefault;
    
    IBOutlet UITableView *tableView;
    
    id<NotifyEventProtocol> RecReloadDelegate;
    NSMutableDictionary *m_ImgDic;
    
    CPPPPChannelManagement *m_pPPPPChannelMgt;
    
    CGRect mainScreen;
    BOOL isIOS7;
    
    NSNumber *authority;
}
@property (nonatomic, retain) NSMutableDictionary *m_ImgDic;
@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, copy) NSString *strName;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIImage *imagePlay;
@property (nonatomic, retain) UIImage *imageDefault;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) id<NotifyEventProtocol> RecReloadDelegate;
@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPChannelMgt;

@property (nonatomic, assign) NSNumber *authority;

@end
