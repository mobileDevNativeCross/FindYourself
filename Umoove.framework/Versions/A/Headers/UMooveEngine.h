/****************************** UMoove PC Face API Engine Header **********************************************************************************\
 
 The UmooveEngine is the main interface to the Umoove tracking process, through it a client interacts with the Umoove process.
 
 Disclaimers:
 THE INFORMATION IS FURNISHED FOR INFORMATIONAL USE ONLY, IS SUBJECT TO CHANGE WITHOUT NOTICE,
 AND SHOULD NOT BE CONSTRUED AS A COMMITMENT BY UMOOVE.
 UMOOVE ASSUMES NO RESPONSIBILITY OR LIABILITY FOR ANY ERRORS OR INACCURACIES THAT MAY APPEAR IN THIS DOCUMENT
 OR ANY SOFTWARE THAT MAY BE PROVIDED IN ASSOCIATION WITH THIS DOCUMENT.
 THIS INFORMATION IS PROVIDED "AS IS" AND UMOOVE DISCLAIMS ANY EXPRESS OR IMPLIED WARRANTY,
 RELATING TO THE USE OF THIS INFORMATION INCLUDING WARRANTIES RELATING TO FITNESS FOR A PARTICULAR PURPOSE,
 COMPLIANCE WITH A SPECIFICATION OR STANDARD, MERCHANTABILITY OR NONINFRINGEMENT.
 
 Legal Notices:
 
 Copyright © 2013, UMOOVE.
 All Rights Reserved.
 The Umoove logo is a registered trademark of Umoove Company.
 Other brands and names are the property of their respective owners.
 
 \************************************************************************************************************************************************/

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

// Umoove Engine Protocol
@protocol umooveDelegate <NSObject>

- (void) UMDirectionsUpdate: (int)x : (int)y;
- (void) UMCursorUpdate: (float)x : (float)y;
- (void) UMLinearSpeedUpdate:(float)x : (float)y;
- (void) UMAbsolutePosition:(float)x :(float)y;
- (void) UMStatesUpdate:(int)state;

@end

@interface UMooveEngine : NSObject {
    
    // Umoove Engine Members
    id<umooveDelegate> umooveDelegate;
    int directionsX;
    int directionsY;
    float cursorX, cursorY;
    int joystickX, joystickY;
    int absolutePositionX, absolutePositionY, gestureX, gestureY;
    int state, alert;
    bool stateFlag, _gbraFormat, _externalFrames;
    
}

// Umoove Engine Properties
@property (assign) id<umooveDelegate> umooveDelegate;
@property (readwrite, assign) AVCaptureSession *captureSession;
@property (nonatomic, retain) NSString *deviceType;

// general methods
- (id) initWithKey:(uint32_t)key;
- (void) start:(BOOL)autoStart;
- (void) stop;
- (void) pause;
- (void) terminate;
- (void) reset;
- (void) stopSensors;
- (void) startSensors;

// setters
- (void) setAutoStart:(BOOL)autoStart;
- (void) setHighResFrame:(BOOL)isHighResFrame;

// getters
- (int) getState;

// enable functions with their setters
- (void) enableCursor: (BOOL)isOn;
- (void) setCursorSensitivity: (float)sensitivity HorizontalInitialPosition: (float)x VerticalInitialPosition: (float)y;

- (void) enableDirections: (BOOL)isOn;
- (void) setDirectionsSensitivity: (float)sensitivity CenterZone: (float)centerZone Levels: (int)levels;

- (void) enableLinearSpeed:(BOOL)isOn;

- (void) enableAbsolutePosition:(BOOL)isOn;


// funtions used when the client send the frames and are not initiated internally
- (id) initWithExternalFrames:(BOOL)externalFrames withGBRAformat:(BOOL)GBRAformat withKey:(uint32_t)key;
- (void) proccessFrame:(uint8_t*)frame withWidth:(int)width withHeight:(int)height;

@end
