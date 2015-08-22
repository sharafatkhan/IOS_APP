/*
added: 
	1.t_usr_active_req
	2.t_lginext_ack

chang:
	1.t_usr_active --->t_usr_active_confirm
	2.t_usr_active_ack -->t_usr_active_confirm_ack
*/

#ifndef _BIZ_DATA_H_
#define _BIZ_DATA_H_

#include "XQ_Global.h"

#if WIN32_DLL

#else
#include <time.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <netinet/ip.h>

#include <arpa/inet.h>
#include "sys/types.h"
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <assert.h>
#include <sys/param.h>
#include <sys/ioctl.h>
#include <net/if.h>

#include <stddef.h>
#include <ctype.h>
#include <unistd.h>
#include <semaphore.h>
#include <signal.h>
#include <pthread.h>

#if IOS_LIB

#else

#include <net/if_arp.h>
#include <netinet/udp.h>

#endif

#endif

#define MAX_ENGINE_NMB  10
#define CMD_ENC_STEP    4
#define CMD_MAX_MSG_SIZE   1400
#define CMD_MAX_PKT_SIZE	1024
#define MAX_MSGTITLE_SIZE   64
#define MAX_MSGCONTENT_SIZE 256
#define MAX_NAME_SIZE    16
#define MAX_ACC_SIZE    16
#define MAX_PWD_SIZE    16
#define MAX_MAIL_SIZE    24
#define MAX_MTEL_SIZE    24
#define MAX_MSGTO_CNTR    64
#define MAX_DESC_SIZE 256
#define MAX_SVRSTR_SIZE	768
#define MAX_IDPRE_SIZE	8
#define MAX_ID_SIZE    20
#define MAX_GID_SIZE    24
#define MAX_APPLETOKEN_SIZE 64
#define MAX_VERSION_SIZE 12
#define MAX_URL_SIZE 256
#define MAX_AUTHCODE_SIZE	4
#define SESSION_STR_SIZE    32
#define PKT_HEADER_LEN  8
#define MAX_MSG_RTN_NMB    4
#define MAX_DEV_RTN_NMB    16
#define MAX_SVC_RTN_NMB     32
#define MAX_HB_COUNTER  5


typedef enum 
	{
	SYS_NOTIFY_NORMAL=0,
	SYS_NOTIFY_URGENT,
	SYS_NOTIFY_ERROR,
	SYS_NOTIFY_USERPUSH,
	SYS_NOTIFY_FRIEND_REQUEST,
	SYS_NOTIFY_FRIEND_RESPONSE,
	SYS_NOTIFY_FRIEND_MSG
	}sys_notify_type;


//for readresult output commondata
typedef struct commonData
{
unsigned int	pNmb;//param struct inst numb
void *pSpace;//param struct
}t_commonData;

//sys user administrator
typedef struct sys_usr_adm
{
unsigned int	mgmType;//0-->enable,1-->disable,2-->delete,3-->notifysth
CHAR authCode[MAX_AUTHCODE_SIZE];
CHAR uID[MAX_ID_SIZE];
CHAR content[MAX_MSGCONTENT_SIZE];
}t_sys_usr_adm;

//sys notification msg
typedef struct sys_notify
{
unsigned int   notifyType;
CHAR notifyContent[MAX_MSGCONTENT_SIZE];
}t_sys_notify;

//app information
typedef struct app_Inf
{
CHAR appVer[MAX_VERSION_SIZE];
CHAR appID[MAX_ID_SIZE];
CHAR appleToken[MAX_APPLETOKEN_SIZE];
}t_app_Inf;
/*
typedef struct biz_Inf
{
unsigned int uGrp;	//user group <--initialize from bizInit by licenstring
CHAR aVer[MAX_VERSION_SIZE]; //app version
unsigned int sqNmb;//sequcence number for every packet,  increased automatically
unsigned int hbCntr;//heartbeat counter , increased automatically and reset by response from server
CHAR sStr[SESSION_STR_SIZE];//session string ()
CHAR uID[MAX_ID_SIZE];
CHAR aID[MAX_ID_SIZE];
struct sockaddr_in *svrAddr;
}t_biz_Inf;
*/
typedef struct biz_Inf
{
unsigned int uGrp;	//user group <--initialize from bizInit by licenstring
CHAR aVer[MAX_VERSION_SIZE]; //app version
unsigned int sqNmb;//sequcence number for every packet,  increased automatically
unsigned int hbCntr;//heartbeat counter , increased automatically and reset by response from server
int status;//session status
//int bInit;//session status
SOCKETFD sSkt;
CHAR sStr[SESSION_STR_SIZE];//session string ()
CHAR uID[MAX_ID_SIZE];
CHAR aID[MAX_ID_SIZE];
struct sockaddr_in svrAddr;
}t_biz_Inf;

