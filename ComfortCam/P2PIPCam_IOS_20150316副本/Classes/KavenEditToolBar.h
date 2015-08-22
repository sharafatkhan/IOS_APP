//
//  KavenEditToolBar.h
//  P2PCamera
//
//  Created by Tsang on 14-4-29.
//
//

#import <UIKit/UIKit.h>
@protocol KavenEditToolBarDelegate<NSObject>
-(void)toolBarPressed:(int)index;

@end
@interface KavenEditToolBar : UIView
{
    UIButton *btnShare;
    UIButton *btnAlbum;
    UIButton *btnSelectAll;
    UIButton *btnReserve;
    UIButton *btnBack;
    UIButton *btnDelete;
    UIButton *btnEdit;
    UIImageView *imgVbg;
    BOOL isEdit;
    id<KavenEditToolBarDelegate>delegate;
}
@property (nonatomic,retain)UIButton *btnShare;
@property (nonatomic,retain)UIButton *btnAlbum;
@property (nonatomic,retain)UIButton *btnSelectAll;
@property (nonatomic,retain)UIButton *btnReserve;
@property (nonatomic,retain)UIButton *btnBack;
@property (nonatomic,retain)UIButton *btnDelete;
@property (nonatomic,retain)UIButton *btnEdit;
@property (nonatomic,retain)UIImageView *imgVbg;
@property (nonatomic,retain)id<KavenEditToolBarDelegate>delegate;
@property BOOL isEdit;
-(void)btnOnEdit;
@end
