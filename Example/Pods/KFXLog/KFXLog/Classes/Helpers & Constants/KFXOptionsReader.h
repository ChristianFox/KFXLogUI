
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

#import <Foundation/Foundation.h>
#import "KFXLoggerDefinitions.h"

NS_ASSUME_NONNULL_BEGIN
@interface KFXOptionsReader : NSObject

//--------------------------------------------------------
#pragma mark - Initilisers
//--------------------------------------------------------
/// Returns a new instance of KFXOptionsReader
+(instancetype)optionsReader;

//--------------------------------------------------------
#pragma mark - Build Configurations
//--------------------------------------------------------
/// Returns the KFXBuildConfiguration by looking for defined preprocessor macros (DEBUG, ADHOC)
-(KFXBuildConfiguration)actualbuildConfiguration;
/// Returns the KFXLogOptions for the given build configuration
-(KFXLogMediums)logMediumsForBuildConfiguration:(KFXBuildConfiguration)buildConfig;

//--------------------------------------------------------
#pragma mark - Create Strings
//--------------------------------------------------------
/// Returns a string describing the build configuration defined in KFXLogConfigurator
-(NSString*)buildConfigurationName;
/// Returns a string describing the build configuration defined by preprocessor macros (DEBUG, ADHOC)
-(NSString*)actualBuildConfigurationName;
/// Returns a string describing the KFXLogOptions for the given KFXBuildConfiguration
-(NSString*)logOptionSummaryForBuildConfiguration:(KFXBuildConfiguration)buildConfig;
/// Returns a string describing the KFXConsoleLogType
-(NSString*)consoleLogType;
/// Returns a string describing all the options set for console logs
-(NSString*)consoleLogOptions;
/// Returns a string describing all the options set for file logs
-(NSString*)fileLogOptions;
/// Returns a string describing all the options set for alert logs
-(NSString*)alertLogOptions;
/// Returns a string describing all the options set for service logs
-(NSString*)serviceLogOptions;



@end
NS_ASSUME_NONNULL_END
