//
//  CameraEditViewController.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCameraProtocol.h"
#import "SearchAddCameraInfoProtocol.h"
#import "CameraListMgt.h"
#import "ScanViewController.h"
#define TAG_CAMERA_NAME 0
#define TAG_CAMERA_ID 1
#define TAG_USER_NAME 2
#define TAG_PASSWORD 3
#define STR_DEFAULT_CAMERA_NAME "IPCam"
#define STR_DEFAULT_USER_NAME "admin"

@interface CameraEditViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SearchAddCameraInfoProtocol, UINavigationBarDelegate,ScanQRCodeResultDelegate> {
           
    //---------------------------------
    
    CGFloat textFieldAnimatedDistance;
    
    //-------------------------
    BOOL bAddCamera;
    id<EditCameraProtocol> editCameraDelegate;
    NSString *strCameraName;
    NSString *strCameraID;
    NSString *strUser;
    NSString *strPwd;
    NSString *strOldDID;
    NSString *strCameraIp;
    NSString *strOldIp;
    NSString *strCameraPort;
    
    UITextField *currentTextField;
   
    //outlet
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;
    BOOL isP2P;
    
    CameraListMgt *cameraListMgt;
    
}
@property BOOL isP2P;

@property BOOL bAddCamera;
@property (nonatomic, assign) id<EditCameraProtocol> editCameraDelegate;
@property (nonatomic, copy) NSString *strCameraName;
@property (nonatomic, copy) NSString *strCameraID;
@property (nonatomic, copy) NSString *strUser;
@property (nonatomic, copy) NSString *strPwd;
@property (nonatomic, copy) NSString *strOldDID;
@property (nonatomic, copy) NSString *strCameraIp;
@property (nonatomic, copy) NSString *strOldIp;
@property (nonatomic, copy) NSString *strCameraPort;
@property (nonatomic, retain) UITextField *currentTextField;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, assign) CameraListMgt *cameraListMgt;

- (void)keyboardWillShowNotification:(NSNotification *)aNotification;
- (void)keyboardWillHideNotification:(NSNotification* )aNotification;
- (void)btnFinished:(id)sender;

@end
