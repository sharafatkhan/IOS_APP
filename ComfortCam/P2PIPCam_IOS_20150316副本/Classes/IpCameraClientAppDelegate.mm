//
//  IpCameraClientAppDelegate.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "IpCameraClientAppDelegate.h"
#import "obj_common.h"
#import "CameraViewController.h"
#import "MyTabBarViewController.h"
#import "AboutViewController.h"
#import "libH264Dec.h"
#import "Biz_API.h"
#import "KGStatusBar.h"
#import "KXToast.h"

@implementation IpCameraClientAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize startViewController;
@synthesize playViewController;
@synthesize playbackViewController;
@synthesize remotePlaybackViewController;
@synthesize myTabViewController;
@synthesize moreViewPlayProtocol;
@synthesize isOnPlayView;
@synthesize fourViewController;
#pragma mark -
#pragma mark Application lifecycle
NSUncaughtExceptionHandler* _uncaughtExceptionHandler = nil;
void UncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // 异常的堆栈信息
    
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    
    NSString *reason = [exception reason];
    
    // 异常名称
    
    NSString *name = [exception name];
    
    NSString *syserror = [NSString stringWithFormat:@"mailto:760814841@qq.com?subject=bug报告&body=感谢您的配合!<br><br><br>"
                          
                          "Error Detail:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                          
                          name,reason,[stackArray componentsJoinedByString:@"<br>"]];
    NSURL *url = [NSURL URLWithString:[syserror stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [[UIApplication sharedApplication] openURL:url];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
     NSLog(@"=======didFinishLaunchingWithOptions...start");
   // 处理其他应用调用该应用的URL
    NSURL *url=[launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (url) {
        if ([[url scheme] isEqualToString:@"objectp2pipcam"]) {
            NSLog(@"处理连接。。");
        }
    }
    isBizInitSuccess=NO;
    isFirstStartApp=YES;
    
    NSString*strServer=@"EJTDICSTSQPDPGATPALNEMLMLKHXTASVPNAWSZHUEHPLPKEEARSYLOAOSTLVLULXLQPISQPFPJPAPDLSLRLKLNLPLT-QIQLPWPNLNLXMSMVMGPMLREGAQSSPCLMLWLSPELTLOLP";
    
    NSLog(@"strServer=%@",strServer);
    NSLog(@"===============P2PVersion=%0x============",PPPP_GetAPIVersion());
    PPPP_Initialize((CHAR*)"SVTDIBEKSQEIAUPFPALVPJLKASPCSYPNELSWHUSUAVHXEEEHARLPAOPESXSTLXPHPGSQLOLQPIPAPDLMLTLKLNLSLR-UFQGFPIHLRERQPMQBZPVBAIBHWEGAQSSPCTCSTLMHWEGBBMMMZMHMYPMELAQSSPCLMHWLWPDSVLTPFAVEGTDMWUBMGIGSXAQSSPCLMHWEQPHEGAQPNQHQIMFQLBALRSSPCLMHWEGTCLPAQSSPCLXMRMSMPMVPMLOLMHWEGAQSSLWLNPCLM");
    
    //hide the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    BOOL isIPad=NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        startViewController = [[StartViewController alloc] initWithNibName:@"StartView" bundle:nil];
        
    }else{
        startViewController = [[StartViewController alloc] initWithNibName:@"StartView_Ipad" bundle:nil];
        isIPad=YES;
    }
    m_pCameraListMgt = [[CameraListMgt alloc] init];
    [m_pCameraListMgt selectP2PAll:YES];
    m_pPicPathMgt = [[PicPathManagement alloc] init];
    m_pRecPathMgt = [[RecPathManagement alloc] init];
    m_pPPPPChannelMgt = new CPPPPChannelManagement();
    picViewController = [[PictureViewController alloc] init];
    picViewController.m_pCameraListMgt = m_pCameraListMgt;
    picViewController.m_pPicPathMgt = m_pPicPathMgt;
    picViewController.isP2P=YES;
    recViewController = [[RecordViewController alloc] init];
    recViewController.m_pCameraListMgt = m_pCameraListMgt;
    recViewController.m_pRecPathMgt = m_pRecPathMgt;
    recViewController.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
    recViewController.isP2P=YES;
    
    alarmViewController=[[AlarmViewController alloc]init];
    alarmViewController.pPPPPChannelMgt=m_pPPPPChannelMgt;
    alarmViewController.m_pCameraListMgt=m_pCameraListMgt;
    
    cameraViewController = [[CameraViewController alloc] init];
    cameraViewController.cameraListMgt = m_pCameraListMgt;
    cameraViewController.m_pPicPathMgt = m_pPicPathMgt;
    cameraViewController.m_pRecPathMgt = m_pRecPathMgt;
    cameraViewController.PicNotifyEventDelegate = picViewController;
    cameraViewController.RecordNotifyEventDelegate = recViewController;
    cameraViewController.alarmNotifyEventDelegate=alarmViewController;
    cameraViewController.pPPPPChannelMgt = m_pPPPPChannelMgt;
    cameraViewController.isP2P=YES;
    cameraViewController.picViewController=picViewController;
    cameraViewController.recViewController=recViewController;

    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    aboutViewController.cameraListMgt=m_pCameraListMgt;
    myTabViewController = [[MyTabBarViewController alloc] init];

    myTabViewController.viewControllers = [NSArray arrayWithObjects:cameraViewController, alarmViewController,picViewController, recViewController, aboutViewController, nil];
    if (isIPad) {
        [[myTabViewController tabBar] setBackgroundImage:[UIImage imageNamed:@"bottom_ipad.png"]];
    }else{
        [[myTabViewController tabBar] setBackgroundImage:[UIImage imageNamed:@"bottom.png"]];
    }
    
    navigationController = [[KXNavViewController alloc] initWithRootViewController:myTabViewController];
    [aboutViewController release];
    
    
    //show the start view
    //self.window.rootViewController=startViewController;
    [self.window addSubview:startViewController.view];
    [self.window makeKeyAndVisible];
 
    
    [NSThread detachNewThreadSelector:@selector(StartThread:) toTarget:self withObject:nil];
    
    //JPush
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushRegisterNotification:) name:kJPFNetworkDidRegisterNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushLoginNotification:) name:kJPFNetworkDidLoginNotification object:nil];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:launchOptions];
 
    

    BOOL isNotFirstStart=[[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"];
    NSLog(@"isNotFirstStart=%d",isNotFirstStart);
    if (!isNotFirstStart) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ispush"];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    netStatus=NotReachable;
    [self monitorNetworkChange];
    
    return YES;
}

#pragma mark---监听网络改变
-(void)monitorNetworkChange{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkChange:) name:kReachabilityChangedNotification object:nil];
    Reachability *hostRech=[[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
    [hostRech startNotifier];
}
- (void)networkChange:(NSNotification *)note {
    if (isFirstStartApp) {
        isFirstStartApp=NO;
        return;
    }
    Reachability* curReach = [note object];
    // NSLog(@"networkChange...");
    if ([curReach isKindOfClass: [Reachability class]]) {
        NetworkStatus status = [curReach currentReachabilityStatus];
        switch (status) {
            case NotReachable:
            {
                NSLog(@"networkChange...没有网络");
                netStatus=NotReachable;
            }
                break;
            case ReachableViaWiFi:
            {
                NSLog(@"networkChange...WIFI网络");
                if (netStatus!=ReachableViaWiFi) {
                    netStatus=ReachableViaWiFi;
                    [cameraViewController networkChangeReStartDevice];
                }
                
            }
                break;
            case ReachableViaWWAN:
            {
                NSLog(@"networkChange...3G网络");
                if (netStatus!=ReachableViaWWAN) {
                    netStatus=ReachableViaWWAN;
                    [cameraViewController networkChangeReStartDevice];
                }
            }
                break;
                
            default:
                break;
        }
    }
}


- (void) StartThread: (id) param
{
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);    
    usleep(3000000);
    
    // code begins
    NSString *strUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    NSString *strUserPassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserPassword"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIN"] == YES)
    {
        if (strUserName != nil && strUserPassword != nil)
        {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"rememberME"] == YES)
            {
                [self performSelectorOnMainThread:@selector(switchView:) withObject:nil waitUntilDone:NO];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(addLoginView) withObject:nil waitUntilDone:NO];
            }
        }
        else
        {
            [self performSelectorOnMainThread:@selector(addLoginView) withObject:nil waitUntilDone:NO];
        }
    }else
    {
        [self performSelectorOnMainThread:@selector(addLoginView) withObject:nil waitUntilDone:NO];
    }
    // code end
    
