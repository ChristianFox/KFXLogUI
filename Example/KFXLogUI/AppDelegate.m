

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


#import "AppDelegate.h"
#import <KFXLog/KFXLogConfigurator.h>
#import <KFXLog/KFXLog.h>
#import "DEMOServiceLogger.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    /***
     Quick Start Guide:
     1. Get a reference to the KFXLogConfigurator singleton (do not initilise an instance directly)
     2. Customise any global settings you want to change from the defaults
     3. Customise the descriptors you need to
     4. Create an instance of your service logger class if you are using one and set the serviceLogger property on the configurator
     5. Print a settings summary if you want to
     6. Purge old log files if needed/desired
     ***/
    
    // 1.
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    
    // 2.
    // ## Global Settings
    config.buildConfiguration = KFXBuildConfigurationDebug;
    config.consoleLogType = KFXConsoleLogTypeClean;
    config.debugLogMediums = KFXLogMediumConsole | KFXLogMediumFile | KFXLogMediumAlert;
    config.adHocLogMediums =  KFXLogMediumFile | KFXLogMediumAlert;
    config.releaseLogMediums = KFXLogMediumFile | KFXLogMediumService;
    config.shouldLogUncaughtExceptions = YES;
    config.shouldLogOnBackgroundQueue = NO;
    
    // 3.
    // ## Log Descriptors ##
    // ### BasicLogDescriptor ###
    config.basicLogDescriptor.showSender = KFXShowSenderClassOnly;
    config.basicLogDescriptor.senderPlacement = KFXSenderPlacementEnd;
    
    // ### CleanLogDescriptor ###
    [config.cleanLogDescriptor configureWithLogFormat:KFXLogFormatFir];
    config.cleanLogDescriptor.blacklist = KFXLogTypeNone;
    config.cleanLogDescriptor.showSender = KFXShowSenderClassOnly;
    
    // ### FileLogDescriptor ###
    [config.fileLogDescriptor configureWithLogFormat:KFXLogFormatBirch];
    config.fileLogDescriptor.fileNameBase = @"Logs";
    config.fileLogDescriptor.split = KFXFileLogsSplitByBuild;
    config.fileLogDescriptor.showDate = YES;

    // ### AlertLogDescriptor ###
    [config.alertLogDescriptor configureWithLogFormat:KFXLogFormatPine];
    config.alertLogDescriptor.whitelist = KFXLogTypeNotice;
    config.alertLogDescriptor.showDate = NO;

    // ### ServiceLogDescriptor  ###
    [config.serviceLogDescriptor configureWithLogFormat:KFXLogFormatBalsa];
    
    // 4.
    // ## Service Logger (custom class that conforms to KFXServiceLogger protocol ##
    config.serviceLogger = [DEMOServiceLogger serviceLogger];
    
    // 5.
    // Log a summary of the current settings to the console
    [config printSettings];
    
    
    // 6.
    // Purge
    NSError *error;
    if (![config purgeLogFilesOlderThan:3 withError:&error]) {
        NSLog(@"ERROR: %@",error);
    }
    
    return YES;
}

















@end
