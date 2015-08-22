//
//  SettingViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "WifiSettingViewController.h"
#import "CameraViewController.h"
#import "UserPwdSetViewController.h"
#import "AlarmController.h"
#import "DateTimeController.h"
#import "FtpSettingViewController.h"
#import "MailSettingViewController.h"
#import "SDCardScheduleViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "mytoast.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize m_pPPPPChannelMgt;
@synthesize m_strDID;
@synthesize mName;
@synthesize navigationBar;
@synthesize m_strIp;
@synthesize m_strPort;
@synthesize m_strPwd;
@synthesize m_strUser;
@synthesize isP2P;
@synthesize netUtiles;
@synthesize mTableView;
@synthesize alertViewRestart;
@synthesize cameraListMgt;
@synthesize mModal;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        m_strPort=@"";
        m_strIp=@"";
        m_strDID=@"";
        m_strPwd=@"";
        m_strUser=@"";
    }
    return self;
}


- (void)didEnterBackground
{
    //NSLog(@"didEnterBackground");
    [self.navigationController popToRootViewControllerAnimated:NO];
}    

- (void)willEnterForeground
{
    //NSLog(@"willEnterForeground");
}

- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainScreen=[[UIScreen mainScreen]bounds];
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    // Do any additional setup after loading the view from its nib.
    NSString *strTitle =mName ;//NSLocalizedStringFromTable(@"Setting", @STR_LOCALIZED_FILE_NAME, nil);
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 120, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= strTitle;
    item.titleView=labelTile;
    [labelTile release];
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    item.leftBarButtonItem=leftButton;
    [leftButton release];
    
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
    
    [item release];

    if ([IpCameraClientAppDelegate isIOS7Version]) {
        isIOS7=YES;
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        
        CGRect tableFrm=mTableView.frame;
        tableFrm.origin.y+=20;
        mTableView.frame=tableFrm;
        self.view.backgroundColor=[UIColor blackColor];
        mTableView.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
    }else{
        isIOS7=NO;
    }
    
    alertViewRestart=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"restartdeciveprompt", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"restartdecivemessage", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
    
    //把self添加到NSNotificationCenter的观察者中
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground) 
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground) 
                                                 name:UIApplicationWillEnterForegroundNotification 
                                               object:nil];
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=mTableView.frame;
    imgView.center=mTableView.center;
    mTableView.backgroundView=imgView;
    [imgView release];
    NSLog(@"isP2P:%d",isP2P);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    mName=nil;
    m_strIp=nil;
    m_strPort=nil;
    m_strPwd=nil;
    m_strUser=nil;
    m_strDID = nil;
    netUtiles=nil;
    self.navigationBar = nil;
    self.m_pPPPPChannelMgt = nil;
    mTableView=nil;
    alertViewRestart=nil;
    [super dealloc];
}

