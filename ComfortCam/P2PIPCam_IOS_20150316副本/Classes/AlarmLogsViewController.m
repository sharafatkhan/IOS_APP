//
//  AlarmLogsViewController.m
//  P2PCamera
//
//  Created by Tsang on 14-6-20.
//
//

#import "AlarmLogsViewController.h"
#import "PPPPDefine.h"
#import "IpCameraClientAppDelegate.h"
@interface AlarmLogsViewController ()

@end

@implementation AlarmLogsViewController
@synthesize navigationBar;
@synthesize mTableView;
@synthesize pPPPPChannelMgt;
@synthesize strDID;
@synthesize strName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    if (mArr!=nil) {
        [mArr removeAllObjects];
        [mArr release];
        mArr=nil;
    }
    pPPPPChannelMgt->SetAlarmLogsDelegate((char*)[strDID UTF8String], nil);
    self.strDID=nil;
    self.strName=nil;
    self.pPPPPChannelMgt=nil;

    [super dealloc];
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    mArr=[[NSMutableArray alloc]init];
    mainScreen=[[UIScreen mainScreen]bounds];
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    if (![IpCameraClientAppDelegate is43Version]) {
        [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
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
        mTableView.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
        
    }else{
        isIOS7=NO;
    }
    
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=mTableView.frame;
    imgView.center=mTableView.center;
    mTableView.backgroundView=imgView;
    [imgView release];
    NSLog(@"strDID=%@",strDID);
    
    if (pPPPPChannelMgt!=nil) {
         pPPPPChannelMgt->SetAlarmLogsDelegate((char*)[strDID UTF8String], self);
    }
   
    [self searchAlarmLogs];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark---UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify=@"cell";
    UITableViewCell *cell=[aTableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellSelectionStyleDefault reuseIdentifier:identify];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=[mArr objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:17];
    
    float cellHeight = cell.frame.size.height;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cellHeight - 1, mainScreen.size.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    cellBgView.backgroundColor=[UIColor clearColor];
    [cellBgView addSubview:label];
    if (isIOS7) {
        cell.backgroundView=cellBgView;
    }
    
    return cell;
}
-(void)ReloadTableView{
    [mTableView reloadData];
    [self stopSearchAlarmLogs];
}
#pragma mark--Refresh
- (void)showLoadingIndicator
{
    
    UINavigationItem *navigationItem1 = [[UINavigationItem alloc] initWithTitle:nil];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, TITLE_WITH, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= [NSString stringWithFormat:@"%@ %@",strName,NSLocalizedStringFromTable(@"alerm_push_log", @STR_LOCALIZED_FILE_NAME, nil)];
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
    
    navigationItem1.leftBarButtonItem=leftButton;
    
	UIActivityIndicatorView *indicator =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
     autorelease];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[UIBarButtonItem alloc] initWithCustomView:indicator];
    
    navigationItem1.rightBarButtonItem = progress;
    NSArray *array = [NSArray arrayWithObjects:navigationItem1, nil];
    [progress release];
    
    [self.navigationBar setItems:array];
    [navigationItem1 release];
    
    
}

- (void)hideLoadingIndicator
{
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, TITLE_WITH, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= [NSString stringWithFormat:@"%@ %@",strName,NSLocalizedStringFromTable(@"alerm_push_log", @STR_LOCALIZED_FILE_NAME, nil)];
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
    
    item.leftBarButtonItem=leftButton;
    
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"refresh_normal.png"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"refresh_pressed.png"] forState:UIControlStateHighlighted];
    btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
    btnRight.frame=CGRectMake(0,0,50,30);
    [btnRight addTarget:self action:@selector(btnRefresh:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *refreshButton =[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
    
    item.rightBarButtonItem = refreshButton;
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    
    [self.navigationBar setItems:array];
    [refreshButton release];
    [item release];
    [leftButton release];
}
-(void)btnRefresh:(id)sender{
   
    [mArr removeAllObjects];
    [mTableView reloadData];
    [self searchAlarmLogs];
}

-(void)searchAlarmLogs{
    [self showLoadingIndicator];
    pPPPPChannelMgt->PPPPSetSystemParams((char*)[strDID UTF8String], MSG_TYPE_GET_ALERM_LOG, NULL, 0);
    searchTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(stopSearchAlarmLogs) userInfo:nil repeats:NO];
}
-(void)stopSearchAlarmLogs{
    if (searchTimer!=NULL) {
        [searchTimer invalidate];
        searchTimer=nil;
    }
    [self hideLoadingIndicator];
}
#pragma mark--报警日志回调
-(void)CallbackAlarmLoglist:(NSInteger)year MON:(NSInteger)mon DAY:(NSInteger)day HOUR:(NSInteger)hour MIN:(NSInteger)min SEC:(NSInteger)sec ACTIONTYPE:(NSInteger)actiontype NCOUT:(NSInteger)ncout BEND:(NSInteger)bEnd{
    NSString *data = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",[self returnString:year],@"-",[self returnString:mon],@"-",[self returnString:day],@" ",[self returnString:hour],@":",[self returnString:min],@":",[self returnString:sec]];
    NSLog(@"%@",data);
    NSString *type = @" ";
    if (actiontype==1) {
        type=NSLocalizedStringFromTable(@"alerm_motion_alarm", @STR_LOCALIZED_FILE_NAME, nil);
    }else if(actiontype==2){
        type=NSLocalizedStringFromTable(@"alerm_gpio_alarm", @STR_LOCALIZED_FILE_NAME, nil);
    }else if (actiontype==3){
        type=NSLocalizedStringFromTable(@"alarm_audio_alarm", @STR_LOCALIZED_FILE_NAME, nil);
    }
    NSString *jilu = [NSString stringWithFormat:@"%@  %@",data,type];
    [mArr addObject:jilu];
    if (bEnd==1) {
        [self performSelectorOnMainThread:@selector(ReloadTableView) withObject:nil waitUntilDone:YES];
    }
}

-(NSString *)returnString:(NSInteger)inter{
    if (inter<10) {
        return [NSString stringWithFormat:@"%@%d",@"0",inter];
    }else{
        return [NSString stringWithFormat:@"%d",inter];
    }
}
@end
