//
//  WifiPwdViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WifiPwdViewController.h"
#import "WifiPwdCell.h"
#import "obj_common.h"
#import "IpCameraClientAppDelegate.h"
#include "CameraViewController.h"
#import "mytoast.h"
#import "SegmentCell.h"
@interface WifiPwdViewController ()

@end

@implementation WifiPwdViewController

@synthesize m_pChannelMgt;
@synthesize m_strSSID;
@synthesize m_channel;
@synthesize m_security;
@synthesize m_strDID;
@synthesize m_strPwd;
@synthesize textPassword;
@synthesize navigationBar;
@synthesize isP2P;
@synthesize m_strPort;
@synthesize m_strIp;
@synthesize m_User;
@synthesize m_Pwd;
@synthesize netUtiles;
@synthesize tableView;
@synthesize mSetResult;
@synthesize mModal;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        m_strSSID=@"";
        m_strPwd=@"";
    }
    return self;
}

- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mEncrypt=0;
    mKeyformat=0;
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    self.textPassword = nil;
    [self hideLoadingIndicator];

    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        
        CGRect tableFrm=tableView.frame;
        tableFrm.origin.y+=20;
        tableView.frame=tableFrm;
        self.view.backgroundColor=[UIColor blackColor];
        tableView.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
    }else{
        NSLog(@"less ios7");
        
    }
    
    m_pChannelMgt->SetResultDelegate((char*)[m_strDID UTF8String], self);
    
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    [imgView release];
}
- (void)showLoadingIndicator
{
    
    UINavigationItem *navigationItem1 = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"EnterPwd", @STR_LOCALIZED_FILE_NAME, nil)];
    
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 80, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= NSLocalizedStringFromTable(@"EnterPwd", @STR_LOCALIZED_FILE_NAME, nil);
    navigationItem1.titleView=labelTile;
    [labelTile release];
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    
    
	UIActivityIndicatorView *indicator =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
     autorelease];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[UIBarButtonItem alloc] initWithCustomView:indicator];
    
    navigationItem1.rightBarButtonItem = progress;
    navigationItem1.leftBarButtonItem=leftButton;
    NSArray *array = [NSArray arrayWithObjects: navigationItem1, nil];
    
    
    [self.navigationBar setItems:array];
    [leftButton release];
    [progress release];
    [navigationItem1 release];
    
}

