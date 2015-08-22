//
//  RecordViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecordViewController.h"
#import "obj_common.h"
#import "RecordDateViewController.h"
#import "PicDirCell.h"
#import "defineutility.h"
#import "APICommon.h"
#import "obj_common.h"
#import "PPPPDefine.h"
#import "RemoteRecordFileListViewController.h"
#import "mytoast.h"
#import "IpCameraClientAppDelegate.h"
#import "recordCell.h"
@interface RecordViewController ()

@end

@implementation RecordViewController

@synthesize navigationBar;
@synthesize segmentedControl;
@synthesize m_pCameraListMgt;
@synthesize m_tableView;
@synthesize m_pRecPathMgt;
@synthesize imageVideoDefault;
@synthesize imagePlay;
@synthesize m_pPPPPChannelMgt;
@synthesize m_myDic;
@synthesize isP2P;
@synthesize labeltitle;
@synthesize mySegment;
@synthesize authority;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"record30.png"];
        self.tabBarItem.title = NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil);
    }
    return self;
}

- (void) segmentedChanged: (id) sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    
    switch (segment.selectedSegmentIndex) {
        case 0: //local
            m_bLocal = YES;
            self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            break;
        case 1: //remote
            m_bLocal = NO;
            self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            break;
            
        default:
            return;
    }
    
    [self.m_tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version>7.9) {
        m_tableView.contentInset=UIEdgeInsetsMake(-10, 0, 0, 0);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    m_tableView.dataSource=self;
    m_tableView.delegate=self;
    mainScreen=[[UIScreen mainScreen]bounds];
    m_bLocal = YES;
    m_myDic=[[NSMutableDictionary alloc]init];
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
   

    
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
   // self.segmentedControl.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1.0f];
    
    NSDictionary *dicTextNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica" size:12],UITextAttributeFont ,nil];
    
    NSDictionary *dicTextPressed = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica" size:12],UITextAttributeFont ,nil];
    
    [segmentedControl setTitleTextAttributes:dicTextNormal forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:dicTextPressed forState:UIControlStateSelected];
    
    [segmentedControl setTitle:NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil) forSegmentAtIndex:0];
    [segmentedControl setTitle:NSLocalizedStringFromTable(@"Remote", @STR_LOCALIZED_FILE_NAME, nil) forSegmentAtIndex:1];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (isP2P) {
        mySegment=[[MySegmentControl alloc]initWithFrame:CGRectMake(0, 0, 140, 30) segmentNumber:2];
        [mySegment setSegmentTitleColor:[UIColor grayColor] ForStatus:UIControlStateNormal Index:0];
        [mySegment setSegmentTitleColor:[UIColor whiteColor] ForStatus:UIControlStateSelected Index:0];
        [mySegment setSegmentTitleColor:[UIColor grayColor] ForStatus:UIControlStateNormal Index:1];
        [mySegment setSegmentTitleColor:[UIColor whiteColor] ForStatus:UIControlStateSelected Index:1];
        //[mySegment setSegmentImage:[UIImage imageNamed:@"done_normal.png"] ForStatus:UIControlStateNormal Index:0];
        [mySegment setSegmentBackgroundImageWithColor:[UIColor colorWithRed:17/255.0 green:86/255.0 blue:148/255.0 alpha:1.0] ForState:UIControlStateNormal Index:0];
        [mySegment setSegmentBackgroundImageWithColor:[UIColor colorWithRed:17/255.0 green:86/255.0 blue:148/255.0 alpha:1.0] ForState:UIControlStateNormal Index:1];
        [mySegment setSegmentBackgroundImageWithColor:[UIColor colorWithRed:12/255.0 green:47/255.0 blue:79/255.0 alpha:1.0] ForState:UIControlStateSelected Index:0];
        [mySegment setSegmentBackgroundImageWithColor:[UIColor colorWithRed:12/255.0 green:47/255.0 blue:79/255.0 alpha:1.0] ForState:UIControlStateSelected Index:1];
//        [mySegment setSegmentImage:[UIImage imageNamed:@"done_pressed.png"] ForStatus:UIControlStateSelected Index:0];
//        [mySegment setSegmentImage:[UIImage imageNamed:@"done_normal.png"] ForStatus:UIControlStateNormal Index:1];
//        [mySegment setSegmentImage:[UIImage imageNamed:@"done_pressed.png"] ForStatus:UIControlStateSelected Index:1];
        [mySegment setSegmentTitle:NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil) Index:0];
        [mySegment setSegmentTitle:NSLocalizedStringFromTable(@"Remote", @STR_LOCALIZED_FILE_NAME, nil) Index:1];
        mySegment.delegate=self;
        [mySegment setSegmentSelected:YES Index:0];
        [mySegment setSegmentSelected:NO Index:1];
        
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
        UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:mySegment];
        item.rightBarButtonItem = rightButton;
        
        UIButton *label=[UIButton buttonWithType:UIButtonTypeCustom];
        label.frame=CGRectMake(0, 0, 80, 20);
        [label setTitle:NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithCustomView:label];
        item.leftBarButtonItem=leftButton;
        
        
        NSArray *array = [NSArray arrayWithObjects:item, nil];
        [self.navigationBar setItems:array];
        [item release];
        [rightButton release];
        [leftButton release];
        
      
    }else{
        self.segmentedControl.hidden=YES;
        labeltitle.hidden=YES;
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil)];
        NSArray *array = [NSArray arrayWithObjects:item, nil];
        [self.navigationBar setItems:array];
        [item release];
    }
    
    
    
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        
        CGRect tableFrm=m_tableView.frame;
        tableFrm.origin.y+=20;
        m_tableView.frame=tableFrm;
        CGRect titleLabelFrame=labeltitle.frame;
        titleLabelFrame.origin.y+=20;
        labeltitle.frame=titleLabelFrame;
        labeltitle.textColor=[UIColor whiteColor];
        labeltitle.backgroundColor=[UIColor blackColor];
       self.view.backgroundColor=[UIColor blackColor];
        isIOS7=YES;
        m_tableView.contentInset=UIEdgeInsetsMake(-10, 0, 0, 0);
        
    }else{
        NSLog(@"less ios7");
        isIOS7=NO;
        self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    }
    
    self.imageVideoDefault = [UIImage imageNamed:@"back.png"];
    self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.imagePlay = [UIImage imageNamed:@"play_video.png"];
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=m_tableView.frame;
    imgView.center=m_tableView.center;
    m_tableView.backgroundView=imgView;
    [imgView release];
}

