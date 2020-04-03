//
//  Audio.h
//  LMS
//
//  Created by Bill Farmer on 03/07/2018.
//  Copyright © 2018 Bill Farmer. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//

#ifndef Audio_h
#define Audio_h

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import <AudioUnit/AudioUnit.h>
#import <CoreAudio/CoreAudio.h>

#import "SLMS-Swift.h"

// Size
enum
  {kMinWidth = 340,
   kMinHeight = 176};

// Macros
#define Length(a) (sizeof(a) / sizeof(a[0]))

#define kMin        0.5
#define kScale    256.0
#define kTimerDelay 0.1

// Frequency scale
enum
    {kFrequencyScale = 250,
     kFrequencyMax   = 850,
     kFrequencyMin   = 0};

// Meter values
enum
    {kMeterMax   = 200,
     kMeterValue = 0,
     kMeterMin   = 0};

// Audio in values
enum
    {kSampleRate       = 44100,
     kBytesPerPacket   = 4,
     kBytesPerFrame    = 4,
     kChannelsPerFrame = 1};

// Audio processing values
enum
    {kOversample = 4,
     kSamples = 4096,
     kLog2Step = 10,
     kRange = kSamples * 7 / 64,
     kStep = kSamples / kOversample,
     kStep2 = kStep /2};

// Tags
enum
    {kTagFreq   = 'Freq'};

// Keycodes
enum
    {kKeyboardUpKey    = 0x7e,
     kKeyboardDownKey  = 0x7d,
     kKeyboardLeftKey  = 0x7b,
     kKeyboardRightKey = 0x7c,
     kKeyboardPriorKey = 0x74,
     kKeyboardNextKey  = 0x79};

// Global data
typedef struct
{
    int length;
    float *data;
    float slot;
} Spectrum;
Spectrum spectrum;

typedef struct
{
    float frequency;
    float level;
} Display;
Display disp;

typedef struct
{
    float level;
} Meter;
Meter meter;

typedef struct
{
    AudioUnit output;
    float *buffer;
    int frames;
    float sample;
    float frequency;
} Audio;
Audio audio;

NSView *scaleView;
NSControl *knobView;
NSView *displayView;
NSView *meterView;
NSView *spectrumView;

OSStatus InputProc(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags,
                   const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber,
                   UInt32 inNumberFrames, AudioBufferList *ioData);
OSStatus SetupAudio();
OSStatus ShutdownAudio();
void (^ProcessAudio)();
char *AudioUnitErrString(OSStatus);

#endif /* Audio_h */
