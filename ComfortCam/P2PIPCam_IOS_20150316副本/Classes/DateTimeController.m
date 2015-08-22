//
//  DateTimeController.m
//  P2PCamera
//
//  Created by mac on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DateTimeController.h"
#import "obj_common.h"
#import "oDropListStruct.h"
#import "oDropController.h"
#import "oLableCell.h"
#import "oSwitchCell.h"
#import "IpCameraClientAppDelegate.h"

#import "mytoast.h"
#import "DateTimeTwoLabelCell.h"
@interface DateTimeController ()
{
    int xialishi;
}
@end



@implementation DateTimeController
@synthesize isSetOver;
@synthesize m_strDID;
@synthesize m_pChannelMgt;

@synthesize m_timingSever;

@synthesize dateTime;
@synthesize timeZone;
@synthesize timing;
@synthesize timingServer;

@synthesize tableView;
@synthesize navigationBar;

@synthesize isP2P;
@synthesize m_strPort;
@synthesize m_strIp;
@synthesize m_strUser;
@synthesize m_strPwd;
@synthesize netUtiles;
@synthesize strDate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_timingSever = @"";
        xialishi = 0;
    }
    return self;
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) btnSetDatetime:(id)sender
{
    isSetOver=YES;
    if (isP2P) {
        int result=m_pChannelMgt->SetDateTime((char*)[m_strDID UTF8String], 0, m_timeZone, m_Timing, (char*)[m_timingSever UTF8String],xialishi);
        NSLog(@"result:%d",result);
    }else{
        [netUtiles setDateTime:m_strIp Port:m_strPort Zone:m_timeZone NtpEnable:m_Timing NtpServer:m_timingSever Now:0 User:m_strUser Pwd:m_strPwd];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    
    NSString *strTitle = NSLocalizedStringFromTable(@"ClockSetting", @STR_LOCALIZED_FILE_NAME, nil);
    
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
    [btnRight addTarget:self action:@selector(btnSetDatetime:) forControlEvents:UIControlEventTouchUpInside];
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
        m_pChannelMgt->SetDateTimeDelegate((char*)[m_strDID UTF8String], self);
        m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    }else{
//        netUtiles.dateProtocol=self;
        [netUtiles getCameraParam:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd ParamType:4];
        
    }
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    [imgView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //m_pChannelMgt->SetDateTimeDelegate((char*)[m_strDID UTF8String], nil);
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
- (void) dealloc
{
    if (netUtiles!=nil) {
        netUtiles.dateProtocol=nil;
    }
    if (m_pChannelMgt!=nil) {
        m_pChannelMgt->SetDateTimeDelegate((char*)[m_strDID UTF8String], nil);
    }
    
    self.m_strDID = nil;
    self.m_pChannelMgt = nil;
    self.m_timingSever = nil;
    self.dateTime = nil;
    self.timing = nil;
    self.timingServer = nil;
    self.tableView = nil;
    self.navigationBar = nil;
    strDate=nil;
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = @"datetime";
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //disable selected cell
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = anIndexPath.row;
    switch (row) {
        case 0:
        {
            
            if (cell1 == nil)
            {
                NSArray *nib;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"DateTimeTwoLabelCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"DateTimeTwoLabelCell_ipad" owner:self options:nil];
                }
                
                cell1 = [nib objectAtIndex:0];
            }
            DateTimeTwoLabelCell * cell = (DateTimeTwoLabelCell*)cell1;
            cell.labelname.text = NSLocalizedStringFromTable(@"datetimeDeviceTime", @STR_LOCALIZED_FILE_NAME, nil);
            
            //            time_t t = (m_dateTime-m_timeZone)*1000;
            //            cell.DescriptionLable.text = [NSString stringWithUTF8String:ctime(&t)];
            
            cell.labelvalue.text = strDate;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }
            break;
        case 1:
        {
            if (cell1 == nil)
            {
                NSArray *nib;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"DateTimeTwoLabelCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"DateTimeTwoLabelCell_ipad" owner:self options:nil];
                }
                cell1 = [nib objectAtIndex:0];
            }
            DateTimeTwoLabelCell * cell = (DateTimeTwoLabelCell*)cell1;
            cell.labelname.text = NSLocalizedStringFromTable(@"datetimeDeviceTimezone", @STR_LOCALIZED_FILE_NAME, nil);
            
            
            cell.labelvalue.text = [self get_time_zone_des:m_timeZone];
            
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
            cell.keyLable.text = NSLocalizedStringFromTable(@"DaylightSavingTime", @STR_LOCALIZED_FILE_NAME, nil);
            //[cell.keySwitch setOn:NO];
            switch (xialishi) {
                case 1:
                    [cell.keySwitch setOn:YES];
                    break;
                case 0:
                    [cell.keySwitch setOn:NO];
                    
                    break;
                default:
                    break;
            }
            
            [cell.keySwitch addTarget:self action:@selector(switchAction1:) forControlEvents:UIControlEventValueChanged];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
            
        case 3:
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
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTiming", @STR_LOCALIZED_FILE_NAME, nil);
            //[cell.keySwitch setOn:NO];
            switch (m_Timing) {
                case 1:
                    [cell.keySwitch setOn:YES];
                    break;
                case 0:
                    [cell.keySwitch setOn:NO];
                    
                    break;
                default:
                    break;
            }
            
            [cell.keySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 4:
        {
            if (cell1 == nil)
            {
                NSArray *nib;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"DateTimeTwoLabelCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"DateTimeTwoLabelCell_ipad" owner:self options:nil];
                }
                
                cell1 = [nib objectAtIndex:0];
            }
            DateTimeTwoLabelCell * cell = (DateTimeTwoLabelCell*)cell1;
            cell.labelname.text = NSLocalizedStringFromTable(@"datetimeDeviceTimingServer", @STR_LOCALIZED_FILE_NAME, nil);
            // cell.textLabel.placeholder = NSLocalizedStringFromTable(@"InputUserName", @STR_LOCALIZED_FILE_NAME, nil);
            
            cell.labelvalue.text = self.m_timingSever;
            //[cell.textLabel setEnabled: NO];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
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
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTimeLocal", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionlocal:) forControlEvents:UIControlEventValueChanged];
            
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
    //    [currentTextField resignFirstResponder];
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    
    switch (anIndexPath.row) {
        case 1:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 102;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
            [dpView release];
        }
            break;
        case 3:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 101;
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
    if (nType == 101) {
        m_timingSever = strDescription;
    }
    if (nType == 102) {
        m_timeZone = nID;
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

- (NSString *) get_time_zone_des:(int) nID
{
    for (int i=0; i<29; i++) {
        if (time_zone[i].index == nID) {
            return time_zone[i].strTitle;
        }
    }
    return  @"";
}
- (void)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        m_Timing = 1;
    }else {
        m_Timing = 0;
    }
}
- (void)switchAction1:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        xialishi = 1;
    }else {
        xialishi = 0;
    }
}
- (void)switchActionlocal:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        //设置时间
        NSTimeZone *zone = [NSTimeZone localTimeZone];//获得当前应用程序默认的时区
        //NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
        NSInteger interval = -[zone secondsFromGMT];
        NSDate *date=[NSDate date];
        NSTimeInterval now=[date timeIntervalSince1970];
        //        time(0)/1000
        NSLog(@"interval=%d",interval);
        if (isP2P) {
            m_pChannelMgt->SetDateTime((char*)[m_strDID UTF8String], now, interval, m_Timing, (char*)[m_timingSever UTF8String],xialishi);
        }else{
            
            [netUtiles setDateTime:m_strIp Port:m_strPort Zone:interval NtpEnable:m_Timing NtpServer:m_timingSever Now:now User:m_strUser Pwd:m_strPwd];
        }
        
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)getDeviceTime{
    //得到指定的时区
    NSTimeZone *tz=[NSTimeZone timeZoneForSecondsFromGMT:m_timeZone];
    NSCalendar *ca=[NSCalendar currentCalendar];

    NSTimeInterval se=(long)m_dateTime;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDate *dd=[date dateByAddingTimeInterval:-m_timeZone];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeZone:tz];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"strD=%@",[formatter stringFromDate:dd]);
    NSString *strD=[dd description];
     NSLog(@"strD=%@",strD);
    NSRange yR=NSMakeRange(0, 4);
    NSString *strYear=[strD substringWithRange:yR];
    NSRange mR=NSMakeRange(5, 2);
    NSString *month=[strD substringWithRange:mR];
    NSRange dR=NSMakeRange(8, 2);
    NSString *day=[strD substringWithRange:dR];
    NSRange tR=NSMakeRange(10, 9);
    NSString *strTime=[strD substringWithRange:tR];
    NSLog(@"strTime=%@",strTime);
    int m=[month intValue];
    int d=[day intValue];
    NSString *strMon=nil;
    switch (m) {
        case 1:
            
            strMon=NSLocalizedStringFromTable(@"datetime_jan", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 2:
           strMon=NSLocalizedStringFromTable(@"datetime_Feb", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 3:
            strMon=NSLocalizedStringFromTable(@"datetime_Mar", @STR_LOCALIZED_FILE_NAME, nil);
           
            break;
        case 4:
            strMon=NSLocalizedStringFromTable(@"datetime_Apr", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 5:
            strMon=NSLocalizedStringFromTable(@"datetime_May", @STR_LOCALIZED_FILE_NAME, nil);
           
            break;
        case 6:
            strMon=NSLocalizedStringFromTable(@"datetime_Jun", @STR_LOCALIZED_FILE_NAME, nil);
           
            break;
        case 7:
            strMon=NSLocalizedStringFromTable(@"datetime_Jul", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 8:
            strMon=NSLocalizedStringFromTable(@"datetime_Aug", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 9:
            strMon=NSLocalizedStringFromTable(@"datetime_Sept", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 10:
            strMon=NSLocalizedStringFromTable(@"datetime_Oct", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 11:
             strMon=NSLocalizedStringFromTable(@"datetime_Nov", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 12:
            strMon=NSLocalizedStringFromTable(@"datetime_Dec", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
            
    }

    NSDateComponents *dateComp=[ca components:NSWeekdayCalendarUnit fromDate:date];
    
    int week=[dateComp weekday];
    NSString *strW=nil;
    switch (week) {
        case 1:
            strW=NSLocalizedStringFromTable(@"datetime_Sun", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 2:
            strW=NSLocalizedStringFromTable(@"datetime_Mon", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 3:
            strW=NSLocalizedStringFromTable(@"datetime_Tue", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 4:
            strW=NSLocalizedStringFromTable(@"datetime_Wed", @STR_LOCALIZED_FILE_NAME, nil);
          
            break;
        case 5:
            strW=NSLocalizedStringFromTable(@"datetime_Thu", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 6:
            strW=NSLocalizedStringFromTable(@"datetime_Fri", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
        case 7:
            strW=NSLocalizedStringFromTable(@"datetime_Sat", @STR_LOCALIZED_FILE_NAME, nil);
            
            break;
            
    }
    ;
    
    strDate=[[NSString alloc] initWithFormat:@"%@ %d %@ %@ %@",strW,d,strMon,strYear,strTime];
    
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}

-(void)DateTimeProtocolResult:(STRU_DATETIME_PARAMS)t{
    xialishi = t.xia_ling_shi_flag_status;
    m_timeZone=t.tz;
    m_dateTime=t.now;
    m_Timing=t.ntp_enable;
    self.m_timingSever=[NSString stringWithUTF8String:t.ntp_svr];
    NSLog(@"xia_ling_shi_flag_status[%d]",xialishi);
    [self getDeviceTime];
}
#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}
@end
