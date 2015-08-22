//
//  LocalPlayback.mm
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalPlayback.h"
#import "obj_common.h"
#import "defineutility.h"
#import "pthread.h"
#include "H264Decoder.h"
#import <sys/time.h>

#define PLAYBACKVBUF_SIZE      2*K*K

CLocalPlayback::CLocalPlayback()
{
    m_pfile = NULL;
    m_playbackDelegate = nil;
    m_PlaybackThreadID = NULL;
    m_UpdateTimeThreadID=NULL;
    
    m_bPlaybackThreadRuning = 0;
    m_bPause = NO;
    sumTime=0;
    m_playbackLock = [[NSCondition alloc] init];
    isPlayOver=NO;
    isReadDataOVer=NO;
    audioReadNumber=0;//test
}

CLocalPlayback::~CLocalPlayback()
{
    StopPlayback();
    if (m_playbackLock != nil) {
        [m_playbackLock release];
        m_playbackLock = nil;
    }
    sumTime=0;
}
void* CLocalPlayback::UpdateTimeThread(void *param){
    
    CLocalPlayback *pPlayback = (CLocalPlayback*)param;
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    pPlayback->updateTimeProcess();
    
    [apool release];
    return  NULL;
}
void CLocalPlayback::updateTimeProcess(){
    
    while (m_bPlaybackThreadRuning) {
        NSLog(@"updateTimeProcess....sumTime=%d",sumTime/1000);
        if (isPlayOver) {
            return;
        }
        [m_playbackDelegate PlaybackPos:sumTime/1000];
        sleep(1);
        
        if ((sumTime/1000)>=m_nTotalTime) {
            NSLog(@"updateTimeProcess...结束");
            return;
        }
    }
}
void* CLocalPlayback::PlaybackThread(void *param)
{
    CLocalPlayback *pPlayback = (CLocalPlayback*)param;
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    pPlayback->PlaybackProcess();
    [apool release];
    
    // NSLog(@"PlaybackThread end");
    return NULL;
}

void* CLocalPlayback::PlayUpThread(void *param){
    CLocalPlayback *pPlayback = (CLocalPlayback*)param;
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    pPlayback->PlayUpProcess();
    [apool release];
    return NULL;
}


void CLocalPlayback::StopPlayback()
{
    
    m_bPlaybackThreadRuning = 0;
    if (m_PlaybackThreadID != NULL) {
        
        pthread_join(m_PlaybackThreadID, NULL);
        m_PlaybackThreadID = NULL;
    }
    if (m_UpdateTimeThreadID!=NULL) {
        pthread_join(m_UpdateTimeThreadID, NULL);
    }
    if (m_PlayUpThreadID!=NULL) {
        pthread_join(m_PlayUpThreadID, NULL);
    }
    
    if (m_pfile) {
        fclose(m_pfile);
        m_pfile = NULL;
    }
    SAFE_DELETE(m_pPCMPlayer);
    
    m_pAudioBuf->Release();
    SAFE_DELETE(m_pAudioBuf);
    
    m_pVideoBuf->Release();
    SAFE_DELETE(m_pVideoBuf);
}

BOOL CLocalPlayback::CustomSleep(int uNum)
{    sumTime+=1;
    int i = 0;
    for (i = 0; i < uNum; i++) {
        sumTime+=1;
        if (!m_bPlaybackThreadRuning) {
            return NO;
        }
        //NSLog(@"sumTime=%d",sumTime);
        usleep(1000);
    }
    return YES;
}

BOOL CLocalPlayback::GetIndexInfo()
{
    //read the total time
    fseek(m_pfile, 0, SEEK_END);
    long fileLen = ftell(m_pfile);
    
    int nEndIndexLen = strlen("ENDINDEX");
    fseek(m_pfile, fileLen - nEndIndexLen, 0);
    //NSLog(@"aaaa: %ld", ftell(m_pfile));
    char tempBuf[1024];
    memset(tempBuf, 0, sizeof(tempBuf));
    if(nEndIndexLen != fread(tempBuf, 1, nEndIndexLen, m_pfile))
    {
        m_nTotalKeyFrame = 0;
        m_nTotalTime= 0;
        return NO;
    }
    
    //NSLog(@"tempBuf: %s", tempBuf);
    if (strcmp("ENDINDEX", tempBuf) != 0) {
        m_nTotalKeyFrame = 0;
        m_nTotalTime= 0;
        return NO;
    }
    
    fseek(m_pfile, fileLen - nEndIndexLen - 8, 0);
    
    if(4 != fread((char*)&m_nTotalKeyFrame, 1, 4, m_pfile))
    {
        m_nTotalKeyFrame = 0;
        m_nTotalTime= 0;
        return NO;
    }
    if (4 != fread((char*)&m_nTotalTime, 1, 4, m_pfile))
    {
        m_nTotalKeyFrame = 0;
        m_nTotalTime= 0;
        return NO;
    }
    
    return YES;
}

