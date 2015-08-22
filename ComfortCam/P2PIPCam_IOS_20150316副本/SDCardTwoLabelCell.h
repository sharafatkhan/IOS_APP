//
//  SDCardTwoLabelCell.h
//  P2PCamera
//
//  Created by Tsang on 13-8-14.
//
//

#import <UIKit/UIKit.h>

@interface SDCardTwoLabelCell : UITableViewCell
{
    IBOutlet UILabel *labelname;
    IBOutlet UILabel *labelvalue;
}
@property (nonatomic,retain) IBOutlet UILabel *labelname;
@property (nonatomic,retain) IBOutlet UILabel *labelvalue;
@end