//    [self performSelectorOnMainThread:@selector(switchView:) withObject:nil waitUntilDone:NO];
}

-(NSString *)serverFilePath{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask
                                                      , YES);
    NSString *paths=[path objectAtIndex:0];
    return[paths stringByAppendingPathComponent:@"server"];
}
- (void) switchView: (id) param
{
    NSLog(@"switchView...===========================");
    [self.startViewController.view removeFromSuperview];
//    [self deleteBizCameraFromLocal];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.window.rootViewController=navigationController;
    //[self.window addSubview:navigationController.view];
}

- (void) switchRemotePlaybackView: (RemotePlaybackViewController*)_remotePlaybackViewController;
{
    isOnPlayView=YES;
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    self.remotePlaybackViewController = _remotePlaybackViewController ;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window.rootViewController=_remotePlaybackViewController;
   // [self.window addSubview:remotePlaybackViewController.view];
}
-(void)enterMoreView:(FourViewController*)vc{
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    self.fourViewController=vc;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.window.rootViewController=vc;
    
}

-(void)playEnterFourView{
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    if (self.playViewController !=nil) {
        self.playViewController = nil;
    }
    self.window.rootViewController=self.fourViewController;
}
- (void) switchPlaybackView: (PlaybackViewController*)_playbackViewController
{
     isOnPlayView=YES;
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    
    self.playbackViewController = _playbackViewController ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window.rootViewController=playbackViewController;
    //[self.window addSubview:playbackViewController.view];
}