void CLocalPlayback::PlaybackProcess()
{
    
    GetIndexInfo();
    [m_playbackLock lock];
    NSLog(@"m_nTotalTime=%d",m_nTotalTime);
    [m_playbackDelegate PlaybackTotalTime:m_nTotalTime];
    [m_playbackLock unlock];
    
    fseek(m_pfile, SEEK_SET, 0);
    
    //read file head
    STRU_REC_FILE_HEAD filehead;
    memset(&filehead, 0, sizeof(filehead));
    if (sizeof(filehead) != fread((char*)&filehead, 1, sizeof(filehead), m_pfile))
    {
        [m_playbackLock lock];
        [m_playbackDelegate PlaybackStop];
        [m_playbackLock unlock];
        return;
    }
    
    if (filehead.head != 0xff00ff00) {
        [m_playbackLock lock];
        [m_playbackDelegate PlaybackStop];
        [m_playbackLock unlock];
        return;
    }
    
    
    
    unsigned int oldtimestamp = 0;
    
    //unsigned int startTimestamp = 0;
    int audiowritenumber=0;
    CH264Decoder *pH264Decoder=new CH264Decoder();
    while (m_bPlaybackThreadRuning) {
        if (m_bPause) {
            usleep(10000);
            continue;
        }
        //read data head
        STRU_DATA_HEAD datahead;
        memset(&datahead, 0, sizeof(datahead));
        if(sizeof(datahead) != fread((char*)&datahead, 1, sizeof(datahead), m_pfile))
        {
            NSLog(@"datahead is error");
            [m_playbackLock lock];
            isPlayOver=YES;
            [m_playbackDelegate PlaybackStop];
            [m_playbackLock unlock];
            return;
        }
        if (datahead.head != 0xffff0000) {
            NSLog(@"datahead.head != 0xffff0000 播放完成");
            [m_playbackLock lock];
            //isPlayOver=YES;
            //[m_playbackDelegate PlaybackStop];
            isReadDataOVer=YES;
            [m_playbackLock unlock];
            return;
        }
        
        //read data
        char *p = new char[datahead.datalen];
        if (p == NULL) {
            NSLog(@"p == NULL");
            [m_playbackLock lock];
            isPlayOver=YES;
            [m_playbackDelegate PlaybackStop];
            [m_playbackLock unlock];
            return;
        }
        
        if (datahead.datalen != fread(p, 1, datahead.datalen, m_pfile)) {
            SAFE_DELETE(p);
            [m_playbackLock lock];
            isPlayOver=YES;
            [m_playbackDelegate PlaybackStop];
            [m_playbackLock unlock];
            NSLog(@"read data error");
            return;
        }
        
        //NSLog(@"timestamp: %d", datahead.timestamp);
        
        // NSLog(@"datahead.dataformat=%d",datahead.dataformat);
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        if (datahead.dataformat == 3) {//MJPEG
            //test
            int Length = sizeof(VIDEO_BUF_HEAD) + datahead.datalen;
            char *pbuf=new char[Length];
            VIDEO_BUF_HEAD *videohead=(VIDEO_BUF_HEAD*)pbuf;
            videohead->frametype=3;
            videohead->timezone=datahead.timezone;
            videohead->devicetime=datahead.devicetime;
            videohead->timestamp=datahead.timestamp;
            videohead->len=datahead.datalen;
            memcpy(pbuf+sizeof(VIDEO_BUF_HEAD), p, datahead.datalen);
            
            int ret= m_pVideoBuf->Write(pbuf, Length);
            while (ret==0&&m_bPlaybackThreadRuning) {
                 NSLog(@"ret==0写入视频数据失败,再写");
                usleep(10000);
                ret=m_pVideoBuf->Write(pbuf, Length);
            }
             NSLog(@"ret==1写入视频数据成功");
            
            SAFE_DELETE(pbuf);
            //test
            
            
            //            NSData *imgData = [NSData dataWithBytes:p length:datahead.datalen];
            //            UIImage *image = [UIImage imageWithData:imgData];
            //            [m_playbackLock lock];
            //            [m_playbackDelegate PlaybackData:image Timestamp:datahead.devicetime TimeZone:datahead.timezone];
            //            [m_playbackLock unlock];
        }else if(datahead.dataformat == 0||datahead.dataformat==1){ //H264
            
            
            //test
            int Length = sizeof(VIDEO_BUF_HEAD) + datahead.datalen;
            //NSLog(@"Length=%d",Length);
            char *pbuf=new char[Length];
            VIDEO_BUF_HEAD *videohead=(VIDEO_BUF_HEAD*)pbuf;
            videohead->frametype=1;
            videohead->timezone=datahead.timezone;
            videohead->devicetime=datahead.devicetime;
            videohead->timestamp=datahead.timestamp;
            videohead->len=datahead.datalen;
            memcpy(&pbuf[sizeof(VIDEO_BUF_HEAD)], p, datahead.datalen);
            int ret= m_pVideoBuf->Write(pbuf, Length);
            while (ret==0&&m_bPlaybackThreadRuning) {
                NSLog(@"ret==0写入视频数据失败,再写");
                usleep(1000);
                ret=m_pVideoBuf->Write(pbuf, Length);
            }
            NSLog(@"ret==1写入视频数据成功");
            SAFE_DELETE(pbuf);
            //test
            
            
            //            int yuvlen = 0;
            //            int nWidth = 0;
            //            int nHeight = 0;
            //            if (pH264Decoder->DecoderFrame((uint8_t*)p, datahead.datalen, nWidth, nHeight)) {
            //                yuvlen=nWidth*nHeight*3/2;
            //                uint8_t *pYUVBuffer = new uint8_t[yuvlen];
            //                if (pYUVBuffer != NULL) {
            //                    int nRec=pH264Decoder->GetYUVBuffer(pYUVBuffer, yuvlen);
            //
            //                    if (nRec>0) {
            //                        [m_playbackLock lock];
            //                        //NSLog(@"LocalPlayback....1帧");
            //                        [m_playbackDelegate PlaybackData:pYUVBuffer length:yuvlen width:nWidth height:nHeight Timestamp:datahead.devicetime TimeZone:datahead.timezone];
            //                        [m_playbackLock unlock];
            //                    }
            //
            //                    delete pYUVBuffer;
            //                    pYUVBuffer = NULL;
            //                }
            //
            //            }
            
        }else if(datahead.dataformat == 6){//Audio
            audiowritenumber++;
            //NSLog(@"LocalPlayback...audio data audiowritenumber=%d。。。",audiowritenumber);
            int ret= m_pAudioBuf->Write(p, datahead.datalen);
            while (ret==0&&m_bPlaybackThreadRuning) {
                NSLog(@"ret==0写入音频数据失败,再写audiowritenumber=%d",audiowritenumber);
                usleep(10000);
                ret=m_pAudioBuf->Write(p, datahead.datalen);
            }
            NSLog(@"ret==1写入音频数据成功,audiowritenumber=%d",audiowritenumber);
        }
        
        [pool release];
        
        //        if (oldtimestamp == 0) {
        //            oldtimestamp = datahead.timestamp;
        //        }else {
        //            unsigned int timestamp1 = datahead.timestamp;
        //            int timeoff = timestamp1 - oldtimestamp;
        //            if (timeoff > 20000 || timeoff <= 0) {
        //                timeoff = 10;
        //            }
        //            //NSLog(@"timeoff=%d",timeoff);
        //            oldtimestamp = timestamp1;
        //
        //
        //            if (!CustomSleep(timeoff)) {
        //                SAFE_DELETE(p);
        //
        //                return;
        //            }
        //
        //        }
        
        
        SAFE_DELETE(p);
        
    }
    delete pH264Decoder;
    pH264Decoder=NULL;
}
void CLocalPlayback::PlayUpProcess(){
    usleep(20000);
    
    CH264Decoder *pH264Decoder=new CH264Decoder();
    unsigned int oldtimestamp = 0;
    while (m_bPlaybackThreadRuning) {
        
        if (m_bPause) {
            usleep(10000);
            continue;
        }
        if(m_pVideoBuf->GetStock() == 0)
        {
            //Log("videobuf is empty...");
            if (isReadDataOVer) {//判断结束
                isPlayOver=YES;
                [m_playbackDelegate PlaybackStop];
                return;
            }
            usleep(10000);
            continue;
        }
        
        char *pbuf = NULL;
        int videoLen = 0;
        VIDEO_BUF_HEAD datahead;
        memset(&datahead, 0, sizeof(datahead));
        pbuf = m_pVideoBuf->ReadOneFrame1(videoLen, datahead) ;
        
        if(NULL == pbuf)
        {
            usleep(10000);
            continue;
        }
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        if (datahead.frametype==3) {
            
            NSData *imgData = [NSData dataWithBytes:pbuf length:videoLen];
            UIImage *image = [UIImage imageWithData:imgData];
            [m_playbackLock lock];
            [m_playbackDelegate PlaybackData:image Timestamp:datahead.timestamp TimeZone:datahead.timezone];
            [m_playbackLock unlock];
        }else{
            
            int yuvlen = 0;
            int nWidth = 0;
            int nHeight = 0;
            if (pH264Decoder->DecoderFrame((uint8_t*)pbuf, videoLen, nWidth, nHeight)) {
                yuvlen=nWidth*nHeight*3/2;
                uint8_t *pYUVBuffer = new uint8_t[yuvlen];
                if (pYUVBuffer != NULL) {
                    int nRec=pH264Decoder->GetYUVBuffer(pYUVBuffer, yuvlen);
                    
                    if (nRec>0) {
                        [m_playbackLock lock];
                        // NSLog(@"LocalPlayback....1帧");
                        [m_playbackDelegate PlaybackData:pYUVBuffer length:yuvlen width:nWidth height:nHeight Timestamp:datahead.devicetime TimeZone:datahead.timezone];
                        [m_playbackLock unlock];
                    }
                    
                    delete pYUVBuffer;
                    pYUVBuffer = NULL;
                }
                
            }
        }
        [pool release];
        
        
        if (oldtimestamp == 0) {
            oldtimestamp = datahead.timestamp;
        }else {
            unsigned int timestamp1 = datahead.timestamp;
            int timeoff = timestamp1 - oldtimestamp;
            if (timeoff > 20000 || timeoff <= 0) {
                timeoff = 10;
            }
            NSLog(@"timeoff=%d",timeoff);
            oldtimestamp = timestamp1;
            
            //timeoff=10;
            if (!CustomSleep(180)) {
                SAFE_DELETE(pbuf);
                return;
            }
            
        }
        SAFE_DELETE(pbuf);
    }
    delete pH264Decoder;
    pH264Decoder=NULL;
}
void CLocalPlayback::Pause(BOOL bPause)
{
    m_bPause = bPause;
}

