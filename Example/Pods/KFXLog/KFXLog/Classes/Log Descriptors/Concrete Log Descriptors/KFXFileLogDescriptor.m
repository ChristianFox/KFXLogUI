
/**********************************************************************
 *
 Copyright (c) 2016 Christian Fox <christianfox890@icloud.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 *
 **********************************************************************/


#import "KFXFileLogDescriptor.h"

@implementation KFXFileLogDescriptor



//======================================================
#pragma mark - ** Public Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - Initiliser
//--------------------------------------------------------
+(instancetype)fileLogDescriptor{
    
    KFXFileLogDescriptor *descriptor = [[[self class]alloc]init];
    [descriptor configureWithLogFormat:KFXLogFormatAsh];
    descriptor.split = KFXFileLogsSplitByBuild;
    descriptor.blacklist = KFXLogTypeNone;
    descriptor.directoryPath =  [descriptor defaultDirectoryPathForLogFiles];
    descriptor.fileNameBase = @"Logs";
    descriptor.dateFormatter = [[NSDateFormatter alloc]init];
    [descriptor.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [descriptor.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    return descriptor;
}

//--------------------------------------------------------
#pragma mark - Directory Path
//--------------------------------------------------------
-(NSString*)defaultDirectoryPathForLogFiles{
    
    NSString *appSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString *logFilesPath = [appSupportPath stringByAppendingPathComponent:@"LogFiles"];
    NSFileManager *fileMan = [NSFileManager defaultManager];
    BOOL success = NO;
    success = [fileMan createDirectoryAtPath:logFilesPath
                 withIntermediateDirectories:YES
                                  attributes:nil
                                       error:nil];
    if (success) {
        return logFilesPath;
    }else{
        return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];;
    }
}

@end
