
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


#import "KFXConsoleLogger.h"
#import "KFXLogConfigurator_Internal.h"
#import "KFXLogFormatter.h"
#import "KFXLogger_Protected.h"

@interface KFXConsoleLogger ()
@end

@implementation KFXConsoleLogger

//======================================================
#pragma mark - ** Public Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - Initilisers
//--------------------------------------------------------
+(instancetype)consoleLogger{
    KFXConsoleLogger *logger = [[[self class]alloc]init];
    return logger;
}


//======================================================
#pragma mark - ** Protected Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - KFXLogger_Protected
//--------------------------------------------------------
-(void)logMessage:(NSString*)message withLogType:(KFXLogType)logType prefix:(NSString*)prefix sender:(id)sender{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    
    switch (config.consoleLogType) {
        case KFXConsoleLogTypeBasic: {
            KFXBasicLogDescriptor *descriptor = config.basicLogDescriptor;
            
            if (descriptor.blacklist & logType) {
                return;
            }else{
                [self logStandardMessage:message withPrefix:prefix sender:sender];
            }
            break;
        }
        case KFXConsoleLogTypeClean: {
            KFXCleanLogDescriptor *descriptor = config.cleanLogDescriptor;
            if (descriptor.blacklist & logType) {
                return;
            }else{
                [self logCleanMessage:message withPrefix:prefix sender:sender];
            }
            break;
        }
    }
}

-(KFXLogDescriptor *)logDescriptor{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    
    switch (config.consoleLogType) {
        case KFXConsoleLogTypeBasic: {
            return config.basicLogDescriptor;
        }
        default: {
            return config.cleanLogDescriptor;
        }
    }
}

//======================================================
#pragma mark - ** Private Methods **
//======================================================
-(void)logStandardMessage:(NSString*)message withPrefix:(NSString*)prefix sender:(id)sender{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    KFXBasicLogDescriptor *descriptor = config.basicLogDescriptor;
    NSString *fullMessage = [config.logFormatter formatMessage:message
                                                    withPrefix:prefix
                                                        sender:sender
                                         standardLogDescriptor:descriptor];
    NSLog(@"%@",fullMessage);
}

-(void)logCleanMessage:(NSString*)message withPrefix:(NSString*)prefix sender:(id)sender{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    KFXCleanLogDescriptor *descriptor = config.cleanLogDescriptor;
    NSString *fullMessage;
    if (descriptor.shouldFormatMessage) {
        fullMessage = [config.logFormatter formatMessage:message
                                              withPrefix:prefix
                                                  sender:sender
                                  formattedLogDescriptor:descriptor];
    }else{
        fullMessage = message;
    }
    
    fprintf(stderr,"%s", [fullMessage UTF8String]);
}


@end
