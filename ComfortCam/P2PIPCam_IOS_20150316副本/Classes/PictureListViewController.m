


//
//  PictureListViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureListViewController.h"
#import "obj_common.h"
#import "PicListCell.h"
#import "PictureShowViewController.h"
#import "APICommon.h"
#import <QuartzCore/QuartzCore.h>
#import "IpCameraClientAppDelegate.h"
#import "PicListIpadCell.h"
#import "mytoast.h"
#import "PictureBean.h"
#import "VideoViewCell.h"
#import "ShowImageViewController.h"
@interface PictureListViewController ()

@end

@implementation PictureListViewController
@synthesize imageTag;
@synthesize navigationBar;
@synthesize strDate;
@synthesize m_pPicPathMgt;
@synthesize strDID;
@synthesize m_tableView;
@synthesize NotifyReloadDataDelegate;
@synthesize progressView;
@synthesize isP2P;
@synthesize m_Lock;
@synthesize alertView;
@synthesize authority;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    
}
- (void) btnBack: (id) sender
{
    int  count = [picPathArray count];
    if (count<=0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        isIphone=YES;
        
    }else{
        isIphone=NO;
    }
    
    m_Lock=[[NSCondition alloc]init];
    
    memset(m_pSelectedStatus, 0, sizeof(m_pSelectedStatus));
    m_nTotalNum = 0;
    m_toolBar = nil;
    m_myImgDic=[[NSMutableDictionary alloc]init];
    m_bEditMode = NO;
    picPathArray = nil;
    picPathArray=[[NSMutableArray alloc]init];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadPicPathArray) userInfo:nil repeats:NO];
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    navigationBar.delegate = self;
    
    [self initNavigationBar];
    
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        
        CGRect tableFrm=m_tableView.frame;
        tableFrm.origin.y+=20;
        m_tableView.frame=tableFrm;
        m_tableView.contentInset=UIEdgeInsetsMake(-10, 0, 0, 0);
        self.view.backgroundColor=[UIColor blackColor];
    }else{
        NSLog(@"less ios7");
        
    }
    
    
    m_tableView .delegate=self;
    m_tableView.dataSource=self;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.imageTag = [UIImage imageNamed:@"del_hook.png"];
    [self initProgressView];
    
    
    
    
        UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
        imgView.frame=m_tableView.frame;
        imgView.center=m_tableView.center;
        m_tableView.backgroundView=imgView;
        [imgView release];
    
    
}

-(void)initProgressView{
    alertView=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"initPicPrompt", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    //alertView.frame=CGRectMake(10.0f, 100.0f, 240.0f, 200.0f);
    
    UIActivityIndicatorView *activeView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activeView.center=CGPointMake(alertView.bounds.size.width/2, alertView.bounds.size.height-40);
    [activeView startAnimating];
    [alertView addSubview:activeView];
    [activeView release];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissProgressView) userInfo:nil repeats:NO];
}
-(void)dismissProgressView{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
}

-(void)loadPicPathArray{
    
    //[progressView removeFromSuperview];
    if (picPathArray!=nil) {
        [picPathArray removeAllObjects];
        NSMutableArray *tempArray= [m_pPicPathMgt GetTotalPathArray:strDID date:strDate];
        for (NSString *pa in tempArray) {
            PictureBean *bean=[[PictureBean alloc]init];
            bean.path=pa;
            [picPathArray addObject:bean];
            [bean release];
        }
    }
    if (m_tableView!=nil) {
        [m_tableView reloadData];
    }
    
    
    [self performSelectorOnMainThread:@selector(initNavigationBarOnMainThread) withObject:nil waitUntilDone:NO];
    
}



