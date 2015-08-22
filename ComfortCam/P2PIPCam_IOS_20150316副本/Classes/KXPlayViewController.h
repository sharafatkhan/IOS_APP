//
//  KXPlayViewController.h
//  P2PCamera
//
//  Created by kaven on 15/3/10.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"

#import "PicPathManagement.h"
#import "CustomAVRecorder.h"
#import "RecPathManagement.h"
#import "NotifyEventProtocol.h"
#import "MyGLViewController.h"
#import "MySetDialog.h"
#import "PresetDialog.h"


#import "CameraMediaSource.h"
#import "NetWorkUtiles.h"
#import "CircleBuf.h"

#import "NotifyMessageProtocol.h"
#import "MoreViewPlayProtocol.h"

#import "PlayViewResultProtocol.h"

#import "MyVerticalScrollToolBar.h"
#import "MyPlayToolbar.h"

#import "PPPPObjectProtocol.h"
@interface KXPlayViewController : UIViewController<PresetDialogDelegate,MySetDialogDelegate,NotifyMessageProtocol,MoreViewPlayProtocol,MyVerticalScrollToolBarDelegate,MyPlayToolbarDelegate,PPPPObjectProtocol>
{
     UIImageView *imgView;
     UIActivityIndicatorView *progressView;
     UILabel *LblProgress;
    
     UILabel *timeoutLabel;
    
     UIImageView *imageUp;
     UIImageView *imageDown;
     UIImageView *imageLeft;
     UIImageView *imageRight;
    
    
     UIButton *btnMicrophone;
    
    
     UIButton *btnRight;
     UIButton *btnLeft;
     UIButton *btnDown;
     UIButton *btnUp;
    
    UILabel *labelContrast;
    UISlider *sliderContrast;
    UILabel *labelBrightness;
    UISlider *sliderBrightness;
    UIImage *imgVGA;
    UIImage *imgQVGA;
    UIImage *img720P;
    UIImage *imgNormal;
    UIImage *imgEnlarge;
    UIImage *imgFullScreen;
    UIImage *ImageBrightness;
    UIImage *ImageContrast;
    NSString *cameraName;
    NSString *strDID;
    UIImage *imageSnapshot;
    
    
    CGPoint beginPoint;
    int m_Contrast;
    int m_Brightness;
    BOOL bGetVideoParams;
    BOOL bPlaying;
    BOOL bManualStop;
    CPPPPChannelManagement *m_pPPPPChannelMgt;
    int nResolution;
    UILabel *OSDLabel;
    UILabel *TimeStampLabel;
    NSInteger nUpdataImageCount;
    NSTimer *timeoutTimer;
    BOOL m_bAudioStarted;
    BOOL m_bTalkStarted;
    BOOL m_bGetStreamCodecType;
    int m_StreamCodecType;
    int m_nP2PMode;
    int m_nTimeoutSec;
    BOOL m_bToolBarShow;
    BOOL m_bPtzIsUpDown;
    BOOL m_bPtzIsLeftRight;
    BOOL m_bUpDownMirror;
    BOOL m_bLeftRightMirror;
    int m_nFlip;
    BOOL m_bBrightnessShow;
    BOOL m_bContrastShow;
    
    int m_nDisplayMode;
    int m_nVideoWidth;
    int m_nVideoHeight;
    
    int m_nScreenWidth;
    int m_nScreenHeight;
    
    PicPathManagement *m_pPicPathMgt;
    RecPathManagement *m_pRecPathMgt;
    
    CCustomAVRecorder *m_pCustomRecorder;
    NSCondition *m_RecordLock;
    
    id<NotifyEventProtocol> PicNotifyDelegate;
    id<NotifyEventProtocol> RecNotifyDelegate;
    
    MyGLViewController *myGLViewController;
    
    int m_videoFormat;
    
    Byte *m_pYUVData;
    NSCondition *m_YUVDataLock;
    int m_nWidth;
    int m_nHeight;
    int m_nLength;
    BOOL isRecording;
    BOOL isTakepicturing;
    
    NSString *recordFileName;
    NSString *recordFilePath;
    NSString *recordFileDate;
    
    
    int recordNum;
    
    CGFloat lastDistance;
    
    CGFloat imgStartWidth;
    CGFloat imgStartHeight;
    
    
    PresetDialog *preDialog;
    MySetDialog *setDialog;
    BOOL isPresetDialogShow;
    BOOL isCallPreset;
    BOOL isSetDialogShow;
    MySetDialog *seeMoreDialog;
    MySetDialog *frameDialog;
    MySetDialog *alarmDialog;
    MySetDialog *ledDialog;
    MySetDialog *gpioDialog;
    BOOL isGPIODilaogShow;
    BOOL isLedDialogShow;
    BOOL isSeeMoreDialogShow;
    BOOL isFrameDialogShow;
    BOOL isAlarmDialogShow;
    BOOL isP2P;
    BOOL isFoutBtnShow;
    //ddns
    
