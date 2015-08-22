//
//  oDropController.m
//  P2PCamera
//
//  Created by mac on 12-10-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "oDropController.h"
#import "oDropListCell.h"
#import "obj_common.h"
#import "oDropListStruct.h"
#import "IpCameraClientAppDelegate.h"
@interface oDropController ()

@end

@implementation oDropController

@synthesize tableView;
@synthesize navigationBar;
@synthesize m_nIndexDrop;
@synthesize m_DropListProtocolDelegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_nIndexDrop = 3;
        m_DropListProtocolDelegate = nil;
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
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    NSString *strTitle = @"";
    
    switch (m_nIndexDrop) {
        case 1: //motion level
            strTitle = NSLocalizedStringFromTable(@"DropListMotionLevel", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 3: //trigger level
            strTitle = NSLocalizedStringFromTable(@"DropListTriggerLevel", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 4: //preset
            strTitle = NSLocalizedStringFromTable(@"DropListPreset", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 6: //output level
            strTitle = NSLocalizedStringFromTable(@"DropListOutputLevel", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 9: //ftp upload interval
            strTitle = NSLocalizedStringFromTable(@"DropListUploadInterval", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 101: //ntp server
            strTitle = NSLocalizedStringFromTable(@"DropListNtpServer", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 102: //time zone
            strTitle = NSLocalizedStringFromTable(@"DropListTimeZone", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 103: //mail ssl
            strTitle = @"SSL";
            break;
        case 104: //smtp server
            strTitle = NSLocalizedStringFromTable(@"MailSmtpSvr", @STR_LOCALIZED_FILE_NAME, nil);
            break;
            
        default:
            break;
    }
    
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
    }else{
        NSLog(@"less ios7");
        
    }
    
    
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
    [leftButton release];
    [item release];
    
    
   
    
    tableView.delegate=self;
    tableView.dataSource=self;
    
    
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
    if (m_nIndexDrop == 1) {return 10;}
    if (m_nIndexDrop == 3) {return 2;}
    if (m_nIndexDrop == 6) {return 2;}
    if (m_nIndexDrop == 4) {return 17;}
    if (m_nIndexDrop == 9) {return 30;}
    if (m_nIndexDrop==10)  {return  24;}
    if (m_nIndexDrop==11)  {return  24;}
    if (m_nIndexDrop == 101) {return 4;}
    if (m_nIndexDrop == 102) {return 29;}
    if (m_nIndexDrop == 103) {return 3;}//ssl
    if (m_nIndexDrop == 104) {return 12 ;} //smtp server
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = @"droplistcell";
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //disable selected cell
    //cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell1 == nil)
    {
        NSArray *nib;
        if ([IpCameraClientAppDelegate isiPhone]) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"oDropListCell" owner:self options:nil];
        }else{
            nib = [[NSBundle mainBundle] loadNibNamed:@"oDropListCell_ipad" owner:self options:nil];
        }
    
        cell1 = [nib objectAtIndex:0];
    }

    
    if (m_nIndexDrop == 1) { //motion level
               
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text =[[[NSString alloc] initWithUTF8String:_motion_level[anIndexPath.row].szName] autorelease];
        
//        [NSString initWithUTF8String: _motion_level[anIndexPath.row].szName];
        cell.keyLable.textAlignment = UITextAlignmentCenter;
        
        return cell1;
    }
    
    if ((m_nIndexDrop == 3)||(m_nIndexDrop == 6)) { //trigger level -- output level

        
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = extern_level[anIndexPath.row].strTitle;
        cell.keyLable.textAlignment = UITextAlignmentCenter;
        
        return cell1;
    }
    
    if (m_nIndexDrop == 4) { //preset
                
        oDropListCell * cell = (oDropListCell*)cell1;
        if (anIndexPath.row==0) {
             cell.keyLable.text =NSLocalizedStringFromTable(@"alarm_presetno", @STR_LOCALIZED_FILE_NAME, nil);
        }else{
         cell.keyLable.text = [[[NSString alloc] initWithUTF8String:motion_preset[anIndexPath.row].szName] autorelease];;
        }
       
        cell.keyLable.textAlignment = UITextAlignmentCenter;
        
        return cell1;
    }
    
    if (m_nIndexDrop == 9) { //ftp upload interval
      
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = [[[NSString alloc] initWithUTF8String:pic_timer[anIndexPath.row].szName] autorelease];;
        cell.keyLable.textAlignment = UITextAlignmentCenter;
        
        return cell1;
    }
    
    if (m_nIndexDrop==10) {
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = [[[NSString alloc] initWithUTF8String:sdcard_recordtime_start[anIndexPath.row].szName] autorelease];;
        cell.keyLable.textAlignment = UITextAlignmentCenter;
        
        return cell1;
    }
    if (m_nIndexDrop == 11) {
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = [[[NSString alloc] initWithUTF8String:sdcard_recordtime_end[anIndexPath.row].szName] autorelease];;
        cell.keyLable.textAlignment = UITextAlignmentCenter;
        
        return cell1;
    }
    
    if (m_nIndexDrop == 101) { //ntp server
      
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = ntp_server[anIndexPath.row].strValue;
        
        return cell1;
    }
    
    if (m_nIndexDrop == 102) { //time zone
       
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = time_zone[anIndexPath.row].strTitle;
        
        return cell1;
    }
    
    if (m_nIndexDrop == 103) { // ssl
        oDropListCell * cell = (oDropListCell*)cell1;
        switch (anIndexPath.row) {
            case 0:
                cell.keyLable.text = NSLocalizedStringFromTable(@"MailNone", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 1:
                cell.keyLable.text = NSLocalizedStringFromTable(@"MailSSL", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 2:
                cell.keyLable.text = NSLocalizedStringFromTable(@"MailTLS", @STR_LOCALIZED_FILE_NAME, nil);
                break;
                
            default:
                break;
        }
        
        return cell1;
    }
    
    if (m_nIndexDrop == 104) { //smtp server
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = [NSString stringWithFormat:@"%s",smtp_svr[anIndexPath.row].szName];
        return cell1;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //    [currentTextField resignFirstResponder];
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    if (m_nIndexDrop == 1)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:_motion_level[anIndexPath.row].strValue
                                                   nID:_motion_level[anIndexPath.row].index  
                                                 nType:1 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 3)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:extern_level[anIndexPath.row].strTitle
                                                   nID:extern_level[anIndexPath.row].index  
                                                 nType:3 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 4)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:motion_preset[anIndexPath.row].strTitle
                                                   nID:motion_preset[anIndexPath.row].index  
                                                 nType:4 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 6)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:extern_level[anIndexPath.row].strTitle
                                                   nID:extern_level[anIndexPath.row].index  
                                                 nType:6 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 9)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:pic_timer[anIndexPath.row].strValue
                                                   nID:pic_timer[anIndexPath.row].index  
                                                 nType:9 param1:0 param2:0]
            ;
        }
    }
    
    
    if (m_nIndexDrop==10||m_nIndexDrop==11) {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:@""
                                                   nID:anIndexPath.row                                                 nType:m_nIndexDrop param1:0 param2:0]
            ;
        }
    }
    
    if (m_nIndexDrop==11) {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:@""
                                                   nID:anIndexPath.row+1                                                 nType:m_nIndexDrop param1:0 param2:0]
            ;
        }
    }

    
    if (m_nIndexDrop == 101)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:ntp_server[anIndexPath.row].strValue
                                                   nID:0 
                                                 nType:101 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 102)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:time_zone[anIndexPath.row].strTitle
                                                   nID:time_zone[anIndexPath.row].index  
                                                 nType:102 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 103) //ssl
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:[NSString stringWithFormat:@"%s",ssl[anIndexPath.row].szName]
                                                   nID:ssl[anIndexPath.row].index
                                                 nType:m_nIndexDrop
                                                param1:0
                                                param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 104) //smtp server
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:[NSString stringWithFormat:@"%s",smtp_svr[anIndexPath.row].szName]
                                                   nID:smtp_svr[anIndexPath.row].index
                                                 nType:m_nIndexDrop
                                                param1:smtp_svr[anIndexPath.row].param1
                                                param2:smtp_svr[anIndexPath.row].param2]
            ;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

@end
