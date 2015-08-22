//
//  PresetDialog.h
//  P2PCamera
//
//  Created by Tsang on 13-5-6.
//
//

#import <UIKit/UIKit.h>
#import "PaomaButton.h"
@protocol PresetDialogDelegate<NSObject>
-(void)presetDialogOnClick:(int)tag;
@end
@interface PresetDialog : UIView{
    id<PresetDialogDelegate> diaDelegate;
    NSMutableDictionary *dicImgs;
    PaomaButton *btnCall;
    PaomaButton *btnSet;
    NSString *strDid;
    int btnWidth;
    int btnHeight;
    
    NSMutableArray *btnArr;
}
@property (nonatomic,copy)NSString *strDid;
@property (nonatomic,retain)PaomaButton *btnCall;
@property (nonatomic,retain)PaomaButton *btnSet;
@property (nonatomic,assign)id<PresetDialogDelegate> diaDelegate;
- (id)initWithFrame:(CGRect)frame Num:(int)num DID:(NSString*)did;
-(void)savePresetImage:(UIImage*)img  Index:(int)index;
@end
