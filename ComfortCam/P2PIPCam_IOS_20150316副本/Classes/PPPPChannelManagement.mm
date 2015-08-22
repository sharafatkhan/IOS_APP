

#include "PPPPChannelManagement.h"
//#include "libH264Dec.h"

CPPPPChannelManagement::CPPPPChannelManagement()
{
    memset(&m_PPPPChannel, 0 ,sizeof(m_PPPPChannel));
    
    m_Lock = [[NSCondition alloc] init];
    pCameraViewController = nil;
}

CPPPPChannelManagement::~CPPPPChannelManagement()
{
    StopAll();
    
    if (m_Lock != nil) {
        [m_Lock release];
        m_Lock = nil;
    }
}


int CPPPPChannelManagement::startRecordAVI(char *szDID,char *path, char *format,int width,int height){
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            
            m_PPPPChannel[i].pPPPPChannel->startRecordAVI(path, format, width, height);
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}
#pragma mark-----JPush Param
void CPPPPChannelManagement::setJPushParam(char *szDID,STRUCT_JPUSH_PARAM jpt){
    [m_Lock lock];
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            
            m_PPPPChannel[i].pPPPPChannel->setJPushParam(jpt);
        }
    }
    [m_Lock unlock];
}
void CPPPPChannelManagement::deleJPushParam(char *szDID,STRUCT_JPUSH_PARAM jpt){
    [m_Lock lock];
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            
            m_PPPPChannel[i].pPPPPChannel->deleJPushParam(jpt);
        }
    }
    [m_Lock unlock];
}
int CPPPPChannelManagement::stopRecordAVI(char *szDID){
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            
            m_PPPPChannel[i].pPPPPChannel->stopRecordAVI();
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}
int CPPPPChannelManagement::SetStatusDelegate(char *szDID, id delegate){
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->m_PPPPStatusDelegate = delegate;
            m_PPPPChannel[i].pPPPPChannel->m_CameraViewSnapshotDelegate =delegate;
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}
int CPPPPChannelManagement::Start(const char * szDID, const char *user, const char *pwd)
{ 
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->ReconnectImmediately();
            [m_Lock unlock];
            return 0;
        }
    }

    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 0)
        {
            m_PPPPChannel[i].bValid = 1;            
            strcpy(m_PPPPChannel[i].szDID, szDID);      
            CCircleBuf *pVideoBuf = new CCircleBuf();
            //pVideoBuf->Create(VBUF_SIZE);
            m_PPPPChannel[i].pVideoBuf = pVideoBuf;
            //m_PPPPChannel[i].pEglDisplay = NULL;      
            
            CCircleBuf *pPlaybackVideoBuf = new CCircleBuf();
            m_PPPPChannel[i].pPlaybackVideoBuf = pPlaybackVideoBuf;
            
            m_PPPPChannel[i].pPPPPChannel = new CPPPPChannel(pVideoBuf, pPlaybackVideoBuf, szDID, user, pwd);
            
            NSString *strServer;
            
            int ntype=getServer(szDID);
            switch (ntype) {
                case 1://丽欧
                    strServer=@"ATTDASPCSUSQAREOSTPAPESVAYLKSWPNLOPDHYHUEIASLTEETAPKAOPFLMLXLRPGSQSULNLQPAPELOLKLULP-QGTNMRBBLVTDMQIVMSIGLREGAQSSPCLMEQSZPIASLSHWPNMPFFPVBAIBEGAQSSPCLMTCELLPLXIZQMPXPMAVHWEGAQSSPCLWLNSXPGPJIHFJMGBPIGPHLMHWEGAQSSEQSUPEPKLOERBTQLTRBALRPCLMHWEGAQTCHXHYEHLTBBTVMFQBPMIBSSPCLMHWEGLWEIASLUSUTDQFMXMLIGELAQSSPCLMHWEQPEEGLOARPNMPMVMHBAAVAQSSPCLMHWTCSXSTLQLXMZMEMWPMPHEGAQSSPCLMLWLRPDLN";
                    break;
                case 2://丽欧客户瑞思哲(平台RSZ,ID前缀:RSZ)
                    strServer=@"ASTDHXEHSUSQELPAARTBSYLKSTSVLQPNPDLNPEHUAVEEHXPLPIAOEHPFSXLXARSTLOSQPHPAPDLVLSLKLNLPLR-QKQLQSPNPDLXMUMVNCPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 3://欧杰特
                    strServer=@"SVTDEHAYLOSQTBHYPAARPCPFLKLQSTPNPDTAEIHUPLASEEPIPKAOSUPESXLXPHLUSQLVLSPALNLTLRLKLOLMLP-QHPUQCBBLVTDMRMEMMIGAVLMHWEGAQSSEQLNPCLMHWEGPNUBBPTYBAHXAQSSPCLMHWTCLQLOPJEGAQLXPXQLQGPMEHSSPCLMHWEGLWSXAQLTLPIHMPMHMJIGARSSPCLMHWEGEQSTAQSSERNCMOBKBAPDPCLMHWEGAQTCLNSSPCBBQIMQMSPMHXLMHWEGAQSSLWEHPCLMTDMXTRTMIGPHHWEGAQSSPCEQARLMHWPNMDQBPWBALREGAQSSPCLMTCSTHWEGLXMVMLMGPMPDAQSSPCLWLNLM";
                    break;
                case 4://大方AJT
                    strServer=@"ATTDSXIASQSUSTEKPASVAZLKTAPCPNPHAUHUPEPDSWEEPFTBAOPKLULXLRPGSQLOLNLQPALPPLLKLVLM-PTQCFQIHIBERMKTMCABAELSSPCLMHWEGTCLOAQSVBBPWPYUCPMAVSSPCLMHWEGLWEHAQPFTDMDMMQMIGSXSSPCLMHWEGEQARAQSTSSLPPNMUMWMSBAPHPCLMHWEGAQTCPDSSPCLXMGMINCPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 5://大方PIX
                    strServer=@"EJTDAVAUSQLOHYPDPAEISWPCLKLNPLHXPNSXPGHUASEHPHEEARATSVAOSUPFLULXLRLQSQPELOLVPASTLPPDLKLNLM-TYTRQQTDLOPNQIQBNABAPHPCLMHWEGAQTCSTSSPDPCLPLXMLMSMFPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 6://大方MHK
                    strServer=@"ATTDLREKSQEIIBELPAHXAUASLKSUPESVPNAVSWHUEHPLPFEELVLMAOARLPSTLXSXPGSQPKPHPAPDLULOLKLNLQLR-QFQAQDTDLOPNMPMKMNBAPHPCLMHWEGAQTCPDSSPCLXMHMSMFPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 7://凯普特CPTCAM
                    strServer=@"LPTDAVIASQLOSTEKPAHYSSLKSYPIPNSXAUHUEIPDSWEEASPCAOPHLVLXLRPGSQSULNLQPAPELMLKLSLO-BJBWQMTDLOPNTLTYMWPVPTQFBAPHPCLMHWEGAQTCPDSSPCPFLXQIMLMSMFMDMPPMLRLMHWEGAQSSLWLNPCLMLP";
                    break;
                case 8://河北电信HRXJ
                    strServer=@"ATTDSUHXTBSQEHSWTAPAAVLKSVSXPNPEARPLHUSTPGPKEEPHAOPFLSLXLOPDLVSQLNLQLUPALRLKLPLT-QAQKQQQCPNPDLXMKMUNAMMPMPHEGAQSSPCLMLWLRLPLNLQ";
                    break;
                case 9://普顺达(平台PSD,ID前缀:PSD)
                    strServer=@"EJTDICSTSQPDPGATPALNEMLMLKHXTASVPNAWSZHUEHPLPKEEARSYLOAOSTLVLULXLQPISQPFPJPAPDLSLRLKLNLPLT-QIQLPWPNLNLXMSMVMGPMLREGAQSSPCLMLWLSPELTLOLP";
                    break;
                case 10://普顺达客户(平台JDF,ID前缀:JDF)
                    strServer=@"PFTDIBTASQLNSZPAHXLOELLKHYSSEHPNAVPKHUARPJEESTEISXAOASPCSULXPHLUSQPDLTPALNPELRLKLOLMLP-QCPWPYPNPDLXMMMGMIPMLRLMHWEGAQSSLWLNPCLMLP";
                    break;
                case 11://施瑞安(平台MEYE,ID前缀:MEYE)
            strServer=@"EJTDLOATSQHYLNPAEIHXPJLKEHLTLUPNAVPGHUASSXAREESTPILSAOPDSVPFLXPHLQSQSUPELVPALPLMLKLOLNLR-QFBLQRTNPNLNLXMPPXNBMHPMSXEGAQSSPCLMLWPHLSLRLP";
                    break;
                case 12://兴华安客户(平台MIL,ID前缀:MIL)
                    strServer=@"SVTDLRSWSQSUIBPEPAHXAYLMLKEHTAARPNELPGHULOPFAVEESTSXPKAOHYEIPDLXPHLQSQASLPSUPAPELOLSLKLNLRLU-QFQBQEPNLNLXMPMLMOPMLRLMHWEGAQSSLWLOPCLMLP";
                    break;
                case 13://兴华安(平台WNS,ID前缀:JWEV,WNSC,TSD,OPCS)
                    strServer=@"SVTDIBEKSQEIAUPFPALVPJLKASPCSYPNELSWHUSUAVHXEEEHARLPAOPESXSTLXPHPGSQLOLQPIPAPDLMLTLKLNLSLR-UFQGFPIHLRERQPMQBZPVBAIBHWEGAQSSPCTCSTLMHWEGBBMMMZMHMYPMELAQSSPCLMHWLWPDSVLTPFAVEGTDMWUBMGIGSXAQSSPCLMHWEQPHEGAQPNQHQIMFQLBALRSSPCLMHWEGTCLPAQSSPCLXMRMSMPMVPMLOLMHWEGAQSSLWLNPCLM";
                    break;
                case 14://艾赛德(平台EST,ID前缀:EST,CTW)
                    strServer=@"PFTDSTAXSWSQPDASEPPASUPELULKLNSZLPPNHXPJPGHUEHLOAZEEHYEITBAOARLMASLXSTLTLQSQPDSUPLPAPELOLVLKLNLR-PXQLUCBBPFTDMHMVQMIGSXSSPCLMHWEGEQSTLOAQSSPCPNPVMWMZBAPHLMHWEGAQSSTCPDLSPCLPLXMQMSMFPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 15://恩讯(平台PAR,ID前缀:DYNE,PAR,PARC)
                    strServer=@"LPTDHXEKSQHZEHPAARAVLKSTEJAUPNPDSWHUATLNEEHXSXAOEHSVPGLXARLQSQPFSTPAPDPHLKLNLPLR-TYTJUABBLPTDMGNBMQMHIGSXSSPCLMHWEGEQPJAQSSPCPNQIPTQKBAPHLMHWEGAQSSTCPEPCLMLXMSMDMUMFPMLRHWEGAQSSPCLWPDLNLTLOLM";
                    break;
                case 16://宏天顺(平台HTS,ID前缀:HTS)
                    strServer=@"SVTDPDLNPHSQEITAPAHXPFASLKSWPNEHARLRHUSUPKEESTLPPEAOPGLXLQLOSQLVPIPAPDLSPCLKLNLULM-QAQMQLPNPDLXMKMWMVPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 17://腾威视(平台TWS,ID前缀:TWS)
                    strServer=@"SVTDPDLNPHSQEITAPAHXPFASLKSWPNEHARLRHUSUPKEESTLPPEAOPGLXLQLOSQLVPIPAPDLSPCLKLNLULM-QAQMQLPNPDLXMKMWMVPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 18://新讯康(平台XXC,ID前缀:XXC)
                    strServer=@"PFTDELEKSQLOAVHYPAEIHXASLKSYPCPNSXAUHUSUSWPIEEPELPEHAOARPGLULXPHLQSQLOSTLRPAPDLVLMLKLNLSLT-CEUGPVPNARLXQQNAMFPMLRHWEGAQSSPCLWSTPDLNLMLP";
                    break;
                case 19://依罗科技(平台PTP,ID前缀:PTP)
                    strServer=@"PFTDLREKSQHYEILVPAPDSYLNLKHXIBLTPNELAUHUASEHAVEESUARSWAOPELPLMLXSXPGSQLOPHLQPASTLRPILKPDLNLS-BWQMTYPNLNLXQIMWMSPMLREGAQSSPCLMLWLQLTLP";
                    break;
                case 20://浩威康(平台HVC,ID前缀:HVC)
                    strServer=@"PFTDSXSWSQSZEIPAASPCLKLNAYHXPNPHPGHUEHTAPJEESUARAOSTLPPKLXLRLQSQLTPEPALOLMLKPDLULN-QAQOPVPNPDLXMKMYMFPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 21://网通达(平台WTD,ID前缀:WTD)
                    strServer=@"ATTDHXSUIASQPESVLOPAEHEKTALKSZPNARHYAUHUEIPFASEESTSWPKAOPJLXPDSUPGSQPELPLOPALNLQLULKLT-QPQMPWPNPDLXMZMWMGPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 22://高斯贝尔(平台GOS,ID前缀:GOS)
                    strServer=@"LPTDSXSWSQLOPGLQPAHYPHLRLKSTPITAPNIBIAHUEIEKAUEEASELAVAOSUPDPKLXSXSWSQPEPGLQPALOPHLRLKLNLSLU-PZQHQLPNPDLXMJMRMVPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 23://韩国NETTOP(平台NTP,ID前缀:NTP)
                    strServer=@"HZTDHYSTTASQSXSWPAEJEGLKEIAQPJPNASPDPKHUPHPGEEATSSAOSUSVPFLXPELNLUSQLRLQPALPPCLKLOLMLT-QGQMQIPNPDLXMQMWMSPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 24://合帮(平台ZEO,ID前缀:ZEO)
                     strServer=@"ATTDSXLQSQEIIAAZPAASPKLKARSVPCPNPHEKHUSTTBPLEESUAUPFAOPDLSSWLXLRPGSQPELQLVPALOLULKLNLPLM-QSPXQHPNPDLXNCMHMRPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 25://艾伟特(平台IVT,ID前缀:IVT)
                    strServer=@"PFTDAUPESQEMLOPASXPKLKHYSTAWPNSWEIHUSYASEEPGPDAOLPPHLXLQSUSQPIPEPALRLULKLOLNLS-$$";
                    break;
                case 26://科立信(平台KLX,ID前缀:KSC)
                    strServer=@"SVTDSXSWSQPELNTBPAHXLSLOLKEHARSTPNPHPGHUPDPLPFEELNHXAOEHPJPCLXLRLQSQARLVLPPASTPDLKLNLTLM-QDMONAPNPDLXMNMVMFPMLRLMHWEGAQSSLWLNPCLM";
                    break;
                case 27://亚高斯(平台YGS,ID前缀:CAM)
                    strServer=@"LPTDSXSWSQLNSZAYPAHYHXSYLKEIEHLVPNPHPGHUARTAPJEESTPKPIAOPDASLMLXLRLQSQLTLSPASUPELKLOLNLU-$$";
                    break;
                case 28://东方郎云(平台ANY,ID前缀：ANY)
                    strServer=@"PFTDASEHARSQSTLQTBPAPDSXIALKLNEKLTPNSUHXEHHUARAUPLEESTPHSWAOPDPGPILXLRLQSQPELNLPPALVLSLKLOLMLU-$$";
                    break;
                case 29://新讯康客户PPF（平台PPF,ID前缀：PPF）
                    strServer=@"EJTDHXEHSSSQARSZPCPASTTBLMLKSUATPIPNPDLNHWHUHXPJEGEEEHPLAQAOPESVPFLXARSTSSSQPDLTPCPALNLVLMLKLOLPLS-$$";
                    break;
                case 30://HZD---平台(OBJ)
                    strServer=@"SVLXLRLQLKSTLUPFHUIAPLEELVLPIHIBIEAOIFEMSQPDENELPALOHWHZERLNEOHYLKEPEIHUHXEGEJEEEKEH-$$";
                    break;
                case 31:
                    strServer=@"ATTDASPCSUSQAREOSTPAPESVAYLKSWPNLOPDHYHUEIASLTEETAPKAOPFLMLXLRPGSQSULNLQPAPELOLKLULP-$$";
                    break;
                default:
                    strServer=@"SVTDEHAYLOSQTBHYPAARPCPFLKLQSTPNPDTAEIHUPLASEEPIPKAOSUPESXLXPHLUSQLVLSPALNLTLRLKLOLMLP-$$";
                    break;
            }
            
            
            m_PPPPChannel[i].pPPPPChannel->SetServer(strServer);
            m_PPPPChannel[i].pPPPPChannel->m_PPPPStatusDelegate = pCameraViewController;
            m_PPPPChannel[i].pPPPPChannel->m_CameraViewSnapshotDelegate = pCameraViewController;
            m_PPPPChannel[i].pPPPPChannel->Start();
            NSLog(@"CPPPPChannelManagement::Start....");
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}
int CPPPPChannelManagement::getServer(const char *szDID){
    NSString *strDid=[[NSString stringWithUTF8String:szDID] uppercaseString];
//    NSMutableString *strDid=[NSMutableString stringWithString:str];
//    NSCharacterSet* set=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//    NSRange range=[strDid rangeOfCharacterFromSet:set];
//    [strDid insertString:@"-" atIndex:range.location];
//    range= [strDid rangeOfCharacterFromSet:set options:NSBackwardsSearch];
//    [strDid insertString:@"-" atIndex:range.location+1];
    
    NSLog(@"============getServer......strDid=%@",strDid);
    if ([strDid hasPrefix:@"NIP"]||[strDid hasPrefix:@"MCI"]||[strDid hasPrefix:@"MSE"]||[strDid hasPrefix:@"MDI"]||[strDid hasPrefix:@"MIC"]||[strDid hasPrefix:@"MSI"]||[strDid hasPrefix:@"MTE"]||[strDid hasPrefix:@"MUI"]||[strDid hasPrefix:@"WBT"]) {
        return 1;//丽欧
    }else if ([strDid hasPrefix:@"RSZ"]) {
        return 2;//丽欧客户瑞思哲(平台RSZ,ID前缀:RSZ)
    }else if ([strDid hasPrefix:@"OBJ"]||[strDid hasPrefix:@"SIP"]||[strDid hasPrefix:@"ESN"]||[strDid hasPrefix:@"ZLD"]||[strDid hasPrefix:@"AID"]||[strDid hasPrefix:@"UID"]||[strDid hasPrefix:@"SID"]||[strDid hasPrefix:@"PNP"]||[strDid hasPrefix:@"MEG"]) {
        return 3;//ojt
    }else if ([strDid hasPrefix:@"HDT"]||[strDid hasPrefix:@"DFT"]||[strDid hasPrefix:@"AJT"]||[strDid hasPrefix:@"DFZ"]) {
        return 4;//大方通信(平台AJT
    }else if ([strDid hasPrefix:@"PIX"]||[strDid hasPrefix:@"IPC"]) {
        return 5;//大方通信(平台PIX,ID前缀:PIX,IPC)
    }else if ([strDid hasPrefix:@"MHK"]||[strDid hasPrefix:@"EPC"]) {
        return 6;//大方(平台MHK,ID前缀:MHK,EPC)
    }else if ([strDid hasPrefix:@"CPTCAM"]||[strDid hasPrefix:@"PIPCAM"]) {
        return 7;//凯普特CPTCAM
    }else if ([strDid hasPrefix:@"HRXJ"]) {
        return 8;//河北电信HRXJ
    }else if ([strDid hasPrefix:@"PSD"]) {
        return 9;//普顺达(平台PSD,ID前缀:PSD)
    }else if ([strDid hasPrefix:@"JDF"]) {
        return 10;//普顺达客户(平台JDF,ID前缀:JDF)
    }else if ([strDid hasPrefix:@"MEYE"]) {
        return 11;//施瑞安(平台MEYE,ID前缀:MEYE)
    }else if ( [strDid hasPrefix:@"MIL"]) {
        return 12;//兴华安客户(平台MIL,ID前缀:MIL)
    }else if ([strDid hasPrefix:@"JWEV"]||[strDid hasPrefix:@"WNSC"]||[strDid hasPrefix:@"TSD"]||[strDid hasPrefix:@"OPCS"]) {
        return 13;//兴华安(平台WNS,ID前缀:JWEV,WNSC,TSD,OPCS)
    }else if ([strDid hasPrefix:@"EST"]||[strDid hasPrefix:@"CTW"]||[strDid hasPrefix:@"NPC"]) {
        return 14;//艾赛德(平台EST,ID前缀:EST,CTW)
    }else if ( [strDid hasPrefix:@"DYNE"]||[strDid hasPrefix:@"PAR"]||[strDid hasPrefix:@"PARC"]) {
        return 15;//恩讯(平台PAR,ID前缀:DYNE,PAR,PARC)
    }else if ([strDid hasPrefix:@"HTS"]) {
        return 16;//宏天顺(平台HTS,ID前缀:HTS)
    }else if ( [strDid hasPrefix:@"TWS"]) {
        return 17;//腾威视(平台TWS,ID前缀:TWS)
    }else if ([strDid hasPrefix:@"XXC"]) {
        return 18;//新讯康(平台XXC,ID前缀:XXC)
    }else if ([strDid hasPrefix:@"PTP"]) {
        return 19;//依罗科技(平台PTP,ID前缀:PTP)
    }else if ([strDid hasPrefix:@"HVC"]) {
        return 20;//浩威康(平台HVC,ID前缀:HVC)
    }else if ([strDid hasPrefix:@"WTD"]) {
        return 21;//网通达(平台WTD,ID前缀:WTD)
    }else if ([strDid hasPrefix:@"GOS"]) {
        return 22;//高斯贝尔(平台GOS,ID前缀:GOS)
    }else if ([strDid hasPrefix:@"NTP"]) {
        return 23;//韩国NETTOP(平台NTP,ID前缀:NTP)
    }else if ([strDid hasPrefix:@"ZEO"]) {
        return 24;//合帮(平台ZEO,ID前缀:ZEO)
    }else if ([strDid hasPrefix:@"IVT"]) {
        return 25;//艾伟特(平台IVT,ID前缀:IVT)
    }else if ([strDid hasPrefix:@"KSC"]) {
        return 26;//科立信(平台KLX,ID前缀:KSC)
    }else if ([strDid hasPrefix:@"CAM"]) {
        return 27;//亚高斯(平台YGS,ID前缀:CAM)
    }else if ([strDid hasPrefix:@"ANY"]) {
        return 28;//东方郎云(平台ANY,ID前缀：ANY)
    }else if ([strDid hasPrefix:@"PPF"]) {
        return 29;//新讯康客户PPF（平台PPF,ID前缀：PPF）
    }else if([strDid hasPrefix:@"ESS"]||[strDid hasPrefix:@"HZD"]){
        return 30;//汇众达
    }else if ([strDid hasPrefix:@"MCIHD"]||[strDid hasPrefix:@"MDIHD"]||[strDid hasPrefix:@"MICHD"]||[strDid hasPrefix:@"MSEHD"]||[strDid hasPrefix:@"MSIHD"]||[strDid hasPrefix:@"MTEHD"]||[strDid hasPrefix:@"MUIHD"]||[strDid hasPrefix:@"NIPHD"]||[strDid hasPrefix:@"WBTHD"]) {
        return 31;//丽欧客户瑞思哲(平台RSZ,ID前缀:RSZ)
    }
    
    return 3;
    
}
int CPPPPChannelManagement::Stop(const char * szDID)
{
    [m_Lock lock];

    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetStop();
            memset(m_PPPPChannel[i].szDID, 0, sizeof(m_PPPPChannel[i].szDID));
            SAFE_DELETE(m_PPPPChannel[i].pPPPPChannel);       
            SAFE_DELETE(m_PPPPChannel[i].pVideoBuf);
            //SAFE_DELETE(m_PPPPChannel[i].pEglDisplay);  
            SAFE_DELETE(m_PPPPChannel[i].pPlaybackVideoBuf);
            m_PPPPChannel[i].bValid = 0;
            
            [m_Lock unlock];
            
            return 1;
        }
    }  
    
    [m_Lock unlock];
    
    return 0;
}

