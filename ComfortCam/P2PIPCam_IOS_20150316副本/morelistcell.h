//
//  morelistcell.h
//  P2PCamera
//
//  Created by Tsang on 13-5-3.
//
//

#import <UIKit/UIKit.h>

@interface morelistcell : UITableViewCell
{
    
    IBOutlet UIImageView *imageCamera;
    IBOutlet UILabel *NameLable;
    IBOutlet UILabel *PPPPIDLable;
    IBOutlet UILabel *PPPPStatusLable;
    
}

@property (nonatomic, retain) UIImageView *imageCamera;
@property (nonatomic, retain) UILabel *NameLable;
@property (nonatomic, retain) UILabel *PPPPIDLable;
@property (nonatomic, retain) UILabel *PPPPStatusLable;

@end
