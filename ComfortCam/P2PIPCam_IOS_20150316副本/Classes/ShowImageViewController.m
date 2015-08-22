//
//  ShowImageViewController.m
//  IOSDemo
//
/*
 kaven
   该类用来显示图片，每次只加载3张图片，多的别移除
 */
//  Created by Tsang on 14-4-26.
//  Copyright (c) 2014年 Tsang. All rights reserved.
//

#import "ShowImageViewController.h"
#import "obj_common.h"
#import "IpCameraClientAppDelegate.h"
#import "mytoast.h"
#import "KavenToast.h"
#import "PictureBean.h"

#define TAG_START 1000
#define TAG_SHARE 1
#define TAG_ALBUM 2
#define TAG_DELETE 3
#define kPadding 2

@interface ShowImageViewController ()

@end

@implementation ShowImageViewController
@synthesize arrImgPath;
@synthesize currentIndex;
@synthesize m_pPicPathMgt;
@synthesize NotifyReloadDataDelegate;
@synthesize strDate;
@synthesize strDID;
@synthesize navigationBar;
@synthesize authority;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)dealloc{
    strDID=nil;
    strDate=nil;
    NotifyReloadDataDelegate=nil;
    m_pPicPathMgt=nil;
    arrImgPath=nil;
    [super dealloc];
}
-(void)btnBack:(id)sender{
    if (toolBar.isEdit) {
        [self editPhoto];
        [toolBar btnOnEdit];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    memset(m_pSelectedStatus, 0, sizeof(m_pSelectedStatus));
    self.view.backgroundColor=[UIColor blackColor];
    mainScreen=[[UIScreen mainScreen]bounds];
    int toolBarY=0;
    int statusHeight;
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        statusHeight=20;
        toolBarY = mainScreen.size.height-44 ;
    }else{
        statusHeight=0;
        toolBarY = mainScreen.size.height-64 ;
    }
    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, statusHeight, mainScreen.size.width, 44)];
    
    [self.view addSubview:navigationBar];
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@""];
    labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 80, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= [NSString stringWithFormat:@"%d of %d",currentIndex,[arrImgPath count]];
    item.titleView=labelTile;
    
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    item.leftBarButtonItem=leftButton;
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [navigationBar setItems:array];
    [leftButton release];
    
    alertDelete=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedStringFromTable(@"picshow_delete", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"Ok", @STR_LOCALIZED_FILE_NAME, nil), nil];
    alertDelete.tag=TAG_DELETE;
    alertShare=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedStringFromTable(@"picshow_share", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"Ok", @STR_LOCALIZED_FILE_NAME, nil), nil];
    alertShare.tag=TAG_SHARE;
    alertAlbum=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedStringFromTable(@"picshow_album", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"Ok", @STR_LOCALIZED_FILE_NAME, nil), nil];
    alertAlbum.tag=TAG_ALBUM;
    [self createScrollView];
    //[self performSelector:@selector(showFullScreen) withObject:nil afterDelay:2];
    
    toolBar=[[KavenEditToolBar alloc]initWithFrame:CGRectMake(0, toolBarY, mainScreen.size.width, 44)];
    toolBar.delegate=self;
    
    [self.view addSubview:toolBar];
    
    
}
-(void)showFullScreen{
    NSLog(@"showFullScreen...");
    isFullScreen=!isFullScreen;
    if (isFullScreen) {
        [self.navigationController.navigationBar setHidden:NO];
        [UIApplication sharedApplication].statusBarHidden=NO;
    }else{
        [self.navigationController.navigationBar setHidden:YES];
        [UIApplication sharedApplication].statusBarHidden=YES;
    }
    
}
-(void)refreshView{
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }
}
-(void)createScrollView{
    NSLog(@"createScrollView...");
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navigationBar.frame.origin.y+navigationBar.frame.size.height, mainScreen.size.width, mainScreen.size.height-navigationBar.frame.size.height)];
	scrollView.pagingEnabled = YES;
	scrollView.delegate = self;
    scrollView.backgroundColor=[UIColor blackColor];
	scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
	scrollView.showsVerticalScrollIndicator = NO;
    scrollView.directionalLockEnabled=NO;
    scrollView.bounces=NO;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*arrImgPath.count,scrollView.frame.size.height);
	[self.view addSubview:scrollView];
    scrollView.contentOffset=CGPointMake(mainScreen.size.width*currentIndex, 0);
    
    [self showImages];
}

