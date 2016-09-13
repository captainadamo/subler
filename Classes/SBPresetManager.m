//
//  SBPresetManager.m
//  Subler
//
//  Created by Damiano Galassi on 02/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SBPresetManager.h"
#import <MP42Foundation/MP42Metadata.h>

/// Notification sent to update presets lists.
NSString *SBPresetManagerUpdatedNotification = @"SBPresetManagerUpdatedNotification";

@interface SBPresetManager ()
{
    NSMutableArray<MP42Metadata *> *_presets;
}

@property (nonatomic, readonly) NSString *appSupportPath;
- (BOOL)removePresetWithName:(NSString*)name;

@end

@implementation SBPresetManager

@synthesize presets = _presets;

+ (SBPresetManager *)sharedManager
{
    static dispatch_once_t pred;
    static SBPresetManager *sharedPresetManager = nil;

    dispatch_once(&pred, ^{ sharedPresetManager = [[self alloc] init]; });
    return sharedPresetManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _presets = [[NSMutableArray alloc] init];

        [self loadPresets];
    }

    return self;
}

- (void)updateNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SBPresetManagerUpdatedNotification object:self];    
}

- (void)newSetFromExistingMetadata:(MP42Metadata *)set
{
    MP42Metadata *newSet = [set copy];
    [_presets addObject:newSet];

    [self savePresets];
    [self updateNotification];
}

- (NSString *)appSupportPath
{
    NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    return [allPaths.firstObject stringByAppendingPathComponent:@"Subler"];
}

- (BOOL)loadPresets
{
    NSString *file;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appSupportPath = [self appSupportPath];
    MP42Metadata *newPreset;

    if (!appSupportPath) {
        return NO;
    }

    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:appSupportPath];
    while ((file = [dirEnum nextObject])) {
        if ([file.pathExtension isEqualToString:@"sbpreset"]) {
            @try {
                newPreset = [NSKeyedUnarchiver unarchiveObjectWithFile:[appSupportPath stringByAppendingPathComponent:file]];
            }
            @catch (NSException *exception) {
                continue;
            }

            newPreset.edited = NO;
            [_presets addObject:newPreset];
        }
    }

    if (!_presets.count) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)savePresets
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appSupportPath = [self appSupportPath];
    BOOL noErr = YES;

    if (!appSupportPath) {
        return NO;
    }

    if (![fileManager fileExistsAtPath:appSupportPath]) {
        [fileManager createDirectoryAtPath:appSupportPath withIntermediateDirectories:noErr attributes:nil error:NULL];
    }

    for (MP42Metadata  *object in _presets) {
        if (object.isEdited) {
            NSString *saveLocation = [NSString stringWithFormat:@"%@/%@.sbpreset", appSupportPath, object.presetName];
                noErr = [NSKeyedArchiver archiveRootObject:object
                                                toFile:saveLocation];
        }
    }
    return noErr;
}

- (MP42Metadata *)setWithName:(NSString *)name {
    for (MP42Metadata *set in _presets) {
        if ([set.presetName isEqualToString:name]) {
            return set;
        }
    }
    return nil;
}

- (BOOL)removePresetAtIndex:(NSUInteger)index
{
    NSString *name = _presets[index].presetName;
    [_presets removeObjectAtIndex:index];

    [self updateNotification];

    return [self removePresetWithName:name];
}

- (BOOL)removePresetWithName:(NSString *)name
{
    BOOL err = NO;
    NSString *appSupportPath = [self appSupportPath];

    if (!appSupportPath) {
        return NO;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    err = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@.sbpreset", appSupportPath, name]
                                  error:NULL];

    return err;
}

@end
