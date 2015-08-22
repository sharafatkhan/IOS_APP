//
//  LocalPlayback.h
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaybackProtocol.h"
#import "pcmplayer.h"
#include "CircleBuf.h"
#ifndef P2PCamera_LocalPlayback_h
#define P2PCamera_LocalPlayback_h

class CLocalPlayback
{
public:
    CLocalPlayback();
    ~CLocalPlayback();
    
    void SetPlaybackDelegate(id<PlaybackProtocol> playbackDelegate);
    BOOL StartPlayback(char *szFilePath);
    void Pause(BOOL bPause);
    static void PlaybackAudioBuffer_Callback(void *inUserData,AudioQueueRef inAQ,
                                             AudioQueueBufferRef buffer);
    void ProcessAudioBuf(AudioQueueRef inAQ, AudioQueueBufferRef buffer);
protected:
    static void* PlaybackThread(void* param);
    void PlaybackProcess();
    static void* PlayUpThread(void *param);
    void PlayUpProcess();
    
    
    void StopPlayback();
    BOOL CustomSleep(int uNum);
    BOOL GetIndexInfo();
    BOOL isPlayOver;
    BOOL isReadDataOVer;
    int audioReadNumber;
    static void* UpdateTimeThread(void* param);
    void updateTimeProcess();
private:
    FILE *m_pfile;
    pthread_t m_UpdateTimeThreadID;
    pthread_t m_PlaybackThreadID;
    pthread_t m_PlayUpThreadID;
    int m_bPlaybackThreadRuning;
    
    id<PlaybackProtocol> m_playbackDelegate;
    unsigned int m_nTotalTime;
    unsigned int m_nTotalKeyFrame;
    
    BOOL m_bPause;
    
    NSCondition *m_playbackLock;
    int sumTime;
    int startposition;
    CPCMPlayer *m_pPCMPlayer;
    CCircleBuf *m_pAudioBuf;
    CCircleBuf *m_pVideoBuf;   
};


#endif
