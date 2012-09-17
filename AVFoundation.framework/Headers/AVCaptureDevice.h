/*
	File:  AVCaptureDevice.h
 
	Framework:  AVFoundation
 
	Copyright 2010-2012 Apple Inc. All rights reserved.
*/

#import <AVFoundation/AVBase.h>
#import <Foundation/Foundation.h>
#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE || TARGET_OS_WIN32)
	#include <CoreGraphics/CGBase.h>
	#include <CoreGraphics/CGGeometry.h>
#elif TARGET_OS_MAC
	#include <ApplicationServices/../Frameworks/CoreGraphics.framework/Headers/CGBase.h>
	#include <ApplicationServices/../Frameworks/CoreGraphics.framework/Headers/CGGeometry.h>
#endif

/*!
 @constant  AVCaptureDeviceWasConnectedNotification
 @abstract
	Posted when a device becomes available on the system.
 
 @discussion
	The notification object is an AVCaptureDevice instance representing the device that became available.
*/
AVF_EXPORT NSString *const AVCaptureDeviceWasConnectedNotification NS_AVAILABLE(10_7, 4_0);

/*!
 @constant  AVCaptureDeviceWasDisconnectedNotification
 @abstract
	Posted when a device becomes unavailable on the system.
 
 @discussion
	The notification object is an AVCaptureDevice instance representing the device that became unavailable.
*/
AVF_EXPORT NSString *const AVCaptureDeviceWasDisconnectedNotification NS_AVAILABLE(10_7, 4_0);

/*!
 @constant  AVCaptureDeviceSubjectAreaDidChangeNotification
 @abstract
	Posted when the instance of AVCaptureDevice has detected a substantial change
	to the video subject area.
 
 @discussion
	Clients may observe the AVCaptureDeviceSubjectAreaDidChangeNotification to know
	when an instance of AVCaptureDevice has detected a substantial change
	to the video subject area.  This notification is only sent if you first set
	subjectAreaChangeMonitoringEnabled to YES.
 */
AVF_EXPORT NSString *const AVCaptureDeviceSubjectAreaDidChangeNotification NS_AVAILABLE_IOS(5_0);

@class AVCaptureDeviceInternal;

/*!
 @class AVCaptureDevice
 @abstract
	An AVCaptureDevice represents a physical device that provides realtime input media data, such as video and audio.
 
 @discussion
	Each instance of AVCaptureDevice corresponds to a device, such as a camera or microphone. Instances of
	AVCaptureDevice cannot be created directly. An array of all currently available devices can also be obtained using
	the devices class method. Devices can provide one or more streams of a given media type. Applications can search
	for devices that provide media of a specific type using the devicesWithMediaType: and defaultDeviceWithMediaType:
	class methods.
	
	Instances of AVCaptureDevice can be used to provide media data to an AVCaptureSession by creating an
	AVCaptureDeviceInput with the device and adding that to the capture session.
*/
NS_CLASS_AVAILABLE(10_7, 4_0)
@interface AVCaptureDevice : NSObject
{
    AVCaptureDeviceInternal *_internal;
}

/*!
 @method devices
 @abstract
	Returns an array of devices currently available for use as media input sources.
 
 @result
	An NSArray of AVCaptureDevice instances for each available device.
 
 @discussion
	This method returns an array of AVCaptureDevice instances for input devices currently connected and available for
	capture. The returned array contains all devices that are available at the time the method is called. Applications
	should observe AVCaptureDeviceWasConnectedNotification and AVCaptureDeviceWasDisconnectedNotification to be notified
	when the list of available devices has changed.
*/
+ (NSArray *)devices;

