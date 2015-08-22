//
//  RemoteRecordFileListViewController.m
//  P2PCamera
//
//  Created by Tsang on 12-12-14.
//
//

#import "RemoteRecordFileListViewController.h"
#import "obj_common.h"
#import "defineutility.h"
#import "RemotePlaybackViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "mytoast.h"
#define STR_RECORD_FILE_NAME "STR_RECORD_FILE_NAME"
#define STR_RECORD_FILE_SIZE "STR_RECORD_FILE_SIZE"

@interface RemoteRecordFileListViewController ()

@end

@implementation RemoteRecordFileListViewController
@synthesize navigationBar;
@synthesize tableView;
@synthesize m_pPPPPChannelMgt;
@synthesize m_strDID;
@synthesize m_strName;

@synthesize mModal;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_CurAllDic=[[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) refresh:(id)param
{
    [m_RecordFileList removeAllObjects];
    [self showLoadingIndicator];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    [self ReloadTableView];
    isSDcardPage=1;
    m_pPPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[m_strDID UTF8String],mPageTime, 0,128);
    
    m_bFinished = NO;
    
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
    //[m_timerLock lock];
    if (m_timer != nil) {
        [m_timer invalidate];
        m_timer = nil;
    }
    //[m_timerLock unlock];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    mPageTime=0;
    isSDcardPage=1;
    mainScreen=[[UIScreen mainScreen]bounds];
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    //NSLog(@"WifiSettingViewController viewDidLoad");
    m_timerLock = [[NSCondition alloc] init];
    
    m_bFinished = NO;
    m_RecordFileList = [[NSMutableArray alloc] init];
    
    [self showLoadingIndicator];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    m_pPPPPChannelMgt->SetSDCardOver((char*)[m_strDID UTF8String], 0);
    m_pPPPPChannelMgt->SetSDCardSearchDelegate((char*)[m_strDID UTF8String], self);
    
    m_pPPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[m_strDID UTF8String],mPageTime, 0, 128);
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [imgView release];
    
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
        tableView.contentInset=UIEdgeInsetsMake(-20, 0, 0, 0);
    }else{
        NSLog(@"less ios7");
        
    }
    
}

- (void) viewDidUnload
{
    
    [super viewDidUnload];
    
    if (m_RecordFileList != nil) {
        [m_RecordFileList release];
        m_RecordFileList = nil;
    }
    
    m_pPPPPChannelMgt->SetSDCardSearchDelegate((char*)[m_strDID UTF8String], nil);
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
    [self StopTimer];
    NSLog(@"viewWillDisappear");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"statuschange" object:nil];
    
}
-(void)popToHome:(NSNotification *)notification{//回到首页
    NSString *did=(NSString *)[notification object];
    NSLog(@"did=%@ m_strDID=%@",did,m_strDID);
    if ([m_strDID  caseInsensitiveCompare:did]==NSOrderedSame) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        //[mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
    }
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showLoadingIndicator
{
    NSString *strTitle = m_strName;
    
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
    //创建一个右边按钮
    UIActivityIndicatorView *indicator =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
     autorelease];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[[UIBarButtonItem alloc] initWithCustomView:indicator] autorelease];
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    item.leftBarButtonItem=leftButton;
    
    item.rightBarButtonItem = progress;
    
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
	
    [item release];
    
    [leftButton release];
}

- (void)hideLoadingIndicator
{
    NSString *strTitle = m_strName;
    
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
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"refresh_normal.png"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"refresh_pressed.png"] forState:UIControlStateHighlighted];
    //[btnRight setTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
    btnRight.frame=CGRectMake(0,0,50,30);
    [btnRight addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *refreshButton =[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    item.leftBarButtonItem=leftButton;
    item.rightBarButtonItem = refreshButton;
    
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
	
    [refreshButton release];
    [item release];
    [leftButton release];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self StopTimer];
    m_pPPPPChannelMgt->SetSDCardOver((char*)[m_strDID UTF8String], 1);
    m_pPPPPChannelMgt->SetSDCardSearchDelegate((char*)[m_strDID UTF8String], nil);
    self.navigationBar = nil;
    self.tableView = nil;
    self.m_strDID = nil;
    self.m_strName = nil;
    if (m_RecordFileList != nil) {
        [m_RecordFileList release];
        m_RecordFileList = nil;
    }
    if (m_CurAllDic!=nil) {
        [m_CurAllDic removeAllObjects];
        [m_CurAllDic release];
        m_CurAllDic=nil;
    }
    [super dealloc];
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDictionary *dic=(NSDictionary *)[m_RecordFileList objectAtIndex:section];
    NSString *flag=[dic objectForKey:@"flag"];
    NSString *date=[dic objectForKey:@"date"];
    if ([flag isEqualToString:@"1"]) {
        NSLog(@"打开section=%d",section);
        NSMutableArray *arr=(NSMutableArray *)[m_CurAllDic objectForKey:date];
        return [arr count];
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
      return [m_RecordFileList count];
}
- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreen.size.width, 50)] autorelease];
    headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
