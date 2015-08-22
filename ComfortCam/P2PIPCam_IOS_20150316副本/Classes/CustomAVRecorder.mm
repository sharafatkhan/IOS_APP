//
//  CustomAVRecorder.cpp
//  P2PCamera
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include "CustomAVRecorder.h"
#import "pthread.h"

CCustomAVRecorder::CCustomAVRecorder()
{
    m_pCircleBuf = new CCircleBuf();
    m_pCircleBuf->Create(VBUF_SIZE);
    
    m_RecordThreadID = NULL;
    m_pfile = NULL;
    
    m_nFilePos = 0;
    
    indexArray = [[NSMutableArray alloc] init];
    m_nRecordStartTime = 0;
    m_nRecordEndTime = 0;
    
    m_stopLock = [[NSCondition alloc] init];
    
    m_bWaitKeyFrame = 1;
    m_WriteVideoFrameNumber=0;
}

CCustomAVRecorder::~CCustomAVRecorder()
{
    [m_stopLock lock];
    StopRecord();
    SAFE_DELETE(m_pCircleBuf);
    if (indexArray != nil) {
        [indexArray release];
        indexArray = nil;
    }
    [m_stopLock unlock];
    
    [m_stopLock release];
    
}

void CCustomAVRecorder::GetRecordPath(char *szPath, char *did)
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%s", did]];
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    NSDate* date = [NSDate date];    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];    
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    //[formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString* strDate = [formatter stringFromDate:date];
    
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@.rec", [NSString stringWithFormat:@"%s",did], strDateTime];
    
    strcpy(szPath, [strFileName UTF8String]);
    [formatter release];
}

int CCustomAVRecorder::StartRecord(char *path, int videoformat, char *szosd)
{
    //NSLog(@"CCustomAVRecorder::StartRecord path: %s, videoformat: %d, szosd: %s", path, videoformat, szosd);
    
    if (m_RecordThreadID != NULL) {
        return 1;
    }
    
  
    
    if (m_pfile == NULL) {
        m_pfile = fopen(path, "wb");
        if (m_pfile == NULL) {
            NSLog(@"if (m_pfile == NULL)....");
            return 0;
        }
        
        //write file head
        STRU_REC_FILE_HEAD filehead;
        memset(&filehead, 0, sizeof(filehead));
        filehead.head = 0xff00ff00;
        filehead.version = 0;
        filehead.videoformat = videoformat;
        filehead.audioformat = 0;
        strcpy(filehead.szosd, szosd);
       
        if(sizeof(filehead) != fwrite((char*)&filehead, 1, sizeof(filehead), m_pfile))
        {
            NSLog(@"write filehead error");
            fclose(m_pfile);
            m_pfile = NULL;
            return 0;
        }
        
        m_nFilePos = sizeof(filehead);
        ///m_nRecordStartTime = time(NULL);
        
    }
    
    m_bRecordThreadRuning = 1;
    pthread_create(&m_RecordThreadID, NULL, RecordThread, this);
    return 1;
}

int CCustomAVRecorder::StopRecord()
{
    if (m_RecordThreadID == NULL) {
        return 0;
    }
    
    m_bRecordThreadRuning = 0;
    if (m_RecordThreadID != NULL) {
        pthread_join(m_RecordThreadID, NULL);
        m_RecordThreadID = NULL;
    }
    
    if(m_pfile == NULL)
    {
        return 1;
    }
    
    //NSLog(@"m_nRecordEndTime: %d, m_nRecordStartTime: %d", m_nRecordEndTime, m_nRecordStartTime);
    
    unsigned int time_total = m_nRecordEndTime - m_nRecordStartTime ;
    time_total=160*m_WriteVideoFrameNumber/1000;
    NSLog(@"time_total=%d",time_total);
    //write index
    if(strlen("BEGININDEX") != fwrite((char*)"BEGININDEX", 1, strlen("BEGININDEX"), m_pfile))
    {
        fclose(m_pfile);
        m_pfile = NULL;
        return 0;
    }
    
    
    for (NSNumber *indexPos in indexArray)
    {
        unsigned int nPos = [indexPos intValue];
        if(sizeof(nPos) != fwrite((char*)&nPos, 1, sizeof(nPos), m_pfile))
        {
            fclose(m_pfile);
            m_pfile = NULL;
            return 0;
        }
    }
    unsigned int nNum = [indexArray count];
    if(sizeof(nNum) != fwrite((char*)&nNum, 1, sizeof(nNum), m_pfile))
    {
        fclose(m_pfile);
        m_pfile = NULL;
        return 0;
    }
    if(sizeof(nNum) != fwrite((char*)&time_total, 1, sizeof(time_total), m_pfile))
    {
        fclose(m_pfile);
        m_pfile = NULL;
        return 0;
    }
    
    if (strlen("ENDINDEX") != fwrite((char*)"ENDINDEX", 1, strlen("ENDINDEX"), m_pfile)) {
        fclose(m_pfile);
        m_pfile = NULL;
        return 0;
    }

    fclose(m_pfile);
    m_pfile = NULL;
    
    return 1;
}