/*!
 @method devicesWithMediaType:
 @abstract
	Returns an array of devices currently available for use as sources of media with the given media type.
 
 @param mediaType
	The media type, such as AVMediaTypeVideo, AVMediaTypeAudio, or AVMediaTypeMuxed, supported by each returned device.
 @result
	An NSArray of AVCaptureDevice instances for each available device.
 
 @discussion
	This method returns an array of AVCaptureDevice instances for input devices currently connected and available for
	capture that provide media of the given type. Media type constants are defined in AVMediaFormat.h. The returned
	array contains all devices that are available at the time the method is called. Applications should observe
	AVCaptureDeviceWasConnectedNotification and AVCaptureDeviceWasDisconnectedNotification to be notified when the list
	of available devices has changed.
*/
+ (NSArray *)devicesWithMediaType:(NSString *)mediaType;

/*!
 @method defaultDeviceWithMediaType:
 @abstract
	Returns an AVCaptureDevice instance for the default device of the given media type.

 @param mediaType
	The media type, such as AVMediaTypeVideo, AVMediaTypeAudio, or AVMediaTypeMuxed, supported by the returned device.
 @result
	The default device with the given media type, or nil if no device with that media type exists.
 
 @discussion
	This method returns the default device of the given media type currently available on the system. For example, for
	AVMediaTypeVideo, this method will return the built in camera that is primarily used for capture and recording.
	Media type constants are defined in AVMediaFormat.h.
*/
+ (AVCaptureDevice *)defaultDeviceWithMediaType:(NSString *)mediaType;

/*!
 @method deviceWithUniqueID:
 @abstract
	Returns an AVCaptureDevice instance with the given unique ID.
 
 @param deviceUniqueID
	The unique ID of the device instance to be returned.
 @result
	An AVCaptureDevice instance with the given unique ID, or nil if no device with that unique ID is available.
 
 @discussion
	Every available capture device has a unique ID that persists on one system across device connections and
	disconnections, application restarts, and reboots of the system itself. This method can be used to recall or track
	the status of a specific device whose unique ID has previously been saved.
*/
+ (AVCaptureDevice *)deviceWithUniqueID:(NSString *)deviceUniqueID;

/*!
 @property uniqueID
 @abstract
	An ID unique to the model of device corresponding to the receiver.
  
 @discussion
	Every available capture device has a unique ID that persists on one system across device connections and
	disconnections, application restarts, and reboots of the system itself. Applications can store the value returned by
	this property to recall or track the status of a specific device in the future.
*/
@property(nonatomic, readonly) NSString *uniqueID;

/*!
 @property modelID
 @abstract
	The model ID of the receiver.
 
 @discussion
	The value of this property is an identifier unique to all devices of the same model. The value is persistent across
	device connections and disconnections, and across different systems. For example, the model ID of the camera built
	in to two identical iPhone models will be the same even though they are different physical devices.
*/
@property(nonatomic, readonly) NSString *modelID;


/*!
 @property localizedName
 @abstract
	A localized human-readable name for the receiver.
 
 @discussion
	This property can be used for displaying the name of a capture device in a user interface.
*/
@property(nonatomic, readonly) NSString *localizedName;

/*!
 @method hasMediaType:
 @abstract
	Returns whether the receiver provides media with the given media type.
 
 @param mediaType
	A media type, such as AVMediaTypeVideo, AVMediaTypeAudio, or AVMediaTypeMuxed.
 @result
	YES if the device outputs the given media type, NO otherwise.
 
 @discussion
	Media type constants are defined in AVMediaFormat.h.
*/
- (BOOL)hasMediaType:(NSString *)mediaType;


/*!
 @method lockForConfiguration:
 @abstract
	Requests exclusive access to configure device hardware properties.
 
 @param outError
	On return, if the device could not be locked, points to an NSError describing why the failure occurred.
 @result
	A BOOL indicating whether the device was successfully locked for configuration.
 
 @discussion
	In order to set hardware properties on an AVCaptureDevice, such as focusMode and exposureMode, clients must first
	acquire a lock on the device.  Clients should only hold the device lock if they require settable device properties
	to remain unchanged.  Holding the device lock unnecessarily may degrade capture quality in other applications
	sharing the device.
*/
- (BOOL)lockForConfiguration:(NSError **)outError;

