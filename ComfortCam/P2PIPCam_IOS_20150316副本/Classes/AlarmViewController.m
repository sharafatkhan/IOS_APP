//
//  AlarmViewController.m
//  P2PCamera
//
//  Created by Tsang on 14-6-18.
//
//

#import "AlarmViewController.h"
#import "CameraListCell.h"
#import "PPPPDefine.h"
#import "IpCameraClientAppDelegate.h"
#import "AlarmLogsViewController.h"
@interface AlarmViewController ()

@end

@implementation AlarmViewController
@synthesize navigationBar;
@synthesize mTableView;
@synthesize m_pCameraListMgt;
@synthesize pPPPPChannelMgt;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"alarmview_title", @STR_LOCALIZED_FILE_NAME, nil);
        self.tabBarItem.image = [UIImage imageNamed:@"alarm30.png"];
    }
    return self;
}
-(void)dealloc{
    if (navigationBar!=nil) {
        [navigationBar release];
        navigationBar=nil;
    }
    
    if (mTableView!=nil) {
        [mTableView release];
        mTableView=nil;
    }
    m_pCameraListMgt=nil;
    pPPPPChannelMgt=nil;
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    isScreenOnForeground=YES;
}
-(void)viewWillAppear:(BOOL)animated{
    ///NSLog(@"viewWillAppear  alarmNumber=%d",alarmNumber);
    [self reloadTableView];
    
    int alNu=[m_pCameraListMgt getAlarmNumber];
    NSLog(@"viewWillAppear...alNu=%d",alNu);
    if (alNu<=0) {
        self.tabBarItem.badgeValue=nil;
    }else{
        self.tabBarItem.badgeValue=@"";
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    isScreenOnForeground=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainScreen=[[UIScreen mainScreen]bounds];
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    if (![IpCameraClientAppDelegate is43Version]) {
        [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    UINavigationItem *navigationItem1 = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"alarmview_title", @STR_LOCALIZED_FILE_NAME, nil)];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, TITLE_WITH, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= NSLocalizedStringFromTable(@"alarmview_title", @STR_LOCALIZED_FILE_NAME, nil);
    navigationItem1.titleView=labelTile;
    [labelTile release];
    NSArray *array = [NSArray arrayWithObjects:navigationItem1, nil];
    [self.navigationBar setItems:array];
    
    [navigationItem1 release];
    
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:navigationBar];
        
        CGRect tableFrm=mTableView.frame;
        tableFrm.origin.y+=20;
        mTableView.frame=tableFrm;
        self.view.backgroundColor=[UIColor blackColor];
        isIOS7=YES;
        mTableView.contentInset=UIEdgeInsetsMake(-10, 0, 0, 0);
        
    }else{
        isIOS7=NO;
    }
    
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=mTableView.frame;
    imgView.center=mTableView.center;
    mTableView.backgroundView=imgView;
    [imgView release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark--UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    return 74;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [m_pCameraListMgt GetCount];
    return count;
}
-(UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int index=indexPath.row;
    NSDictionary *cameraDic =[m_pCameraListMgt GetCameraAtIndex:index];
    NSString *name =[cameraDic objectForKey:@STR_NAME];
    UIImage *img =[cameraDic objectForKey:@STR_IMG];
    NSNumber *nPPPPStatus =[cameraDic objectForKey:@STR_PPPP_STATUS];
    NSString *did =[cameraDic objectForKey:@STR_DID];
    NSNumber *alarm=[cameraDic objectForKey:@STR_ALARM];
    BOOL isAlarm=[alarm boolValue];
    NSLog(@"tablecell....isAlarm=%d",isAlarm);
    
    NSString *cellIdentifier = @"CameraListCell";
    //当状态为显示当前的设备列表信息时
    CameraListCell *cell =  (CameraListCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        UINib *nib=[UINib nibWithNibName:@"CameraListCell" bundle:nil];
        [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell =  (CameraListCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    int PPPPStatus = [nPPPPStatus intValue];
    if (img != nil) {
        cell.imageCamera.image = img;
    }else{
        cell.imageCamera.image= [UIImage imageNamed:@"back.png"];
    }
    cell.NameLable.text = name;
    cell.PPPPIDLable.text = did;
    
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
    
    
    NSString *strPPPPStatus = nil;
    switch (PPPPStatus) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus= NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_LAN:
            strPPPPStatus= NSLocalizedStringFromTable(@"PPPPStatusLanOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_WLAN:
            strPPPPStatus= NSLocalizedStringFromTable(@"PPPPStatusWLanOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    cell.PPPPStatusLable.text = strPPPPStatus;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 30, 30);
    if (isAlarm) {
        [btn setImage:[UIImage imageNamed:@"alarm_icon.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"alarm_icon.png"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"alarm_icon.png"] forState:UIControlStateSelected];
       
       
    }else{
        [btn setImage:[UIImage imageNamed:@"playright.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"playright.png"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"playright.png"] forState:UIControlStateSelected];
    }
    cell.accessoryView=btn;
  
    return cell;
}

-(void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"AlarmViewController....didSelectRowAtIndexPath...row=%d",indexPath.row);
    NSDictionary *cameraDic =[m_pCameraListMgt GetCameraAtIndex:indexPath.row];
    NSString *name =[cameraDic objectForKey:@STR_NAME];
    NSNumber *nPPPPStatus =[cameraDic objectForKey:@STR_PPPP_STATUS];
    NSString *did =[cameraDic objectForKey:@STR_DID];
    
    if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
        return;
    }
    if ([nPPPPStatus intValue]==PPPP_STATUS_CONNECTING) {
        return;
    }
    
    if ([nPPPPStatus intValue] != PPPP_STATUS_LAN&&[nPPPPStatus intValue] != PPPP_STATUS_WLAN) {
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
        //pPPPPChannelMgt->Stop([strDID UTF8String]);
        pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
        
        return;
    }
    [m_pCameraListMgt UpdateCameraAlarmStatus:did AlarmStatus:NO];
    
    AlarmLogsViewController *alarmLog=[[AlarmLogsViewController alloc]init];
    alarmLog.pPPPPChannelMgt=pPPPPChannelMgt;
    alarmLog.strDID=did;
    alarmLog.strName=name;
    [self.navigationController pushViewController:alarmLog animated:YES];
    [alarmLog release];
    
}
#pragma mark--刷新TableView
-(void)reloadTableView{
    
    [mTableView reloadData];
}
#pragma mark---NotifyEventProtocol
- (void) NotifyReloadData{
    
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}

-(void)apsNotify:(NSString *)did{
    NSLog(@"apsNotify.....did=%@",did);
    self.tabBarItem.badgeValue=@"";
    BOOL b=[m_pCameraListMgt UpdateCameraAlarmStatus:did AlarmStatus:YES];
    if (b) {
       
        [self reloadTableView];
    }else{
        NSLog(@"updateCamera NO");
    }

}

#pragma mark---比对报警设备ID，修改设备的抱紧状态
-(void)changeAlarmStatus:(NSString*)did Alarm:(BOOL)flag{
    BOOL b=[m_pCameraListMgt UpdateCameraAlarmStatus:did AlarmStatus:flag];
    if (b) {
       // [self reloadTableView];
    }else{
        NSLog(@"updateCamera NO");
    }
}

@end
