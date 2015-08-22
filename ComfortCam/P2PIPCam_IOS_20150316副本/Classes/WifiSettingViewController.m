//
//  WifiSettingViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WifiSettingViewController.h"
#import "WifiPwdViewController.h"
#import "obj_common.h"
#import "CameraViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "mytoast.h"
@interface WifiSettingViewController ()

@end

@implementation WifiSettingViewController

@synthesize m_pPPPPChannelMgt;
@synthesize m_strSSID;
@synthesize m_strWEPKey;
@synthesize m_strWPA_PSK;
@synthesize m_strDID;
@synthesize navigationBar;
@synthesize isSetOver;
@synthesize wifiTableView;


@synthesize isP2P;
@synthesize m_strPort;
@synthesize m_strIp;
@synthesize m_strUser;
@synthesize m_strPwd;
@synthesize netUtiles;
@synthesize mModal;
@synthesize cameraListMgt;
#pragma mark -
#pragma mark system

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_strSSID=@"";
        m_strWEPKey=@"";
        m_strWPA_PSK=@"";
    }
    return self;
}

- (void)handleTimer:(id)param
{    
    [self StopTimer];
    [self hideLoadingIndicator];  
    m_bFinished = YES;
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}

- (void) StopTimer
{
    [m_timerLock lock];
    if (m_timer != nil) {
        [m_timer invalidate];
        m_timer = nil;
    }
    [m_timerLock unlock];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    isSetOver=NO;
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    //NSLog(@"WifiSettingViewController viewDidLoad");
    m_timerLock = [[NSCondition alloc] init];
   
    m_bFinished = NO;
    m_wifiScanResult = [[NSMutableArray alloc] init];
    
    [self showLoadingIndicator];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    
    if (isP2P) {
        
        m_pPPPPChannelMgt->SetWifiParamDelegate((char*)[m_strDID UTF8String], self);
        m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
        m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_WIFI_SCAN, NULL, 0);
    }else{//ddns
        //netUtiles.wifiProtocol=self;
        
        [netUtiles getCameraParam:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd ParamType:2];
        
        
       // [netUtiles getWifiScanParam:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd ParamType:8];
    }
    
    
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        
        CGRect tableFrm=wifiTableView.frame;
        tableFrm.origin.y+=20;
        wifiTableView.frame=tableFrm;
        self.view.backgroundColor=[UIColor blackColor];
       
      wifiTableView.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
        
    }else{
        NSLog(@"less ios7");
        
    }
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=wifiTableView.frame;
    imgView.center=wifiTableView.center;
    wifiTableView.backgroundView=imgView;
    [imgView release];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(popToHome:)
     name:@"statuschange"
     object:nil];
	
}
-(void)popToHome:(NSNotification *)notification{//回到首页
    NSString *did=(NSString *)[notification object];
    NSLog(@"did=%@ m_strDID=%@",did,m_strDID);
    if ([m_strDID  caseInsensitiveCompare:did]==NSOrderedSame) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    m_pPPPPChannelMgt->SetWifiParamDelegate((char*)[m_strDID UTF8String], nil);
    if (m_wifiScanResult != nil) {
        [m_wifiScanResult release];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self StopTimer];
   [[NSNotificationCenter defaultCenter]removeObserver:self name:@"statuschange" object:nil];
    NSLog(@"viewWillDisappear");
}

- (void)dealloc
{
    if (isP2P) {
        m_pPPPPChannelMgt->SetWifiParamDelegate((char*)[m_strDID UTF8String], nil);
        self.m_pPPPPChannelMgt = nil;
    }else{
        netUtiles.wifiProtocol=nil;
    }
    
    wifiTableView = nil;
    if (m_wifiScanResult != nil) {
        [m_wifiScanResult release];
    }    
    m_strDID = nil;
    m_strWEPKey = nil;
    m_strWPA_PSK = nil;
    m_strSSID = nil;
    wifiTableView=nil;
    navigationBar = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) refresh:(id)param
{
    [m_wifiScanResult removeAllObjects];
    [self showLoadingIndicator];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    if (isP2P) {
        m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
        m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_WIFI_SCAN, NULL, 0);
    }else{
        //netUtiles.wifiProtocol=self;
        [netUtiles getCameraParam:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd ParamType:2];
        //[netUtiles getWifiScanParam:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd ParamType:8];
    }
    m_bFinished = NO;
    [self reloadTableView:nil];
}