/*!
 @method unlockForConfiguration
 @abstract
	Release exclusive control over device hardware properties.
  
 @discussion
	This method should be called to match an invocation of lockForConfiguration: when an application no longer needs to
	keep device hardware properties from changing automatically.
*/
- (void)unlockForConfiguration;

/*!
 @method supportsAVCaptureSessionPreset:
 @abstract
	Returns whether the receiver can be used in an AVCaptureSession configured with the given preset.
 
 @param preset
	An AVCaptureSession preset.
 @result
	YES if the receiver can be used with the given preset, NO otherwise.
 
 @discussion
	An AVCaptureSession instance can be associated with a preset that configures its inputs and outputs to fulfill common
	use cases. This method can be used to determine if the receiver can be used in a capture session with the given
	preset. Presets are defined in AVCaptureSession.h.
*/
- (BOOL)supportsAVCaptureSessionPreset:(NSString *)preset;

/*!
 @property connected
 @abstract
	Indicates whether the device is connected and available to the system.
 
 @discussion
	The value of this property is a BOOL indicating whether the device represented by the receiver is connected and
	available for use as a capture device. Clients can key value observe the value of this property to be notified when
	a device is no longer available. When the value of this property becomes NO for a given instance, it will not become
	YES again. If the same physical device again becomes available to the system, it will be represented using a new
	instance of AVCaptureDevice.
*/
@property(nonatomic, readonly, getter=isConnected) BOOL connected;

@end


/*!
 @enum  AVCaptureDevicePosition
 @abstract
	Constants indicating the physical position of an AVCaptureDevice's hardware on the system.
 
 @constant AVCaptureDevicePositionBack
	Indicates that the device is physically located on the back of the system hardware.
 @constant AVCaptureDevicePositionFront
	Indicates that the device is physically located on the front of the system hardware.
*/
enum {
	AVCaptureDevicePositionBack                = 1,
	AVCaptureDevicePositionFront               = 2
};
typedef NSInteger AVCaptureDevicePosition;

@interface AVCaptureDevice (AVCaptureDevicePosition)

/*!
 @property position
 @abstract
	Indicates the physical position of an AVCaptureDevice's hardware on the system.
 
 @discussion
	The value of this property is an AVCaptureDevicePosition indicating where the receiver's device is physically
	located on the system hardware.
*/
@property(nonatomic, readonly) AVCaptureDevicePosition position;

@end

/*!
 @enum  AVCaptureFlashMode
 @abstract
	Constants indicating the mode of the flash on the receiver's device, if it has one.
 
 @constant AVCaptureFlashModeOff
	Indicates that the flash should always be off.
 @constant AVCaptureFlashModeOn
	Indicates that the flash should always be on.
 @constant AVCaptureFlashModeAuto
	Indicates that the flash should be used automatically depending on ambient light conditions.
*/
enum {
	AVCaptureFlashModeOff  = 0,
	AVCaptureFlashModeOn   = 1,
	AVCaptureFlashModeAuto = 2
};
typedef NSInteger AVCaptureFlashMode;

@interface AVCaptureDevice (AVCaptureDeviceFlash)

/*!
 @property hasFlash
 @abstract
	Indicates whether the receiver has a flash.
 
 @discussion
	The value of this property is a BOOL indicating whether the receiver has a flash. The receiver's flashMode property
	can only be set when this property returns YES.
*/
@property(nonatomic, readonly) BOOL hasFlash;

/*!
 @property flashAvailable
 @abstract
 Indicates whether the receiver's flash is currently available for use.
 
 @discussion
 The value of this property is a BOOL indicating whether the receiver's flash is 
 currently available. The flash may become unavailable if, for example, the device
 overheats and needs to cool off. This property is key-value observable.
 */
@property(nonatomic, readonly, getter=isFlashAvailable) BOOL flashAvailable NS_AVAILABLE_IOS(5_0);

