#ifndef _PPPP_AVI_MANAGEMENT_H_
#define _PPPP_AVI_MANAGEMENT_H_

#include "avilib.h"
#define MAX_DID_LENGTH 64
#define MAX_AVI_NUM 4


typedef struct _AVI_D{
	int bValid;
	char avDID[MAX_DID_LENGTH];
	char avFileName[MAX_DID_LENGTH];
    
	avi_t *g_pavi;	
}AVI_D,*AVID;


class CAviManagement{
 public:

	CAviManagement();
	~CAviManagement();
	int startAvi(char*did,char * filename,int width,int height,int fram,char *fcc);
	void writeVideoData(char *did, char *data, long bytes, int keyframe);
	void writeAudioData(char *did, char *data, long bytes);
	void closeAvi(char *did);
    void openAviWithPath(char *did,char *path);
 private:
  AVI_D m_AviD[MAX_AVI_NUM];
    BOOL isRecord;
};

#ifndef SAFE_DELETE
#define SAFE_DELETE(p)\
{\
	if((p) != NULL)\
	{\
		delete (p) ;\
		(p) = NULL ;\
	}\
}
#endif
#endif
