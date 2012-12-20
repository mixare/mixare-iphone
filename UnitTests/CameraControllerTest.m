/*
 * Copyright (C) 2010- Peer internet solutions
 *
 * This file is part of mixare.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>
 */
//
//  CameraControllerTest.m
//  Mixare
//
//  Created by Aswin Ly on 18-12-12.
//

#import "CameraControllerTest.h"

@implementation CameraControllerTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitializeCamera {
    CameraController *camera = [[CameraController alloc] init];
    [camera addVideoInput];
    [camera addVideoPreviewLayer];
    [camera setPortrait];
    [camera setLandscapeLeft];
    [camera setLandscapeRight];
    STAssertNotNil(camera, @"Camera not created");
}

@end