void CPPPPChannelManagement::StopAll()
{    
    [m_Lock lock];
    
    NSLog(@"StopAll begin....");
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1)
        {
            m_PPPPChannel[i].pPPPPChannel->SetStop();
        }
    }  
    
//  NSLog(@"StopAll 1111111");
    
    PPPP_Connect_Break();

    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1)
        {
//          NSLog(@"StopAll  channel: %d", i);
            memset(m_PPPPChannel[i].szDID, 0, sizeof(m_PPPPChannel[i].szDID));
            SAFE_DELETE(m_PPPPChannel[i].pPPPPChannel);          
            SAFE_DELETE(m_PPPPChannel[i].pVideoBuf);
            //SAFE_DELETE(m_PPPPChannel[i].pEglDisplay);            
            m_PPPPChannel[i].bValid = 0;
        }
    }  
    
    //NSLog(@"StopAll end...");
    [m_Lock unlock];
}

int CPPPPChannelManagement::StartPPPPAudio(const char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            NSLog(@"CPPPPChannelManagement  StartPPPPAudio");
            int nRet = m_PPPPChannel[i].pPPPPChannel->StartAudio(); 
            [m_Lock unlock];            
            return nRet;          
        }
    }  
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::StopPPPPAudio(const char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            int nRet = m_PPPPChannel[i].pPPPPChannel->StopAudio(); 
            [m_Lock unlock];            
            return nRet;          
        }
    }  
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::StartPPPPTalk(const char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            int nRet = m_PPPPChannel[i].pPPPPChannel->StartTalk(); 
            [m_Lock unlock];            
            return nRet;          
        }
    }  
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::StopPPPPTalk(const char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            int nRet = m_PPPPChannel[i].pPPPPChannel->StopTalk(); 
            [m_Lock unlock];            
            return nRet;          
        }
    }  
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::TalkAudioData(const char *szDID, const char *data, int len)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            int nRet = m_PPPPChannel[i].pPPPPChannel->TalkAudioData(data, len); 
            [m_Lock unlock];            
            return nRet;          
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::StartPPPPLivestream(const char * szDID, int streamid, id delegate)
{
    [m_Lock lock];

    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {   
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewPPPPStatusDelegate(delegate);
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewParamNotifyDelegate(delegate);
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewImageNotifyDelegate(delegate);
            int nRet = m_PPPPChannel[i].pPPPPChannel->cgi_livestream(1, streamid); 
            [m_Lock unlock];            
            return nRet;          
        }
    }  
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::StopPPPPLivestream(const char * szDID)
{ 
    [m_Lock lock];

    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewPPPPStatusDelegate(nil);
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewParamNotifyDelegate(nil);
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewImageNotifyDelegate(nil);
            m_PPPPChannel[i].pPPPPChannel->cgi_livestream(0, 16);
            [m_Lock unlock];
            return 1;
        }
    }  
   
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::GetCGI(const char* szDID, int cgi)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {            
            m_PPPPChannel[i].pPPPPChannel->get_cgi(cgi);
            [m_Lock unlock];
            return 1;
        }
    }  
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::PTZ_Control(const char *szDID, int command)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {            
            m_PPPPChannel[i].pPPPPChannel->PTZ_Control(command);
            [m_Lock unlock];
            return 1;
        }
    }  
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::CameraControl(const char *szDID, int param, int value)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {            
            m_PPPPChannel[i].pPPPPChannel->CameraControl(param, value);
            [m_Lock unlock];
            return 1;
        }
    }  
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::Snapshot(const char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {            
            m_PPPPChannel[i].pPPPPChannel->Snapshot();
            [m_Lock unlock];
            return 1;
        }
    }  
    
    [m_Lock unlock];
    return 0;
}