- (void) switchPlayView:(KXPlayViewController *)_playViewController
{
     isOnPlayView=YES;
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    
    self.playViewController = _playViewController ;
    self.playViewController.m_pPicPathMgt = m_pPicPathMgt;
    self.playViewController.m_pRecPathMgt = m_pRecPathMgt;
    self.playViewController.PicNotifyDelegate = picViewController;
    self.playViewController.RecNotifyDelegate = recViewController;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window.rootViewController=_playViewController;
    //[self.window addSubview:_playViewController.view];
}

- (void) switchBack
{
    
    NSLog(@"---------switchBack--------getFourBackground(%d)",[IpCameraClientAppDelegate getFourBackground]);
     isOnPlayView=NO;
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.window.rootViewController=navigationController;
    //[self.window addSubview:navigationController.view];
    if (self.playViewController != nil) {
        self.playViewController = nil;
    } 
    if (self.playbackViewController != nil) {
        self.playbackViewController = nil;
    }

    if (self.remotePlaybackViewController != nil) {
        self.remotePlaybackViewController = nil;
    }
    
    if ([IpCameraClientAppDelegate getFourBackground]==YES) {
        
        [IpCameraClientAppDelegate setFourBackground:NO];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  
    
    NSLog(@"==================applicationDidEnterBackground");
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"enterbackground" object:nil];

    if (moreViewPlayProtocol!=nil) {
        [moreViewPlayProtocol stopMoreViewPlay];
    }
    
    if (playViewController != nil) {
        [playViewController StopPlay:1];
    }
    
    if (playbackViewController != nil) {
        [playbackViewController StopPlayback];
    }
    
    if (remotePlaybackViewController != nil) {
        [remotePlaybackViewController StopPlayback];
    }
    if ([IpCameraClientAppDelegate getFourBackground]==YES) {
        [self switchBack];
    }

    [cameraViewController StopPPPP];
    
   [self loginOutBizSever];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    NSLog(@"=====================applicationWillEnterForeground");
    [NSThread detachNewThreadSelector:@selector(loginInBizSever) toTarget:self withObject:nil];
    [cameraViewController StartPPPPThread];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
   // NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    NSLog(@"applicationWillTerminate");
    
}
#pragma mark---获取DeviceToken和接受推送消息
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    //注册JPush
    [APService registerDeviceToken:deviceToken];
    NSLog(@"deviceToken=%@",deviceToken);
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    BOOL isLogined=[def boolForKey:@"bizlogin"];
    if (!isLogined) {
        [def setObject:pushToken forKey:@"deviceToken"];
    }
    [NSThread detachNewThreadSelector:@selector(loginInBizSever) toTarget:self withObject:nil];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"didReceiveRemoteNotification userInfo=%@",userInfo);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    CGRect mainScreen=[UIScreen mainScreen].bounds;
   
    NSDictionary *dic=[userInfo objectForKey:@"aps"];
    NSString *alertContent=[dic objectForKey:@"alert"];
    NSRange range=[alertContent rangeOfString:@":"];
    NSString *did=@"-1";
    if (range.length>0) {
       // NSLog(@"有ID location:%d id=%@",range.location,[alertContent substringToIndex:range.location]);
        did=[alertContent substringToIndex:range.location];
    }else{
        NSLog(@"没有ID");
    }
    if (isOnPlayView) {
       [KXToast showWithText:alertContent];
    }else{
        kxStatusBar=[[KXStatusBar alloc]initWithFrame:CGRectMake(0, 0, mainScreen.size.width, 20)];
        [kxStatusBar showWithString:alertContent];
        [kxStatusBar release];
    }
   // NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:did,@"did", nil];
    if (alarmViewController!=nil){
        [alarmViewController apsNotify:did];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError...error=%@",error);
}
#pragma mark---Biz服务器的登陆和注销
-(void)loginInBizSever{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *appToken = [defaults objectForKey:@"deviceToken"];//保存设备所获取到到deviceToken
    if (appToken==nil||appToken.length<64) {//判断deviceToken是否合法,若不合法则不登录服务器
        NSLog(@"loginInBizSever...deviceToken不合法");
        return;
    }
    
   
    //开发测试用的推送服务器地址  dev biz: HYLXJUGEKBHCHUGLEDGOGQGNEEGFGRGPIHEJEIEKLMHWEREHEG
    //发布用的推送服务器地址  pro biz: HYLXKHGMGWGEKBHCHUGLEDGOGQGNEEGFGRGPIHEJEIEKLMHWEREHEG
    int ret1 = Biz_Init("AQTDPDPKEISQLVASPALSLULKSUPELRPNLPLOLQSSPCLXLNLM",2000,3500);
    isBizInitSuccess=YES;//isBizInitSuccess:只有初始化了才需要注销:Biz_Deinit()
    if (ret1<0) {
            
        return;
    }
    NSLog(@"biz init-ret:%d",ret1);

    NSString *nsAID = [defaults objectForKey:@"appid"];//nsAID:保存第一次登录时服务器分配的appid,若是第一次登录则默认 nsAID=@"AID"
    NSLog(@"====appToken=%@  nsAID=%@",appToken,nsAID);
    if (nsAID==nil) {
        nsAID = @"AID";
    }
    
    t_app_Inf appInf;
    memset(&appInf, 0, sizeof(appInf));
    strcpy(appInf.appID, [nsAID UTF8String]);
    strcpy(appInf.appVer, "020603001");
    /*
     下面是应用版本，该版本好需要向欧杰特索取，dev是测试的， pro是发布的
     dev: 021302001
     pro: 020603001
    */
    strncpy(appInf.appleToken,[appToken UTF8String],64);
    INT32 retl;
    retl=Biz_AppLgn(&appInf);
    NSLog(@"============Applog login appid:%s,token:%s,ret:%d \n",appInf.appID,appInf.appleToken,retl);
    if (retl>=0) {
        nsAID = [NSString stringWithUTF8String:appInf.appID];
        [defaults setObject:nsAID forKey:@"appid"];
        [defaults synchronize];
        NSLog(@"=======AppLgn successfully===1===appid=%@",nsAID);
    }else{
        retl=Biz_AppLgn(&appInf);
        printf("Applog login appid:%s,token:%s,ret:%d \n",appInf.appID,appInf.appleToken,retl);
        if (retl>=0) {
            nsAID = [NSString stringWithUTF8String:appInf.appID];
            [defaults setObject:nsAID forKey:@"appid"];
            
            [defaults synchronize];
            NSLog(@"=======AppLgn successfully===2===");
        }else{
            NSLog(@"=======AppLgn failed===1===");
            return;
        }
    }
    
    char usrID[24];
    char usrAcc[24];
    char usrPwd[24];
    memset(&usrID, 0, sizeof(usrID));
    memset(&usrAcc, 0, sizeof(usrAcc));
    memset(&usrPwd, 0, sizeof(usrPwd));
    
    NSString *strUuid=[defaults stringForKey:@"oID"];
    NSString *strUsrID=[defaults stringForKey:@"usrID"];
    NSString *strAcc=[defaults stringForKey:@"usrAcc"];
    NSString *strPwd=[defaults stringForKey:@"usrPwd"];
    if (strUuid==nil) {
         appToken = [defaults objectForKey:@"deviceToken"];
        strUuid=[self getoID:appToken];
        [defaults setObject:strUuid forKey:@"oID"];
    }
    if (strUsrID!=nil) {
        strcpy(usrID, [strUsrID UTF8String]);
    }
    if (strAcc!=nil) {
        strcpy(usrAcc, [strAcc UTF8String]);
    }
    if (strPwd!=nil) {
        strcpy(usrPwd, [strPwd UTF8String]);
    }
    //int ret =  Biz_UsrLgin(const char *usrAcc,const char *usrPwd,char *usrID);
    int ret = Biz_OusrLgin((char*)[strUuid UTF8String], usrID, usrAcc, usrPwd);
    NSLog(@"usrID=%@ usrAcc=%@ usrPwd=%@",[NSString stringWithUTF8String:usrID],[NSString stringWithUTF8String:usrAcc],[NSString stringWithUTF8String:usrPwd]);
    
    if (ret>=0) {
        NSLog(@"Biz  登陆成功");
        //登陆成功
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"bizlogin"];
        
        if (strUsrID==nil) {
            [defaults setObject:[NSString stringWithUTF8String:usrID] forKey:@"usrID"];
        }
        if (strAcc==nil) {
            [defaults setObject:[NSString stringWithUTF8String:usrAcc] forKey:@"usrAcc"];
        }
        if (strPwd==nil) {
            [defaults setObject:[NSString stringWithUTF8String:usrPwd] forKey:@"usrPwd"];
        }
    }else{
        NSLog(@"Biz  登陆失败 ret＝%d",ret);
        //登陆失败
        [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"bizlogin"];
    }
    [defaults synchronize];
}