#pragma mark--kavenEditToolbarDelegate
-(void)toolBarPressed:(int)index{
    
    NSLog(@"~~~~~~~~ShowImgVC==1111 authority(%@)",authority);
    if ([authority integerValue]==USER_VISITOR) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"not_authority", @STR_LOCALIZED_FILE_NAME, nil)];
        return ;
    }
    switch (index) {
            
        case 0://share
        {
            [alertShare show];
        }
            break;
        case 1://album
        {
            [alertAlbum show];
        }
            break;
        case 4://delete
        {
            [alertDelete show];
            
            
            
        }
            break;
        case 5://edit
        case 6:
        {
            if ([authority integerValue]==USER_VISITOR) {
                [mytoast showWithText:NSLocalizedStringFromTable(@"not_authority", @STR_LOCALIZED_FILE_NAME, nil)];
                return ;
            }
            NSLog(@"~~~~~~~~ShowImageVC=2222= editPhoto->authority(%@)",authority);
            [self editPhoto];
        }
            break;
      
        default:
            break;
    }
}
-(void)editPhoto{
    
    NSLog(@"~~~~~~~~ShowImageVC=2222= editPhoto(%@)",authority);
    isEdit=!isEdit;
    
    if (isEdit) {
        
        NSLog(@"kkkk.4444..currentIndex=%d",currentIndex);
        mEditIndexBack=currentIndex;
        scrollView.contentOffset=CGPointMake(mainScreen.size.width*(currentIndex/2), 0);
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*arrImgPath.count/2,scrollView.frame.size.height);
    }else{
        NSLog(@"kkkk222...currentIndex=%d",currentIndex);
        scrollView.contentOffset=CGPointMake(mainScreen.size.width*mEditIndexBack, 0);
        memset(m_pSelectedStatus, 0, sizeof(m_pSelectedStatus));
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*arrImgPath.count,scrollView.frame.size.height);
    }
    
    [self refreshView];
    [self showImages];
    toolBar.btnSelectAll.hidden=YES;
    toolBar.btnReserve.hidden=YES;
}
-(void)saveImageToAlbum{
    BOOL isHas=NO;
    for (int i=0; i<[arrImgPath count]; i++) {
        if (m_pSelectedStatus[i]==1) {
            isHas=YES;
            PictureBean *bean=[arrImgPath objectAtIndex:i];
            UIImage *img=[self GetImageByName:strDID filename:bean.path];
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
        }
    }
    if (isHas) {
       // [mytoast showWithText:@"保存图片到相册成功"];
       
        KavenToast *toast=[[KavenToast alloc]initWithFrame:CGRectMake(0, mainScreen.size.height-100, mainScreen.size.width, 60)];
        [toast showWithText:NSLocalizedStringFromTable(@"SavePictureSuccess", @STR_LOCALIZED_FILE_NAME, nil)];
        [self.view addSubview:toast];
        [toast release];
    }
    
}
- (void) image: (UIImage*)image didFinishSavingWithError: (NSError*) error contextInfo: (void*)contextInfo
{
    
}