void CPPPPChannelManagement::SetPlaybackDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetPlaybackDelegate(delegate);
            [m_Lock unlock];
            return ;
        }
    }
    
    [m_Lock unlock];
    return ;
}

int CPPPPChannelManagement::PPPPStartPlayback(char *szDID, char *szFileName, int offset)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            if(1 == m_PPPPChannel[i].pPPPPChannel->StartPlayback(szFileName, offset))
            {
                [m_Lock unlock];
                return 1;
            }
            else
            {
                [m_Lock unlock];
                return 0;
            }
        }
    } 
    
    [m_Lock unlock];
    return 0;
    
}

int CPPPPChannelManagement::PPPPGetSDCardRecordFileList(char *szDID, int pageTime, int pageIndex, int pageSize)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            STRU_SEARCH_SDCARD_RECORD_FILE sdcardsearch;
            memset(&sdcardsearch, 0, sizeof(sdcardsearch));
            sdcardsearch.pageIndex = pageIndex;
            sdcardsearch.pageSize = pageSize;
            sdcardsearch.pagetime=pageTime;
            if(1 == m_PPPPChannel[i].pPPPPChannel->SetSystemParams(MSG_TYPE_GET_RECORD_FILE, (char*)&sdcardsearch, sizeof(sdcardsearch)))
            {
                [m_Lock unlock];
                return 1;
            }
            else
            {
                [m_Lock unlock];
                return 0;
            }
        }
    } 
    
    [m_Lock unlock];
    return 0;
    
}