-(void)initNavigationBar{
    if (!m_bEditMode) {
        
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[NSString stringWithFormat:@"%@(%d)",strDate,m_nTotalNum]];
        UILabel *labelTile=[[UILabel alloc]init];
        labelTile.frame=CGRectMake(0, 0, TITLE_WITH, 20);
        labelTile.font=[UIFont systemFontOfSize:18];
        labelTile.textColor=[UIColor whiteColor];
        labelTile.textAlignment=UITextAlignmentCenter;
        labelTile.backgroundColor=[UIColor clearColor];
        labelTile.text= [NSString stringWithFormat:@"%@(%d)",strDate,m_nTotalNum];
        item.titleView=labelTile;
        [labelTile release];
        UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
        [btnRight setTitle:NSLocalizedStringFromTable(@"Edit", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
        btnRight.frame=CGRectMake(0,0,50,30);
        [btnRight addTarget:self action:@selector(btnEdit) forControlEvents:UIControlEventTouchUpInside];
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
        NSArray *array = [NSArray arrayWithObjects: item, nil];
        [self.navigationBar setItems:array];
        [rightButton release];
        [leftButton release];
        [item release];
        
        
        
        
    }else{
        
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[NSString stringWithFormat:@"%@(%d)",strDate,m_nTotalNum]];
        UILabel *labelTile=[[UILabel alloc]init];
        labelTile.frame=CGRectMake(0, 0, TITLE_WITH, 20);
        labelTile.font=[UIFont systemFontOfSize:18];
        labelTile.textColor=[UIColor whiteColor];
        labelTile.textAlignment=UITextAlignmentCenter;
        labelTile.backgroundColor=[UIColor clearColor];
        labelTile.text= [NSString stringWithFormat:@"%@(%d)",strDate,m_nTotalNum];
        item.titleView=labelTile;
        [labelTile release];
        UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
        [btnRight setTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
        btnRight.frame=CGRectMake(0,0,50,30);
        [btnRight addTarget:self action:@selector(btnEdit) forControlEvents:UIControlEventTouchUpInside];
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
        NSArray *array = [NSArray arrayWithObjects: item, nil];
        [self.navigationBar setItems:array];
        [rightButton release];
        [leftButton release];
        [item release];
        
    }
}
-(void)btnEdit{
//    int imgCount= [m_myImgDic count];
//    int count = [picPathArray count];
//    NSLog(@"imgCount=%d count=%d",imgCount,count);
//    if (imgCount<count) {
//        [mytoast showWithText:NSLocalizedStringFromTable(@"piclisteditprompt", @STR_LOCALIZED_FILE_NAME, nil)];
//        return;
//    }
    
    NSLog(@"~~~~~~~~pictureListVC== authority(%@)",authority);
    if ([authority integerValue]==USER_VISITOR) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"not_authority", @STR_LOCALIZED_FILE_NAME, nil)];
        return ;
    }

    m_bEditMode=!m_bEditMode;
    [self initNavigationBar];
    [self showToolBar];
}
-(void)showToolBar{
    
    
    mainScreen=[[UIScreen mainScreen]bounds];
    if (m_bEditMode) {
        int toolBarX=0;
        int toolBarY=0;
        if ([IpCameraClientAppDelegate isIOS7Version]) {
            toolBarY = mainScreen.size.height-44 ;
        }else{
            toolBarY = mainScreen.size.height-64 ;
        }
        int toolBarWidth=mainScreen.size.width;
        int toolBarHeight=44;
        m_toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(toolBarX, toolBarY, toolBarWidth, toolBarHeight)];
        m_toolBar.barStyle=UIBarStyleBlackOpaque;
        
        UIBarButtonItem *btnSelectAll=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"selectAll",  @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(mySelectAll)];
        UIBarButtonItem *btnSpace1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem*btnReserveSelect=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"reserveSelect",  @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(myReserveSelect)];
        UIBarButtonItem *btnSpace2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *btnDelete=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Delete",  @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(myDelete)];
        NSArray *array=[NSArray arrayWithObjects:btnSpace1,btnSelectAll,btnReserveSelect,btnDelete,btnSpace2 ,nil];
        [m_toolBar setItems:array];
        [btnSelectAll release];
        [btnReserveSelect release];
        [btnDelete release];
        [btnSpace1 release];
        [btnSpace2 release];
        [self.view addSubview:m_toolBar];
        CGRect rectTableView=m_tableView.frame;
        if ([IpCameraClientAppDelegate isIOS7Version]) {
            rectTableView.size.height -= 60 ;
        }else{
            rectTableView.size.height -= 44 ;
        }
        m_tableView.frame=rectTableView;
    }else{
        CGRect rectTableView = self.m_tableView.frame;
        if ([IpCameraClientAppDelegate isIOS7Version]) {
            rectTableView.size.height += 60 ;
        }else{
            rectTableView.size.height += 44 ;
        }
        self.m_tableView.frame = rectTableView ;
        [m_toolBar removeFromSuperview];
        [m_toolBar release];
        m_toolBar=nil;
        int i;
        BOOL bReload=NO;
        for (i=0; i<m_nTotalNum; i++) {
            if (m_pSelectedStatus[i]==1) {
                bReload=YES;
            }
            m_pSelectedStatus[i]=0;
        }
        if (bReload) {
            [self.m_tableView reloadData];
        }
    }
}
-(void)mySelectAll{
    BOOL bReload=NO;
    for (int i=0; i<m_nTotalNum; i++) {
        if (m_pSelectedStatus[i]==0) {
            bReload=YES;
            m_pSelectedStatus[i]=1;
        }
    }
    if (bReload) {
        [self.m_tableView reloadData];
    }
}
-(void)myReserveSelect{
    int i;
    for (i = 0; i < m_nTotalNum; i++) {
        if(m_pSelectedStatus[i] == 1){
            m_pSelectedStatus[i] = 0;
        }else {
            m_pSelectedStatus[i] = 1;
        }
    }
    
    [self.m_tableView reloadData];
}
-(void)myDelete{
    BOOL bReload=NO;
    int i;
    
    for (i=m_nTotalNum-1; i>=0; i--) {
        if (m_pSelectedStatus[i]==1) {
            bReload=YES;
            PictureBean *bean=[picPathArray objectAtIndex:i];
            [m_pPicPathMgt RemovePicPath:strDID PicDate:strDate PicPath:bean.path];
            [picPathArray removeObject:bean];
        }
    }
    
    if (bReload) {
        memset(m_pSelectedStatus, 0, sizeof(m_pSelectedStatus));
        [self.m_tableView reloadData];
        [self.NotifyReloadDataDelegate NotifyReloadData];
    }
}

