/*
	File:  AVCaptureInput.h

	Framework:  AVFoundation
 
	Copyright 2010-2012 Apple Inc. All rights reserved.
*/

#import <AVFoundation/AVBase.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CMFormatDescription.h>

@class AVCaptureInputPort;
@class AVCaptureInputInternal;

/*!
 @class AVCaptureInput
 @abstract
	AVCaptureInput is an abstract class that provides an interface for connecting capture input sources to an
	AVCaptureSession.
 
 @discussion
	Concrete instances of AVCaptureInput representing input sources such as cameras can be added to instances of
	AVCaptureSession using the -[AVCaptureSession addInput:] method. An AVCaptureInput vends one or more streams of
	media data. For example, input devices can provide both audio and video data. Each media stream provided by an input
	is represented by an AVCaptureInputPort object. Within a capture session, connections are made between
	AVCaptureInput instances and AVCaptureOutput instances via AVCaptureConnection objects that define the mapping
	between a set of AVCaptureInputPort objects and a single AVCaptureOutput.
*/
NS_CLASS_AVAILABLE(10_7, 4_0)
@interface AVCaptureInput : NSObject 
{
@private
	AVCaptureInputInternal *_inputInternal;
}

/*!
 @property ports
 @abstract
	The ports owned by the receiver.
 
 @discussion
	The value of this property is an array of AVCaptureInputPort objects, each exposing an interface to a single stream
	of media data provided by an input.
*/
@property(nonatomic, readonly) NSArray *ports;

@end


/*!
 @constant AVCaptureInputPortFormatDescriptionDidChangeNotification
 @abstract
	This notification is posted when the value of an AVCaptureInputPort instance's formatDescription property changes.
 
 @discussion
	The notification object is the AVCaptureInputPort instance whose format description changed.
*/
AVF_EXPORT NSString *const AVCaptureInputPortFormatDescriptionDidChangeNotification NS_AVAILABLE(10_7, 4_0);

@class AVCaptureInputPortInternal;

/*!
 @class AVCaptureInputPort
 @abstract
	An AVCaptureInputPort describes a single stream of media data provided by an AVCaptureInput and provides an
	interface for connecting that stream to AVCaptureOutput instances via AVCaptureConnection.
 
 @discussion
	Instances of AVCaptureInputPort cannot be created directly. An AVCaptureInput exposes its input ports via its ports
	property. Input ports provide information about the format of their media data via the mediaType and
	formatDescription properties, and allow clients to control the flow of data via the enabled property. Input ports
	are used by an AVCaptureConnection to define the mapping between inputs and outputs in an AVCaptureSession.
*/
NS_CLASS_AVAILABLE(10_7, 4_0)
@interface AVCaptureInputPort : NSObject
{
@private
    AVCaptureInputPortInternal *_internal;
}

/*!
 @property input
 @abstract
	The input that owns the receiver.
 
 @discussion
	The value of this property is an AVCaptureInput instance that owns the receiver.
*/
@property(nonatomic, readonly) AVCaptureInput *input;

/*!
 @property mediaType
 @abstract
	The media type of the data provided by the receiver.
 
 @discussion
	The value of this property is a constant describing the type of media, such as AVMediaTypeVideo or AVMediaTypeAudio,
	provided by the receiver. Media type constants are defined in AVMediaFormat.h.
*/
@property(nonatomic, readonly) NSString *mediaType;

/*!
 @property formatDescription
 @abstract
	The format of the data provided by the receiver.
 
 @discussion
	The value of this property is a CMFormatDescription that describes the format of the media data currently provided
	by the receiver. Clients can be notified of changes to the format by observing the
	AVCaptureInputPortFormatDescriptionDidChangeNotification.
*/
@property(nonatomic, readonly) CMFormatDescriptionRef formatDescription;

/*!
 @property enabled
 @abstract
	Whether the receiver should provide data.
 
 @discussion
	The value of this property is a BOOL that determines whether the receiver should provide data to outputs when a
	session is running. Clients can set this property to fine tune which media streams from a given input will be used
	during capture. The default value is YES.
*/
@property(nonatomic, getter=isEnabled) BOOL enabled;

@end

@class AVCaptureDevice;
@class AVCaptureDeviceInputInternal;

/*!
 @class AVCaptureDeviceInput
 @abstract
	AVCaptureDeviceInput is a concrete subclass of AVCaptureInput that provides an interface for capturing media from an
	AVCaptureDevice.
 
 @discussion
	Instances of AVCaptureDeviceInput are input sources for AVCaptureSession that provide media data from devices
	connected to the system, represented by instances of AVCaptureDevice.
*/
NS_CLASS_AVAILABLE(10_7, 4_0)
@interface AVCaptureDeviceInput : AVCaptureInput 
{
@private
	AVCaptureDeviceInputInternal *_internal;
}

/*!
 @method deviceInputWithDevice:error:
 @abstract
	Returns an AVCaptureDeviceInput instance that provides media data from the given device.
 
 @param device
	An AVCaptureDevice instance to be used for capture.
 @param outError
	On return, if the given device cannot be used for capture, points to an NSError describing the problem.
 @result
	An AVCaptureDeviceInput instance that provides data from the given device, or nil, if the device could not be used
	for capture.
 
 @discussion
	This method returns an instance of AVCaptureDeviceInput that can be used to capture data from an AVCaptureDevice in
	an AVCaptureSession. This method attempts to open the device for capture, taking exclusive control of it if
	necessary. If the device cannot be opened because it is no longer available or because it is in use, for example,
	this method returns nil, and the optional outError parameter points to an NSError describing the problem.
*/
+ (id)deviceInputWithDevice:(AVCaptureDevice *)device error:(NSError **)outError;

/*!
 @method initWithDevice:error:
 @abstract
	Creates an AVCaptureDeviceInput instance that provides media data from the given device.
 
 @param device
	An AVCaptureDevice instance to be used for capture.
 @param outError
	On return, if the given device cannot be used for capture, points to an NSError describing the problem.
 @result
	An AVCaptureDeviceInput instance that provides data from the given device, or nil, if the device could not be used
	for capture.
 
 @discussion
	This method creates an instance of AVCaptureDeviceInput that can be used to capture data from an AVCaptureDevice in
	an AVCaptureSession. This method attempts to open the device for capture, taking exclusive control of it if
	necessary. If the device cannot be opened because it is no longer available or because it is in use, for example,
	this method returns nil, and the optional outError parameter points to an NSError describing the problem.
*/
- (id)initWithDevice:(AVCaptureDevice *)device error:(NSError **)outError;

/*!
 @property device
 @abstract
	The device from which the receiver provides data.
 
 @discussion
	The value of this property is the AVCaptureDevice instance that was used to create the receiver.
*/
@property(nonatomic, readonly) AVCaptureDevice *device;

@end
