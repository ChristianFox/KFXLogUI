
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


#import "KFXLogConfigurator.h"
// Helpers
#import "KFXOptionsReader.h"
#import "KFXLogFormatter.h"
// Loggers
#import "KFXConsoleLogger.h"
#import "KFXFileLogger.h"
#import "KFXAlertLogger.h"

@interface KFXLogConfigurator ()
// # Log Type descriptors - Lazily loaded
@property (strong, nonatomic, readwrite) KFXBasicLogDescriptor *basicLogDescriptor;
@property (strong, nonatomic, readwrite) KFXCleanLogDescriptor *cleanLogDescriptor;
@property (strong, nonatomic, readwrite) KFXFileLogDescriptor *fileLogDescriptor;
@property (strong, nonatomic, readwrite) KFXAlertLogDescriptor *alertLogDescriptor;
// # Loggers
@property (strong, nonatomic, readwrite) KFXConsoleLogger *consoleLogger;
@property (strong, nonatomic, readwrite) KFXFileLogger *fileLogger;
@property (strong, nonatomic, readwrite) KFXAlertLogger *alertLogger;
// # Helpers
@property (strong, nonatomic, readwrite) KFXOptionsReader *optionsReader;
@property (strong, nonatomic, readwrite) KFXLogFormatter *logFormatter;

@end

@implementation KFXLogConfigurator

@synthesize serviceLogDescriptor = _serviceLogDescriptor;


//======================================================
#pragma mark - ** Public Methods **
//======================================================
+(instancetype)sharedConfigurator{
    
    static dispatch_once_t oncePredicate;
    static KFXLogConfigurator *sharedConfigurator = nil;
    
    dispatch_once(&oncePredicate,^{
        sharedConfigurator = [[[self class] alloc]init];
        [sharedConfigurator configureWithDefaults];
    });
    return sharedConfigurator;
}


-(void)printSettings{
    
    NSString *bigLine = @"\n***********************************************\n";
    NSString *header = @"#### KFXLogConfiguration ####";
    
    NSString *buildConfiguration = [self.optionsReader buildConfigurationName];
    NSString *actualBuildConfiguration = [self.optionsReader actualBuildConfigurationName];
    NSString *logOptions = [self.optionsReader logOptionSummaryForBuildConfiguration:self.buildConfiguration];
    NSString *consoleLogType = [self.optionsReader consoleLogType];
    NSString *consoleLogOptions = [self.optionsReader consoleLogOptions];
    NSString *fileLogOptions = [self.optionsReader fileLogOptions];
    NSString *alertLogOptions = [self.optionsReader alertLogOptions];
    NSString *serviceLogOptions = [self.optionsReader serviceLogOptions];
    
    NSString *message = [NSString stringWithFormat:@"\n\n\tBuild Configuration: %@;\n\tActual Build Configuration: %@;\n\tLog Options: %@;\n\tConsole Log Type: %@;\n\n\tConsole Log Options: %@;\n\n\tFile Log Options: %@;\n\n\tAlert Log Options: %@;\n\n\tService Log Options: %@; \n",buildConfiguration,actualBuildConfiguration,logOptions,consoleLogType,consoleLogOptions,fileLogOptions,alertLogOptions,serviceLogOptions];
    NSLog(@"%@%@%@%@\n\n",bigLine,header,message,bigLine);
}

//--------------------------------------------------------
#pragma mark - Public Accessors
//--------------------------------------------------------
-(BOOL)shouldCatchUncaughtExceptions{
    return self.shouldLogUncaughtExceptions;
}
-(void)setShouldCatchUncaughtExceptions:(BOOL)shouldCatchUncaughtExceptions{
    self.shouldLogUncaughtExceptions = shouldCatchUncaughtExceptions;
}


//--------------------------------------------------------
#pragma mark Purge
//--------------------------------------------------------
-(NSInteger)purgeLogFilesOlderThan:(NSInteger)days withError:(NSError * _Nullable __autoreleasing * _Nullable)error{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    KFXFileLogDescriptor *descriptor = config.fileLogDescriptor;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL fileURLWithPath:descriptor.directoryPath isDirectory:YES];
    if (url == nil) {
        return -1;
    }
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:url
                                   includingPropertiesForKeys:@[NSURLCreationDateKey]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:error];
    if (contents == nil) {
        if (error) {
            return -1;
        }else{
            return 0;
        }
    }
    
    NSTimeInterval timeInt = 60*60*24*days;
    NSDate *cutoffDate = [NSDate dateWithTimeIntervalSinceNow:-timeInt];
    NSInteger deletedCount = 0;
    
    for (NSURL *fileURL in contents) {
        
        
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:[fileURL path] error:error];
        NSDate *createdDate = attributes[NSFileCreationDate];
        if (createdDate == nil) {
            return -1;
        }else{
            
            if ([createdDate compare:cutoffDate] == NSOrderedAscending) {
                if (![fileManager removeItemAtURL:fileURL error:error]) {
                    return -1;
                }else{
                    deletedCount++;
                }
            }
        }
        
    }
    
    
    return deletedCount;
}



//======================================================
#pragma mark - ** Private Methods **
//======================================================
-(void)configureWithDefaults{
    
    self.buildConfiguration = KFXBuildConfigurationNone;
    self.debugLogMediums = KFXLogMediumConsole;
    self.consoleLogType = KFXConsoleLogTypeBasic;
    self.shouldLogUncaughtExceptions = NO;
    self.logFormatter = [KFXLogFormatter logFormatter];
    self.shouldLogOnBackgroundQueue = NO;
}


//--------------------------------------------------------
#pragma mark - Lazy Load
//--------------------------------------------------------
-(KFXConsoleLogger *)consoleLogger{
    if (!_consoleLogger) {
        _consoleLogger = [KFXConsoleLogger consoleLogger];
    }
    return _consoleLogger;
}

-(KFXFileLogger *)fileLogger{
    if (!_fileLogger) {
        _fileLogger = [KFXFileLogger fileLogger];
    }
    return _fileLogger;
}

-(KFXAlertLogger *)alertLogger{
    if (!_alertLogger) {
        _alertLogger = [KFXAlertLogger alertLogger];
    }
    return _alertLogger;
}

-(KFXOptionsReader *)optionsReader{
    if (!_optionsReader) {
        _optionsReader = [KFXOptionsReader optionsReader];
    }
    return _optionsReader;
}

-(KFXBasicLogDescriptor *)basicLogDescriptor{
    if (!_basicLogDescriptor) {
        _basicLogDescriptor = [KFXBasicLogDescriptor basicLogDescriptor];
    }
    return _basicLogDescriptor;
}

-(KFXCleanLogDescriptor *)cleanLogDescriptor{
    if (!_cleanLogDescriptor) {
        _cleanLogDescriptor = [KFXCleanLogDescriptor cleanLogDescriptor];
    }
    return _cleanLogDescriptor;
}

-(KFXFileLogDescriptor *)fileLogDescriptor{
    if (!_fileLogDescriptor) {
        _fileLogDescriptor = [KFXFileLogDescriptor fileLogDescriptor];
    }
    return _fileLogDescriptor;
}

-(KFXAlertLogDescriptor *)alertLogDescriptor{
    if (!_alertLogDescriptor) {
        _alertLogDescriptor = [KFXAlertLogDescriptor alertLogDescriptor];
    }
    return _alertLogDescriptor;
}

-(KFXServiceLogDescriptor *)serviceLogDescriptor{
    if (!_serviceLogDescriptor) {
        _serviceLogDescriptor = [KFXServiceLogDescriptor serviceLogDescriptor];
    }
    return _serviceLogDescriptor;
}




@end