- (void)showLoadingIndicator
{
   
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@""];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 80, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= NSLocalizedStringFromTable(@"WifiSetting", @STR_LOCALIZED_FILE_NAME, nil);
    item.titleView=labelTile;
    
    [labelTile release];
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
  
    //创建一个右边按钮  
    UIActivityIndicatorView *indicator =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
     autorelease];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[[UIBarButtonItem alloc] initWithCustomView:indicator] autorelease];

    item.leftBarButtonItem=leftButton;
    item.rightBarButtonItem = progress;
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
	[leftButton release];
    
    [item release];
    
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hideLoadingIndicator
{
    
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@""];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 80, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= NSLocalizedStringFromTable(@"WifiSetting", @STR_LOCALIZED_FILE_NAME, nil);
    item.titleView=labelTile;
    [labelTile release];
    
    //创建一个右边按钮
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
	
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"refresh_normal.png"] forState:UIControlStateNormal];
//    [btnRight setBackgroundImage:[UIImage imageNamed:@"refresh_pressed.png"] forState:UIControlStateHighlighted];
    //[btnRight setTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
    btnRight.frame=CGRectMake(0,0,50,30);
    [btnRight addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *refreshButton =[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
    item.rightBarButtonItem = refreshButton;
    item.leftBarButtonItem=leftButton;
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
	[leftButton release];
    [refreshButton release];
    [item release];
    
    
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    if (m_bFinished == NO) {
        return 1;
    }
    
    if ([m_wifiScanResult count] > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return [m_wifiScanResult count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{  
    NSString *cellIdentifier = @"SettingCell";	
    UITableViewCell *cell =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }    
    
    int section = [anIndexPath section];
    if (section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (m_bFinished == FALSE) {
            cell.textLabel.text = NSLocalizedStringFromTable(@"Loading", @STR_LOCALIZED_FILE_NAME, nil); 
        }else {
            if (m_strSSID.length == 0) {
                cell.textLabel.text = NSLocalizedStringFromTable(@"NotSetting", @STR_LOCALIZED_FILE_NAME, nil);  
            }else {
                NSString *strConnect=@"";
                if (m_wifi_link_status==0) {
                    strConnect=NSLocalizedStringFromTable(@"wifi_connected", @STR_LOCALIZED_FILE_NAME, nil);
                }else{
                    strConnect=NSLocalizedStringFromTable(@"wifi_connectedfail", @STR_LOCALIZED_FILE_NAME, nil);
                }
                cell.textLabel.text = [NSString stringWithFormat:@"%@     %@",m_strSSID,strConnect];
               
            }
        }   
    }
    
    if (section == 1) {
        int index = anIndexPath.row;
        
        NSDictionary *wifiResult = [m_wifiScanResult objectAtIndex:index];
        NSString *strSSID = [wifiResult objectForKey:@STR_SSID];
        cell.textLabel.text = strSSID;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedStringFromTable(@"wifi_ssid", @STR_LOCALIZED_FILE_NAME, nil);
    }else {
        return NSLocalizedStringFromTable(@"WifiList", @STR_LOCALIZED_FILE_NAME, nil);
    }    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    if (anIndexPath.section == 0) {
        return;
    }
    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];

    int index = anIndexPath.row;
    m_currentIndex = index;
    NSDictionary *wifiInfor = [m_wifiScanResult objectAtIndex:index];    
    int security = [[wifiInfor objectForKey:@STR_SECURITY] intValue];
    NSString *strSSID = [wifiInfor objectForKey:@STR_SSID];
    if (security == 0) {
        NSString *strMessage = [NSString stringWithFormat:@"%@%@ ?",NSLocalizedStringFromTable(@"WillSet", @STR_LOCALIZED_FILE_NAME, nil),strSSID];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:strMessage delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
        [alertView show];
        [alertView release];
        return;
    }
    WifiPwdViewController *wifipwdView = [[WifiPwdViewController alloc] init];
    wifipwdView.m_pChannelMgt = m_pPPPPChannelMgt;
    wifipwdView.m_strDID = m_strDID;
    wifipwdView.m_strSSID = strSSID;
    wifipwdView.m_channel = [[wifiInfor objectForKey:@STR_CHANNEL] intValue];
    wifipwdView.m_security = security;
    wifipwdView.isP2P=isP2P;
    wifipwdView.mModal=mModal;
    [self.navigationController pushViewController:wifipwdView animated:YES];
    [wifipwdView release];
    
}

#pragma mark -
#pragma mark WifiParamsProtocol


-(void)WifiProtocolResult:(STRU_WIFI_PARAMS)t{
    NSLog(@"ssid=%@",[NSString stringWithUTF8String:t.ssid]);
    self.m_strSSID=[NSString stringWithUTF8String:t.ssid];
    m_channel = t.channel;
    m_authtype = t.authtype;
    m_strWEPKey = [NSString stringWithUTF8String:t.key1];
    m_strWPA_PSK =[NSString stringWithUTF8String:t.wpa_psk];
    m_wifi_link_status=t.wifi_link_status;
}
-(void)WifiScanProtocolResult:(STRU_WIFI_SEARCH_RESULT)t{
    if (m_bFinished == YES) {
        return;
    }
    NSString *ssid=[NSString stringWithUTF8String:t.ssid];
    if (ssid==nil||[ssid length]==0) {
        NSLog(@"strSSID==nil");
        return;
    }
    
    NSNumber *nSecurity = [NSNumber numberWithInt:t.security];
    NSNumber *nDB0 = [NSNumber numberWithInt:atoi(t.dbm0)];
    NSNumber *nChannel = [NSNumber numberWithInt:t.channel];
    NSDictionary *wifiscan = [NSDictionary dictionaryWithObjectsAndKeys:ssid, @STR_SSID, nSecurity, @STR_SECURITY, nDB0, @STR_DB0, nChannel, @STR_CHANNEL, nil];
    
    [m_wifiScanResult addObject:wifiscan];
    
    if (t.bEnd == 1) {
        m_bFinished = YES;
        [self performSelectorOnMainThread:@selector(StopTimer) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
        
    }
}


#pragma mark -
#pragma mark PerformInMainThread

- (void) reloadTableView:(id) param
{
    if (wifiTableView!=nil) {
        [wifiTableView reloadData];
    }
    
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex: %d", buttonIndex);
    if (buttonIndex != 1) {
        return;
    }
    
    NSDictionary *wifiInfor = [m_wifiScanResult objectAtIndex:m_currentIndex];    
    int security = [[wifiInfor objectForKey:@STR_SECURITY] intValue];
    NSString *strSSID = [wifiInfor objectForKey:@STR_SSID];
    int channel = [[wifiInfor objectForKey:@STR_CHANNEL] intValue];
    
   
    if (isP2P) {
        m_pPPPPChannelMgt->SetWifi((char*)[m_strDID UTF8String], 1, (char*)[strSSID UTF8String], channel, 0, security, 0, 0, 0, (char*)"", (char*)"", (char*)"", (char*)"", 0, 0, 0, 0, (char*)"");
        m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_REBOOT_DEVICE, NULL, 0);
    }else{
        [netUtiles setWifi:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Enable:1 SSID:strSSID Channel:channel Mode:0 Authtype:security Encrypt:0 Keyformat:0 Defkey:0 Key1:@"" Key2:@"" Key3:@"" Key4:@"" Key1_bits:0 Key2_bits:0 Key3_bits:0 Key4_bits:0 Wpa_psk:@""];
        
        [netUtiles setRoot:m_strIp Port:m_strPort CGI:@"" User:m_strUser Pwd:m_strPwd];
    }
    CameraViewController *camereView = [self.navigationController.viewControllers objectAtIndex:0];
    [self.navigationController popToViewController:camereView animated:YES];
    
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

@end
