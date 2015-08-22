

#ifndef _PPPP_CHANNEL_H_
#define _PPPP_CHANNEL_H_

#include <pthread.h>

#include "PPPP_API.h"
#include "defineutility.h"
#include "CircleBuf.h"





#import "Adpcm.h"
#import "pcmplayer.h"
#import "PCMRecorder.h"

#import "CgiPacket.h"



#import "SDCardRecordFileSearchProtocol.h"

#import "MyPlaybackBuffer.h"
#import "PPPPObjectProtocol.h"
#import "AviManagement.h"
class CPPPPChannel
{
public:
    CPPPPChannel(CCircleBuf *pVideoBuf, CCircleBuf *pPlaybackVideoBuf, const char *DID, const char *user, const char *pwd);
    virtual ~CPPPPChannel();
    int Start();
    void SetStop();
    int cgi_livestream(int bstart, int streamid);
    int cgi_get_common(char *cgi);
    int get_cgi(int cgi);
    int PTZ_Control(int command);
    int CameraControl(int param, int value);
    int Snapshot();
    void ReconnectImmediately();
    int StartAudio();
    int StopAudio();
    int StartTalk();
    int StopTalk();
    int TalkAudioData(const char* data, int len);
    int StopPlayback();
    int StartPlayback(char *szFilename, int offset);
    
    static void PlaybackAudioBuffer_Callback(void *inUserData,AudioQueueRef inAQ,
                                       AudioQueueBufferRef buffer);
    static void RecordAudioBuffer_Callback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc);
    
    int SetSystemParams(int type,char * msg,int len);
    void SetWifiParamsDelegate(id delegate);
    int SetWifi(int enable, char *szSSID, int channel, int mode, int authtype, int encrypt, int keyformat, int defkey, char *strKey1, char *strKey2, char *strKey3, char *strKey4, int key1_bits, int key2_bits, int key3_bits, int key4_bits, char *wpa_psk);
    int SendWifiSetting(char *msg, int len);
    int GetResult(char *pbuf, int len);

    void SetUserPwdParamsDelegate(id delegate);
    int SetUserPwd(char *user1,char *pwd1,char *user2,char *pwd2,char *user3,char *pwd3);
    

    void SetDateTimeParamsDelegate(id delegate);
    int SetDateTime(int now,int tz,int ntp_enable,char *ntp_svr,int xialishi);
    
    void SetFtpDelegate(id delegate);
    int SetFtp(char *szSvr, char *szUser, char *szPwd, char *dir, int port, int uploadinterval, int mode);
    
    void SetMailDelegate(id delegate);
    int SetMail(char *sender, char *smtp_svr, int smtp_port, int ssl, int auth, char *user,  char *pwd, char *recv1, char *recv2, char *recv3, char *recv4);
    
    void SetAlarmParamsDelegate(id delegate);
    int SetPlayAlarm(int motion_armed,int input_armed);
    int SetAlarm(  
                 int motion_armed,
                 int motion_sensitivity,
                 int input_armed,
                 int ioin_level,
                 int alarmpresetsit,
                 int iolinkage,
                 int ioout_level,
                 int mail,
                 int upload_interval,
                 int record,
                 int enable_alarm_audio
                 );
    
    void SetSDCardSearchDelegate(id delegate);
    void SetPlaybackDelegate(id delegate);
    
    void SetSDCardScheduleDelegate(id delegate);
    int SetSDCardScheduleParams(
                   int coverage_enable,
                   int timelength,
                   int fixed_enable,
                   int enable_record_audio,
                                int record_schedule_sun_0,
                                int record_schedule_sun_1,
                                int record_schedule_sun_2,
                                int record_schedule_mon_0,
                                int record_schedule_mon_1,
                                int record_schedule_mon_2,
                                int record_schedule_tue_0,
                                int record_schedule_tue_1,
                                int record_schedule_tue_2,
                                int record_schedule_wed_0,
                                int record_schedule_wed_1,
                                int record_schedule_wed_2,
                                int record_schedule_thu_0,
                                int record_schedule_thu_1,
                                int record_schedule_thu_2,
                                int record_schedule_fri_0,
                                int record_schedule_fri_1,
                                int record_schedule_fri_2,
                                int record_schedule_sat_0,
                                int record_schedule_sat_1,
                                int record_schedule_sat_2);
    void SetSDcardOver(int over);
    void ProcessResult(int result,int type);
    void SetResultDelegate(id delegate);
    void SetAlarmLogsDelegate(id delegate);
    void SetServer(NSString *server);
    
    void startRecordAVI(char *path,char *format,int width,int height);
    void stopRecordAVI();
    void setJPushParam(STRUCT_JPUSH_PARAM jpt);
    void deleJPushParam(STRUCT_JPUSH_PARAM jpt);
