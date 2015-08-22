//
//  PPPPObjectProtocol.h
//  P2PCamera
//
//  Created by Tsang on 14-4-17.
//
//

#import <Foundation/Foundation.h>
#import "P2P_API_Define.h"
@protocol PPPPObjectProtocol <NSObject>
@optional
#pragma mark--摄像机的各种设置回调

-(void)DateTimeProtocolResult:(STRU_DATETIME_PARAMS)t;

-(void)AlarmProtocolResult:(STRU_ALARM_PARAMS)t;

-(void)FtpProtocolResult:(STRU_FTP_PARAMS)t;

-(void)MailProtocolResult:(STRU_MAIL_PARAMS)t;

-(void)UserProtocolResult:(STRU_USER_INFO)t;

-(void)WifiProtocolResult:(STRU_WIFI_PARAMS)t;

-(void)WifiScanProtocolResult:(STRU_WIFI_SEARCH_RESULT)t;

-(void)DDNSProtocolResult:(STRU_DDNS_PARAMS)t;

-(void)NetworkProtocolResult:(STRU_NETWORK_PARAMS)t;

-(void)SDCardProtocolResult:(STRU_SD_RECORD_PARAM)t;

-(void)setResult:(int )nResult;

-(void)SDCardRecordListResult:(STRU_SDCARD_RECORD_FILE)t;

#pragma mark--报警日志回调
-(void)CallbackAlarmLoglist:(NSInteger)year MON:(NSInteger)mon DAY:(NSInteger)day HOUR:(NSInteger)hour MIN:(NSInteger)min SEC:(NSInteger)sec ACTIONTYPE:(NSInteger)actiontype NCOUT:(NSInteger)ncout BEND:(NSInteger)bEnd;

#pragma mark--  摄像机状态回调
- (void) PPPPStatus: (NSString*)strDID
         statusType:(NSInteger)statusType
             status:(NSInteger) status;

#pragma mark--获取摄像机的一张图片
- (void) SnapshotNotify: (NSString*) strDID
                   data:(char*) data
                 length:(int) length;

#pragma mark-- 获取视频的回调
- (void) ImageNotify: (UIImage *)image
           timestamp: (NSInteger)timestamp
                 DID:(NSString *)did;
- (void) ImageData:(Byte*)buf
            Length:(int)len
         timestamp: (NSInteger)timestamp;


- (void) YUVNotify: (Byte*) yuv
            length:(int)length
             width: (int) width
            height:(int)height
         timestamp:(unsigned int)timestamp
               DID:(NSString *)did;


- (void) H264Data: (Byte*) h264Frame
           length: (int) length
             type: (int) type
        timestamp: (NSInteger) timestamp
              DID:(NSString *)did;


- (void) CameraDefaultParams:(int)m_Contrast
                      Bright:(int)m_Brightness
                  Resolution:(int)nResolution
                        Flip:(int)m_nFlip
                       Frame:(int)frame;


- (void) AVData:(char *)data
         length:(int)length
      Timestamp:(int)timestamp;
#pragma mark--获取摄像机的默认值的回调
- (void) ParamNotify: (int) paramType
              params:(void*) params;

- (void) CgiResultNotify: (NSInteger)cgiID
               CgiResult:(NSString*)strResult ;



#pragma mark--音频数据
-(void)AudioDataBack:(Byte*)data Length:(int)len;


#pragma mark-- 实时读取视频数据的速度xf/s
-(void)readPPPPChannelDataSpeed;
#pragma mark-- 实时显示视频数据的速度xf/s
-(void)showPPPPChannelDataSpeed;

@end