//user register
typedef struct usr_reg
    {
    unsigned int usrGrpID;
    CHAR usrAcc[MAX_ACC_SIZE]; 
    CHAR usrPwd[MAX_PWD_SIZE];
    }t_usr_reg;

typedef struct gps
{
int gps_x;
int gps_y;
}t_gps;

//simple service infomation
typedef struct svcInf_s
{
unsigned int  svcID;
unsigned int billingPrice;
CHAR svcName[MAX_ACC_SIZE];
CHAR billingName[MAX_ACC_SIZE];
}t_svcInf_s;

//detail service infomation
typedef struct svcInf_d
{
unsigned int svcID;
CHAR svcName[MAX_ACC_SIZE];
CHAR svcDesc[MAX_DESC_SIZE];
}t_svcInf_d;

//detail billing infomation
typedef struct billInf_d
{
UINT16 billingID;
UINT16 billingMoney;
CHAR billingName[MAX_ACC_SIZE];
CHAR billingDesc[MAX_DESC_SIZE];
}t_billInf_d;

//simple device group infomation
typedef struct 
{
CHAR dGID[MAX_GID_SIZE];//device group ID
CHAR pdGID[MAX_GID_SIZE];//the parent device groupp ID  
CHAR dGName[MAX_NAME_SIZE];//device group anme
}t_dgInf_s;

//detail device group infomation
typedef struct 
{
CHAR dGID[MAX_GID_SIZE];//device group ID
CHAR pdGID[MAX_GID_SIZE];//the parent device groupp ID  
CHAR dGName[MAX_NAME_SIZE];//device group anme
unsigned int dGEnabled;//if enabled
CHAR dGDesc[MAX_DESC_SIZE];//describtion of the device group
}t_dgInf_d;

//simple infomation of device
typedef struct 
{
CHAR dID[MAX_ID_SIZE];//device ID
CHAR dGID[MAX_GID_SIZE];//device group id the device belong to
CHAR dName[MAX_NAME_SIZE];//device name
CHAR dAcc[MAX_ACC_SIZE]; //access account
CHAR dPwd[MAX_PWD_SIZE];//access password
}t_devInf_s;

//detail infomation for user-device
typedef struct 
{
CHAR dID[MAX_ID_SIZE];//device ID
CHAR dGID[MAX_GID_SIZE];//device group id the device belong to
CHAR dName[MAX_NAME_SIZE];//device name
CHAR dAcc[MAX_ACC_SIZE]; //access account
CHAR dPwd[MAX_PWD_SIZE];//access password
unsigned int dSvcMap;//the bitmap for servcie 
unsigned int dEnable;//if enabled 0'enabled,1->disenabled
unsigned int dTag; //owner or just accessor
CHAR dDesc[MAX_DESC_SIZE];//desribe infomation
}t_udevInf_d;

//detail infomation for saler-device
typedef struct 
{
CHAR dID[MAX_ID_SIZE];
CHAR dAcc[MAX_ACC_SIZE]; 
CHAR dPwd[MAX_PWD_SIZE];
unsigned int dStatus;//�豸״̬�����ڱ�ʶ�豸��������(�����̡��ɡ��ۡ���)
unsigned int dEnable;//���÷�
unsigned int dSPrice;//ʵ�����ۼ�        
int dGpsX;//GPS
int dGpsY;//GPS
CHAR dAddr[MAX_DESC_SIZE];//�豸��ַ����������Ϣ
}t_sdevInf_d;

//simple infomation for user
typedef struct 
{
CHAR uID[MAX_ID_SIZE];//user id
CHAR uName[MAX_NAME_SIZE] ;//user name /alias
}t_uInf_s;

