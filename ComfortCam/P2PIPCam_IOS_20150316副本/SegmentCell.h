//
//  SegmentCell.h
//  P2PCamera
//
//  Created by Tsang on 13-6-26.
//
//

#import <UIKit/UIKit.h>

@interface SegmentCell : UITableViewCell
{
    IBOutlet UILabel *label;
    IBOutlet UISegmentedControl *segment;
}
@property (nonatomic,retain)IBOutlet UILabel *label;
@property (nonatomic,retain)IBOutlet UISegmentedControl *segment;
@end
