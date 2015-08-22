//
//  RecordViewController.h
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraListMgt.h"
#import "NotifyEventProtocol.h"
#import "RecPathManagement.h"
#import "PPPPChannelManagement.h"
#import "MySegmentControl.h"
@interface RecordViewController : UIViewController<NotifyEventProtocol,UITableViewDataSource,UITableViewDelegate,MySegmentControlDelegate>{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UITableView *m_tableView;
    IBOutlet UILabel *labeltitle;
    
    
    CameraListMgt *m_pCameraListMgt;
    RecPathManagement *m_pRecPathMgt;
    
    UIImage *imageVideoDefault;
    UIImage *imagePlay;
    
    BOOL m_bLocal;
    
    CPPPPChannelManagement *m_pPPPPChannelMgt;
    NSMutableDictionary *m_myDic;
    BOOL isP2P;
    CGRect mainScreen;
    MySegmentControl *mySegment;
    BOOL isIOS7;
    
    NSNumber *authority;
}
@property BOOL isP2P;
@property (nonatomic, assign) NSNumber *authority;
@property (nonatomic, retain) NSMutableDictionary *m_myDic;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) CameraListMgt *m_pCameraListMgt;
@property (nonatomic, retain) UITableView *m_tableView;
@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, retain) UIImage *imageVideoDefault;
@property (nonatomic, retain) UIImage *imagePlay;
@property (nonatomic, retain) IBOutlet UILabel *labeltitle;
@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPChannelMgt;
@property (nonatomic, retain)  MySegmentControl *mySegment;
@end