int CPPPPChannelManagement::PPPPStopPlayback(char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            if(1 == m_PPPPChannel[i].pPPPPChannel->StopPlayback())
            {
                [m_Lock unlock];
                return 1;
            }
            else
            {
                [m_Lock unlock];
                return 0;
            }
        }
    } 
    [m_Lock unlock];
    return 0;
    
}

int CPPPPChannelManagement::PPPPSetSystemParams(char * szDID,int type,char * msg,int len)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            //NSLog(@"PPPPSetSystemParams  7777");
            if(1 == m_PPPPChannel[i].pPPPPChannel->SetSystemParams(type, msg, len))
            {
                //NSLog(@"PPPPSetSystemParams  66666");
                [m_Lock unlock];
                return 1;
            }
            else
            {
                [m_Lock unlock];
                return 0;
            }
        }
    } 
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetWifiParamDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetWifiParamsDelegate(delegate);        
            [m_Lock unlock];
            return 1;
        
        }
    } 
    
    [m_Lock unlock];
    return 0;
}
int CPPPPChannelManagement::SetResultDelegate(char *szDID, id delegate){
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetResultDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetAlarmLogsDelegate(char *szDID, id delegate){
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetAlarmLogsDelegate(delegate);
           
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
    
   
}
int CPPPPChannelManagement::SetWifi(char *szDID, int enable, char *szSSID, int channel, int mode, int authtype, int encrypt, int keyformat, int defkey, char *strKey1, char *strKey2, char *strKey3, char *strKey4, int key1_bits, int key2_bits, int key3_bits, int key4_bits, char *wpa_psk)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
         int nResult=m_PPPPChannel[i].pPPPPChannel->SetWifi(enable, szSSID, channel, mode, authtype, encrypt, keyformat, defkey, strKey1, strKey2, strKey3, strKey4, key1_bits, key2_bits, key3_bits, key4_bits, wpa_psk);
            [m_Lock unlock];
            NSLog(@"wifi..nResult=%d",nResult);
            return nResult;
            
        }
    } 
    
    [m_Lock unlock];
    return 0;
}