-(NSString*)getoID:(NSString*)deviceToken{
    char *appTokens=(char*)[deviceToken UTF8String];
    NSLog(@"getoID...appTokens=%s",appTokens);
    NSInteger tLen=strlen(appTokens);
    NSLog(@"getoID...tLen=%ld",tLen);
    char  oID[100]={0};
    char  a[2]={0};
    for (int i=0; i<tLen; i+=2) {
        memcpy(a, appTokens+i, 1);
        strcat(oID, a);
    }
    NSString *str=[NSString stringWithUTF8String:oID];
   // NSLog(@"getoID...str=%@  len=%d",str,str.length);
    return str;
}
-(void)loginOutBizSever{
    
    if (!isBizInitSuccess) {
        return;
    }
    int ret = Biz_UsrLgout();
    if (ret>0) {
         NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"bizlogin"];
    }
   
    int ret1 = Biz_Deinit();
    NSLog(@"loginOutBizSever ret:%d  ret1:%d",ret,ret1);
}

#pragma mark-----JPush start
-(void)jpushRegisterNotification:(NSNotification *)notification{
    NSLog(@"===========================================");
    NSLog(@"====jpushLoginNotification....极光推送注册成功===%@",[notification.userInfo objectForKey:@"RegistrationID"]);
    ;
}
-(void)jpushLoginNotification:(NSNotification *)notification{
    NSLog(@"===========================================");
    NSLog(@"====jpushLoginNotification....极光推送登录成功===");
    [self setJPushAlias];
}


- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
-(void)setJPushAlias{
    NSLog(@"setJPushAlias");
    //设置别名
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *appToken = [defaults objectForKey:@"deviceToken"];//保存设备所获取到到deviceToken
    if (appToken==nil||appToken.length<64) {//判断deviceToken是否合法,若不合法则不登录服务器
        NSLog(@"loginInBizSever...deviceToken不合法");
        return;
    }
    
    NSString *_alias=[defaults objectForKey:@"jpush_alias"];
    if (_alias==nil) {
        _alias=[self getoID:appToken];
        NSLog(@"========strAlias=%@",_alias);
        [APService setAlias:_alias callbackSelector:@selector(setAliasCallback:tags:alias:) object:self];
        
    }
}

-(void)setAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias{
    NSLog(@"setAliasCallback.......iResCode=%d  alias=%@",iResCode,alias);
    if (iResCode==0) {
        NSLog(@"别名设置成功");
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:alias forKey:@"jpush_alias"];
        [defaults synchronize];
    }else{
        [self setJPushAlias];
    }
}

-(NSString*)getJPushAlias{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"jpush_alias"];
}
#pragma mark------JPush End


#pragma mark--向服务器上添加设备和删除设备
-(void)openOrCloseAlarmPush:(BOOL)isOpen{
    if (isOpen) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ispush"];
        int count=[m_pCameraListMgt GetCount];
        for(int i=0;i<count;i++){
            NSDictionary *cameraDic = [m_pCameraListMgt GetCameraAtIndex:i];
            NSString *did = [cameraDic objectForKey:@STR_DID];
            NSString *name=[cameraDic objectForKey:@STR_NAME];
            NSString *user=[cameraDic objectForKey:@STR_USER];
            NSString *pwd=[cameraDic objectForKey:@STR_PWD];
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:did,@"did",name,@"name",user,@"user",pwd,@"pwd", nil];
            
            [self addDeviceToBizServer:dic];
            //sleep(100);
        }
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ispush"];
        int count=[m_pCameraListMgt GetCount];
        for(int i=0;i<count;i++){
            NSDictionary *cameraDic = [m_pCameraListMgt GetCameraAtIndex:i];
            NSString *strDID = [cameraDic objectForKey:@STR_DID];
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strDID,@"did",[NSNumber numberWithBool:NO],@"flag", nil];
            
            
            [self deleteDeviceFromBizServer:dic];
            //sleep(100);
        }
    }
}
-(void)deleteBizCameraFromLocal{
    int count= [m_pCameraListMgt getDeleFromBizServerCount];
    for(int i=0;i<count;i++){
        NSString *strDID=[m_pCameraListMgt getDeleDIDFromBizAtIndex:i];
        NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:strDID,@"did",[NSNumber numberWithBool:YES],@"flag", nil];
        [self deleteDeviceFromBizServer:dic2];
        
    }
}

