/* CoreAnimation - CAEAGLLayer.h

   Copyright (c) 2007-8 Apple Inc.
   All rights reserved. */

#import <QuartzCore/CALayer.h>
#import <OpenGLES/EAGLDrawable.h>

/* CAEAGLLayer is a layer that implements the EAGLDrawable protocol,
 * allowing it to be used as an OpenGLES render target. Use the
 * `drawableProperties' property defined by the protocol to configure
 * the created surface. */

@interface CAEAGLLayer : CALayer <EAGLDrawable>
{
@private
  struct _CAEAGLNativeWindow *_win;
}

/* Note: the default value of the `opaque' property in this class is true,
 * not false as in CALayer. */

@end