//detail infomation for user
typedef struct 
{
CHAR uID[MAX_ID_SIZE];//userID ,pre-defined,be unify
CHAR uOID[SESSION_STR_SIZE];//thirdth authentication (maybe null)-should be unify
CHAR umtel[MAX_MTEL_SIZE]; //user mobile number, should be unify
CHAR uMail[MAX_MAIL_SIZE]; //user email address,should be unify
CHAR uName[MAX_NAME_SIZE]; //user name /alias
CHAR uAcc[MAX_ACC_SIZE]; //acount
CHAR uPwd[MAX_PWD_SIZE];//password (when search return NULL)
unsigned int uRegTime;//regist time
unsigned int uLastLgnTime;//regist time
unsigned int uAge;//age
unsigned int uSex;//sex
unsigned int uEnable;  
int uGpsX;//GPS
int uGpsY;//GPS    
CHAR uAddr[MAX_DESC_SIZE];//address
}t_uInf_d;

//detail infomation for fellow
typedef struct 
{
CHAR uID[MAX_ID_SIZE];//userID
CHAR uName[MAX_NAME_SIZE]; //user name /alias
unsigned int uRegTime;//regist time
unsigned int uLastLgnTime;//regist time
unsigned int uAge;//age
unsigned int uSex;//sex
unsigned int uEnable;  
int uGpsX;//GPS
int uGpsY;//GPS    
CHAR uAddr[MAX_DESC_SIZE];//address
}t_uInf_d1;

typedef struct msg_view
{
unsigned int total;
unsigned int unread;
unsigned int  readed;
unsigned int bePush;//pushed msg numb
}t_msg_view;

//simple infomation for msg
typedef struct msg_s
{
unsigned int msgID;//msg id
unsigned int pmsgID;//msg id
CHAR msgTitle[MAX_MSGTITLE_SIZE];
CHAR msgFrom[MAX_ID_SIZE];//from who    
unsigned int msgTag;//msg type
unsigned int msgCTime;//create time    
}t_msg_s;

//detail infomation for msg
typedef struct msg_d
{
unsigned int msgID;//msg id
unsigned int pmsgID;//msg id
CHAR msgTitle[MAX_MSGTITLE_SIZE];
CHAR msgFrom[MAX_ID_SIZE];//from who    
unsigned int msgTag;//msg type
unsigned int msgCTime;//create time    
unsigned int msgTo[MAX_MSGTO_CNTR];//to whos,of uid-sn
CHAR msgContent[MAX_MSGCONTENT_SIZE];//content
}t_msg_d;


//****************************************************************************************
typedef	struct cmd_header
	{
	unsigned int     cmdSeq;
	UINT16	cmdType;
	UINT16	cmdLen;
	} t_pkt_header;



//remote manage biz_server
typedef struct sys_mgm
    {
    unsigned int   mgmType;
    CHAR magicToken[SESSION_STR_SIZE];
    }t_sys_mgm;


//client login/register
typedef struct app_lgn
    {
    CHAR appVer[MAX_VERSION_SIZE];    
    CHAR appID[MAX_ID_SIZE];
    CHAR appleToken[MAX_APPLETOKEN_SIZE];
    }t_app_lgn;

//ack for client login/register
typedef struct app_lgn_ack
    {
    t_just_validation ack;
    CHAR appVer[MAX_VERSION_SIZE];    
    CHAR appID[MAX_ID_SIZE];
    }t_app_lgn_ack; 

//get client version url address
typedef struct ver_url_get
    {
    CHAR appVer[MAX_VERSION_SIZE];    
    }t_ver_url_get;


//ack for version url get
typedef struct ver_url_get_ack
    {
    t_just_validation ack;
    CHAR verURL[MAX_URL_SIZE];
    }t_ver_url_get_ack;

//ack for service list get
typedef struct svc_list_get_ack
    {
    t_just_validation ack;
    //unsigned int  svcNmb; 
    t_svcInf_s svcInf[MAX_SVC_RTN_NMB];
    }t_svc_list_get_ack;

//get detailed infomation for service 
typedef struct svc_detail_get
    {
    unsigned int svcID;
    }t_svc_detail_get;

//ack for detailed service infomation get 
typedef struct svc_detail_get_ack
    {
    t_just_validation ack;
    t_svcInf_d svcDetail;
    }t_svc_detail_get_ack;

//get defailted infomation for billing
typedef struct billing_detail_get
    {
    unsigned int svcID;
    }t_billing_detail_get;

