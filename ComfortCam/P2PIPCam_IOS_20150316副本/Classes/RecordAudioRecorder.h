//
//  RecordAudioRecorder.h
//  P2PCamera
//
//  Created by Tsang on 14-3-21.
//
//

#ifndef P2PCamera_RecordAudioRecorder_h
#define P2PCamera_RecordAudioRecorder_h
#import "obj_common.h"

class CRecordAudioRecorder{
public:
    CRecordAudioRecorder();
    ~CRecordAudioRecorder();
    void StartRecord();
    void StopRecord();
};

#endif
