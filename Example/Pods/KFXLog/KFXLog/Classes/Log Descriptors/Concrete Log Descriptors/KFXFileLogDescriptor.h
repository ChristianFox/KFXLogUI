
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


#import "KFXFormattedLogDescriptor.h"

NS_ASSUME_NONNULL_BEGIN
@interface KFXFileLogDescriptor : KFXFormattedLogDescriptor

/// The method to use to split files (version, build, day, week, month). Defaults to KFXFileLogsSplitByBuild.
@property (nonatomic) KFXFileLogsSplit split;
/// The log types to exclude from the file logs. Defaults to none.
@property (nonatomic) KFXLogType blacklist;
/// The directory path that the files are saved to. If not set will use the path returned from -defaultDirectoryPathForLogFiles.
@property (strong,nonatomic) NSString *directoryPath;
/// The base file name which then has a different suffix appended depending on the split property. Defaults to "Logs"
@property (strong,nonatomic) NSString *fileNameBase;

//--------------------------------------------------------
#pragma mark - Initiliser
//--------------------------------------------------------
/// Returns a new KFXFileLogDescriptor instance with default properties set
+(instancetype)fileLogDescriptor;

//--------------------------------------------------------
#pragma mark - Directory Path
//--------------------------------------------------------
/**
 * @brief The directory where log files will be saved by default
 * @discussion This method will attempt to create a new directory in the Application Support directory called "LogFiles", if that fails for any reason then it will fall back on using the documents directory.
 * @return An NSString with the entire path to the default log files directory
 **/
-(NSString*)defaultDirectoryPathForLogFiles;

@end
NS_ASSUME_NONNULL_END