-(void)segmentSelectedIndex:(int)index{
    switch (index) {
        case 0:
        {
            m_bLocal = YES;
            [mySegment setSegmentSelected:YES Index:0];
            [mySegment setSegmentSelected:NO Index:1];
            self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
            break;
        case 1:
        {
            m_bLocal = NO;
            [mySegment setSegmentSelected:NO Index:0];
            [mySegment setSegmentSelected:YES Index:1];
            self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
            break;
        default:
            break;
    }
    [self.m_tableView reloadData];
}
- (void) dealloc
{
    self.navigationBar = nil;
    self.segmentedControl = nil;
    self.m_pCameraListMgt = nil;
    self.m_tableView = nil;
    self.m_pRecPathMgt = nil;
    self.imageVideoDefault = nil;
    self.imagePlay = nil;
    if (m_myDic!=nil) {
        [m_myDic removeAllObjects];
    }
    [m_myDic release];
    m_myDic=nil;
    mySegment=nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark TableViewDelegate


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection");    
    int count = [m_pCameraListMgt GetCount];
    return count;  
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");  
    
    NSInteger index = anIndexPath.row ;    
    
    //-----------------------------------------------------------------------------------
    NSDictionary *cameraDic = nil;    
    NSString *name = @"";
    NSNumber *nPPPPStatus=nil;
    NSString *did =@"";
    
    if (isP2P) {
        //UIImage *img = [cameraDic objectForKey:@STR_IMG];
        cameraDic = [m_pCameraListMgt GetCameraAtIndex:index];
        nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
        //NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
        did = [cameraDic objectForKey:@STR_DID];
        name = [cameraDic objectForKey:@STR_NAME];
    }else{
        cameraDic = [m_pCameraListMgt GetIpCameraAtIndex:index];
        nPPPPStatus=[NSNumber numberWithInt:0];
        did=[cameraDic objectForKey:@STR_IPADDR];
        name = [cameraDic objectForKey:@STR_NAME];
    }
 
    NSString *cellIdentifier1 = @"RemoteRecordViewCell";
    if (m_bLocal == NO) {
       
        recordCell *cell1 =(recordCell *)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        
        if (cell1 == nil)
        {
            
            UINib *nib=[UINib nibWithNibName:@"recordCell" bundle:nil];
            [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
            cell1=(recordCell *)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        }
        
       
        
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell1.labelName.text = name;
        cell1.labelID.text=did;
        NSString *strPPPPStatus = nil;
        int PPPPStatus = [nPPPPStatus intValue];
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
        if (isP2P) {
            cell1.labelStatus.text = strPPPPStatus;
        }else{
            cell1.labelStatus.text=@"DDNS";
        }
        //cell1.detailTextLabel.textColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.8 alpha:1];
        return cell1;
    }
    NSString *cellIdentifier = @"LocalRecordViewCell";       
    //当状态为显示当前的设备列表信息时
    PicDirCell *cell =  (PicDirCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PicDirCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.opaque=YES;
    
    NSString *strFileName = [m_pRecPathMgt GetFirstPathByID:did];
    
    NSDictionary *myDic=[m_pRecPathMgt GetSumAndFirstPicByID:did];
    NSNumber *num=[myDic objectForKey:@"sum"];
    int sum=[num intValue]; 
    cell.labelName.text = [NSString stringWithFormat:@"%@(%d)", name, sum];
    cell.labelDID.text=did;
    UIImage *img=[m_myDic objectForKey:[NSString stringWithFormat:@"img%@",did]];
     //NSString *flag=[m_myDic objectForKey:did];
    if (strFileName==nil) {
        NSLog(@"recordview  ......strFileName==nil");
    }
    if (img==nil&&strFileName!=nil){
            [m_myDic setObject:did forKey:did];
             NSDictionary *mdic=[NSDictionary dictionaryWithObjectsAndKeys:strFileName,@"filename",did,@"did", nil];
            
           [NSThread detachNewThreadSelector:@selector(startLoadImg:) toTarget:self withObject:mdic];
           
        }else if(img!=nil&&strFileName!=nil){
            cell.imageView.image = img;
            cell.playFView.hidden=NO;

        
        }else {
           cell.imageView.image = imageVideoDefault;
            cell.playFView.hidden=YES;
            NSLog(@"recordview  cell.imageView.image = imageVideoDefault;");
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
//kaven
-(void)startLoadImg:(NSDictionary *) dic{
    
    NSString *strFileName =[dic objectForKey:@"filename"];
    NSString *did=[dic objectForKey:@"did"];
    UIImage *image = [APICommon GetImageByName:did filename:strFileName];
    NSLog(@"RecordViewController did=%@ strFileName=%@",did,strFileName);
    if (image!=nil) {
       
        [m_myDic setObject:image forKey:[NSString stringWithFormat:@"img%@",did]];
        //[m_pRecPathMgt UpdateImageByID:did Img:image];
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
    } 
}
-(void)updateCellForIndexPath:(NSDictionary *)dic{
     NSIndexPath *indexPath=[dic objectForKey:@"indexpath"];
     UIImage *img=[dic objectForKey:@"img"];
    PicDirCell *cell=(PicDirCell *)[self.m_tableView cellForRowAtIndexPath:indexPath];

    if (img!=nil) {
        cell.imageView.image=img;
        
        int halfWidth = cell.imageView.frame.size.width / 2;
        int halfHeight = cell.imageView.frame.size.height / 2;
        
        int halfX = cell.imageView.frame.origin.x + halfWidth;
        int halfY = cell.imageView.frame.origin.y + halfHeight;
        
        int imageX = halfX - 20;
        int imageY = halfY - 20;
        
        //play image
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, 40, 40)];
        imageView.image = self.imagePlay;
        imageView.alpha = 0.6f;
        [cell addSubview:imageView];
        [imageView release];

    }else{
      cell.imageView.image = imageVideoDefault;
    }
}
//kaven
- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    if (m_bLocal) {
        return 60;
    }
    
    return 70;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    NSDictionary *cameraDic = nil;
    NSString *did =@"";
    NSNumber *nPPPPStatus = nil;
    int modal=0;
    if (isP2P) {
        cameraDic = [m_pCameraListMgt GetCameraAtIndex:anIndexPath.row];
        did = [cameraDic objectForKey:@STR_DID];
        nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
        modal=[[cameraDic objectForKey:@STR_MODAL] integerValue];
    }else{
        cameraDic = [m_pCameraListMgt GetIpCameraAtIndex:anIndexPath.row];
        did = [cameraDic objectForKey:@STR_IPADDR];
        nPPPPStatus=[NSNumber numberWithInt:0];
    }
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    NSNumber *num=[cameraDic objectForKey:@STR_AUTHORITY];

    
    if (m_bLocal) {
        RecordDateViewController *recDateViewController = [[RecordDateViewController alloc] init];
        recDateViewController.strName = name;
        recDateViewController.strDID = did;
        recDateViewController.authority = num;
        recDateViewController.m_pRecPathMgt = m_pRecPathMgt;
        recDateViewController.RecReloadDelegate = self;
        [self.navigationController pushViewController:recDateViewController animated:YES];
        [recDateViewController release];
    }else{
        
        int nStatus = [nPPPPStatus intValue];
        if (nStatus != PPPP_STATUS_LAN&&nStatus != PPPP_STATUS_WLAN) {
            if (isP2P) {
                [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
            }else{
            
            }
            
            return;
        }
        RemoteRecordFileListViewController *remoteFileView = [[RemoteRecordFileListViewController alloc] init];
        remoteFileView.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
        remoteFileView.m_strName = name;
        remoteFileView.m_strDID = did;
        remoteFileView.mModal=modal;
        [self.navigationController pushViewController:remoteFileView animated:YES];
        [remoteFileView release];
    }    
    
}

#pragma mark -
#pragma mark performOnMainThread

- (void) reloadTableView
{
    if (m_tableView!=nil) {
        [m_tableView reloadData];
    }
    
}

#pragma mark -
#pragma mark NotifyReloadData

- (void) NotifyReloadData
{
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}

@end