//ack for detailed infomation of device
typedef struct billing_detail_get_ack
    {
    t_just_validation ack;
    t_billInf_d billingDetail;
    }t_billing_detail_get_ack;

//get encoded servers string for idPrefix
typedef struct svr_str_get
    {
    CHAR idPre[MAX_IDPRE_SIZE];
    }t_svr_str_get;

//ack for encoded servers string
typedef struct svr_str_get_ack
    {
    t_just_validation ack;
    CHAR svrStr[MAX_SVRSTR_SIZE];
    }t_svr_str_get_ack;


//ack for user register
typedef struct usr_reg_ack
    { 
    t_just_validation ack;//o-ok,  -error
    CHAR usrID[MAX_ID_SIZE];
    }t_usr_reg_ack;

//user register ext
typedef struct usr_reg_ext
    {
    unsigned int usrGrpID;
    CHAR usrAcc[MAX_ACC_SIZE]; 
    CHAR usrPwd[MAX_PWD_SIZE];
	CHAR usrMtel[MAX_MTEL_SIZE];
	CHAR usrMail[MAX_MAIL_SIZE];	
    }t_usr_reg_ext;

//ack for user register
typedef struct usr_reg_ext_ack
    { 
    t_just_validation ack;//o--sms,1--email,2 sms and emai,  -error
    CHAR usrID[MAX_ID_SIZE];
    }t_usr_reg_ext_ack;

//user active confirm
typedef struct usr_active_req
    {
	unsigned int actType;//the next field type, 0-->mtel,1-->mail
    CHAR actString[MAX_MAIL_SIZE];//mtel or email
    }t_usr_active_req;


//user active confirm
typedef struct usr_active_confirm
    {
    CHAR usrID[MAX_ID_SIZE];
    CHAR usrAuthCode[MAX_AUTHCODE_SIZE];//authencate code is gotten from the thirdparty source,like sms or email
    }t_usr_active_confirm;

//ack for user register
typedef struct usr_recovery_request
    {
    unsigned int	actvType;
    CHAR actString[MAX_MAIL_SIZE];
    }t_usr_recovery_request;

typedef struct usr_recovery_confirm
    {
    CHAR uAuth[MAX_AUTHCODE_SIZE];
    CHAR uStr[MAX_MAIL_SIZE];
    }t_usr_recovery_confirm;

typedef struct usr_recovery_confirm_ack
	{
	t_just_validation ack;
	CHAR uStr[MAX_MAIL_SIZE];
	CHAR uPwd[MAX_PWD_SIZE];
	}t_usr_recovery_confirm_ack;


//user/saler login
typedef struct lgin
    {
    unsigned int usrGrpID;
    CHAR appID[MAX_ID_SIZE];        
    CHAR usrAcc[MAX_ACC_SIZE]; 
    CHAR usrPwd[MAX_PWD_SIZE];
    }t_lgin;

//user/saler login
typedef struct lginext
    {
    unsigned int usrGrpID;
    CHAR appID[MAX_ID_SIZE];        
    CHAR usrAcc[MAX_MAIL_SIZE]; 
    CHAR usrPwd[MAX_PWD_SIZE];
    }t_lginext;


//the third partner user login 
typedef struct olgin
    {
    unsigned int usrGrpID;
    CHAR appID[MAX_ID_SIZE];        
    CHAR oID[SESSION_STR_SIZE];
    }t_olgin;

//ack for login
typedef struct lgin_ack
    {
    t_just_validation ack;
    CHAR usrID[MAX_ID_SIZE];
    CHAR usrAcc[MAX_ACC_SIZE];
    CHAR usrPwd[MAX_PWD_SIZE];    
    CHAR sessionStr[SESSION_STR_SIZE];
    }t_lgin_ack;

//ack for login ext (add mtel and mail, please distiguish it with olgin)
typedef struct lgin_ext_ack
    {
    t_just_validation ack;
    CHAR usrID[MAX_ID_SIZE];
    CHAR usrMtel[MAX_MTEL_SIZE];
    CHAR usrMail[MAX_MAIL_SIZE];    
    CHAR sessionStr[SESSION_STR_SIZE];
    }t_lgin_ext_ack;


//logout
typedef struct lgout
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    }t_lgout;

//heartbeat packet
typedef struct alive
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    }t_alive;