#pragma mark--UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"222222 buttonIndex=%d",buttonIndex);
    switch (alertView.tag) {
        case TAG_SHARE:
        {
            if (buttonIndex==1) {
                KavenToast *toast=[[KavenToast alloc]initWithFrame:CGRectMake(0, mainScreen.size.height-100, mainScreen.size.width, 60)];
                //[toast showWithText:@"分享功能正在开发中..."];
                [self.view addSubview:toast];
                [toast release];
            }
        }
            break;
        case TAG_ALBUM:
        {
            if (buttonIndex==1) {
                [self saveImageToAlbum];
            }
        }
            break;
        case TAG_DELETE:
        {
            if (buttonIndex==1) {
                NSMutableArray *arrDelete=[[NSMutableArray alloc]init];
                for (int i=0; i<arrImgPath.count; i++) {
                    if (m_pSelectedStatus[i]==1) {
                         PictureBean *bean=[arrImgPath objectAtIndex:i];
                        
                        [arrDelete addObject:[arrImgPath objectAtIndex:i]];
                        [m_pPicPathMgt RemovePicPath:strDID PicDate:strDate PicPath:bean.path];
                    }
                }
                [NotifyReloadDataDelegate NotifyReloadData];
                [arrImgPath removeObjectsInArray:arrDelete];
                [arrDelete release];
                
                if ((currentIndex+1)*2<[arrImgPath count]) {
                    scrollView.contentOffset=CGPointMake(mainScreen.size.width*(currentIndex/2), 0);
                    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*arrImgPath.count/2,scrollView.frame.size.height);
                    
                }else{
                    currentIndex=[arrImgPath count]/2+[arrImgPath count]%2;
                    scrollView.contentOffset=CGPointMake(mainScreen.size.width*currentIndex, 0);
                    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*arrImgPath.count/2,scrollView.frame.size.height);
                }
                memset(m_pSelectedStatus, 0, sizeof(m_pSelectedStatus));
                [self refreshView];
                if ([arrImgPath count]<=0) {
                    [self scrollToIndexImage:currentIndex];
                }else{
                    [self showImages];
                }
                
                toolBar.btnSelectAll.hidden=YES;
                toolBar.btnReserve.hidden=YES;
            }
        }
            break;
        default:
            break;
    }
}
-(void)showImages{
    
    CGRect visibleBounds=scrollView.bounds;
    currentIndex=(int)floorf((CGRectGetMaxX(visibleBounds)-1)/CGRectGetWidth(visibleBounds));
    NSLog(@"currentIndex=%d",currentIndex);
    if (currentIndex<0) {
        currentIndex=0;
    }
    if (currentIndex>=arrImgPath.count) {
        currentIndex=(int)arrImgPath.count-1;
    }
    
    if (!isEdit) {
        NSInteger photoViewIndex;
        for (UIView *view in [scrollView subviews]) {
            photoViewIndex=view.tag-TAG_START;
            if (photoViewIndex<(currentIndex-1)||photoViewIndex>(currentIndex+1)) {
                [view removeFromSuperview];
            }
        }
       
    }else{
        
        currentIndex*=2;
    }
    
    
    for (int i=currentIndex-2; i<=currentIndex+1; i++) {
        NSInteger nIndex=[self validIndex:i];
        //NSLog(@"nIndex=%d",nIndex);
        if (![self isShowingImageIndex:nIndex]) {
            [self showImageAtIndex:nIndex];
            
        }
    }
    if (isEdit) {
        [self scrollToIndexImage:currentIndex+2];
    }else{
        [self scrollToIndexImage:currentIndex+1];
    }
    
}
/*
 判断index下的图片是否已经加载
 */
-(BOOL)isShowingImageIndex:(NSInteger)index{
    
    for (UIView *view in [scrollView subviews]) {
        if (view.tag==(index+TAG_START)) {
           // NSLog(@"已经存在index＝%d",index);
            return YES;
        }
    }
   // NSLog(@"没有图片index=%d",index);
    return NO;
}
/*
   加载一张图片
 */
