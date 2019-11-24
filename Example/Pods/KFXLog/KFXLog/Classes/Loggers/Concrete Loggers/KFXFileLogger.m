
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


#import "KFXFileLogger.h"
#import "KFXLogger_Protected.h"
#import "KFXLogConfigurator_Internal.h"
#import "KFXFileLogDescriptor.h"
#import "KFXLogFormatter.h"

@interface KFXFileLogger ()
@end

@implementation KFXFileLogger

//======================================================
#pragma mark - ** Public Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - Initilisers
//--------------------------------------------------------
+(instancetype)fileLogger{
    
    KFXFileLogger *logger = [[[self class]alloc]init];
    return logger;
}


//======================================================
#pragma mark - ** Protected Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - KFXLogger_Protected
//--------------------------------------------------------
-(void)logMessage:(NSString *)message withLogType:(KFXLogType)logType prefix:(NSString *)prefix sender:(id)sender{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    KFXFileLogDescriptor *descriptor = config.fileLogDescriptor;
    
    if (!(descriptor.blacklist & logType)) {
        [self logMessage:message withPrefix:prefix sender:sender];
    }
}

-(KFXLogDescriptor *)logDescriptor{
    return [KFXLogConfigurator sharedConfigurator].fileLogDescriptor;
}

//======================================================
#pragma mark - ** Private Methods **
//======================================================
//--------------------------------------------------------
#pragma mark Logs
//--------------------------------------------------------

-(void)logMessage:(NSString*)message withPrefix:(NSString*)prefix sender:(id)sender{

    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    KFXFileLogDescriptor *descriptor = config.fileLogDescriptor;
    NSFileManager *fileMan = [NSFileManager defaultManager];

    // If directory does not exist we stop
    BOOL isDir;
    if ([fileMan fileExistsAtPath:descriptor.directoryPath isDirectory:&isDir]) {
        if (!isDir) {
            return;
        }
    }else{
        return;
    }
    
    // ## Get Path and create file if it does not exist
    NSString *fullPath = [self fullPathForLogFile];
    if (![fileMan fileExistsAtPath:fullPath]) {
        
        [fileMan createFileAtPath:fullPath contents:nil attributes:nil];
    }
    
    // ## Format message and append to file
    NSString *formattedMessage = [self formatMessage:message withPrefix:prefix sender:sender];
    [self appendMessage:formattedMessage toFileAtPath:fullPath];
}


-(void)appendMessage:(NSString*)message toFileAtPath:(NSString*)path{
    
    // Add text from error to log file and write it to disk
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}


-(NSString*)formatMessage:(NSString*)message withPrefix:(NSString*)prefix sender:(id)sender{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    KFXFileLogDescriptor *descriptor = config.fileLogDescriptor;
    NSString *fullMessage;
    if (descriptor.shouldFormatMessage) {
        fullMessage = [config.logFormatter formatMessage:message
                                              withPrefix:prefix
                                                  sender:sender
                                  formattedLogDescriptor:descriptor];
    }else{
        fullMessage = message;
    }
    return fullMessage;
}


//--------------------------------------------------------
#pragma mark File Path
//--------------------------------------------------------
-(NSString*)fullPathForLogFile{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    KFXFileLogDescriptor *descriptor = config.fileLogDescriptor;
    NSString *basePath = [descriptor.directoryPath stringByAppendingPathComponent:descriptor.fileNameBase];
    NSString *fullPath;
    switch (descriptor.split) {
        case KFXFileLogsSplitNever: {
            fullPath = basePath;
            break;
        }
        case KFXFileLogsSplitByDay: {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            fullPath = [[basePath stringByAppendingString:@"_Day_"]stringByAppendingString:dateString];
            break;
        }
        case KFXFileLogsSplitByWeek: {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-ww"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            fullPath = [[basePath stringByAppendingString:@"_Week_"]stringByAppendingString:dateString];
            break;
        }
        case KFXFileLogsSplitByMonth: {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            fullPath = [[basePath stringByAppendingString:@"_Month_"]stringByAppendingString:dateString];
            break;
        }
        case KFXFileLogsSplitByVersion: {
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *majorVersion = infoDictionary[@"CFBundleShortVersionString"];
            fullPath = [[basePath stringByAppendingString:@"_v_"]stringByAppendingString:majorVersion];
            break;
        }
        case KFXFileLogsSplitByBuild: {
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *minorVersion = infoDictionary[@"CFBundleVersion"];
            fullPath = [[basePath stringByAppendingString:@"_Build_"]stringByAppendingString:minorVersion];
            break;
        }
    }
    return fullPath;
}











@end
