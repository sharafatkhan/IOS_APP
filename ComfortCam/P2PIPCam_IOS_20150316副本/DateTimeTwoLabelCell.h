//
//  DateTimeTwoLabelCell.h
//  P2PCamera
//
//  Created by Tsang on 13-8-14.
//
//

#import <UIKit/UIKit.h>

@interface DateTimeTwoLabelCell : UITableViewCell{
IBOutlet UILabel *labelname;
IBOutlet UILabel *labelvalue;
    CGRect mainScreen;
}
@property (nonatomic,retain) IBOutlet UILabel *labelname;
@property (nonatomic,retain) IBOutlet UILabel *labelvalue;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Frame:(CGRect)mFrame;
@end