    NSString *m_strIp;
    NSString *m_strPort;
    NSString *m_strUser;
    NSString *m_strPwd;
    
    CCameraMediaSource *m_pCameraMediaSource;
    CCircleBuf *m_pVideoBuf;
    NetWorkUtiles *netUtiles;
    
    BOOL isScale;// 缩放
    int mFrame;
    BOOL isMove;
    BOOL isMicrophoneShow;
    BOOL isMoreView;
    
    UILabel *labelRecord;
    
    
    BOOL isH264;
    BOOL isStop;
    
    int timezone;
    NSString *strOSD;
    
    int ddnsDisconnectNumber;
    
    BOOL isDataComeback;
    
    id<PlayViewResultProtocol> playViewResultDelegate;
    
    
    MyVerticalScrollToolBar *verScrollToolBar;
    MyPlayToolbar *playTopToolBar;
    MyPlayToolbar *playBottomToolBar;
    MySetDialog *waveDialog;
    BOOL isWaveDialogShow;
    NSUserDefaults *userDefault;
    
    BOOL isDelayOpenAudio;
    int writeAudioDataNumber;//写入的音频数
    int writeH264Number;//写入连续h264视频数
    
    BOOL isZoomPlus;
    BOOL isZoomMinus;
    
    int mModal;//是否是第三方设备，如果是第三方设备则不显示本地OSD
    
    int mAuthority;
    
    //录制AVI格式视频
    
    int aviWidth;
    int aviHeight;
    
    int takePicNumber;
    
    
    NSTimer *timerCheckData;
    int mDataComeDelayTime;
    
    CGRect mainScreen;
}

@property (nonatomic,copy)NSString *strOSD;
@property (nonatomic,retain)  UILabel *labelRecord;
@property (nonatomic,retain)  UILabel *labelNetworkSpeed;
@property BOOL isMoreView;
@property (nonatomic,copy) NSString *m_strIp;
@property (nonatomic,copy) NSString *m_strPort;
@property (nonatomic,copy) NSString *m_strUser;
@property (nonatomic,copy) NSString *m_strPwd;
@property (nonatomic, assign) NetWorkUtiles *netUtiles;

@property BOOL isP2P;
@property (nonatomic,retain)MySetDialog *setDialog;
@property (nonatomic,retain) PresetDialog *preDialog;
@property (nonatomic,retain)MySetDialog *seeMoreDialog;
@property (nonatomic,retain)MySetDialog *frameDialog;
@property (nonatomic,retain)MySetDialog *waveDialog;
@property (nonatomic,retain)MySetDialog *alarmDialog;
@property int recordNum;

@property BOOL isRecording;
@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPChannelMgt;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, copy) NSString *cameraName;
@property (nonatomic, copy) NSString *recordFileName;
@property (nonatomic, copy) NSString *recordFilePath;
@property (nonatomic, copy) NSString *recordFileDate;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, retain) UIActivityIndicatorView *progressView;
@property (nonatomic, retain) UILabel *LblProgress;

@property (nonatomic, retain) UILabel *timeoutLabel;
@property int m_nP2PMode;
@property (nonatomic, retain) UIImage *imgVGA;
@property (nonatomic, retain) UIImage *imgQVGA;
@property (nonatomic, retain) UIImage *img720P;

@property (nonatomic, retain) UIImage *imgNormal;
@property (nonatomic, retain) UIImage *imgEnlarge;
@property (nonatomic, retain) UIImage *imgFullScreen;
@property (nonatomic, retain) UIImage *imageSnapshot;
@property (nonatomic, assign) PicPathManagement *m_pPicPathMgt;

@property (nonatomic, retain) UIImageView *imageUp;
@property (nonatomic, retain) UIImageView *imageDown;
@property (nonatomic, retain) UIImageView *imageLeft;
@property (nonatomic, retain) UIImageView *imageRight;
@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, assign) id<NotifyEventProtocol> PicNotifyDelegate;
@property (nonatomic, assign) id<NotifyEventProtocol> RecNotifyDelegate;

@property (nonatomic, retain)  UIButton *btnMicrophone;
@property (nonatomic, retain)  UIButton *btnRight;
@property (nonatomic, retain)  UIButton *btnLeft;
@property (nonatomic, retain)  UIButton *btnDown;
@property (nonatomic, retain)  UIButton *btnUp;
@property (nonatomic, retain) id<PlayViewResultProtocol> playViewResultDelegate;
@property (nonatomic,retain)MyVerticalScrollToolBar *verScrollToolBar;
@property (nonatomic,retain)MyPlayToolbar *playTopToolBar;
@property (nonatomic,retain)MyPlayToolbar *playBottomToolBar;

@property (nonatomic,retain)NSUserDefaults *userDefault;

@property int mAuthority;
@property int mModal;
- (void)StopPlay: (int) bForce;
@end