/*!
 @property flashActive
 @abstract
 Indicates whether the receiver's flash is currently active.
 
 @discussion
 The value of this property is a BOOL indicating whether the receiver's flash is 
 currently active. When the flash is active, it will flash if a still image is
 captured. This property is key-value observable.
 */
@property(nonatomic, readonly, getter=isFlashActive) BOOL flashActive NS_AVAILABLE_IOS(5_0);

/*!
 @method isFlashModeSupported:
 @abstract
	Returns whether the receiver supports the given flash mode.
 
 @param flashMode
	An AVCaptureFlashMode to be checked.
 @result
	YES if the receiver supports the given flash mode, NO otherwise.
 
 @discussion
	The receiver's flashMode property can only be set to a certain mode if this method returns YES for that mode.
*/
- (BOOL)isFlashModeSupported:(AVCaptureFlashMode)flashMode;

/*!
 @property flashMode
 @abstract
	Indicates current mode of the receiver's flash, if it has one.
 
 @discussion
	The value of this property is an AVCaptureFlashMode that determines the mode of the 
	receiver's flash, if it has one.  -setFlashMode: throws an NSInvalidArgumentException
    if set to an unsupported value (see -isFlashModeSupported:).  -setFlashMode: throws an NSGenericException 
    if called without first obtaining exclusive access to the receiver using lockForConfiguration:.
    Clients can observe automatic changes to the receiver's flashMode by key value observing this property.
*/
@property(nonatomic) AVCaptureFlashMode flashMode;

@end

/*!
 @enum  AVCaptureTorchMode
 @abstract
	Constants indicating the mode of the torch on the receiver's device, if it has one.
 
 @constant AVCaptureTorchModeOff
	Indicates that the torch should always be off.
 @constant AVCaptureTorchModeOn
	Indicates that the torch should always be on.
 @constant AVCaptureTorchModeAuto
	Indicates that the torch should be used automatically depending on ambient light conditions.
*/
enum {
	AVCaptureTorchModeOff  = 0,
	AVCaptureTorchModeOn   = 1,
	AVCaptureTorchModeAuto = 2,
};
typedef NSInteger AVCaptureTorchMode;

@interface AVCaptureDevice (AVCaptureDeviceTorch)

/*!
 @property hasTorch
 @abstract
	Indicates whether the receiver has a torch.
 
 @discussion
	The value of this property is a BOOL indicating whether the receiver has a torch. The receiver's torchMode property
	can only be set when this property returns YES.
*/
@property(nonatomic, readonly) BOOL hasTorch;

/*!
 @property torchAvailable
 @abstract
 Indicates whether the receiver's torch is currently available for use.
 
 @discussion
 The value of this property is a BOOL indicating whether the receiver's torch is 
 currently available. The torch may become unavailable if, for example, the device
 overheats and needs to cool off. This property is key-value observable.
 */
@property(nonatomic, readonly, getter=isTorchAvailable) BOOL torchAvailable NS_AVAILABLE_IOS(5_0);

/*!
 @property torchLevel
 @abstract
 Indicates the receiver's current torch brightness level as a floating point value.
 
 @discussion
 The value of this property is a float indicating the receiver's torch level 
 from 0.0 (off) -> 1.0 (full). This property is key-value observable.
 */
@property(nonatomic, readonly) float torchLevel NS_AVAILABLE_IOS(5_0);

/*!
 @method isTorchModeSupported:
 @abstract
 Returns whether the receiver supports the given torch mode.
 
 @param torchMode
	An AVCaptureTorchMode to be checked.
 @result
	YES if the receiver supports the given torch mode, NO otherwise.
 
 @discussion
	The receiver's torchMode property can only be set to a certain mode if this method returns YES for that mode.
*/
- (BOOL)isTorchModeSupported:(AVCaptureTorchMode)torchMode;