- (void) AddTag: (UIView*) view
{
    int imageX = view.frame.size.width - 5 - 30;
    int imageY = 5;
    
    UIImageView *imageViewTag = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, 30, 30)];
    imageViewTag.image = self.imageTag;
    [view addSubview:imageViewTag];
    [imageViewTag release];
}
-(void)removeTag:(UIView *)view{
    for (UIView  *v in [view subviews]) {
        [v removeFromSuperview];
    }
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

- (void) dealloc
{
    if (m_Lock!=nil) {
        [m_Lock release];
        m_Lock=nil;
    }
    if (alertView!=nil) {
        [alertView release];
        alertView=nil;
    }
    self.navigationBar = nil;
    self.m_pPicPathMgt = nil;
    self.strDID = nil;
    self.strDate = nil;
    self.m_tableView = nil;
    self.NotifyReloadDataDelegate=nil;
    self.progressView=nil;
    [picPathArray release];
    picPathArray=nil;
    [m_myImgDic removeAllObjects];
    [m_myImgDic release];
    m_myImgDic=nil;
    [super dealloc];
}


- (void) singleTapHandle: (UITapGestureRecognizer*)sender
{
    VideoPicView *imageView = (VideoPicView*)[sender view];
    int tag = imageView.tag;
    
    NSLog(@"singleTapHandle tag:%d", tag);
    if(!m_bEditMode){

        
        ShowImageViewController *picC=[[ShowImageViewController alloc]init];
        picC.strDID=strDID;
        picC.strDate=strDate;
        picC.m_pPicPathMgt=m_pPicPathMgt;
        picC.arrImgPath=picPathArray;
        picC.NotifyReloadDataDelegate=self;
        picC.currentIndex=tag;
        picC.authority=authority;
        [self.navigationController pushViewController:picC animated:YES];
        [picC release];
        
        return;
    }
    if (tag>=m_nTotalNum) {
        return;
    }
    if(m_pSelectedStatus[tag]==1){
        
        imageView.hookImgView.hidden=YES;
        m_pSelectedStatus[tag]=0;
    }else{
       
        m_pSelectedStatus[tag]=1;
        imageView.hookImgView.hidden=NO;
    }
    
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    
    
    int  count = [picPathArray count];
    m_nTotalNum=count;
    NSLog(@" numberOfRowsInSection...count=%d",count);
    if (count == 0) {
        
        return 0;
    }
    if (isIphone) {
        return (count % 4) > 0 ? (count / 4) + 1 : count / 4;
    }else{
        
        return (count % 8) > 0 ? (count / 8) + 1 : count / 8;
    }
    
    
}

-(NSString*)caculateTime:(NSString *)strTime{
    //NSLog(@"caculateTime...strTime=%@",strTime);
    int iHour=[[strTime substringToIndex:2] intValue];
    NSString *strHour=[NSString stringWithFormat:@"%d",iHour];
    NSString *strMin=[strTime substringFromIndex:2];
    
    NSString *strFl=@"AM";
    if (iHour<=12) {
        if (iHour<10) {
            strHour=[NSString stringWithFormat:@"0%d",iHour];
        }
    }else{
        iHour-=12;
        if (iHour<10) {
            strHour=[NSString stringWithFormat:@"0%d",iHour];
        }
        strFl=@"PM";
    }
    NSString *time=[NSString stringWithFormat:@"%@ %@%@",strFl,strHour,strMin];
    
    return time;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
   
    
    NSString *cellIdentifier = @"PicListCell";
    VideoViewCell *cell=[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        if ([IpCameraClientAppDelegate isiPhone]) {
            cell=[[VideoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier mFrame:CGRectMake(0, 0, mainScreen.size.width, 85)];
        }else{
            cell=[[VideoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier mFrame:CGRectMake(0, 0, mainScreen.size.width, 105)];
        }
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.vidPicView1.flagImgView.hidden=YES;
    cell.vidPicView2.flagImgView.hidden=YES;
    cell.vidPicView3.flagImgView.hidden=YES;
    cell.vidPicView4.flagImgView.hidden=YES;
    cell.vidPicView5.flagImgView.hidden=YES;
    cell.vidPicView6.flagImgView.hidden=YES;
    cell.vidPicView7.flagImgView.hidden=YES;
    cell.vidPicView8.flagImgView.hidden=YES;
    
    if ([IpCameraClientAppDelegate isiPhone]) {
        //ImageView1
        int index=anIndexPath.row*4;
        NSLog(@"index1=%d",index);
        PictureBean *bean=[picPathArray objectAtIndex:index];
        bean.indexpath=anIndexPath;
        bean.number=1;
        NSString *strTime=[bean.path substringFromIndex:([bean.path length]-14)];
        
        cell.vidPicView1.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];;
        if (!bean.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean];
        }
        if (bean.img!=nil) {
            cell.vidPicView1.imageView.image=bean.img;
        }
        cell.vidPicView1.tag=index;
        cell.vidPicView1.hidden=NO;
        cell.vidPicView1.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView1 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView1.hookImgView.hidden=NO;
        }else{
            cell.vidPicView1.hookImgView.hidden=YES;
        }
        
        //ImageView2
        index+=1;
        NSLog(@"index2=%d",index);
        if (index>=[picPathArray count]) {
            cell.vidPicView2.hidden=YES;
            cell.vidPicView3.hidden=YES;
            cell.vidPicView4.hidden=YES;
            return cell;
        }
        PictureBean *bean2=[picPathArray objectAtIndex:index];
        
        bean2.indexpath=anIndexPath;
        bean2.number=2;
        strTime=[bean2.path substringFromIndex:([bean2.path length]-14)];
        cell.vidPicView2.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];;
        if (!bean2.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean2];
        }
        if (bean2.img!=nil) {
            cell.vidPicView2.imageView.image=bean2.img;
        }
        cell.vidPicView2.hidden=NO;
        cell.vidPicView2.userInteractionEnabled=YES;
        cell.vidPicView2.tag=index;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView2 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView2.hookImgView.hidden=NO;
        }else{
            cell.vidPicView2.hookImgView.hidden=YES;
        }
        
        //ImageView3
        index+=1;
        if (index>=[picPathArray count]) {
            
            cell.vidPicView3.hidden=YES;
            cell.vidPicView4.hidden=YES;
            return cell;
        }
        PictureBean  *bean3=[picPathArray objectAtIndex:index];
        bean3.indexpath=anIndexPath;
        bean3.number=3;
        strTime=[bean3.path substringFromIndex:([bean3.path length]-14)];
        cell.vidPicView3.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];
        if (!bean3.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean3];
        }
        if (bean3.img!=nil) {
            cell.vidPicView2.imageView.image=bean3.img;
        }
        cell.vidPicView3.hidden=NO;
        cell.vidPicView3.userInteractionEnabled=YES;
        cell.vidPicView3.tag=index;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView3 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView3.hookImgView.hidden=NO;
        }else{
            cell.vidPicView3.hookImgView.hidden=YES;
        }
        
        //ImageView4
        index+=1;
        if (index>=[picPathArray count]) {
            
            cell.vidPicView4.hidden=YES;
            return cell;
        }
        PictureBean *bean4=[picPathArray objectAtIndex:index];
        bean4.indexpath=anIndexPath;
        bean4.number=4;
        strTime=[bean4.path substringFromIndex:([bean4.path length]-14)];
        cell.vidPicView4.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];
        if (!bean4.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean4];
        }
        if (bean4.img!=nil) {
            cell.vidPicView4.imageView.image=bean4.img;
        }
        
        cell.vidPicView4.hidden=NO;
        cell.vidPicView4.userInteractionEnabled=YES;
        cell.vidPicView4.tag=index;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView4 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView4.hookImgView.hidden=NO;
        }else{
            cell.vidPicView4.hookImgView.hidden=YES;
        }
    }else{
        
        int index=anIndexPath.row*8;
        NSLog(@"index1=%d",index);
        PictureBean *bean=[picPathArray objectAtIndex:index];
        bean.indexpath=anIndexPath;
        bean.number=1;
        NSString *strTime=[bean.path substringFromIndex:([bean.path length]-14)];
        cell.vidPicView1.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];
        if (!bean.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean];
        }
        if (bean.img!=nil) {
            cell.vidPicView1.imageView.image=bean.img;
        }
        cell.vidPicView1.hidden=NO;
        cell.vidPicView1.userInteractionEnabled=YES;
        cell.vidPicView1.tag=index;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView1 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView1.hookImgView.hidden=NO;
        }else{
            cell.vidPicView1.hookImgView.hidden=YES;
        }
        //ImageView2
        index+=1;
        NSLog(@"index2=%d",index);
        if (index>=[picPathArray count]) {
            cell.vidPicView2.hidden=YES;
            cell.vidPicView3.hidden=YES;
            cell.vidPicView4.hidden=YES;
            cell.vidPicView5.hidden=YES;
            cell.vidPicView6.hidden=YES;
            cell.vidPicView7.hidden=YES;
            cell.vidPicView8.hidden=YES;
            return cell;
        }
        PictureBean *bean2=[picPathArray objectAtIndex:index];
        
        bean2.indexpath=anIndexPath;
        bean2.number=2;
        strTime=[bean2.path substringFromIndex:([bean2.path length]-14)];
        cell.vidPicView2.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];
        if (!bean2.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean2];
        }
        if (bean2.img!=nil) {
            cell.vidPicView2.imageView.image=bean2.img;
        }
        cell.vidPicView2.hidden=NO;
        cell.vidPicView2.userInteractionEnabled=YES;
        cell.vidPicView2.tag=index;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView2 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView2.hookImgView.hidden=NO;
        }else{
            cell.vidPicView2.hookImgView.hidden=YES;
        }
        //ImageView3
        index+=1;
        if (index>=[picPathArray count]) {
            
            cell.vidPicView3.hidden=YES;
            cell.vidPicView4.hidden=YES;
            cell.vidPicView5.hidden=YES;
            cell.vidPicView6.hidden=YES;
            cell.vidPicView7.hidden=YES;
            cell.vidPicView8.hidden=YES;
            return cell;
        }
        PictureBean  *bean3=[picPathArray objectAtIndex:index];
        bean3.indexpath=anIndexPath;
        bean3.number=3;
        strTime=[bean3.path substringFromIndex:([bean3.path length]-14)];
        cell.vidPicView3.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];
        if (!bean3.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean3];
        }
        if (bean3.img!=nil) {
            cell.vidPicView2.imageView.image=bean3.img;
        }
        cell.vidPicView3.hidden=NO;
        cell.vidPicView3.userInteractionEnabled=YES;
        cell.vidPicView3.tag=index;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView3 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView3.hookImgView.hidden=NO;
        }else{
            cell.vidPicView3.hookImgView.hidden=YES;
        }
        
        //ImageView4
        index+=1;
        if (index>=[picPathArray count]) {
            
            cell.vidPicView4.hidden=YES;
            cell.vidPicView5.hidden=YES;
            cell.vidPicView6.hidden=YES;
            cell.vidPicView7.hidden=YES;
            cell.vidPicView8.hidden=YES;
            return cell;
        }
        PictureBean *bean4=[picPathArray objectAtIndex:index];
        bean4.indexpath=anIndexPath;
        bean4.number=4;
        strTime=[bean4.path substringFromIndex:([bean4.path length]-14)];
        cell.vidPicView4.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];
        if (!bean4.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean4];
        }
        if (bean4.img!=nil) {
            cell.vidPicView4.imageView.image=bean4.img;
        }
        
        cell.vidPicView4.hidden=NO;
        cell.vidPicView4.userInteractionEnabled=YES;
        cell.vidPicView4.tag=index;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView4 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView4.hookImgView.hidden=NO;
        }else{
            cell.vidPicView4.hookImgView.hidden=YES;
        }
        //ImageView5
        index+=1;
        if (index>=[picPathArray count]) {
            
            cell.vidPicView5.hidden=YES;
            cell.vidPicView6.hidden=YES;
            cell.vidPicView7.hidden=YES;
            cell.vidPicView8.hidden=YES;
            return cell;
        }
        PictureBean *bean5=[picPathArray objectAtIndex:index];
        bean5.indexpath=anIndexPath;
        bean5.number=5;
        strTime=[bean5.path substringFromIndex:([bean5.path length]-14)];
        cell.vidPicView5.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];
        if (!bean5.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean5];
        }
        if (bean5.img!=nil) {
            cell.vidPicView5.imageView.image=bean5.img;
        }
        
        cell.vidPicView5.hidden=NO;
        cell.vidPicView5.userInteractionEnabled=YES;
        cell.vidPicView5.tag=index;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView5 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView5.hookImgView.hidden=NO;
        }else{
            cell.vidPicView5.hookImgView.hidden=YES;
        }
        //ImageView6
        index+=1;
        if (index>=[picPathArray count]) {
            
            cell.vidPicView6.hidden=YES;
            cell.vidPicView7.hidden=YES;
            cell.vidPicView8.hidden=YES;
            return cell;
        }
        PictureBean *bean6=[picPathArray objectAtIndex:index];
        bean6.indexpath=anIndexPath;
        bean6.number=6;
        strTime=[bean6.path substringFromIndex:([bean6.path length]-14)];
        cell.vidPicView6.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];
        if (!bean6.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean6];
        }
        if (bean6.img!=nil) {
            cell.vidPicView6.imageView.image=bean6.img;
        }
        
        cell.vidPicView6.hidden=NO;
        cell.vidPicView6.userInteractionEnabled=YES;
        cell.vidPicView6.tag=index;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView6 addGestureRecognizer:singleTap];
        [singleTap release];
        
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView6.hookImgView.hidden=NO;
        }else{
            cell.vidPicView6.hookImgView.hidden=YES;
        }
        //ImageView7
        index+=1;
        if (index>=[picPathArray count]) {
            
            cell.vidPicView7.hidden=YES;
            cell.vidPicView8.hidden=YES;
            return cell;
        }
        PictureBean *bean7=[picPathArray objectAtIndex:index];
        bean7.indexpath=anIndexPath;
        bean7.number=7;
        strTime=[bean7.path substringFromIndex:([bean7.path length]-14)];
        cell.vidPicView7.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];
        if (!bean7.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean7];
        }
        if (bean7.img!=nil) {
            cell.vidPicView7.imageView.image=bean7.img;
        }
        
        cell.vidPicView7.hidden=NO;
        cell.vidPicView7.userInteractionEnabled=YES;
        cell.vidPicView7.tag=index;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView7 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView7.hookImgView.hidden=NO;
        }else{
            cell.vidPicView7.hookImgView.hidden=YES;
        }
        //ImageView8
        index+=1;
        if (index>=[picPathArray count]) {
            
            cell.vidPicView8.hidden=YES;
            return cell;
        }
        PictureBean *bean8=[picPathArray objectAtIndex:index];
        bean8.indexpath=anIndexPath;
        bean8.number=8;
        strTime=[bean8.path substringFromIndex:([bean8.path length]-14)];
        cell.vidPicView8.labelTime.text=[self caculateTime:[strTime substringToIndex:8]];
        if (!bean8.isLoaded) {
            [NSThread detachNewThreadSelector:@selector(startLoadLocalPic:) toTarget:self withObject:bean8];
        }
        if (bean8.img!=nil) {
            cell.vidPicView8.imageView.image=bean8.img;
        }
        
        cell.vidPicView8.hidden=NO;
        cell.vidPicView8.userInteractionEnabled=YES;
        cell.vidPicView8.tag=index;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.vidPicView8 addGestureRecognizer:singleTap];
        [singleTap release];
        if (m_pSelectedStatus[index] == 1) {
            cell.vidPicView8.hookImgView.hidden=NO;
        }else{
            cell.vidPicView8.hookImgView.hidden=YES;
        }
    }
    
    
    return cell;
    
}
-(void)startLoadLocalPic:(PictureBean *)bean{
    usleep(10);
    [m_Lock lock];
    
    UIImage *img=[APICommon GetImageByNameFromImage:strDID filename:bean.path];
    if (img!=nil) {
       // NSLog(@"获取到图片:%d",bean.number);
        bean.img=img;
        [self performSelectorOnMainThread:@selector(refreshCellForIndexPath:) withObject:bean waitUntilDone:NO];
    }else{
       // NSLog(@"获取到图片:%d",bean.number);
    }
    
    [m_Lock unlock];
}
-(void)refreshCellForIndexPath:(PictureBean *)bean{
    if (m_tableView==nil) {
        return;
    }
    
    NSIndexPath *indexpath=bean.indexpath;
    VideoViewCell *cell=(VideoViewCell*)[self.m_tableView cellForRowAtIndexPath:indexpath];
    
    if ([IpCameraClientAppDelegate isiPhone]) {
        switch (bean.number) {
            case 1:
            {
                cell.vidPicView1.imageView.image=bean.img;
            }
                break;
            case 2:
            {
                cell.vidPicView2.imageView.image=bean.img;
            }
                break;
            case 3:
            {
                cell.vidPicView3.imageView.image=bean.img;
            }
                break;
            case 4:
            {
                cell.vidPicView4.imageView.image=bean.img;
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (bean.number) {
            case 1:
            {
                cell.vidPicView1.imageView.image=bean.img;
            }
                break;
            case 2:
            {
                cell.vidPicView2.imageView.image=bean.img;
            }
                break;
            case 3:
            {
                cell.vidPicView3.imageView.image=bean.img;
            }
                break;
            case 4:
            {
                cell.vidPicView4.imageView.image=bean.img;
            }
                break;
            case 5:
            {
                cell.vidPicView5.imageView.image=bean.img;
            }
                break;
            case 6:
            {
                cell.vidPicView6.imageView.image=bean.img;
            }
                break;
            case 7:
            {
                cell.vidPicView7.imageView.image=bean.img;
            }
                break;
            case 8:
            {
                cell.vidPicView8.imageView.image=bean.img;
            }
                break;
                
            default:
                break;
        }
        
    }
    
    
    
}
- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    if ([IpCameraClientAppDelegate isiPhone]) {
        return 90;
        
    }else{
        return 115;
        
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    
    
}


#pragma mark -
#pragma mark performInMainThread
-(void)initNavigationBarOnMainThread{
    [self initNavigationBar];
}
- (void)reloadTableViewData
{
    
    [self loadPicPathArray];
    
}

#pragma mark -
#pragma mark NotifyReloadData

- (void) NotifyReloadData
{
    if (NotifyReloadDataDelegate!=nil) {
        [self.NotifyReloadDataDelegate NotifyReloadData];
    }
    
    [self performSelectorOnMainThread:@selector(reloadTableViewData) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark navigationBardelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    if ([picPathArray count]<=0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        return NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    return NO;
}


@end

