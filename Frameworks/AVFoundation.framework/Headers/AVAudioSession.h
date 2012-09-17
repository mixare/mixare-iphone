/*
	File:  AVAudioSession.h
	
	Framework:  AVFoundation
	
	Copyright 2009-2012 Apple Inc. All rights reserved.
	
*/

#import <AVFoundation/AVBase.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSDate.h>	/* for NSTimeInterval */
#import <AvailabilityMacros.h>

/* This protocol is available with iPhone 3.0 or later */
@protocol AVAudioSessionDelegate;
@class NSError, NSString;

/* values for the category property */
AVF_EXPORT NSString *const AVAudioSessionCategoryAmbient;
AVF_EXPORT NSString *const AVAudioSessionCategorySoloAmbient;
AVF_EXPORT NSString *const AVAudioSessionCategoryPlayback;
AVF_EXPORT NSString *const AVAudioSessionCategoryRecord;
AVF_EXPORT NSString *const AVAudioSessionCategoryPlayAndRecord;
AVF_EXPORT NSString *const AVAudioSessionCategoryAudioProcessing;

AVF_EXPORT NSString *const AVAudioSessionModeDefault NS_AVAILABLE_IOS(5_0);
AVF_EXPORT NSString *const AVAudioSessionModeVoiceChat NS_AVAILABLE_IOS(5_0);
AVF_EXPORT NSString *const AVAudioSessionModeGameChat NS_AVAILABLE_IOS(5_0);
AVF_EXPORT NSString *const AVAudioSessionModeVideoRecording NS_AVAILABLE_IOS(5_0);
AVF_EXPORT NSString *const AVAudioSessionModeMeasurement NS_AVAILABLE_IOS(5_0);

/* flags passed to you when endInterruptionWithFlags: is called on the delegate */
enum {
	AVAudioSessionInterruptionFlags_ShouldResume = 1
};

/* flags for use when calling setActive:withFlags:error: */
enum {	
	AVAudioSessionSetActiveFlags_NotifyOthersOnDeactivation = 1
};

NS_CLASS_AVAILABLE(NA, 3_0)
@interface AVAudioSession : NSObject {
@private
    __strong void *_impl;
}

 /* returns singleton instance */
+ (id)sharedInstance;

@property(assign) id<AVAudioSessionDelegate> delegate;

/* set the session active or inactive */
- (BOOL)setActive:(BOOL)beActive error:(NSError**)outError;
- (BOOL)setActive:(BOOL)beActive withFlags:(NSInteger)flags error:(NSError**)outError NS_AVAILABLE_IOS(4_0);

- (BOOL)setCategory:(NSString*)theCategory error:(NSError**)outError; /* set session category */
- (BOOL)setMode:(NSString*)theMode error:(NSError**)outError NS_AVAILABLE_IOS(5_0); /* set session mode */
- (BOOL)setPreferredHardwareSampleRate:(double)sampleRate error:(NSError**)outError;
- (BOOL)setPreferredIOBufferDuration:(NSTimeInterval)duration error:(NSError**)outError;

@property(readonly) NSString* category; /* get session category */
@property(readonly) NSString* mode NS_AVAILABLE_IOS(5_0); /* get session mode */
@property(readonly) double preferredHardwareSampleRate;
@property(readonly) NSTimeInterval preferredIOBufferDuration;

@property(readonly) BOOL inputIsAvailable; /* is input available or not? */
@property(readonly) double currentHardwareSampleRate;
@property(readonly) NSInteger currentHardwareInputNumberOfChannels;
@property(readonly) NSInteger currentHardwareOutputNumberOfChannels;

@end


/* A protocol for delegates of AVAudioSession */
@protocol AVAudioSessionDelegate <NSObject>
@optional 

- (void)beginInterruption; /* something has caused your audio session to be interrupted */

/* the interruption is over */
- (void)endInterruptionWithFlags:(NSUInteger)flags NS_AVAILABLE_IOS(4_0); /* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
		
- (void)endInterruption; /* endInterruptionWithFlags: will be called instead if implemented. */

/* notification for input become available or unavailable */
- (void)inputIsAvailableChanged:(BOOL)isInputAvailable;

@end
