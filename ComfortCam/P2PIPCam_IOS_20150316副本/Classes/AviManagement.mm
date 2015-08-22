#include "AviManagement.h"




CAviManagement::CAviManagement(){
	memset(&m_AviD, 0 ,sizeof(m_AviD));
}

CAviManagement::~ CAviManagement(){

}

int CAviManagement::startAvi(char*did,char * filename,int width,int height,int fram,char *fcc){
  
    
    NSLog(@"startAvi.......filename=%s",filename);
    int i;
    for(i = 0; i <MAX_AVI_NUM; i++)
    {
        if(m_AviD[i].bValid == 1 && strcmp(m_AviD[i].avDID, did) == 0)
        {
        	
            return 1;
        }
    }

    for(i = 0; i < MAX_AVI_NUM; i++)
    {
        if(m_AviD[i].bValid == 0)
        {
            isRecord=YES;
            m_AviD[i].bValid = 1;            
            strcpy(m_AviD[i].avDID, did);
			strcpy(m_AviD[i].avFileName, filename); 
        	m_AviD[i].g_pavi = AVI_open_output_file(filename);
            if (m_AviD[i].g_pavi==NULL) {
                NSLog(@"m_AviD[i].g_pavi ==NULL  filename=%s",filename);
            }else{
                NSLog(@"m_AviD[i].g_pavi !=NULL filename=%s",filename);
            }
		   if (m_AviD[i].g_pavi)
  			  {
     	     AVI_set_video(m_AviD[i].g_pavi, width, height, fram, fcc);
	 	     AVI_set_audio(m_AviD[i].g_pavi, 1,8000,16,WAVE_FORMAT_PCM);
   			 }
            return 1;
        }
    }
    
    return 0;
}

void CAviManagement::writeVideoData(char *did, char *data, long bytes, int keyframe){

    NSLog(@"writeVideoData....did=%s   len=%ld",did,bytes);
    int i;
    for(i = 0; i < MAX_AVI_NUM; i++)
    {
        if(m_AviD[i].bValid == 1 && strcmp(m_AviD[i].avDID, did) == 0&&m_AviD[i].g_pavi!=NULL)
        {
            if (!isRecord) {
                return;
            }
            AVI_write_frame(m_AviD[i].g_pavi, data, bytes, keyframe);
        }
    }  
       
}



void CAviManagement::writeAudioData(char *did, char *data, long bytes){

    int i;
    for(i = 0; i < MAX_AVI_NUM; i++)
    {
        if(m_AviD[i].bValid == 1 && strcmp(m_AviD[i].avDID, did) == 0&&m_AviD[i].g_pavi!=NULL)
        {
            if (!isRecord) {
                return;
            }
            AVI_write_audio(m_AviD[i].g_pavi, data, bytes);
		
        }
    }  
       
}



void CAviManagement::closeAvi(char *did){
    isRecord=NO;
    int i;
    for(i = 0; i < MAX_AVI_NUM; i++)
    {
        if(m_AviD[i].bValid == 1 && strcmp(m_AviD[i].avDID, did) == 0)
        {
            AVI_close(m_AviD[i].g_pavi);
			m_AviD[i].g_pavi = NULL;
            memset(m_AviD[i].avDID, 0, sizeof(m_AviD[i].avDID));
			memset(m_AviD[i].avFileName, 0, sizeof(m_AviD[i].avFileName));
                  
            m_AviD[i].bValid = 0;
		
        }
    }  

}


void CAviManagement::openAviWithPath(char *did,char *path){

    int i;
    for(i = 0; i < MAX_AVI_NUM; i++)
    {
        if(m_AviD[i].bValid == 1 && strcmp(m_AviD[i].avDID, did) == 0)
        {
//            m_AviD[i].g_pavi=AVI_open_input_file(path, 1);
//            long frames=AVI_video_frames(m_AviD[i].g_pavi);
//            NSLog(@"openAviWithPath=%ld",frames);
        }
    
    }
    
}




















