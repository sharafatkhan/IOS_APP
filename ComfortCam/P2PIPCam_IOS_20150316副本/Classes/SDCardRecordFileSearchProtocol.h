//
//  SDCardRecordFileSearchProtocol.h
//  P2PCamera
//
//  Created by mac on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDCardRecordFileSearchProtocol <NSObject>

- (void) SDCardRecordFileSearchResult: (NSString *) strFileName fileSize: (NSInteger) fileSize bEnd: (BOOL) bEnd PageCount:(int)pagecount RecordBend:(int)record_bend;

@end
