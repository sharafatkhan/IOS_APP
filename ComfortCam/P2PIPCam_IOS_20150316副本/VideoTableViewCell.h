//
//  VideoTableViewCell.h
//  P2PCamera
//
//  Created by Tsang on 13-8-21.
//
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell
{
    IBOutlet UILabel *labelName;
    IBOutlet UILabel *labelStatus;
    IBOutlet UILabel *labelID;
}
@property (nonatomic,retain)IBOutlet UILabel *labelName;
@property (nonatomic,retain)IBOutlet UILabel *labelStatus;
@property (nonatomic,retain)IBOutlet UILabel *labelID;

@end
