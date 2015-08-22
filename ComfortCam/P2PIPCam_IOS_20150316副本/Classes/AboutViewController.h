//
//  AboutViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraListMgt.h"
@interface AboutViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;
    UITextField *mTf;
    CGRect tableoldFrame;
    BOOL isFirstShowing;
    CGFloat textFieldAnimatedDistance;
    CGRect mainScreen;
    BOOL isIOS7;
    CameraListMgt *cameraListMgt;
    BOOL isReceivePush;
}
@property (nonatomic, assign) CameraListMgt *cameraListMgt;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain)UITextField *mTf;


@end