-(void)addDeviceToBizServer:(NSDictionary *)dic{
    BOOL isPush=[[NSUserDefaults standardUserDefaults] boolForKey:@"ispush"];
    if (isPush) {
        [NSThread detachNewThreadSelector:@selector(ToBizServer:) toTarget:self withObject:dic];
    }else{
        NSLog(@"addDeviceToBizServer..没有打开push功能");
    }
}
-(void)ToBizServer:(NSDictionary*)dic{
    int isLegal=-1;
    NSString *strName=[dic objectForKey:@"name"];
    NSString *did=[[dic objectForKey:@"did"] uppercaseString];
    
    NSRange ra=[did rangeOfString:@"-"];
    NSRange ra1=[did rangeOfString:@"-" options:NSBackwardsSearch];
    NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSRange rangeFirst=[did rangeOfCharacterFromSet:set];
    NSRange rangeLast=[did rangeOfCharacterFromSet:set options:NSBackwardsSearch];
    
    NSString *strDid=@"";
    if (ra.length>0&&ra1.length>0&&ra.location!=ra1.location) {//有两个-
        strDid=[did uppercaseString];
    }else if(ra.length>0&&ra1.length>0&&ra.location==ra1.location&&ra.location<rangeFirst.location){
        NSMutableString *str=[NSMutableString stringWithString:did];
        [str insertString:@"-" atIndex:rangeLast.location+1];
        strDid=[NSString stringWithString:str];
        strDid=[strDid uppercaseString];
        
        //只有前面有-
    }else if(ra.length>0&&ra1.length>0&&ra.location==ra1.location&&ra.location>rangeFirst.location){
        NSMutableString *str=[NSMutableString stringWithString:did];
        [str insertString:@"-" atIndex:rangeFirst.location];
        strDid=[NSString stringWithString:str];
        strDid=[strDid uppercaseString];
        //只有后面有-
    }else{
        NSMutableString *str=[NSMutableString stringWithString:did];
        [str insertString:@"-" atIndex:rangeFirst.location];
        [str insertString:@"-" atIndex:rangeLast.location+2];
        strDid=[NSString stringWithString:str];
        strDid=[strDid uppercaseString];
        // 没有-
    }
    
    NSString *strUser=[dic objectForKey:@"user"];
    NSString *strPwd=[dic objectForKey:@"pwd"];
   
    t_devInf_s s_dev;
    memset(&s_dev, 0, sizeof(t_devInf_s));
    strcpy(s_dev.dID, [strDid UTF8String]);
    strcpy(s_dev.dAcc, [strUser UTF8String]);
    strcpy(s_dev.dPwd, [strPwd UTF8String]);
    strcpy(s_dev.dName, [strName UTF8String]);
    strcpy(s_dev.dGID,[@"" UTF8String]);
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL bizLogin=[defaults boolForKey:@"bizlogin"];
    NSLog(@"bizLogin=%d",bizLogin);
    if (bizLogin) {//登陆成功才去添加设备
        isLegal = Biz_UsrDevAdd(s_dev);
        if (isLegal<0) {
            isLegal = Biz_UsrDevAdd(s_dev);
            if (isLegal<0) {
                NSLog(@"添加设备到Biz服务器上失败 strDid=%@",strDid);
            }
        }else if (isLegal>=0){
            NSLog(@"添加设备到Biz服务器上成功 strDid=%@",strDid);
        }
    }else{//登陆失败再次登陆
        
    }
    
    
}
-(void)deleteDeviceFromBizServer:(NSDictionary*)dic{
   
    [NSThread detachNewThreadSelector:@selector(FromBizServer:) toTarget:self withObject:dic];
}
-(void)FromBizServer:(NSDictionary*)dic{
    BOOL isDelete=[[dic objectForKey:@"flag"] boolValue];
    NSString *did=[dic objectForKey:@"did"];
    
    NSRange ra=[did rangeOfString:@"-"];
    NSRange ra1=[did rangeOfString:@"-" options:NSBackwardsSearch];
    NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSRange rangeFirst=[did rangeOfCharacterFromSet:set];
    NSRange rangeLast=[did rangeOfCharacterFromSet:set options:NSBackwardsSearch];
    
    NSString *strDid=@"";
    if (ra.length>0&&ra1.length>0&&ra.location!=ra1.location) {//有两个-
        strDid=[did uppercaseString];
    }else if(ra.length>0&&ra1.length>0&&ra.location==ra1.location&&ra.location<rangeFirst.location){
        NSMutableString *str=[NSMutableString stringWithString:did];
        [str insertString:@"-" atIndex:rangeLast.location+1];
        strDid=[NSString stringWithString:str];
        strDid=[strDid uppercaseString];
        
        //只有前面有-
    }else if(ra.length>0&&ra1.length>0&&ra.location==ra1.location&&ra.location>rangeFirst.location){
        NSMutableString *str=[NSMutableString stringWithString:did];
        [str insertString:@"-" atIndex:rangeFirst.location];
        strDid=[NSString stringWithString:str];
        strDid=[strDid uppercaseString];
        //只有后面有-
    }else{
        NSMutableString *str=[NSMutableString stringWithString:did];
        [str insertString:@"-" atIndex:rangeFirst.location];
        [str insertString:@"-" atIndex:rangeLast.location+2];
        strDid=[NSString stringWithString:str];
        strDid=[strDid uppercaseString];
        // 没有-
    }
    
    int isLegal = -1;
    char szDidS[20]={0};
	memset(szDidS, 0, sizeof(szDidS));
	strcpy(szDidS, [strDid UTF8String]);
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL bizLogin=[defaults boolForKey:@"bizlogin"];
    NSLog(@"bizLogin=%d",bizLogin);
    if (bizLogin) {//登陆成功才去删除设备
        BOOL isDeleteOk=NO;
        isLegal=Biz_UsrDevDel(szDidS);
        if (isLegal<0) {
            isDeleteOk=NO;
            isLegal=Biz_UsrDevDel(szDidS);
            if (isLegal>=0) {
                NSLog(@"从Biz服务器上删除设备成功 did=%@",strDid);
                isDeleteOk=YES;
            }else{
                NSLog(@"从Biz服务器上删除设备失败 did=%@",strDid);
            }
        }else if (isLegal>=0){
            NSLog(@"从Biz服务器上删除设备成功 did=%@",strDid);
            isDeleteOk=YES;
        }
//        if (isDelete) {//如果是删除才删除
//            if ([m_pCameraListMgt RemoveCameraFromLocal:did DeleOk:isDeleteOk]) {
//                NSLog(@"从本地删除成功");
//            }else{
//                NSLog(@"不需要从本地删除设备=%@",did);
//            }
//        }
        
    }else{//登陆失败再次登陆
//        if (isDelete) {//如果是删除才删除
//            if ([m_pCameraListMgt RemoveCameraFromLocal:did DeleOk:NO]) {
//                NSLog(@"从本地删除成功=%@",did);
//            }else{
//                NSLog(@"从本地删除失败=%@",did);
//            }
//        }
    }
	
}
#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    
    NSLog(@"applicationDidReceiveMemoryWarning");
}