int CPPPPChannelManagement::SetUserPwdParamDelegate(char *szDID, id delegate)
{
   // NSLog(@"SetUserPwdParamDelegate 999");
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetUserPwdParamsDelegate(delegate);
          //  NSLog(@"SetUserPwdParamDelegate 1010");
            [m_Lock unlock];
            return 1;
            
        }
    } 
    
    [m_Lock unlock];
    return 0;
}
int CPPPPChannelManagement::SetUserPwd(char *szDID,char *user1,char *pwd1,char *user2,char *pwd2,char *user3,char *pwd3)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetUserPwd(user1, pwd1, user2, pwd2, user3, pwd3);
            [m_Lock unlock];
            return 1;
            
        }
    } 
    
    [m_Lock unlock];
    return 0;
}


int CPPPPChannelManagement::SetDateTimeDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetDateTimeParamsDelegate(delegate);        
            [m_Lock unlock];
            return 1;
            
        }
    } 
    
    [m_Lock unlock];
    return 0;
}
int CPPPPChannelManagement::SetDateTime(char *szDID,int now,int tz,int ntp_enable,char *ntp_svr,int xialishi)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetDateTime(now, tz, ntp_enable, ntp_svr,xialishi);
            [m_Lock unlock];
            return 1;
            
        }
    } 
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetAlarmDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetAlarmParamsDelegate(delegate);        
            [m_Lock unlock];
            return 1;
            
        }
    } 
    
    [m_Lock unlock];
    return 0;
}
int CPPPPChannelManagement::SetSDCardOver(char *szDID,int over){
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetSDcardOver(over);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
    
}
int CPPPPChannelManagement::SetSDCardSearchDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetSDCardSearchDelegate(delegate);        
            [m_Lock unlock];
            return 1;
            
        }
    } 
    
    [m_Lock unlock];
    return 0;
}