//    UIImageView *imgV=[[UIImageView alloc]init];
//    imgV.frame=CGRectMake(0, 0, mainScreen.size.width, 50);
//    imgV.userInteractionEnabled=YES;
//    imgV.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud.png"]];
//    [headerView addSubview:imgV];
    
    UILabel *line=[[UILabel alloc] init];
    line.frame=CGRectMake(0, 49, mainScreen.size.width, 1);
    line.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:line];
    [line release];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 200,50)];
    
    NSDictionary *dic=(NSDictionary*)[m_RecordFileList objectAtIndex:section];
    label1.text=[dic objectForKey:@"date"];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.backgroundColor=[UIColor clearColor];
    [headerView addSubview:label1];
    [label1 release];
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(mainScreen.size.width-80, 0, 70, 50)];
    label2.textAlignment=UITextAlignmentRight;
    NSMutableArray *arr=(NSMutableArray *)[m_CurAllDic objectForKey:[dic objectForKey:@"date"]];
    
    
    label2.text=[NSString stringWithFormat:@"%d",arr.count];
    label2.backgroundColor=[UIColor clearColor];
    [headerView addSubview:label2];
    [label2 release];
    headerView.tag=section;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)];
    [headerView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    return headerView;
}
-(void)headerTap:(UITapGestureRecognizer *)theTap{
    UIView *view=theTap.view;
    view.backgroundColor=[UIColor blackColor];
    int index=view.tag;
    
    NSDictionary *dic=(NSDictionary*)[m_RecordFileList objectAtIndex:index];
    NSString *date=[dic objectForKey:@"date"];
    NSString *flag=[dic objectForKey:@"flag"];
    if ([flag isEqualToString:@"1"]) {
        flag=@"0";
    }else{
        flag=@"1";
    }
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:date,@"date",flag,@"flag", nil];
    [m_RecordFileList replaceObjectAtIndex:index withObject:dic2];
    
     [tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];

}
- (UITableViewCell *) tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");
    
    NSString *cellIdentifier = @"RemoteRecordFileListCell";
    UITableViewCell *cell =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    
    NSDictionary *fileDic = [m_RecordFileList objectAtIndex:anIndexPath.section];
    NSString *key=[fileDic objectForKey:@"date"];
    NSMutableArray *arr=(NSMutableArray *)[m_CurAllDic objectForKey:key];
    NSDictionary *dic=(NSDictionary *)[arr objectAtIndex:anIndexPath.row];
    cell.textLabel.text = [dic objectForKey:@STR_RECORD_FILE_NAME];
    
    float cellHeight = cell.frame.size.height;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cellHeight - 1, mainScreen.size.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    cellBgView.backgroundColor=[UIColor clearColor];
    [cellBgView addSubview:label];
    cell.backgroundView=cellBgView;
    [label release];
    [cellBgView release];
    
    
    return cell;
    
}

//- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
//{
//    return 100 + 5;
//}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    
    NSDictionary *fileDic = [m_RecordFileList objectAtIndex:anIndexPath.section];
    NSString *key=[fileDic objectForKey:@"date"];
    NSMutableArray *arr=(NSMutableArray *)[m_CurAllDic objectForKey:key];
    NSDictionary *dic=(NSDictionary *)[arr objectAtIndex:anIndexPath.row];
    NSString *strFileName = [dic objectForKey:@STR_RECORD_FILE_NAME];
    NSInteger filesize=[[dic objectForKey:@STR_RECORD_FILE_SIZE] integerValue];
    RemotePlaybackViewController *remotePlaybackViewController = [[RemotePlaybackViewController alloc] init];
    
    remotePlaybackViewController.m_strName = m_strName;
    remotePlaybackViewController.m_strFileName = strFileName;
    remotePlaybackViewController.m_pPPPPMgnt = m_pPPPPChannelMgt;
    remotePlaybackViewController.strDID = m_strDID;
    remotePlaybackViewController.mFileSize=filesize;
    remotePlaybackViewController.mModal=mModal;
    [remotePlaybackViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    //[self presentViewController:remotePlaybackViewController animated:YES completion:nil];
    
    IpCameraClientAppDelegate *IPCamDelegate = [[UIApplication sharedApplication] delegate];
    [IPCamDelegate switchRemotePlaybackView:remotePlaybackViewController];
    
    [remotePlaybackViewController release];
    
}