//user change pwd
typedef struct pwd_chg
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    CHAR newAcc[MAX_ACC_SIZE];
    CHAR newPwd[MAX_PWD_SIZE];
    }t_pwd_chg;

//get user detail infomation
typedef struct usrinf_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    }t_usrinf_get;

//get user detail infomation
typedef struct usrinf_get_ack
    {
     t_just_validation ack;
     t_uInf_d usrInf;
    }t_usrinf_get_ack;

//user infomation change
typedef struct usrinf_set
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    t_uInf_d usrInf;
    }t_usrinf_set;

//fellow add
typedef struct fellow_add
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    CHAR heStr[MAX_MAIL_SIZE];
	CHAR meDesc[MAX_DESC_SIZE];
    }t_fellow_add;

//fellow accept
typedef struct fellow_accept
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    unsigned int ifAgree;
    CHAR uStr[MAX_MAIL_SIZE];        
    }t_fellow_accept;

//search fellow
typedef struct fellow_search
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    unsigned int searchType;
    void *searchValue;
    unsigned int startFrom; //query reasult start pos
    unsigned int perNmb;//return number for everytime
    }t_fellow_search;

//ack for search fellow
typedef struct fellow_search_ack
    {
    t_just_validation ack;
    unsigned int perNmb;
    t_uInf_s usrInfs[MAX_DEV_RTN_NMB];
    }t_fellow_search_ack;

//get detailed infomation for fellow
typedef struct fellow_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    CHAR usrID[MAX_ID_SIZE];
    }t_fellow_get;

//get detailed infomation for fellow
typedef struct fellow_get_ack
    {
    t_just_validation ack;
    t_uInf_d1 fellowInf  ;
    }t_fellow_get_ack;


//****************user device group management***************
//get device group list
typedef struct usr_devgrp_list_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    CHAR pdgID[MAX_GID_SIZE];//parent devicegroup ID
    }t_usr_devgrp_list_get;

//ack for get device group list
typedef struct usr_devgrp_list_get_ack
    {
    t_just_validation ack;
    unsigned int perNmb;
    t_dgInf_s dgInfs[MAX_DEV_RTN_NMB];
    }t_usr_devgrp_list_get_ack;

//get detailed infomation for device group
typedef struct usr_devgrp_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    CHAR dgID[MAX_GID_SIZE];//devicegroup ID
    }t_usr_devgrp_get;

//ack for getting detailed infomation for device group
typedef struct usr_devgrp_get_ack
    {
    t_just_validation ack;
    t_dgInf_d dfInf;
    }t_usr_devgrp_get_ack;

//add devgrp
typedef struct usr_devgrp_add
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    t_dgInf_s dfInf;
    }t_usr_devgrp_add;

//add devgrp
typedef struct usr_devgrp_add_ack
    {
    t_just_validation ack;
    CHAR dgID[MAX_GID_SIZE];//devicegroup ID
    }t_usr_devgrp_add_ack;


//set detailed(add or chg) infomation for device group
typedef struct usr_devgrp_set
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    t_dgInf_d dfInf;
    }t_usr_devgrp_set;

//del devicegroup
typedef struct usr_devgrp_del
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    CHAR dgID[MAX_GID_SIZE];//devicegroup ID
    }t_usr_devgrp_del;

//*********************user-dev management****************
//get device list
typedef struct usr_dev_list_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    CHAR dgID[MAX_GID_SIZE];//devicegroup ID belong to,can be ""
    }t_usr_dev_list_get;

//ack for getting device list
typedef struct usr_dev_list_get_ack
    {
    t_just_validation ack;
    unsigned int perNmb;
    t_devInf_s devInfs[MAX_DEV_RTN_NMB];
    }t_usr_dev_list_get_ack;

//get detailed infomation of device
typedef struct usr_dev_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    CHAR dID[MAX_ID_SIZE];//devicegroup ID belong to,can be ""
    }t_usr_dev_get;

//ack for getting detailed infomation of device
typedef struct usr_dev_get_ack
    {
    t_just_validation ack;
    t_udevInf_d devInf;
    }t_usr_dev_get_ack;

//add user-dev
typedef struct usr_dev_add
    {
     CHAR sessionStr[SESSION_STR_SIZE];
      t_devInf_s devInf;
    }t_usr_dev_add;

//set (add or chg) user-dev
typedef struct usr_dev_set
    {
     CHAR sessionStr[SESSION_STR_SIZE];
      t_udevInf_d devInf;
    }t_usr_dev_set;