/*!
 @property torchMode
 @abstract
	Indicates current mode of the receiver's torch, if it has one.
 
 @discussion
	The value of this property is an AVCaptureTorchMode that determines the mode of the 
	receiver's torch, if it has one.  -setTorchMode: throws an NSInvalidArgumentException
    if set to an unsupported value (see -isTorchModeSupported:).  -setTorchMode: throws an NSGenericException 
    if called without first obtaining exclusive access to the receiver using lockForConfiguration:.
    Clients can observe automatic changes to the receiver's torchMode by key value observing this property.
*/
@property(nonatomic) AVCaptureTorchMode torchMode;

@end

/*!
 @enum  AVCaptureFocusMode
 @abstract
	Constants indicating the mode of the focus on the receiver's device, if it has one.
 
 @constant AVCaptureFocusModeLocked
	Indicates that the focus should be locked at the lens' current position.
 @constant AVCaptureFocusModeAutoFocus
	Indicates that the device should autofocus once and then change the focus mode to AVCaptureFocusModeLocked.
 @constant AVCaptureFocusModeContinuousAutoFocus
	Indicates that the device should automatically focus when needed.
*/
enum {
	AVCaptureFocusModeLocked              = 0,
	AVCaptureFocusModeAutoFocus           = 1,
	AVCaptureFocusModeContinuousAutoFocus = 2,
};
typedef NSInteger AVCaptureFocusMode;

@interface AVCaptureDevice (AVCaptureDeviceFocus)

/*!
 @method isFocusModeSupported:
 @abstract
	Returns whether the receiver supports the given focus mode.
 
 @param focusMode
	An AVCaptureFocusMode to be checked.
 @result
	YES if the receiver supports the given focus mode, NO otherwise.
 
 @discussion
	The receiver's focusMode property can only be set to a certain mode if this method returns YES for that mode.
*/
- (BOOL)isFocusModeSupported:(AVCaptureFocusMode)focusMode;

/*!
 @property focusMode
 @abstract
	Indicates current focus mode of the receiver, if it has one.
 
 @discussion
	The value of this property is an AVCaptureFocusMode that determines the receiver's focus mode, if it has one.
	-setFocusMode: throws an NSInvalidArgumentException if set to an unsupported value (see -isFocusModeSupported:).  
	-setFocusMode: throws an NSGenericException if called without first obtaining exclusive access to the receiver 
	using lockForConfiguration:.  Clients can observe automatic changes to the receiver's focusMode by key value 
	observing this property.
*/
@property(nonatomic) AVCaptureFocusMode focusMode;

/*!
 @property focusPointOfInterestSupported
 @abstract
	Indicates whether the receiver supports focus points of interest.
 
 @discussion
	The receiver's focusPointOfInterest property can only be set if this property returns YES.
*/
@property(nonatomic, readonly, getter=isFocusPointOfInterestSupported) BOOL focusPointOfInterestSupported;

/*!
 @property focusPointOfInterest
 @abstract
	Indicates current focus point of interest of the receiver, if it has one.
 
 @discussion
	The value of this property is a CGPoint that determines the receiver's focus point of interest, if it has one. A
	value of (0,0) indicates that the camera should focus on the bottom left corner of the image, while a value of (1,1)
	indicates that it should focus on the top right. The default value is (0.5,0.5).  -setFocusPointOfInterest:
	throws an NSInvalidArgumentException if isFocusPointOfInterestSupported returns NO.  -setFocusPointOfInterest: throws 
	an NSGenericException if called without first obtaining exclusive access to the receiver using lockForConfiguration:.  
	Clients can observe automatic changes to the receiver's focusMode by key value observing this property.  Note that
	setting focusPointOfInterest alone does not initiate a focus operation.  After setting focusPointOfInterest, call
	-setFocusMode: to apply the new point of interest.
*/
@property(nonatomic) CGPoint focusPointOfInterest;

/*!
 @property adjustingFocus
 @abstract
	Indicates whether the receiver is currently adjusting camera focus.
 
 @discussion
	The value of this property is a BOOL indicating whether the receiver's camera focus is being automatically
	adjusted because its focus mode is AVCaptureFocusModeAutoFocus or AVCaptureFocusModeContinuousAutoFocus. Clients can
	observe the value of this property to determine whether the camera focus is stable or is being automatically
	adjusted.
*/
@property(nonatomic, readonly, getter=isAdjustingFocus) BOOL adjustingFocus;