int CPPPPChannelManagement::SetMailDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetMailDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetMail(char *szDID, char *sender, char *smtp_svr, int smtp_port, int ssl, int auth, char *user, char *pwd, char *recv1, char *recv2, char *recv3, char *recv4)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
           int result= m_PPPPChannel[i].pPPPPChannel->SetMail(sender, smtp_svr, smtp_port, ssl, auth, user, pwd, recv1, recv2, recv3, recv4);
            [m_Lock unlock];
            return result;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}


int CPPPPChannelManagement::SetFTPDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetFtpDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetFTP(char *szDID, char *szSvr, char *szUser, char *szPwd, char *dir, int port, int uploadinterval, int mode)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetFtp(szSvr, szUser, szPwd, dir, port, uploadinterval, mode);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
    
}
int CPPPPChannelManagement::SetPlayAlarm(char *szDID,int motion_armed,int input_armed){
    [m_Lock lock];
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetPlayAlarm(motion_armed, input_armed);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}
int CPPPPChannelManagement::SetAlarm(char *szDID,    
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
                                     int enable_alarm_audio)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetAlarm(motion_armed, motion_sensitivity, input_armed,  ioin_level, alarmpresetsit, iolinkage, ioout_level, mail,upload_interval,record,enable_alarm_audio);
            [m_Lock unlock];
            return 1;
            
        }
    } 
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetSDcardScheduleDelegate(char *szDID, id delegate){
    [m_Lock lock];
   // NSLog(@"CPPPPChannelManagement::SetSDcardScheduleDelegate---11");
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
           // NSLog(@"CPPPPChannelManagement::SetSDcardScheduleDelegate---222");
            m_PPPPChannel[i].pPPPPChannel->SetSDCardScheduleDelegate(delegate);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return  0;
}