//del user-dev
typedef struct usr_dev_del
    {
     CHAR sessionStr[SESSION_STR_SIZE];
     CHAR devID[MAX_ID_SIZE];
    }t_usr_dev_del;

//*******************msg management************

//get msg view
typedef struct msg_view_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    }t_msg_view_get;

//ack for getting msg view
typedef struct msg_view_get_ack
    {
    t_just_validation ack;
    unsigned int unread;
    unsigned int  readed;
    unsigned int bePush;//pushed msg numb
    }t_msg_view_get_ack;

//get receved msg list
typedef struct msg_in_list_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    int msgTag; //msg type
    int msgUsedTag; //msg status
    unsigned int startFrom;//query result from pos
    unsigned int perNmb;//number for everytime
    }t_msg_in_list_get;

//ack for getting receved msg list
typedef struct msg_in_list_get_ack
    {
    t_just_validation ack;
    unsigned int perNmb;
    t_msg_s msgInfs[MAX_MSG_RTN_NMB];
    }t_msg_in_list_get_ack;

//get receved msg list
typedef struct msg_out_list_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    int msgTag; //msg type
    unsigned int startFrom;//query result from pos
    unsigned int perNmb;//number for everytime
    }t_msg_out_list_get;

//ack for getting receved msg list
typedef struct msg_out_list_get_ack
    {
    t_just_validation ack;
    unsigned int perNmb;
    t_msg_s msgInfs[MAX_MSG_RTN_NMB];
    }t_msg_out_list_get_ack;

//get detailed infomation of msg
typedef struct msg_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    unsigned int msgID;
    }t_msg_get;

//ack for getting detailed infomation of msg
typedef struct msg_get_ack
    {
    t_just_validation ack;
    t_msg_d msgInf;
    }t_msg_get_ack;

//set msg
typedef struct msg_set
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    t_msg_d msgInf;
    }t_msg_set;

//tag msg
typedef struct msg_tag
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    unsigned int msgID;
    unsigned int msgTag;//0-->unread,1-->readed,2-->del
    }t_msg_tag;

//push msg
typedef struct msg_push
    {
    CHAR fromID[MAX_ID_SIZE];
    CHAR msgTitle[MAX_MSGTITLE_SIZE];
    CHAR msgContent[MAX_MSGCONTENT_SIZE];
    }t_msg_push;

//push msg
typedef struct msg_push_ext
    {
    CHAR fromID[MAX_ID_SIZE];
	CHAR msgParam[MAX_NAME_SIZE];
    CHAR msgTitle[MAX_MSGTITLE_SIZE];
    CHAR msgContent[MAX_MSGCONTENT_SIZE];
    }t_msg_push_ext;

//************************saler management
typedef struct sdev_set{
char devID[MAX_ID_SIZE];
t_gps devGPS;
char devAddr[MAX_DESC_SIZE];
}t_sdev_set;

//get saler device list
typedef struct slr_dev_list_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    unsigned int devStatus;
    unsigned int startFrom;
    unsigned int perNmb;
    }t_slr_dev_list_get;

//ack for getting saler device list
typedef struct slr_dev_list_get_ack
    {
     t_just_validation ack;
    unsigned int perNmb;
    t_devInf_s devInfs[MAX_DEV_RTN_NMB];
    }t_slr_dev_list_get_ack;

//get detailed infomation of device
typedef struct slr_dev_get
    {
    CHAR sessionStr[SESSION_STR_SIZE];
    CHAR devID[MAX_ID_SIZE];
    }t_slr_dev_get;

//ack for getting detailed infomation of device
typedef struct slr_dev_get_ack
    {
     t_just_validation ack;
    t_sdevInf_d devInf;
    }t_slr_dev_get_ack;

//set(change) detailed infomation of device
typedef struct slr_dev_set
    {
    CHAR sessionStr[SESSION_STR_SIZE];
     t_sdevInf_d devInf;
    }t_slr_dev_set;

//*******************************************************

typedef struct usr_active_confirm_ack{t_just_validation ack;}t_usr_active_confirm_ack;
typedef struct usr_active_req_ack{t_just_validation ack;}t_usr_active_req_ack;
typedef struct usr_recovery_request_ack{t_just_validation ack;}t_usr_recovery_request_ack;


