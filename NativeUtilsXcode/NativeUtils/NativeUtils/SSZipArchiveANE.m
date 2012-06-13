//
//  SSZipArchiveANE.m
//  NativeUtils
//
//  Created by Pawel Meller on 29.05.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SSZipArchiveANE.h"

@implementation SSZipArchiveANE
double processedFiles=0;
-(void)setContext:(FREContext)ctx {
    context = ctx;
}
-(void)unzipFile:(NSString *)zipPath archivePath:(NSString*)destinationPath {
    [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath delegate:self];   
}

- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
    DISPATCH_STATUS_EVENT( context,(uint8_t*)[path UTF8String], UnzipStart);
    processedFiles=0;
	//NSLog(@"*** zipArchiveWillUnzipArchiveAtPath: `%@` zipInfo:",(uint8_t*)[path UTF8String]);
}


- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    DISPATCH_STATUS_EVENT( context, (uint8_t*)[path UTF8String],UnzipComplete);
	//NSLog(@"*** zipArchiveDidUnzipArchiveAtPath: `%@` zipInfo: unzippedPath: `%@`", path, unzippedPath);
}


- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo {
    NSString *progress=[NSString stringWithFormat:@"%f",processedFiles/totalFiles*100 ];
    DISPATCH_STATUS_EVENT( context,(uint8_t*)[progress UTF8String], UnzipProgressStart);
   // [progress release];
	//NSLog(@"*** zipArchiveWillUnzipFileAtIndex: `%ld` totalFiles: `%ld` archivePath: `%@` fileInfo:", processedFiles, totalFiles, archivePath);
    
}


- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo {
    processedFiles++;
    NSString *progress=[NSString stringWithFormat:@"%f",processedFiles/totalFiles*100];
    DISPATCH_STATUS_EVENT( context,(uint8_t*)[progress UTF8String], UnzipProgress   );
    //[progress release];
	//NSLog(@"*** zipArchiveDidUnzipFileAtIndex: `%ld` totalFiles: `%ld` archivePath: `%@` fileInfo:", processedFiles, totalFiles, archivePath);
    
}

@end