public:
    //这个delegate是用来给cameraviewcontroller通知pppp的状态的
    id <PPPPObjectProtocol> m_PPPPStatusDelegate;
    id <PPPPObjectProtocol> m_CameraViewSnapshotDelegate;
    void SetPlayViewPPPPStatusDelegate(id delegate);
    void SetPlayViewParamNotifyDelegate(id delegate);
    void SetPlayViewImageNotifyDelegate(id delegate);

private:
    int SscanfInt(const char *pszBuffer , const char *reg , int &nResult);
    int PPPP_IndeedRead(UCHAR channel, CHAR *buf, int len);    
    void CommandRecvProcess();
    void DataProcess();
    void TalkProcess();
    void PlaybackProcess();
    void AlarmProcess();  
    void Stop();
    void ProcessAudioBuf(AudioQueueRef inAQ, AudioQueueBufferRef buffer);
    void ProcessRecordAudioBuf(AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc);
    int SendTalk(char * pbuf,int len);
    
    int StartCommandChannel();
    int StartDataChannel();
    int StartPlaybackChannel();
    int StartAudioChannel();
    int StartTalkChannel();
    int StartAlarmChannel();
    int StartCommandRecvThread();
    
    void StartPlaybackVideoPlayer();
    void StopPlaybackVideoPlayer();
    
    static void* CommandRecvThread(void* param);
    static void* CommandThread(void* param);       
    static void* DataThread(void* param); 
    static void* TalkThread(void* param);      
    static void* PlaybackThread(void* param);      
    static void* AlarmThread(void* param);
    static void* AudioThread(void* param);
    static void* PlaybackVideoPlayerThread(void* param);
    void PlaybackVideoPlayerProcess();
    
    void CommandProcess(); 
    void AudioProcess();
    void ProcessCommand(int cmd, char *pbuf, int len);
    void ProcessCameraParams(char *pbuf, int len);   
    int AddCommand(void* data, int len); 
    void StopOtherThread();
    void MsgNotify(int MsgType, int Param);
    void MainWindowNotify(int MsgType, int Param);
    void PlayWindowNotify(int MsgType, int Param);
    //void AVNofity(char *buf, int len);
    void PlayViewParamNotify(int paramType, void* param);    
    void StartVideoPlay();
    void StopVideoPlay();    
    void ProcessSnapshot(char *pbuf, int len);    
    void PPPPClose();
    void ImageNotify(UIImage *image, unsigned int timestamp);
    void ImageData(unsigned char* buf,int len,unsigned int timestamp);
    void YUVNotify(unsigned char* yuv, int len, int width, int height, unsigned int timestamp);
    static void* PlayThread(void* param);      
    void PlayProcess();
    void H264DataNotify(unsigned char* h264Data, int length, int type, unsigned int timestamp);
    
    void PlaybackYUVNotify(unsigned char *yuv, int len, int width, int height, unsigned int timestamp);
    void PlaybackImageNotify(UIImage *image, unsigned int timestamp);
    
    void ProcessWifiScanResult(STRU_WIFI_SEARCH_RESULT_LIST wifiSearchResultList);
    void ProcessWifiParam(STRU_WIFI_PARAMS wifiParams);

    void ProcessUserInfo(STRU_USER_INFO userInfo);
    void ProcessDatetimeParams(STRU_DATETIME_PARAMS datetime);
    void ProcessAlaramParams(STRU_ALARM_PARAMS alarm);
    void ProcessFtpParams(STRU_FTP_PARAMS ftpParam);
    void ProcessMailParams(STRU_MAIL_PARAMS mailParam);
    void ProcessRecordFile(STRU_RECORD_FILE_LIST recordFileList);
    void ProcessRecordParam(STRU_SD_RECORD_PARAM recordFileList);
    void ProcessCheckUser(char *pbuf, int len);
    const char * getCMDEncrptedStr(const char *plainTxt,int step);
    static void* startRecordAVIChannel(void *param);
    void startRecordAVIProcess();