-(void)showImageAtIndex:(int)index{
    NSLog(@"showImageAtIndex...index=%d",index);
    if (index<0) {
        return;
    }
     CGRect bounds=scrollView.frame;
    if (isEdit) {
        
        CGRect imgFrame=CGRectMake(0, (bounds.size.height-mainScreen.size.width/2*3/4)/2-10, mainScreen.size.width/2, mainScreen.size.width/2*3/4);
        imgFrame.size.width -= (2 * kPadding);
        imgFrame.origin.x=mainScreen.size.width/2*index+kPadding;
       // NSLog(@"index=%d x=%f widthX=%f",index,imgFrame.origin.x,imgFrame.size.width*index);
        KavenZoomImageView *imgView=[[KavenZoomImageView alloc]initWithFrame:imgFrame];
        imgView.tag=index+TAG_START;
        imgView.mdelegate=self;
        PictureBean *bean=[arrImgPath objectAtIndex:index] ;
        [imgView displayImage:[self GetImageByName:strDID filename:bean.path] Frame:CGRectMake(0, 0, imgFrame.size.width, imgFrame.size.height)];
        [scrollView addSubview:imgView];
         [imgView release];
    }else{
        CGRect imgFrame=CGRectMake(0, 0, bounds.size.width, bounds.size.height);
        //imgFrame.size.width-=(2 * kPadding);
        imgFrame.origin.x=bounds.size.width*index;
        KavenZoomImageView *imgView=[[KavenZoomImageView alloc]initWithFrame:imgFrame];
        imgView.tag=index+TAG_START;
        imgView.mdelegate=self;
        PictureBean *bean=[arrImgPath objectAtIndex:index] ;
        [imgView displayImage:[self GetImageByName:strDID filename:bean.path] Frame:CGRectMake(0, (bounds.size.height-mainScreen.size.width*3/4)/2-10, mainScreen.size.width, mainScreen.size.width*3/4)];
        [scrollView addSubview:imgView];
        [imgView release];
    }
    
    
}


-(NSInteger)validIndex:(NSInteger)index{
    if (index<0) {
        index=0;
    }
    if (index>=arrImgPath.count) {
        index=arrImgPath.count-1;
    }
    return index;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"ShowImageViewController....didReceiveMemoryWarning");
}

-(void)scrollToIndexImage:(int)index{
    if (index>[arrImgPath count]) {
        index=[arrImgPath count];
    }
    mEditIndexBack=index-1;
    labelTile.text= [NSString stringWithFormat:@"%d of %d",index,[arrImgPath count]];

}

#pragma mark--ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   // NSLog(@"scrollViewDidScroll");
    [self showImages];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

}
#pragma mark---KavenZoomImageViewDelegate
-(void)photoViewDidSingleTap:(int)index{
    NSLog(@" 4444444index=%d",index-TAG_START);
    if (isEdit) {
        if (m_pSelectedStatus[index-TAG_START]==0) {
            m_pSelectedStatus[index-TAG_START]=1;
            UIView *view=[scrollView viewWithTag:index];
            UIImageView *tagView=[[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width-30, view.frame.size.height-30, 30, 30)];
            tagView.image=[UIImage imageNamed:@"del_hook.png"];
            [view addSubview:tagView];
            [tagView release];
            NSLog(@"kkkkkk");
        }else{
            
            UIView *view=[scrollView viewWithTag:index];
            NSArray *views=[view subviews];
            if([views count]<1){
                m_pSelectedStatus[index-TAG_START]=0;
                return;
            }
            UIView *tagView=[views objectAtIndex:1];
            [tagView removeFromSuperview];
            m_pSelectedStatus[index-TAG_START]=0;
            
        }
        return;
    }
    
    
    [self showFullScreen];
}

#pragma mark--Orientation
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    //[self refreshView];
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        
        scrollView.frame=CGRectMake(0, 0, mainScreen.size.width, mainScreen.size.height);
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*arrImgPath.count,scrollView.frame.size.height);
        scrollView.contentOffset=CGPointMake(mainScreen.size.width*currentIndex, 0);
        
    }else{
        
        scrollView.frame=CGRectMake(0, 0, mainScreen.size.height, mainScreen.size.width);
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.height*arrImgPath.count,scrollView.frame.size.width);
        scrollView.contentOffset=CGPointMake(mainScreen.size.height*currentIndex, 0);
    }
    [self showImages];
}
-(BOOL)shouldAutorotate{
    return NO;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark--获取图片
- (UIImage*) GetImageByName: (NSString*)did filename:(NSString*)filename
{
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:did];
    strPath = [strPath stringByAppendingPathComponent:filename];
    //NSLog(@"strPath: %@", strPath);
    
    UIImage *image = [UIImage imageWithContentsOfFile:strPath];
    
    return image;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