BOOL CLocalPlayback::StartPlayback(char *szFilePath)
{
    if (m_pfile != NULL) {
        return NO;
    }
    
    m_pfile = fopen(szFilePath, "rb");
    if (m_pfile == NULL) {
        return NO;
    }
    
    m_pAudioBuf = new CCircleBuf();
    m_pAudioBuf->Create(PLAYBACKVBUF_SIZE);
    m_pPCMPlayer = new CPCMPlayer(PlaybackAudioBuffer_Callback, (void*)this);
    m_pPCMPlayer->StartPlay();
    m_pVideoBuf=new CCircleBuf();
    m_pVideoBuf->Create(8*K*K);
    
    m_bPlaybackThreadRuning = 1;
    isPlayOver=NO;
    pthread_create(&m_PlaybackThreadID, NULL, PlaybackThread, this);
    pthread_create(&m_UpdateTimeThreadID, NULL, UpdateTimeThread, this);
    pthread_create(&m_PlayUpThreadID, NULL, PlayUpThread, this);
    return YES;
}

void CLocalPlayback::SetPlaybackDelegate(id<PlaybackProtocol> playbackDelegate)
{
    [m_playbackLock lock];
    m_playbackDelegate = playbackDelegate;
    [m_playbackLock unlock];
}

void CLocalPlayback::PlaybackAudioBuffer_Callback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef buffer){
    //NSLog(@"PlaybackAudioBuffer_Callback...");
    CLocalPlayback *localPlay=(CLocalPlayback*)inUserData;
    localPlay->ProcessAudioBuf(inAQ, buffer);
}
void CLocalPlayback::ProcessAudioBuf(AudioQueueRef inAQ, AudioQueueBufferRef buffer){
    
    
    // NSLog(@"播放音频数据");
    int nAudioBufSize = _AVCODEC_MAX_AUDIO_FRAME_SIZE * 4;
    char PCMBuf[_AVCODEC_MAX_AUDIO_FRAME_SIZE*4 + 1] = {0};
    
    //读取包数据
    AudioQueueBufferRef outBufferRef = buffer;
    
    memset(PCMBuf, 0, sizeof(PCMBuf));
    if (!m_bPause)
    {
        if (0 == m_pAudioBuf->Read(PCMBuf, nAudioBufSize)) {
            NSLog(@"没有音频数据audioReadNumber=%d",audioReadNumber);
            memset(outBufferRef->mAudioData, 0, nAudioBufSize);
        }else {
            audioReadNumber++;
            NSLog(@"audioReadNumber=%d",audioReadNumber);
            
            memcpy(outBufferRef->mAudioData, PCMBuf, nAudioBufSize);
        }
    }
    else
    {
        memset(outBufferRef->mAudioData, 0, nAudioBufSize);
        //NSLog(@"暂停或者没有数据");
    }
    
    outBufferRef->mAudioDataByteSize = nAudioBufSize;
    
    AudioQueueEnqueueBuffer(inAQ, outBufferRef, 0, nil);
    usleep(235000);
    
    
}