private:        
    int m_bOnline;    
    
   
    id <PPPPObjectProtocol> m_PlayViewPPPPStatusDelegate;
    id <PPPPObjectProtocol> m_PlayViewParamNotifyDelegate;
    id <PPPPObjectProtocol> m_PlayViewImageNotifyDelegate;
    
    id <PPPPObjectProtocol> m_PlaybackViewImageNotifyDelegate;
    
    NSCondition *m_WifiParamsLock;
    id <PPPPObjectProtocol> m_WifiParamsDelegate;
    
    
    NSCondition *m_UserPwdParamsLock;
    id <PPPPObjectProtocol> m_UserPwdParamsDelegate;
    
    NSCondition *m_DateTimeParamsLock;
    
    id <PPPPObjectProtocol> m_DateTimeParamsDelegate;
    
    NSCondition *m_AlarmParamsLock;
    id <PPPPObjectProtocol> m_AlarmParamsDelegate;
    
    NSCondition *m_SDCardSearchLock;
    id <SDCardRecordFileSearchProtocol> m_SDCardSearchDelegate;
    
    NSCondition *m_FTPLock;
    id <PPPPObjectProtocol> m_FtpDelegate;
    
    NSCondition *m_MailLock;
    id <PPPPObjectProtocol> m_MailDelegate;
    
    NSCondition *m_SDCardScheduleLock;
    id<PPPPObjectProtocol>m_SDcardScheduleDelegate;
    
    
    NSCondition *m_SetLock;
    id<PPPPObjectProtocol>m_SetResultDelegate;
    
    NSCondition *m_AlarmLogsLock;
    id<PPPPObjectProtocol>m_AlarmLogsDelegate;
    
    int m_bConnectThreadRuning;
    int m_bCommandThreadRuning;
    int m_bCommandRecvThreadRuning;
    int m_bDataThreadRuning;
    int m_bTalkThreadRuning;
    int m_bPlaybackThreadRuning;
    int m_bAlarmThreadRuning;
    int m_bAudioThreadRuning;    
    int m_bRead;
    
    NSString *strServer;
    
    pthread_t m_CommandThreadID;
    pthread_t m_DataThreadID;
    pthread_t m_TalkThreadID;
    pthread_t m_PlaybackThreadID;
    pthread_t m_AlarmThreadID;
    pthread_t m_CommandRecvThreadID;
    pthread_t m_AudioThreadID;    
    
    INT32 m_hSessionHandle;
    ENUM_VIDEO_MODE m_EnumVideoMode;
    int m_bFindIFrame;
    CCircleBuf *m_pVideoBuf;    
    
    NSCondition *m_PlayViewAVDataDelegateLock;
    NSCondition *m_PlayViewPPPPStatusDelegateLock;
    NSCondition *m_PlayViewParamNotifyDelegateLock;
    
    NSCondition *m_PlaybackViewAVDataDelegateLock;
    
	pthread_t m_PlayThreadID;    
	int m_bPlayThreadRuning;   
    
    pthread_t m_PlaybackVideoPlayerThreadID;    
	int m_bPlaybackVideoPlayerThreadRuning; 
    
    char szDID[64];
    char szUser[64];
    char szPwd[64];    
    
    CCircleBuf *m_pCommandBuffer;    
    NSCondition *m_PPPPCloseCondition;
    NSCondition *m_StopCondition;    
    int m_bReconnectImmediately;
    
    CCircleBuf *m_pAudioBuf;
    CCircleBuf *m_pTalkAudioBuf;
    
    CAdpcm *m_pAudioAdpcm;
    CAdpcm *m_pTalkAdpcm;
    
    int m_bAudioStarted;  
    int m_bTalkStarted;
    CPCMPlayer *m_pPCMPlayer;
    CPCMRecorder *m_pPCMRecorder;
    
    CCgiPacket m_CgiPacket;
    
    ENUM_VIDEO_MODE m_EnumPlayBackVideoMode;
    int m_bPlayBackFindIFrame;
    CCircleBuf *m_pPlayBackVideoBuf;
    //CVideoPlayer *m_pPlayBackVideoPlayer;
    int m_bPlayBackStreamOK;
    BOOL m_bPlaybackStarted;
    
    
    int playbackwriteNum;
    int playbackreadNum;
    MyPlaybackBuffer *myPlaybackBuff;
    int sdcardOver;
    
    
    //录制AVI格式视频
    CAviManagement *aviRecordMgt;
    pthread_t m_AVIThreadID;
    int m_bAVIRecordThreadRunning;
    CCircleBuf *m_BufRecordAVIVideo;
    CCircleBuf *m_BufRecordAVIAudio;
};

#endif