@end

/*!
 @enum  AVCaptureExposureMode
 @abstract
	Constants indicating the mode of the exposure on the receiver's device, if it has adjustable exposure.
 
 @constant AVCaptureExposureModeLocked
	Indicates that the exposure should be locked at its current value.
 @constant AVCaptureExposureModeAutoExpose
	Indicates that the device should automatically adjust exposure once and then change the exposure mode to 
	AVCaptureExposureModeLocked.
 @constant AVCaptureExposureModeContinuousAutoExposure
	Indicates that the device should automatically adjust exposure when needed.
*/
enum {
	AVCaptureExposureModeLocked					= 0,
	AVCaptureExposureModeAutoExpose				= 1,
	AVCaptureExposureModeContinuousAutoExposure	= 2,
};
typedef NSInteger AVCaptureExposureMode;

@interface AVCaptureDevice (AVCaptureDeviceExposure)

/*!
 @method isExposureModeSupported:
 @abstract
	Returns whether the receiver supports the given exposure mode.
 
 @param exposureMode
	An AVCaptureExposureMode to be checked.
 @result
	YES if the receiver supports the given exposure mode, NO otherwise.
 
 @discussion
	The receiver's exposureMode property can only be set to a certain mode if this method returns YES for that mode.
*/
- (BOOL)isExposureModeSupported:(AVCaptureExposureMode)exposureMode;

/*!
 @property exposureMode
 @abstract
	Indicates current exposure mode of the receiver, if it has adjustable exposure.
 
 @discussion
	The value of this property is an AVCaptureExposureMode that determines the receiver's exposure mode, if it has
	adjustable exposure.  -setExposureMode: throws an NSInvalidArgumentException if set to an unsupported value 
	(see -isExposureModeSupported:).  -setExposureMode: throws an NSGenericException if called without first obtaining 
	exclusive access to the receiver using lockForConfiguration:.  Clients can observe automatic changes to the receiver's 
	exposureMode by key value observing this property.
*/
@property(nonatomic) AVCaptureExposureMode exposureMode;

/*!
 @property exposurePointOfInterestSupported:
 @abstract
	Indicates whether the receiver supports exposure points of interest.
 
 @discussion
	The receiver's exposurePointOfInterest property can only be set if this property returns YES.
*/
@property(nonatomic, readonly, getter=isExposurePointOfInterestSupported) BOOL exposurePointOfInterestSupported;

/*!
 @property exposurePointOfInterest
 @abstract
	Indicates current exposure point of interest of the receiver, if it has one.
 
 @discussion
	The value of this property is a CGPoint that determines the receiver's exposure point of interest, if it has
	adjustable exposure. A value of (0,0) indicates that the camera should adjust exposure based on the bottom left
	corner of the image, while a value of (1,1) indicates that it should adjust exposure based on the top right. The
	default value is (0.5,0.5). -setExposurePointOfInterest: throws an NSInvalidArgumentException if isExposurePointOfInterestSupported 
	returns NO.  -setExposurePointOfInterest: throws an NSGenericException if called without first obtaining exclusive access 
	to the receiver using lockForConfiguration:.  Clients can observe automatic changes to the receiver's exposureMode 
	by key value observing this property.  Note that setting exposurePointOfInterest alone does not initiate an exposure 
	operation.  After setting exposurePointOfInterest, call -setExposureMode: to apply the new point of interest.
*/
@property(nonatomic) CGPoint exposurePointOfInterest;

/*!
 @property adjustingExposure
 @abstract
	Indicates whether the receiver is currently adjusting camera exposure.
 
 @discussion
	The value of this property is a BOOL indicating whether the receiver's camera exposure is being automatically
	adjusted because its exposure mode is AVCaptureExposureModeAutoExpose or AVCaptureExposureModeContinuousAutoExposure.
	Clients can observe the value of this property to determine whether the camera exposure is stable or is being
	automatically adjusted.
*/
@property(nonatomic, readonly, getter=isAdjustingExposure) BOOL adjustingExposure;

