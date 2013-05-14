//
//  AppDelegate.h
//  BreakReminder
//
//  Created by Cecilia Zhang on 3/30/13.
//  Copyright (c) 2013 Cecilia Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MAAttachedWindow.h"

@class Stopwatch;



@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSMenu *mainMenu;
    NSStatusItem *statusItem;

     BOOL timerIsRunning;       ///< Instance variable for \c timerIsRunning property
    int secondsRemaining;      ///< Number of seconds remaining
    int timerSettingSeconds;   ///< Timer setting
    MAAttachedWindow *attachedWindow;
   
}


//@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *mainMenu;
@property (weak) IBOutlet Stopwatch *stopwatch;
@property (weak) IBOutlet NSView *customChangeTimeView;
@property (weak) IBOutlet NSSlider *customTimeSlider;
@property (weak) IBOutlet NSTextField *customMinTextField;
@property (weak) IBOutlet NSButton *customSettingButton;
@property (weak) IBOutlet NSView *customSettingView;
@property (weak) IBOutlet NSTextField *customShowTimeTextField;
@property (weak) IBOutlet NSButton *backButton;
@property (weak) IBOutlet NSButton *settingButton;

- (void)toggleAttachedWindowAtPoint:(NSPoint)pt;

@end
