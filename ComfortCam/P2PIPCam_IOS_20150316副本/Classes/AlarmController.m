//
//  AlarmController.m
//  P2PCamera
//
//  Created by mac on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AlarmController.h"
#import "obj_common.h"

#import "oSwitchCell.h"
#import "oLableCell.h"
#import "oTextCell.h"

#import "oDropController.h"
#import "oDropListStruct.h"
#import "IpCameraClientAppDelegate.h"
#import "mytoast.h"
@interface AlarmController ()

@end

@implementation AlarmController

@synthesize tableView;
@synthesize navigationBar;
@synthesize isSetOver;
@synthesize m_strDID;
@synthesize m_pChannelMgt;

@synthesize isP2P;
@synthesize m_strPort;
@synthesize m_strIp;
@synthesize m_strUser;
@synthesize m_strPwd;
@synthesize netUtiles;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) btnSetAlarm:(id)sender
{
    isSetOver=YES;
    //NSLog(@"m_ioin_level=%d m_ioout=%d",m_ioin_level,m_ioout_level);
    if (isP2P) {
        m_pChannelMgt->SetAlarm((char*)[m_strDID UTF8String],
                                m_motion_armed,
                                m_motion_sensitivity,
                                m_input_armed,
                                m_ioin_level,
                                m_alarmpresetsit,
                                m_iolinkage,
                                m_ioout_level,
                                m_mail,
                                m_upload_interval,
                                m_record,
                                enable_alarm_audio);
    }else{
        
        [netUtiles setAlarm:m_strIp
                       Port:m_strPort
                       User:m_strUser
                        Pwd:m_strPwd
                  MotionArm:m_motion_armed
          MotionSensitivity:m_motion_sensitivity
                 InputArmed:m_input_armed
                  IoinLevel:m_ioin_level
                     Preset:m_alarmpresetsit
                  Iolinkage:m_iolinkage
                 IooutLevel:m_ioout_level
                       Mail:m_mail
             UploadInterval:m_upload_interval
                     Record:m_record];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    NSString *strTitle = NSLocalizedStringFromTable(@"AlarmSetting", @STR_LOCALIZED_FILE_NAME, nil);
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 80, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= strTitle;
    item.titleView=labelTile;
    [labelTile release];
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
    [btnRight setTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
    btnRight.frame=CGRectMake(0,0,50,30);
    [btnRight addTarget:self action:@selector(btnSetAlarm:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    item.rightBarButtonItem = rightButton;
    item.leftBarButtonItem=leftButton;
    
    
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
        UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [titlelabel setText:strTitle];
        [titlelabel setTextColor:[UIColor whiteColor]];
        titlelabel.font=[UIFont boldSystemFontOfSize:18];
        item.titleView=titlelabel;
        [titlelabel release];
        tableView.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
    }else{
        NSLog(@"less ios7");
        
    }
    
    
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
    [rightButton release];
    [leftButton release];
    [item release];

 
    
    if (isP2P) {
        m_pChannelMgt->SetAlarmDelegate((char*)[m_strDID UTF8String], self);
        
        m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    }else{
        //netUtiles.alarmProtocol=self;
        [netUtiles getCameraParam:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd ParamType:5];
        
    }
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
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
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    m_pChannelMgt->SetAlarmDelegate((char*)[m_strDID UTF8String], nil);
    
}

- (void)dealloc
{
    if (isP2P) {
        m_pChannelMgt->SetAlarmDelegate((char*)[m_strDID UTF8String], nil);
    }else{
        netUtiles.alarmProtocol=nil;
    }
    
    self.m_strDID = nil;
    self.m_pChannelMgt = nil;
    self.tableView = nil;
    self.navigationBar = nil;
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"alarmcell%d",anIndexPath.row];
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //disable selected cell
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = anIndexPath.row;
    switch (row) {
        case 0: 
        {
            if (cell1 == nil)
            {
                NSArray *nib =nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionEnable", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_motion_armed>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionMotion_armed:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        break;
        case 1: 
        {
            if (cell1 == nil)
            {
                NSArray *nib = nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell_ipad" owner:self options:nil];
                }
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionLevel", @STR_LOCALIZED_FILE_NAME, nil);
            

            cell.DescriptionLable.text = [NSString stringWithFormat:@"%d",m_motion_sensitivity];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        break;
  
        case 2: 
        {
            if (cell1 == nil)
            {
                NSArray *nib =nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmExtern", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_input_armed>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionInput_armed:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 3: 
        {
            if (cell1 == nil)
            {
                NSArray *nib = nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell_ipad" owner:self options:nil];
                }
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmExternLevel", @STR_LOCALIZED_FILE_NAME, nil);
            cell.DescriptionLable.text = extern_level[m_ioin_level].strTitle;
            //[NSString stringWithFormat:@"%d", m_ioin_level];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break; 
        case 4: 
        {
            if (cell1 == nil)
            {
                NSArray *nib = nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell_ipad" owner:self options:nil];
                }
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionPreset", @STR_LOCALIZED_FILE_NAME, nil);
            if (m_alarmpresetsit==0) {
                
                cell.DescriptionLable.text =NSLocalizedStringFromTable(@"alarm_presetno", @STR_LOCALIZED_FILE_NAME, nil);
            }else{
            cell.DescriptionLable.text = [NSString stringWithUTF8String:motion_preset[m_alarmpresetsit].szName];
            }
            
           
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;

        case 5: 
        {
            if (cell1 == nil)
            {
                NSArray *nib =nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionIO", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_iolinkage>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionIolinkage:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 6: 
        {
            if (cell1 == nil)
            {
                NSArray *nib = nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell_ipad" owner:self options:nil];
                }
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionIOLevel", @STR_LOCALIZED_FILE_NAME, nil);
            cell.DescriptionLable.text = extern_level[m_ioout_level].strTitle;
            //NSString stringWithUTF8String:motion_preset[m_alarmpresetsit].szName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case 7: 
        {
            if (cell1 == nil)
            {
                NSArray *nib =nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMail", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_mail>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionMail:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 8: 
        {
            if (cell1 == nil)
            {
                NSArray *nib = nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell_ipad" owner:self options:nil];
                }
               
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmPicTimer", @STR_LOCALIZED_FILE_NAME, nil);
            cell.DescriptionLable.text = [NSString stringWithFormat:@"%d", m_upload_interval];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 9://alarm record
        {
            if (cell1 == nil)
            {
                NSArray *nib =nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmRecord", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_record>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionRecord:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 10:
        {
            if (cell1==nil) {
                NSArray *nib =nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"isEnableAlarmAudio", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(enable_alarm_audio>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchEnableAlarmAudio:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        default:
            break;
    }

	
	return cell1;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //[currentTextField resignFirstResponder];
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    
    switch (anIndexPath.row) {
        case 1:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 1;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];    
            [dpView release];
        }
            break;
        case 3:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 3;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];    
            [dpView release];
        }
            break;
        case 4:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 4;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];    
            [dpView release];
        }
            break;
        case 6:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 6;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];    
            [dpView release];
        }
        break;
        case 8:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 9;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];    
            [dpView release];
        }
            break;
    default:
    break;
    }
}

- (void) DropListResult:(NSString*)strDescription nID:(int)nID nType:(int)nType param1:(int)param1 param2:(int)param2
{
    if (nType == 1) {
        m_motion_sensitivity = nID;
    }
    if (nType == 3) {
        m_ioin_level = nID;
        //NSLog(@"m_ioin_level=%d",m_ioin_level);
    }  
    if (nType == 4) {
        m_alarmpresetsit = nID;
    }  
    if (nType == 6) {
        m_ioout_level = nID;
        //NSLog(@"m_ioout_level=%d",m_ioout_level);

    }  
    if (nType == 9) {
        m_upload_interval = nID;
    }

    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}
#pragma mark -
#pragma mark PerformInMainThread

- (void) reloadTableView:(id) param
{
    if (tableView!=nil) {
        [tableView reloadData];
    }
    
}



-(void)AlarmProtocolResult:(STRU_ALARM_PARAMS)t{
    if (isSetOver) {
        return;
    }
    
    m_motion_armed=t.motion_armed;
    m_motion_sensitivity = t.motion_sensitivity;
    
    m_input_armed = t.input_armed;
    m_ioin_level = t.ioin_level;
    
    m_alarmpresetsit = t.alarmpresetsit;
    m_iolinkage = t.iolinkage;
    m_ioout_level = t.ioout_level;
    
    m_mail = t.mail;
    m_snapshot = t.snapshot;
    m_upload_interval = t.upload_interval;
    
    m_record = t.record;
    enable_alarm_audio=t.enable_alarm_audio;
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}
- (void)switchActionMotion_armed:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_motion_armed = 1;   }else {     m_motion_armed = 0;       }
}
- (void)switchActionInput_armed:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_input_armed = 1;   }else {     m_input_armed = 0;       }
}
- (void)switchActionIolinkage:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_iolinkage = 1;   }else {     m_iolinkage = 0;       }
}
- (void)switchActionMail:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_mail = 1;   }else {     m_mail = 0;       }
}
- (void)switchActionSnapshot:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_snapshot = 1;   }else {     m_snapshot = 0;       }
}

- (void)switchActionRecord:(id) sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_record = 1;   }else {     m_record = 0;       }
    
}

-(void)switchEnableAlarmAudio:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        enable_alarm_audio = 1;
    }else {
        enable_alarm_audio = 0;
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
