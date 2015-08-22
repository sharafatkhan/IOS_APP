//
//  ShowImageViewController.h
//  IOSDemo
//
//  Created by Tsang on 14-4-26.
//  Copyright (c) 2014年 Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicPathManagement.h"
#import "NotifyEventProtocol.h"
#import "KavenZoomImageView.h"
#import "KavenEditToolBar.h"
@interface ShowImageViewController : UIViewController<UIScrollViewDelegate,UIScrollViewDelegate,KavenZoomImageViewDelegate,KavenEditToolBarDelegate,UIAlertViewDelegate>
{
    UIScrollView *scrollView;
    int currentIndex;
    NSMutableArray *arrImgPath;
    CGRect mainScreen;
    BOOL isFullScreen;
    
    NSString *strDID;
    NSString *strDate;
    PicPathManagement *m_pPicPathMgt;
    UINavigationBar *navigationBar;
    id<NotifyEventProtocol> NotifyReloadDataDelegate;
    UILabel *labelTile;
    
    KavenEditToolBar *toolBar;
    BOOL isEdit;
    char m_pSelectedStatus[1024];
    int mEditIndexBack;
    
    UIAlertView *alertAlbum;
    UIAlertView *alertDelete;
    UIAlertView *alertShare;
    
    NSNumber *authority;
}
@property(nonatomic,retain)NSMutableArray *arrImgPath;
@property int currentIndex;
@property (nonatomic, assign) NSNumber *authority;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, copy) NSString *strDate;
@property (nonatomic ,retain)UINavigationBar *navigationBar;
@property (nonatomic, assign) PicPathManagement *m_pPicPathMgt;
@property (nonatomic, assign) id<NotifyEventProtocol> NotifyReloadDataDelegate;

@end