- (void)hideLoadingIndicator
{
    
  
    NSString *strTitle = NSLocalizedStringFromTable(@"EnterPwd", @STR_LOCALIZED_FILE_NAME, nil);
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 80, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= NSLocalizedStringFromTable(@"EnterPwd", @STR_LOCALIZED_FILE_NAME, nil);
    item.titleView=labelTile;
    
    [labelTile release];
    //创建一个左边按钮
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
	
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
    [btnRight setTitle:NSLocalizedStringFromTable(@"wifijoin", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnRight.frame=CGRectMake(0,0,50,30);
    [btnRight addTarget:self action:@selector(btnSetWifi:) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    item.rightBarButtonItem = rightButton;
    item.leftBarButtonItem=leftButton;
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
	[leftButton release];
    [rightButton release];
    [item release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"statuschange" object:nil];
    
}
-(void)popToHome:(NSNotification *)notification{//回到首页
    NSString *did=(NSString *)[notification object];
    NSLog(@"did=%@ m_strDID=%@",did,m_strDID);
    if ([m_strDID  caseInsensitiveCompare:did]==NSOrderedSame) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
     m_pChannelMgt->SetResultDelegate((char*)[m_strDID UTF8String], nil);
    self.m_pChannelMgt = nil;
    self.textPassword = nil;
    self.m_strSSID = nil;
    self.m_strDID = nil;
    self.m_strPwd = nil;
    self.navigationBar = nil;
    
    [super dealloc];
}

- (void) btnSetWifi:(id)sender
{
    
    if (textPassword != nil) {
        [textPassword resignFirstResponder];
    }
    
    char *pkey = NULL;
    char *pwpa_psk = NULL;
    
    switch (m_security) {
        case 0: //none
            pkey = (char*)"";
            pwpa_psk = (char*)"";
            break;
        case 1: //wep
            pkey = (char*)[m_strPwd UTF8String];
            pwpa_psk = (char*)"";
            break;
        case 2: //wpa-psk(AES)
        case 3://wpa-psk(TKIP)
        case 4://wpa2-psk(AES)
        case 5://wpa3-psk(TKIP)
            pkey = (char*)"";
            pwpa_psk = (char*)[m_strPwd UTF8String];
            break;
        default:
            break;
    }
    
    
    if (isP2P) {
        NSLog(@"isP2P wifiset");
        isSetOver=NO;
        if (m_pChannelMgt!=nil) {
        [self showLoadingIndicator];
        NSString *encodedValue = (NSString*)CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                        (CFStringRef)m_strSSID, nil,
                                                                                        (CFStringRef)@"!*'();~:@&=+$,/?%#[]", kCFStringEncodingUTF8);
        NSLog(@"encodedValue=%@",encodedValue);
        m_pChannelMgt->SetWifi((char*)[m_strDID UTF8String], 1, (char*)[encodedValue UTF8String], m_channel, 0, m_security, mEncrypt, mKeyformat, 0, pkey, (char*)"", (char*)"", (char*)"", 0, 0, 0, 0, pwpa_psk);
        setTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:NO];
            
            
            
            //            if (nResult==1) {
//                [mytoast showWithText:NSLocalizedStringFromTable(@"wifisetsucc", @STR_LOCALIZED_FILE_NAME, nil)];
//                m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_REBOOT_DEVICE, NULL, 0);
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }else{
//                
//                 [mytoast showWithText:NSLocalizedStringFromTable(@"wifisetfail", @STR_LOCALIZED_FILE_NAME, nil)];
//            }
            
        }
        
    }else{
        if (netUtiles!=nil) {
            [netUtiles setWifi:m_strIp Port:m_strPort User:m_User Pwd:m_Pwd Enable:1 SSID:m_strSSID Channel:m_channel Mode:0 Authtype:m_security Encrypt:mEncrypt Keyformat:mKeyformat Defkey:0 Key1:[NSString stringWithUTF8String:pkey] Key2:@"" Key3:@"" Key4:@"" Key1_bits:0 Key2_bits:0 Key3_bits:0 Key4_bits:0 Wpa_psk:[NSString stringWithUTF8String:pwpa_psk]];
            
            [netUtiles setRoot:m_strIp Port:m_strPort CGI:@"" User:m_User Pwd:m_Pwd];
        }
        
    }
    
}
- (void)handleTimer
{
    isSetOver=YES;
    NSLog(@"handleTimer");
   
    [self hideLoadingIndicator];  
}
#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (m_security==1) {
        return 3;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 45;
    }else{
        return 54;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"\"%@\"",m_strSSID];
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = @"WifiPwdCell";
    UITableViewCell *cell=nil;
    switch (anIndexPath.row) {
        case 0:{
            WifiPwdCell *cell1 =  (WifiPwdCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WifiPwdCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.textPassword.delegate = self;
            cell1.lablePassword.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
            cell=cell1;
        }
            break;
        case 1:
        {
            cellIdentifier=@"cell2";
            SegmentCell *cell1=(SegmentCell *)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell1==nil) {
                UINib *nib=[UINib nibWithNibName:@"SegmentCell" bundle:nil];
                [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
                cell1=(SegmentCell *)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
            }
            cell1.label.text=NSLocalizedStringFromTable(@"wifipwdcheck", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.label.font=[UIFont boldSystemFontOfSize:17];
            [cell1.segment setTitle:NSLocalizedStringFromTable(@"wifipwdopen", @STR_LOCALIZED_FILE_NAME, nil) forSegmentAtIndex:0];
            [cell1.segment setTitle:NSLocalizedStringFromTable(@"wifipwdshare", @STR_LOCALIZED_FILE_NAME, nil) forSegmentAtIndex:1];
            
            cell1.segment.selectedSegmentIndex = 0;
            [cell1.segment addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
            cell1.segment.tag=1;
            cell=cell1;
        }
            break;
        case 2:
        {
            cellIdentifier=@"cell2";
            SegmentCell *cell1=(SegmentCell *)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell1==nil) {
                UINib *nib=[UINib nibWithNibName:@"SegmentCell" bundle:nil];
                [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
                cell1=(SegmentCell *)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
            }
            cell1.label.text=NSLocalizedStringFromTable(@"wifipwdkekformat", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.label.font=[UIFont boldSystemFontOfSize:17];
            [cell1.segment setTitle:NSLocalizedStringFromTable(@"kekformat16", @STR_LOCALIZED_FILE_NAME, nil) forSegmentAtIndex:0];
            [cell1.segment setTitle:NSLocalizedStringFromTable(@"kekformatAscci", @STR_LOCALIZED_FILE_NAME, nil) forSegmentAtIndex:1];
            
            cell1.segment.selectedSegmentIndex = 0;
            [cell1.segment addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
            cell1.segment.tag=2;
            cell=cell1;
        }
            break;
            
        default:
            break;
    }
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
}
-(void)segmentedChanged:(id)sender{
    UISegmentedControl *segmet=(UISegmentedControl *)sender;
    switch (segmet.tag) {
        case 1:
        {
            switch (segmet.selectedSegmentIndex) {
                case 0:
                    mEncrypt=0;//开放
                    NSLog(@"mEncrypt=%d",mEncrypt);
                    break;
                case 1:
                    mEncrypt=1;//共享
                    NSLog(@"mEncrypt=%d",mEncrypt);
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (segmet.selectedSegmentIndex) {
                case 0://16进制
                    mKeyformat=0;
                    NSLog(@"mKeyformat=%d",mKeyformat);
                    break;
                case 1://ascii
                    mKeyformat=1;
                    NSLog(@"mKeyformat=%d",mKeyformat);
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //NSLog(@"textFieldShouldBeginEditing");
    self.textPassword = textField;    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//NSLog(@"textFieldDidEndEditing");
    
    self.m_strPwd = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 64) {
        return NO;
    }
    
    return YES;
}
-(void)showResult{
    if (isSetOver) {
        return;
    }
    [setTimer invalidate];
    [self handleTimer];
    if (mSetResult==0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"wifisetsucc", @STR_LOCALIZED_FILE_NAME, nil)];
        if (mModal!=1) {
             m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_REBOOT_DEVICE, NULL, 0);
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [mytoast showWithText:NSLocalizedStringFromTable(@"wifisetfail", @STR_LOCALIZED_FILE_NAME, nil)];
    }
}
#pragma mark--SetResultDelegate
-(void)setResult:(int)nResult{
    NSLog(@"nResult=%d",nResult);
    mSetResult=nResult;
    [self performSelectorOnMainThread:@selector(showResult) withObject:nil waitUntilDone:NO];
}
#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}


@end
