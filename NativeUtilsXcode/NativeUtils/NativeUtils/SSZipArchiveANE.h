//
//  SSZipArchiveANE.h
//  NativeUtils
//
//  Created by Pawel Meller on 29.05.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NativeUtils.h"
@interface SSZipArchiveANE : NSObject <SSZipArchiveDelegate>
{
    FREContext context;
}
-(void)setContext:(FREContext)ctx;
-(void)unzipFile:(NSString *)zipPath archivePath:(NSString*)destinationPath;
@end