void* CCustomAVRecorder::RecordThread(void *param)
{
    CCustomAVRecorder *pRecorder = (CCustomAVRecorder*)param;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    pRecorder->RecordProcess();
    [pool release];
    return NULL;
}

void CCustomAVRecorder::RecordProcess()
{
    int m_bFindIFrame = 0;
    
    NSLog(@"CCustomAVRecorder::RecordProcess..");
    while (m_bRecordThreadRuning) {
        if (m_pCircleBuf->GetStock() == 0) {
            NSLog(@"m_pCircleBuf->GetStock() == 0");
            usleep(100000);
            continue;
        }
        
        int len = 0;
        VIDEO_BUF_HEAD videohead;
        char *pbuf = m_pCircleBuf->ReadOneFrame1(len, videohead);
        if (pbuf == NULL) {
            NSLog(@"ReadOneFrame1 failed");
            usleep(100000);
            continue;
        }
        
        
        if(m_bFindIFrame == 0 && videohead.frametype == 0)
        {
            m_bFindIFrame = 1;
        }
        
        if (m_bFindIFrame == 0 && videohead.frametype == 1) {
            usleep(100000);
            continue;
        }
       
        
        
        NSLog(@"向文件中写数据videohead.frametype=%d",videohead.frametype);
        STRU_DATA_HEAD datahead;
        memset(&datahead, 0, sizeof(datahead));
        datahead.head = 0xffff0000;
        datahead.format = 0;
        datahead.dataformat = videohead.frametype;
        datahead.timestamp = videohead.timestamp;
        datahead.datalen = len;
        datahead.timezone=videohead.timezone;
        datahead.devicetime=videohead.devicetime;
        if(sizeof(datahead) != fwrite((char*)&datahead, 1, sizeof(datahead), m_pfile))
        {
            SAFE_DELETE(pbuf);
            return;
        }
        
        if(len != fwrite(pbuf, 1, len, m_pfile))
        {
            SAFE_DELETE(pbuf);
            return;
        }
        
        time_t tm = time(NULL);
        
        if (m_nRecordStartTime == 0) {
            m_nRecordStartTime = tm ;
           // m_nRecordStartTime=videohead.timestamp;
        }
        
        m_nRecordEndTime = tm ;
        //m_nRecordEndTime =videohead.timestamp;
        SAFE_DELETE(pbuf);
        
        //NSLog(@"write one frame ok...");
        
        if (datahead.dataformat == 3||datahead.dataformat==0) {
            NSNumber *number = [NSNumber numberWithInt:m_nFilePos];
            [indexArray addObject:number];
           // NSLog(@"index array add...");
        }
        if (datahead.dataformat!=6) {
            m_WriteVideoFrameNumber++;
            NSLog(@"m_WriteVideoFrameNumber=%d",m_WriteVideoFrameNumber);
        }
        
        m_nFilePos += sizeof(datahead) + len;

    }
    
}

void CCustomAVRecorder::SendOneFrame(char *pbuf, unsigned int len, unsigned int timestamp, int frametype, int timezone,int deviceTime)
{
    //NSLog(@"CCustomAVRecorder::SendOneFrame len: %d, timestamp: %d, frametype: %d", len, timestamp, frametype);
    //0 是I帧  1是p帧
    if (frametype!=3) {
        if (m_bWaitKeyFrame == 1 && frametype != 0) {
            NSLog(@"录像是高清的第一帧，这一帧不是i帧，不保存");
            return;
        }
    }
   
    m_bWaitKeyFrame = 0;
    
    VIDEO_BUF_HEAD videohead;
    memset(&videohead, 0, sizeof(videohead));
    videohead.frametype = frametype;
    videohead.len = len;
    videohead.timestamp = timestamp;
    videohead.timezone=timezone;
    videohead.devicetime=deviceTime;
    unsigned int length = sizeof(VIDEO_BUF_HEAD) + len;
    char *p = new char[length];
    memcpy(p, (char*)&videohead, sizeof(videohead));
    memcpy(p + sizeof(videohead), pbuf, len);
    
//    if (frametype == 0) {
//        m_pCircleBuf->Reset();
//    }
    
    if(0 == m_pCircleBuf->Write(p, length))
    {//这一帧保存失败，若是高清又回到必须保存i帧的状态
        
        //m_pCircleBuf->Reset();
        m_bWaitKeyFrame = 1;
    }
    
    SAFE_DELETE(p);
}