- (void)dealloc 
{
    //NSLog(@"IpCameraClientAppDelegate dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateui" object:nil];
    self.window = nil;
    self.startViewController = nil;
    self.navigationController = nil;
    self.playViewController = nil;
    self.remotePlaybackViewController = nil;
    self.playbackViewController = nil;
    if (cameraViewController != nil) {
        [cameraViewController release];
        cameraViewController = nil;
    }
    if (kxStatusBar!=nil) {
        [kxStatusBar release];
        kxStatusBar=nil;
    }
    PPPP_DeInitialize();
    Biz_Deinit();
    if(m_pCameraListMgt != nil){
        [m_pCameraListMgt release];
        m_pCameraListMgt = nil;
    }
    if (picViewController != nil) {
        [picViewController release];
        picViewController = nil;
    }
    if (recViewController != nil) {
        [recViewController release];
        recViewController = nil;
    }
    
    SAFE_DELETE(m_pPPPPChannelMgt);
    
    [myTabViewController release];
    [super dealloc];
}
-(void) changeP2PAndDDNS:(BOOL)isP2P{
    NSLog(@"IpCameraClientAppDelegate changeP2PAndDDNS()");
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    
    
    [m_pCameraListMgt release];
    [m_pPicPathMgt release];
    [m_pRecPathMgt release];
    [picViewController release];
    [recViewController release];
    [cameraViewController release];
    [myTabViewController release];
    [navigationController release];
    
    
    
    
    m_pCameraListMgt = [[CameraListMgt alloc] init];
    [m_pCameraListMgt selectP2PAll:isP2P];
    m_pPicPathMgt = [[PicPathManagement alloc] init];
    m_pRecPathMgt = [[RecPathManagement alloc] init];
    
    
    m_pPPPPChannelMgt = new CPPPPChannelManagement();
    netWorkUtile=[[NetWorkUtiles alloc]init];
    
    picViewController = [[PictureViewController alloc] init];
    picViewController.m_pCameraListMgt = m_pCameraListMgt;
    picViewController.m_pPicPathMgt = m_pPicPathMgt;
    picViewController.isP2P=isP2P;
    
    recViewController = [[RecordViewController alloc] init];
    recViewController.m_pCameraListMgt = m_pCameraListMgt;
    recViewController.m_pRecPathMgt = m_pRecPathMgt;
    recViewController.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
    recViewController.isP2P=isP2P;
    

    alarmViewController=[[AlarmViewController alloc]init];
    alarmViewController.pPPPPChannelMgt=m_pPPPPChannelMgt;
    alarmViewController.m_pCameraListMgt=m_pCameraListMgt;
    
    
    cameraViewController = [[CameraViewController alloc] init];
    cameraViewController.isP2P=isP2P;
    cameraViewController.netWorkUtile=netWorkUtile;
    cameraViewController.cameraListMgt = m_pCameraListMgt;
    cameraViewController.m_pPicPathMgt = m_pPicPathMgt;
    cameraViewController.m_pRecPathMgt = m_pRecPathMgt;
    cameraViewController.PicNotifyEventDelegate = picViewController;
    cameraViewController.RecordNotifyEventDelegate = recViewController;
    cameraViewController.pPPPPChannelMgt = m_pPPPPChannelMgt;
    
    cameraViewController.picViewController=picViewController;
    cameraViewController.recViewController=recViewController;
    
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    myTabViewController = [[MyTabBarViewController alloc] init];
    
    myTabViewController.viewControllers = [NSArray arrayWithObjects:cameraViewController, alarmViewController, picViewController, recViewController, aboutViewController, nil];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:myTabViewController];
    [[myTabViewController tabBar] setBackgroundImage:[UIImage imageNamed:@"bottom.png"]];
    //[cameraViewController release];
    //[picViewController release];
    //[recViewController release];
    [aboutViewController release];
    [self.window addSubview:navigationController.view];
    
}
+(BOOL)is43Version{
  float version = [[[UIDevice currentDevice] systemVersion] floatValue];
   // NSLog(@"version=%f",version);
    BOOL b=NO;
    if (version<4.5) {
       
        b=YES;
    }
    return b;
}
+(BOOL)isIOS7Version{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    // NSLog(@"version=%f",version);
    BOOL b=NO;
    if (version>6.9) {
        
        b=YES;
    }
    return b;
}
+(BOOL)isiPhone{
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        return YES;
    }else{
        return NO;
    }
}
+(void)setFourBackground:(BOOL)flag{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
     [def setBool:flag forKey:@"FourViewBackground"];
    NSLog(@"----IpCa-----------setFourBackground(%d)",flag);
}
+(BOOL)getFourBackground{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"FourViewBackground"] intValue];
}