#pragma mark -
#pragma mark performOnMainThread

- (void) ReloadTableView
{
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
     m_bFinished=YES;
    [self StopTimer];
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

#pragma mark -
#pragma mark sdcardfilelistresult

- (void) SDCardRecordFileSearchResult:(NSString *)strFileName fileSize:(NSInteger)fileSize bEnd:(BOOL)bEnd PageCount:(int)pagecount RecordBend:(int)record_bend
{
    NSLog(@"strFileName: %@, bEnd: %d , record_bend=%d", strFileName,  bEnd,record_bend);
    if (m_bFinished == YES) {
        return;
    }
    
    
    
    [self performSelectorOnMainThread:@selector(StopTimer) withObject:nil waitUntilDone:YES];
    
    
    if (pagecount>50) {
        [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(ReloadTableView) withObject:nil waitUntilDone:YES];
        NSLog(@"该设备返回的PageCount有问题");
        return;
    }
    
    if ([strFileName length]<8) {
        [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(ReloadTableView) withObject:nil waitUntilDone:YES];
        return;
    }
    
     NSDictionary *fileDic = [NSDictionary dictionaryWithObjectsAndKeys:strFileName, @STR_RECORD_FILE_NAME, [NSString stringWithFormat:@"%d", fileSize], @STR_RECORD_FILE_SIZE, nil];
    
    NSString *strDate=@"";
    if (mModal==1) {
        strDate=[strFileName substringWithRange:NSMakeRange(0,7)];
    }else{
        strDate=[strFileName substringWithRange:NSMakeRange(0,8)];
    }
    NSDictionary *dateDic=[NSDictionary dictionaryWithObjectsAndKeys:strDate, @"date", @"0",@"flag", nil];
    if (![m_RecordFileList containsObject:dateDic]) {// 没有该日期
        //NSLog(@"没有该日期：%@",strDate);
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        [arr addObject:fileDic];
        [m_CurAllDic setObject:arr forKey:strDate];
        [m_RecordFileList addObject:dateDic];
        [arr release];
    }else{
        //NSLog(@"有该日期：%@",strDate);
        NSMutableArray *arr=(NSMutableArray *)[m_CurAllDic objectForKey:strDate];
        if (![arr containsObject:fileDic]) {
           // NSLog(@"arr 添加数据 ");
            [arr addObject:fileDic];
        }
        //NSLog(@"arr.count=%d",arr.count);
    
    }
    
    
    //[m_RecordFileList addObject:fileDic];
    
    if (bEnd == 1) {
         NSLog(@"kkkk======pagecount=%d",pagecount);
        if (isSDcardPage<pagecount) {//分页加载
            
            m_pPPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[m_strDID UTF8String], 0,isSDcardPage, 128);
            isSDcardPage++;
            
            NSLog(@"isSDcardPage=%d",isSDcardPage);
        }else if(mModal==1){
            NSLog(@"mModal==%d",mModal);
            
            if (record_bend==1) {//该页到最后
                mPageTime++;
                m_pPPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[m_strDID UTF8String], mPageTime,isSDcardPage, 128);
                
            }else if (record_bend==2){
                NSLog(@"pagecount=%d, 完成",pagecount);
                [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(ReloadTableView) withObject:nil waitUntilDone:YES];
            }
          
        }else{
            NSLog(@"pagecount=%d, 完成",pagecount);
            [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(ReloadTableView) withObject:nil waitUntilDone:YES];
        }
    }
}

#pragma  mark-
#pragma mark- SDcardScheduleDelegate
-(void)sdcardScheduleParams:(NSString *)did Tota:(int)total RemainCap:(int)remain SD_status:(int)status Cover:(int)cover_enable TimeLength:(int)timeLength FixedTimeRecord:(int)ftr_enable{

}
-(void)sdcardScheduleParams:(NSString *)did Tota:(int)total RemainCap:(int)remain SD_status:(int)status Cover:(int)cover_enable TimeLength:(int)timeLength FixedTimeRecord:(int)ftr_enable RecordSize:(int)recordSize{

}

@end
