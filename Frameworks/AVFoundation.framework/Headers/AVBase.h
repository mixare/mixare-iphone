/*
	File:  AVBase.h

	Framework:  AVFoundation
 
	Copyright 2010-2012 Apple Inc. All rights reserved.

 */

#import <Availability.h>
#import <Foundation/NSObjCRuntime.h>

#if defined(__cplusplus)
	#define AVF_EXPORT extern "C"
#else
	#define AVF_EXPORT extern
#endif

// Pre-10.7, weak import
#ifndef __AVAILABILITY_INTERNAL__MAC_10_7
	#define __AVAILABILITY_INTERNAL__MAC_10_7 __AVAILABILITY_INTERNAL_WEAK_IMPORT
#endif

// Pre-5.0, weak import
#ifndef __AVAILABILITY_INTERNAL__IPHONE_5_0
	#define __AVAILABILITY_INTERNAL__IPHONE_5_0 __AVAILABILITY_INTERNAL_WEAK_IMPORT
#endif

// To be determined, weak import
#ifndef __AVAILABILITY_INTERNAL__IPHONE_TBD
	#define __AVAILABILITY_INTERNAL__IPHONE_TBD __AVAILABILITY_INTERNAL_WEAK_IMPORT
#endif

#ifndef __AVAILABILITY_INTERNAL__MAC_TBD
	#define __AVAILABILITY_INTERNAL__MAC_TBD __AVAILABILITY_INTERNAL_WEAK_IMPORT
#endif

#ifndef AVAILABLE_MAC_OS_X_VERSION_TBD_AND_LATER
   #define AVAILABLE_MAC_OS_X_VERSION_TBD_AND_LATER WEAK_IMPORT_ATTRIBUTE
#endif

#ifndef NS_AVAILABLE
    #define NS_AVAILABLE(a, b)
#endif

#ifndef NS_AVAILABLE_IOS
	#define NS_AVAILABLE_IOS(a)
#endif

#ifndef NS_CLASS_AVAILABLE
    #define NS_CLASS_AVAILABLE(a, b)
#endif
