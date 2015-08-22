//
//  adddevicecellCell.h
//  P2PCamera
//
//  Created by Tsang on 13-5-13.
//
//

#import <UIKit/UIKit.h>

@interface adddevicecellCell : UITableViewCell
{
    IBOutlet UILabel *labelname;
    IBOutlet UIImageView *imgView;
    IBOutlet UITextField *textField;
}
@property (nonatomic,retain)IBOutlet UILabel *labelname;
@property (nonatomic,retain)IBOutlet UIImageView *imgView;
@property (nonatomic,retain)IBOutlet UITextField *textField;

@end