#pragma mark--UIAlertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex=%d",buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
        m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_REBOOT_DEVICE, NULL, 0);
        [mytoast showWithText:NSLocalizedStringFromTable(@"devicerestarting", @STR_LOCALIZED_FILE_NAME, nil)];
        [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{  
    NSString *cellIdentifier = @"SettingCell";	
    UITableViewCell *cell =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell autorelease];
    }
    
    switch (anIndexPath.row) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
            cell.textLabel.text = NSLocalizedStringFromTable(@"WifiSetting", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
            cell.textLabel.text = NSLocalizedStringFromTable(@"UserSetting", @STR_LOCALIZED_FILE_NAME, nil);  
            break;  
        case 2:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
            cell.textLabel.text = NSLocalizedStringFromTable(@"ClockSetting", @STR_LOCALIZED_FILE_NAME, nil);  
            break;        
        case 3:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
            cell.textLabel.text = NSLocalizedStringFromTable(@"AlarmSetting", @STR_LOCALIZED_FILE_NAME, nil);  
            break;
        case 4: //ftp setting
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedStringFromTable(@"FTPSetting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 5: //mail setting
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedStringFromTable(@"MailSetting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 6://sdcard schedule
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=NSLocalizedStringFromTable(@"SdcardSetting", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 7:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=NSLocalizedStringFromTable(@"setttingsrestart", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            break;
    }
    float cellHeight = cell.frame.size.height;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cellHeight - 1, mainScreen.size.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    cellBgView.backgroundColor=[UIColor clearColor];
    [cellBgView addSubview:label];
    if (isIOS7) {
        cell.backgroundView=cellBgView;
    }
    
    [label release];
    [cellBgView release];
	return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    //return NSLocalizedStringFromTable(@"Network", @STR_LOCALIZED_FILE_NAME, nil);
//}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    

    
    switch (anIndexPath.row) {
        case 0: //WIFI
        {
            WifiSettingViewController *wifiSettingView = [[WifiSettingViewController alloc] init];
            wifiSettingView.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
            wifiSettingView.m_strDID = m_strDID;
            
            wifiSettingView.m_strIp=m_strIp;
            wifiSettingView.m_strPort=m_strPort;
            wifiSettingView.m_strPwd=m_strPwd;
            wifiSettingView.m_strUser=m_strUser;
            wifiSettingView.isP2P=isP2P;
            wifiSettingView.netUtiles=netUtiles;
            wifiSettingView.mModal=mModal;
            [self.navigationController pushViewController:wifiSettingView animated:YES];
            [wifiSettingView release];
        }
            break;
        case 1: //用户设置
        {
            UserPwdSetViewController *UserPwdSettingView =nil; [[UserPwdSetViewController alloc] init];
            if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
                UserPwdSettingView=[[UserPwdSetViewController alloc]initWithNibName:@"UserSettingViewController" bundle:nil];
                
            }else{
            
            UserPwdSettingView=[[UserPwdSetViewController alloc]initWithNibName:@"UserSettingViewController_Ipad" bundle:nil];
            }
            
            UserPwdSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
            UserPwdSettingView.m_strDID = m_strDID;
            UserPwdSettingView.m_strIp=m_strIp;
            UserPwdSettingView.m_strPort=m_strPort;
            UserPwdSettingView.m_Pwd=m_strPwd;
            UserPwdSettingView.m_User=m_strUser;
            UserPwdSettingView.isP2P=isP2P;
            UserPwdSettingView.netUtiles=netUtiles;
            UserPwdSettingView.m_strName=mName;
            UserPwdSettingView.cameraListMgt=cameraListMgt;
            UserPwdSettingView.mModal=mModal;
            [self.navigationController pushViewController:UserPwdSettingView animated:YES];
            [UserPwdSettingView release];
        }
            break;
        case 2: //时间
        {
            DateTimeController *DateTimeSettingView = [[DateTimeController alloc] init];
            DateTimeSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
            DateTimeSettingView.m_strDID = m_strDID;
            DateTimeSettingView.isP2P=isP2P;
            DateTimeSettingView.m_strIp=m_strIp;
            DateTimeSettingView.m_strPort=m_strPort;
            DateTimeSettingView.m_strPwd=m_strPwd;
            DateTimeSettingView.m_strUser=m_strUser;
            DateTimeSettingView.netUtiles=netUtiles;
            [self.navigationController pushViewController:DateTimeSettingView animated:YES];
            [DateTimeSettingView release];
        }
            break;
        case 3: //报警设置
        {
            AlarmController *AlarmSettingView = [[AlarmController alloc] init];
            AlarmSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
            AlarmSettingView.m_strDID = m_strDID;
            
            AlarmSettingView.isP2P=isP2P;
            AlarmSettingView.m_strIp=m_strIp;
            AlarmSettingView.m_strPort=m_strPort;
            AlarmSettingView.m_strPwd=m_strPwd;
            AlarmSettingView.m_strUser=m_strUser;
            AlarmSettingView.netUtiles=netUtiles;
            
            [self.navigationController pushViewController:AlarmSettingView animated:YES];
            [AlarmSettingView release];
        }
            break;
        case 4: //ftp setting
        {
            FtpSettingViewController *ftpSettingView = [[FtpSettingViewController alloc] init];
            ftpSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
            ftpSettingView.m_strDID = m_strDID;
            
            ftpSettingView.isP2P=isP2P;
            ftpSettingView.m_strIp=m_strIp;
            ftpSettingView.m_strPort=m_strPort;
            ftpSettingView.m_Pwd=m_strPwd;
            ftpSettingView.m_User=m_strUser;
            ftpSettingView.netUtiles=netUtiles;
            
            [self.navigationController pushViewController:ftpSettingView animated:YES];
            [ftpSettingView release];
        }
            break;
        case 5://mail setting
        {
            
            MailSettingViewController *mailSettingView = [[MailSettingViewController alloc] init];
            mailSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
            mailSettingView.m_strDID = m_strDID;
            
            mailSettingView.isP2P=isP2P;
            mailSettingView.m_strIp=m_strIp;
            mailSettingView.m_strPort=m_strPort;
            mailSettingView.m_Pwd=m_strPwd;
            mailSettingView.m_User=m_strUser;
            mailSettingView.netUtiles=netUtiles;
            
            [self.navigationController pushViewController:mailSettingView animated:YES];
            
            [mailSettingView release];
        }
            break;
        case 6:
        {
            SDCardScheduleViewController *sdSettingView=[[SDCardScheduleViewController alloc]init];
            sdSettingView.m_pChannelMgt=m_pPPPPChannelMgt;
            sdSettingView.strDID=m_strDID;
            
            sdSettingView.isP2P=isP2P;
            sdSettingView.m_strIp=m_strIp;
            sdSettingView.m_strPort=m_strPort;
            sdSettingView.m_strPwd=m_strPwd;
            sdSettingView.m_strUser=m_strUser;
            sdSettingView.netUtiles=netUtiles;
            
            [self.navigationController pushViewController:sdSettingView animated:YES];
            [sdSettingView release];
        }
            break;
        case 7:
            [alertViewRestart show];
            
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}



@end