// Code Begin

+(IpCameraClientAppDelegate *)sharedAppDelegate
{
    return  (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)addLoginView
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        loginViewCntrl = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
    }else{
        loginViewCntrl = [[LoginViewController alloc] initWithNibName:@"LoginViewController_IPad" bundle:nil];
    }
    
    nav = [[UINavigationController alloc] initWithRootViewController:loginViewCntrl];
    
    NSLog(@"switchView...===========================");
    
    if ([self.startViewController.view isDescendantOfView:self.window])
    {
        [self.startViewController.view removeFromSuperview];
    }
    
    //    [self deleteBizCameraFromLocal];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.window addSubview:nav.view];
}

#pragma mark -  Loading view methods

-(void) showLoadingView {
    //NSLog(@"show loading view called");
    if (loadingView == nil)
    {
        CGRect mainScreen=[UIScreen mainScreen].bounds;
        loadingView = [[UIView alloc] initWithFrame:mainScreen];
        loadingView.opaque = NO;
        loadingView.backgroundColor = [UIColor darkGrayColor];
        loadingView.alpha = 0.5;
        
        UIView *subloadview=[[UIView alloc] initWithFrame:CGRectMake(84.0, 190.0,150.0 ,50.0)];
        subloadview.backgroundColor=[UIColor blackColor];
        subloadview.opaque=NO;
        subloadview.alpha=0.8;
        
        subloadview.layer.masksToBounds = YES;
        subloadview.layer.cornerRadius = 6.0;
        
        lblLoad=[[UILabel alloc]initWithFrame:CGRectMake(50.0, 7.0,80.0, 33.0)];
        lblLoad.text=@"LoadingView";
        lblLoad.backgroundColor=[UIColor clearColor];
        lblLoad.textColor=[UIColor whiteColor];
        [subloadview addSubview:lblLoad];
        
        UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0, 11.0, 25.0, 25.0)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [subloadview addSubview:spinningWheel];
        [loadingView addSubview:subloadview];
        
        subloadview.center = loadingView.center;
        
        [spinningWheel release];
    }
    [self.window addSubview:loadingView];
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
}


-(void) hideLoadingView {
    if (loadingView) {
        [loadingView removeFromSuperview];
        [loadingView release];
        loadingView = nil;
    }
    
}
// Code Ends

@end