@end

/*!
 @enum  AVCaptureWhiteBalanceMode
 @abstract
	Constants indicating the mode of the white balance on the receiver's device, if it has adjustable white balance.
 
 @constant AVCaptureWhiteBalanceModeLocked
	Indicates that the white balance should be locked at its current value.
 @constant AVCaptureWhiteBalanceModeAutoWhiteBalance
	Indicates that the device should automatically adjust white balance once and then change the white balance mode to 
	AVCaptureWhiteBalanceModeLocked.
 @constant AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance
	Indicates that the device should automatically adjust white balance when needed.
*/
enum {
	AVCaptureWhiteBalanceModeLocked				        = 0,
	AVCaptureWhiteBalanceModeAutoWhiteBalance	        = 1,
    AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance = 2,
};
typedef NSInteger AVCaptureWhiteBalanceMode;

@interface AVCaptureDevice (AVCaptureDeviceWhiteBalance)

/*!
 @method isWhiteBalanceModeSupported:
 @abstract
	Returns whether the receiver supports the given white balance mode.
 
 @param whiteBalanceMode
	An AVCaptureWhiteBalanceMode to be checked.
 @result
	YES if the receiver supports the given white balance mode, NO otherwise.
 
 @discussion
	The receiver's whiteBalanceMode property can only be set to a certain mode if this method returns YES for that mode.
*/
- (BOOL)isWhiteBalanceModeSupported:(AVCaptureWhiteBalanceMode)whiteBalanceMode;

/*!
 @property whiteBalanceMode
 @abstract
	Indicates current white balance mode of the receiver, if it has adjustable white balance.
 
 @discussion
	The value of this property is an AVCaptureWhiteBalanceMode that determines the receiver's white balance mode, if it
	has adjustable white balance. -setWhiteBalanceMode: throws an NSInvalidArgumentException if set to an unsupported value 
	(see -isWhiteBalanceModeSupported:).  -setWhiteBalanceMode: throws an NSGenericException if called without first obtaining 
	exclusive access to the receiver using lockForConfiguration:.  Clients can observe automatic changes to the receiver's 
	whiteBalanceMode by key value observing this property.
*/
@property(nonatomic) AVCaptureWhiteBalanceMode whiteBalanceMode;

/*!
 @property adjustingWhiteBalance
 @abstract
	Indicates whether the receiver is currently adjusting camera white balance.
 
 @discussion
	The value of this property is a BOOL indicating whether the receiver's camera white balance is being
	automatically adjusted because its white balance mode is AVCaptureWhiteBalanceModeAutoWhiteBalance or
	AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance. Clients can observe the value of this property to determine
	whether the camera white balance is stable or is being automatically adjusted.
*/
@property(nonatomic, readonly, getter=isAdjustingWhiteBalance) BOOL adjustingWhiteBalance;

@end

@interface AVCaptureDevice (AVCaptureDeviceSubjectAreaChangeMonitoring)

/*!
 @property subjectAreaChangeMonitoringEnabled
 @abstract
	Indicates whether the receiver should monitor the subject area for changes.
 
 @discussion
	The value of this property is a BOOL indicating whether the receiver should
	monitor the video subject area for changes, such as lighting changes, substantial
	movement, etc.  If subject area change monitoring is enabled, the receiver
	sends an AVCaptureDeviceSubjectAreaDidChangeNotification whenever it detects
	a change to the subject area, at which time an interested client may wish
	to re-focus, adjust exposure, white balance, etc.  The receiver must be locked 
	for configuration using lockForConfiguration: before clients can set
	the value of this property.
 */
@property(nonatomic, getter=isSubjectAreaChangeMonitoringEnabled) BOOL subjectAreaChangeMonitoringEnabled NS_AVAILABLE_IOS(5_0);

@end