int CPPPPChannelManagement::SetSDcardScheduleParams(char *szDID,
                                                    int cover_enable,
                                                    int timeLength,
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
                                                    int record_schedule_sat_2){
    [m_Lock lock];
    for (int i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID,szDID)==0) {
           int result= m_PPPPChannel[i].pPPPPChannel->SetSDCardScheduleParams(
                                                                   cover_enable,
                                                                   timeLength,
                                                                   fixed_enable,
                                                                   enable_record_audio,
                                                                   record_schedule_sun_0,
                                                                   record_schedule_sun_1,
                                                                   record_schedule_sun_2,
                                                                   record_schedule_mon_0,
                                                                   record_schedule_mon_1,
                                                                   record_schedule_mon_2,
                                                                   record_schedule_tue_0,
                                                                   record_schedule_tue_1,
                                                                   record_schedule_tue_2,
                                                                   record_schedule_wed_0,
                                                                   record_schedule_wed_1,
                                                                   record_schedule_wed_2,
                                                                   record_schedule_thu_0,
                                                                   record_schedule_thu_1,
                                                                   record_schedule_thu_2,
                                                                   record_schedule_fri_0,
                                                                   record_schedule_fri_1,
                                                                   record_schedule_fri_2,
                                                                   record_schedule_sat_0,
                                                                   record_schedule_sat_1,
                                                                   record_schedule_sat_2);
            [m_Lock unlock];
            return result;
        }
    }
    [m_Lock unlock];
    return 0;
}