typedef struct biz_packet
	{
	int sockfd;
	struct sockaddr_in peer_addr; 
	int sin_size;
	char buff[CMD_MAX_MSG_SIZE];	 
	unsigned int buff_len;
	char *pos;
	unsigned int len;   
	t_pkt_header	header;
	struct biz_packet *next;
    struct biz_packet *pres;
	union
		{
                    t_app_lgn    appLgn;
                    t_app_lgn_ack appLgnAck;
                    t_ver_url_get    verUrlGet;
                    t_ver_url_get_ack    verUrlGetAck;
                    t_svc_list_get_ack   svcListGetAck;
                    t_billing_detail_get billingDetailGet;
                    t_billing_detail_get_ack billingDetailGetAck;
                    t_svc_detail_get svcDetailGet;
                    t_svc_detail_get_ack svcDetailGetAck;
                    t_svr_str_get    svrStrGet;
                    t_svr_str_get_ack svrStrGetAck;                                
                    t_usr_reg    usrReg;
                    t_usr_reg_ack usrRegAck;
                    t_usr_reg_ext    usrRegExt;
                    t_usr_reg_ext_ack usrRegExtAck;
					t_usr_active_req usrActiveReq;
                    t_usr_active_confirm usrActiveConfirm;//confirm
                    t_usr_active_confirm_ack usrActiveConfirmAck;
                    t_usr_recovery_request usrRecoveryRequest;
					t_usr_recovery_confirm usrRecoveryConfirm;	
					t_usr_recovery_confirm_ack usrRecoveryConfirmAck;
                    t_lgin Lgin;
					t_lgin LginExt;
                    t_olgin oLgin;
                    t_lgin_ack LginAck;
					t_lgin_ext_ack LginExtAck;//add 20141212
                    t_lgout Lgout;
					t_alive alive;
                    t_pwd_chg pwdChg;
                    t_usrinf_set usrInfSet;
                    t_usrinf_get usrInfGet;
                    t_usrinf_get_ack  usrInfGetAck;
                    t_fellow_search fellowSearch;
                    t_fellow_search_ack fellowSearchAck;
                    t_fellow_get    fellowGet;
					t_fellow_add	fellowAdd;
					t_fellow_accept fellowAccept;
                    t_fellow_get_ack    fellowGetAck;
                    t_usr_devgrp_list_get usrDevGrpListGet;
                    t_usr_devgrp_list_get_ack usrDevGrpListGetAck;
                    t_usr_devgrp_get usrDevGrpGet;
                    t_usr_devgrp_get_ack usrDevGrpGetAck;
                    t_usr_devgrp_add usrDevGrpAdd;
                    t_usr_devgrp_add_ack usrDevGrpAddAck;
                    t_usr_devgrp_set usrDevGrpSet;
                    t_usr_devgrp_del usrDevGrpDel;
                    t_usr_dev_list_get usrDevListGet;
                    t_usr_dev_list_get_ack usrDevListGetAck;
                    t_usr_dev_add usrDevAdd;
                    t_usr_dev_set usrDevSet;
                    t_usr_dev_del    usrDevDel;                
                    t_usr_dev_get    usrDevGet;
                    t_usr_dev_get_ack    usrDevGetAck;
                    t_msg_view_get msgViewGet;
                    t_msg_view_get_ack msgViewGetAck;
                    t_msg_in_list_get   msgInListGet;
                    t_msg_in_list_get_ack msgInListGetAck;
                    t_msg_out_list_get   msgOutListGet;
                    t_msg_out_list_get_ack msgOutListGetAck;                       
                    t_msg_set    msgSet;                  
                    t_msg_push    msgPush; 
					t_msg_push_ext    msgPushExt; 
                    t_msg_get    msgGet;
                    t_msg_get_ack    msgGetAck;
                    t_msg_tag    msgTag;
                    t_slr_dev_list_get  slrDevListGet;
                    t_slr_dev_list_get_ack  slrDevListGetAck;
                    t_slr_dev_get slrDevGet;
                    t_slr_dev_get_ack slrDevGetAck;
                    t_slr_dev_set slrDevSet;
                    t_just_validation    commonAck;  
                    t_sys_mgm sysMgm;
					t_sys_notify sysNotify;
					t_sys_usr_adm sysUsrAdm;
        	}u;
}t_biz_packet;


#endif

