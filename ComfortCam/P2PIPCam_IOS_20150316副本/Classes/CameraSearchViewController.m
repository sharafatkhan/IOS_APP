//
//  CameraSearchViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CameraSearchViewController.h"
#import "obj_common.h"
#import "defineutility.h"
#import "CameraEditViewController.h"
#import "SearchListCell.h"
#import "IpCameraClientAppDelegate.h"

@interface CameraSearchViewController ()

@end

@implementation CameraSearchViewController

@synthesize SearchListView;
@synthesize navigationBar;
@synthesize cameraViewController;
@synthesize SearchAddCameraDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mainScreen=[[UIScreen mainScreen] bounds];
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1.0f];
    
    bSearchFinished = NO;    
    
    [self showLoadingIndicator];    
    searchListMgt = [[SearchListMgt alloc] init];    
    m_pSearchDVS = NULL;
    [self startSearch];
    
    
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        
        CGRect tableFrm=SearchListView.frame;
        tableFrm.origin.y+=20;
        tableFrm.size.height-=20;
        SearchListView.frame=tableFrm;
         self.view.backgroundColor=[UIColor blackColor];
         SearchListView.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
        isIOS7=YES;
    }else{
        NSLog(@"less ios7");
        isIOS7=NO;
    }

    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=SearchListView.frame;
    imgView.center=SearchListView.center;
    SearchListView.backgroundView=imgView;
    [imgView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self stopSearch];
    [searchListMgt release];
    searchListMgt = nil;
}

- (void) dealloc
{
    [self stopSearch];
    self.SearchListView = nil;
    [searchListMgt release];
    self.searchListView = nil;
    self.navigationBar = nil;
    self.SearchAddCameraDelegate = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleTimer:(NSTimer *)timer
{
    NSLog(@"handleTimer");
    //time is up, invalidate the timer
    [searchTimer invalidate];  
    
    [self stopSearch];    
    
    bSearchFinished = YES;
    [self hideLoadingIndicator];
    
    [SearchListView reloadData];    
    
}

- (void) startSearch
{
//    [self stopSearch];
//    m_pSearchDVS = new CSearchDVS();
//    m_pSearchDVS->searchResultDelegate = self;
//    m_pSearchDVS->Open();
    
    //create the start timer
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(ppppSearchLocalDevices) userInfo:nil repeats:NO];
    
}

-(void)ppppSearchLocalDevices{
    lanSearchExtRet *sea=new lanSearchExtRet[32];
    
    INT32 ret=PPPP_SearchExt(sea, 32, 900);
    if (ret>0) {
        for(int i=0;i<ret;i++){
            NSLog(@"ip:%s id:%s  name=%s",sea[i].mIP,sea[i].mDID,sea[i].mName);
            
//            NSString *name=[NSString stringWithUTF8String:sea[i].mName];
//            if (name==nil||[name hasPrefix:@"old_node"]) {
//               
//            }
            
            NSString *name=@STR_DEFAULT_CAMERA_NAME;
            [searchListMgt AddCamera:@"mac" Name:name Addr:[NSString stringWithUTF8String:sea[i].mIP] Port:@"81" DID:[NSString stringWithUTF8String:sea[i].mDID]];
            
        }
    }
    
    delete sea;
}

- (void) stopSearch
{
    
    if (m_pSearchDVS != NULL) {
        m_pSearchDVS->searchResultDelegate = nil;
        SAFE_DELETE(m_pSearchDVS);
    }
}


- (void) btnRefresh: (id) sender
{
    //NSLog(@"btnRefresh");
    [self showLoadingIndicator];
    [searchListMgt ClearList];
    [SearchListView reloadData];
    [self startSearch];
    
    
    
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showLoadingIndicator
{
   
    UINavigationItem *navigationItem1 = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"SearchCamera", @STR_LOCALIZED_FILE_NAME, nil)];     
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 120, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= NSLocalizedStringFromTable(@"SearchCamera", @STR_LOCALIZED_FILE_NAME, nil);
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
    [leftButton release];
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
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"SearchCamera", @STR_LOCALIZED_FILE_NAME, nil)];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 120, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= NSLocalizedStringFromTable(@"SearchCamera", @STR_LOCALIZED_FILE_NAME, nil);
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

#pragma mark -
#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    // NSLog(@"numberOfSectionsInTableView");
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    // NSLog(@"numberOfRowsInSection");
    if (bSearchFinished == NO) {
        return 0;
    }
    
    return [searchListMgt GetCount];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");             
    
    NSDictionary *cameraDic = [searchListMgt GetCameraAtIndex:anIndexPath.row];
    
    NSString *cellIdentifier = @"SearchListCell";

    SearchListCell *cell=(SearchListCell *)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        UINib *nib=[UINib nibWithNibName:@"SearchListCell" bundle:nil];
        [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell=(SearchListCell *)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    float cellHeight = cell.frame.size.height;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, 64, mainScreen.size.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    cellBgView.backgroundColor=[UIColor clearColor];
    [cellBgView addSubview:label];
    if (isIOS7) {
        cell.backgroundView=cellBgView;
    }
    [label release];
    [cellBgView release];
    
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    NSString *ip=[cameraDic objectForKey:@STR_IPADDR];
    
    NSLog(@"name: %@, id: %@, ip: %@", name, did,ip);

	cell.nameLabel.text=name;
    cell.addrLabel.text=ip;
    cell.didLabel.text=did;
	return cell;
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    return 65.0;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    
    NSDictionary *cameraDic = [searchListMgt GetCameraAtIndex:anIndexPath.row];
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    NSString *ip=[cameraDic objectForKey:@STR_IPADDR];
    NSString *port=[cameraDic objectForKey:@STR_PORT];
    
    [SearchAddCameraDelegate AddCameraInfo:name DID:did IP:ip Port:port];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return NSLocalizedStringFromTable(@"Network", @STR_LOCALIZED_FILE_NAME, nil);
//}

#pragma mark -
#pragma mark SearchCamereResultDelegate
- (void) SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString *)did
{
    if ([did length] == 0) {
        return;
    }
    
    NSLog(@"SearchCameraResult。。。mac:%@ name=%@ addr=%@ port=%@ did=%@",mac,name,addr,port,did);
    if ([name length]==0) {
        name=@"P2PCam";
    }
    BOOL b=[searchListMgt AddCamera:mac Name:name Addr:addr Port:port DID:did];
    if (b) {
        NSLog(@"SearchCameraResult..添加成功");
    }else{
        NSLog(@"SearchCameraResult..添加失败");
    }
}

#pragma mark -
#pragma mark navigationbardelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}


@end
