//
//  SBQueuePreferences.h
//  Subler
//
//  Created by Damiano Galassi on 24/06/14.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const SBQueueFileType;
extern NSString * const SBQueueOrganize;
extern NSString * const SBQueueFixFallbacks;
extern NSString * const SBQueueClearTrackName;
extern NSString * const SBQueueMetadata;
extern NSString * const SBQueueSubtitles;
extern NSString * const SBQueueSet;

extern NSString * const SBQueueAutoStart;
extern NSString * const SBQueueOptimize;
extern NSString * const SBQueueShowDoneNotification;

extern NSString * const SBQueueFixTrackLanguage;
extern NSString * const SBQueueFixTrackLanguageValue;

extern NSString * const SBQueueApplyColorSpace;
extern NSString * const SBQueueApplyColorSpaceValue;

extern NSString * const SBQueueMovieProvider;
extern NSString * const SBQueueTVShowProvider;
extern NSString * const SBQueueMovieProviderLanguage;
extern NSString * const SBQueueTVShowProviderLanguage;
extern NSString * const SBQueueProviderArtwork;

extern NSString * const SBQueueDestination;

@interface SBQueuePreferences : NSObject

@property (nonatomic, readonly) NSMutableDictionary<NSString *, id> *options;
@property (nonatomic, readonly, nullable) NSURL *queueURL;

+ (void)registerUserDefaults;
- (void)saveUserDefaults;

@end

NS_ASSUME_NONNULL_END
