//
//  PlaybackViewController.h
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaybackProtocol.h"
#import "MyGLViewController.h"
#import "PPPPChannelManagement.h"


#import "PPPPObjectProtocol.h"
@interface RemotePlaybackViewController : UIViewController<UINavigationBarDelegate,PPPPObjectProtocol>{
    IBOutlet UIImageView *imageView;
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIActivityIndicatorView *progressView;
    IBOutlet UILabel *LblProgress;
    
    
    NSString *strDID;
    
    UIView *bottomView;
    UIButton *playButton;
    UILabel *startLabel;
    UILabel *endLabel;
    UISlider *slider;
        
    int m_nTotalTime;
    
    BOOL m_bPlayPause;
    BOOL m_bHideToolBar;
    
    MyGLViewController *myGLViewController;
    int m_nScreenHeight;
    int m_nScreenWidth;
    
    NSCondition *m_playbackstoplock;
    
    NSString *m_strFileName;
    CPPPPChannelManagement *m_pPPPPMgnt;
    NSString *m_strName;
    BOOL isP2P;
    int TimeZone;
    UILabel *TimeStampLabel;
    
    NSTimer *mTimer;
    BOOL isPlayOver;
    BOOL isFirstFrame;
    int mFileSize;
    
    int mModal;
}
@property BOOL isP2P;
@property int mFileSize;
@property (nonatomic,retain)UILabel *TimeStampLabel; 
@property (nonatomic, retain) UIActivityIndicatorView *progressView;
@property (nonatomic, retain) UILabel *LblProgress;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, retain) NSString *m_strFileName;
@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPMgnt;
@property (nonatomic, copy) NSString *m_strName;

@property int mModal;

- (void) StopPlayback;


@end
