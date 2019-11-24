
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


#import "KFXAlertLogger.h"
#import "KFXLogger_Protected.h"
#import "KFXAlertLogDescriptor.h"
#import "KFXLogConfigurator_Internal.h"
#import "KFXLogFormatter.h"
@import UIKit.UIAlertController;

@implementation KFXAlertLogger

//======================================================
#pragma mark - ** Public Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - Initilisers
//--------------------------------------------------------
+(instancetype)alertLogger{
    KFXAlertLogger *logger = [[[self class]alloc]init];
    return logger;
}


//======================================================
#pragma mark - ** Protected Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - KFXLogger_Protected
//--------------------------------------------------------
-(void)logMessage:(NSString*)message withLogType:(KFXLogType)logType prefix:(NSString*)prefix sender:(id)sender{

    
    if ([sender isKindOfClass:[UIViewController class]]) {
        KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
        KFXAlertLogDescriptor *descriptor = config.alertLogDescriptor;
        
        if (descriptor.whitelist & logType) {
            [self logMessage:message withPrefix:prefix sender:sender];
        }
    }
}

-(KFXLogDescriptor *)logDescriptor{
    return [KFXLogConfigurator sharedConfigurator].alertLogDescriptor;
}

//======================================================
#pragma mark - ** Private Methods **
//======================================================
-(void)logMessage:(NSString*)message withPrefix:(NSString*)prefix sender:(UIViewController*)sender{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    KFXAlertLogDescriptor *descriptor = config.alertLogDescriptor;
    NSString *fullMessage;
    if (descriptor.shouldFormatMessage) {
        fullMessage = [config.logFormatter formatMessage:message
                                              withPrefix:@"" // Because the prefix is used as the alert title
                                                  sender:sender
                                  formattedLogDescriptor:descriptor];
    }else{
        fullMessage = message;
    }

    dispatch_async(dispatch_get_main_queue(), ^{

        if (sender.isViewLoaded && sender.view.window != nil) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:prefix
                                                                           message:fullMessage
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            NSString *okay = NSLocalizedStringWithDefaultValue(@"com.kfxtech.KFXLogger.alertLogger.okay", @"Localizable", [NSBundle mainBundle], @"Okay", @"Okay, accept, approve, agree");
            UIAlertAction *okayAction = [UIAlertAction actionWithTitle:okay
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];
            [alert addAction:okayAction];
            [sender presentViewController:alert animated:YES completion:nil];
        }
    });
    
}






@end
