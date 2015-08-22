//
//  CameraList.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBSelectResultProtocol.h"
#import "CameraDBUtils.h"
#import "P2P_API_Define.h"
#import "obj_common.h"


@interface CameraListMgt : NSObject <DBSelectResultProtocol> {
    
    
@private
    NSMutableArray *CameraArray;
    CameraDBUtils *cameraDB;
    NSMutableArray *deleArray;
    NSCondition *m_Lock;
    
}
-(int)getAlarmNumber;
- (void) selectP2PAll:(BOOL)isP2P ;

- (BOOL) AddCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Snapshot:(UIImage *)img ;
- (BOOL)AddIpCamera:(NSString *)name Ip:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd;


- (BOOL) EditCamera:(NSString *)olddid Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd;
- (BOOL) EditIpCamera:(NSString *)oldip Name:(NSString *)name Ip:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd;

- (NSInteger) UpdateCamereaImage:(NSString *)did Image:(UIImage *)img;
- (NSInteger) UpdateIpCameraImage:(NSString *)ip Image:(UIImage *)img;

- (BOOL) RemoveCamerea:(NSString *)did ;
- (BOOL) RemoveIpCamera:(NSString *)ip;
- (int) GetCount;



-(NSMutableDictionary *)GetIpCameraAtIndex:(NSInteger)index;
- (NSDictionary*) GetCameraAtIndex:(NSInteger) index;

- (BOOL) RemoveCameraAtIndex:(NSInteger) index;
- (BOOL) RemoveIpCameraAtIndex:(NSInteger) index;

- (BOOL) CheckCamere:(NSString *)did;
-(BOOL)CheckCameraIp:(NSString *)ip;

- (NSInteger) UpdatePPPPStatus: (NSString*) did status:(int)status;
- (NSInteger) UpdatePPPPMode: (NSString*) did mode: (int) mode;
-(BOOL) UpdateCameraAuthority:(NSString *)did andStrut:(STRU_USER_INFO)t;
-(BOOL) UpdateCameraAlarmStatus:(NSString *)did AlarmStatus:(BOOL)alarmFlag;
/**
  获取从本地删除，但是从服务器上删除失败的设备数目
 **/
-(int) getDeleFromBizServerCount;
/**
  获取从服务器上删除失败的一台设备id
 **/
-(NSString *)getDeleDIDFromBizAtIndex:(NSInteger)index;

- (BOOL) RemoveCameraFromLocal:(NSString*)did DeleOk:(BOOL)bFlag;
@end
