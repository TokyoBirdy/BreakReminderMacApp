//
//  AppDelegate.m
//  BreakReminder
//
//  Created by Cecilia Zhang on 3/30/13.
//  Copyright (c) 2013 Cecilia Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "Stopwatch.h"


@implementation AppDelegate {
    int TIMEINTERVAL;
    BOOL firstTimeLaunch;


}

//@synthesize window = _window;
@synthesize mainMenu = _mainMenu;
@synthesize stopwatch = _stopwatch;
@synthesize customChangeTimeView = _customChangTimeView;
@synthesize customMinTextField = _customMinTextField;
@synthesize customSettingView = _customSettingView;
@synthesize customShowTimeTextField = _customShowTimeTextField;
@synthesize customSettingButton = _customSettingButton;
@synthesize backButton = _backButton;
@synthesize settingButton = _settingButton;


NSStatusItem *ourStatus;
NSMenuItem *dateMenuItem;




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    timerIsRunning = YES;
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    TIMEINTERVAL = [[_customMinTextField stringValue] intValue]*60;
    [self reallyStartTimer:TIMEINTERVAL];
    [statusItem setMenu:mainMenu];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"smallCircle.png"]];
    [statusItem setToolTip:NSLocalizedString(@"Menubar Countdown",
                                             @"Status Item Tooltip")];
    [statusItem setTarget:self];
    [statusItem setAction:@selector(openSetting:)];
    firstTimeLaunch = TRUE;
   
    
}


- (void)openSetting:(id)sender {
    if(attachedWindow)
        attachedWindow = Nil;
   
    NSRect frame = [[statusItem valueForKey:@"window"] frame];
    
    NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));
    attachedWindow = [[MAAttachedWindow alloc] initWithView:_customSettingView
                                            attachedToPoint:pt
                                                   inWindow:nil
                                                     onSide:MAPositionBottom
                                                 atDistance:5.0];
    [self showTimer];
   // [attachedWindow makeFirstResponder:attachedWindow];
    [attachedWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    //[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];

}





- (void)reallyStartTimer:(int)seconds {
    timerSettingSeconds = seconds;
    timerIsRunning = YES;
   // self.canResume = NO;
    [_stopwatch reset];
    [self updateStatusItemTitle:timerSettingSeconds];
    [self waitForNextSecond];
    
    
}

-(void) updateStatusItemTitle:(int)timeRemaining{
    
    //TIMEINTERVAL = [[_customMinTextField stringValue] intValue] * 60;
    bool showSeconds = YES;
     
     //[statusItem setTitle:[self timeToString:timeRemaining showSeconds:showSeconds]];

    CGFloat width = 16 * timeRemaining / TIMEINTERVAL ;
    
    NSSize size = CGSizeMake(width, width);
    [statusItem.image setSize:size];
    
    [_customShowTimeTextField setStringValue:[NSString stringWithFormat:@"%@",[self timeToString:timeRemaining showSeconds:showSeconds]]];
    
}


- (NSString *)timeToString:(int)time
               showSeconds:(BOOL)showSeconds {
    if (!showSeconds) {
        // Round timeRemaining up to the next minute
        double minutes = (double)time / 60.0;
        time = (int)ceil(minutes) * 60;
    }
    
    int hours = time / 3600;
    time %= 3600;
    int minutes = time / 60;
    int seconds = time % 60;
    
    // TODO: Use localized time-formatting function
    NSString* timeString;
    if (showSeconds) {
        timeString = [NSString stringWithFormat:@"%02d:%02d:%02d",
                      hours, minutes, seconds];
    }
    else {
        timeString = [NSString stringWithFormat:@"%02d:%02d",
                      hours, minutes];
    }
    return timeString;
}


-(void) waitForNextSecond {
    
    NSTimeInterval elapsed = [_stopwatch elapsedTimeInterval];
    double intervalToNextSecond = ceil(elapsed) - elapsed;
    
    [NSTimer scheduledTimerWithTimeInterval:intervalToNextSecond
                                     target:self
                                   selector:@selector(nextSecondTimerDidFire:)
                                   userInfo:nil
                                    repeats:NO];
}



- (void)nextSecondTimerDidFire:(NSTimer*)timer {
   
    if (timerIsRunning) {
        secondsRemaining = nearbyint(timerSettingSeconds - [_stopwatch elapsedTimeInterval]);
        if (secondsRemaining <= 0) {
           [self timerDidExpire];
        }
        else {
            [self updateStatusItemTitle:secondsRemaining];
            
            [self waitForNextSecond];
        }
    }
}


-(void)timerDidExpire {
    timerIsRunning = NO;
    [NSApp activateIgnoringOtherApps:YES];
    NSRect frame = [[statusItem valueForKey:@"window"] frame];
    NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));
    [self toggleAttachedWindowAtPoint:pt];


}


-(void) toggleAttachedWindowAtPoint:(NSPoint)pt {
    
        if(attachedWindow)
            attachedWindow = Nil;
//    if (!attachedWindow) {
        attachedWindow = [[MAAttachedWindow alloc] initWithView:_customSettingView
                                                attachedToPoint:pt
                                                       inWindow:nil
                                                         onSide:MAPositionBottom
                                                     atDistance:5.0];
        if(_customChangTimeView)
            [_customChangTimeView removeFromSuperview];
        [_customShowTimeTextField setAlphaValue:1];
        [_customShowTimeTextField setStringValue:[self text]];
        _customShowTimeTextField.font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
       // [_customTextContent setStringValue:];
        [attachedWindow makeKeyAndOrderFront:self];
        [NSApp activateIgnoringOtherApps:YES];

}

- (IBAction)restartButtonClicked:(id)sender {
        [attachedWindow orderOut:self];
        attachedWindow = Nil;
      //timerIsRunning = YES;
        [self restartTimer];
}



- (IBAction)settingButtonClicked:(id)sender {
    [self showcustomChangeTimeView];
    [_settingButton setHidden:YES];
   // [_settingButton setTransparent:YES];
    [_settingButton setEnabled:NO];
//    [_backButton setTransparent:NO];
    [_backButton setHidden:NO];
    [_backButton setEnabled:YES];

    
}

- (IBAction)backButtonClicked:(id)sender {

    [self showTimer];
   // [attachedWindow makeFirstResponder:attachedWindow];
  
}

- (IBAction)quitAppButtonClicked:(id)sender {
    [NSApp terminate:self];
}

-(void)restartTimer {
    [_stopwatch reset];
    TIMEINTERVAL = [[_customMinTextField stringValue] intValue] *60;
    [self reallyStartTimer:TIMEINTERVAL];
    
    
}

-(void) showTimer {
    [self showTimeTextField];
    [_backButton setHidden:YES];
    //[_backButton setTransparent:YES];
    [_backButton setEnabled:NO];
    [_settingButton setHidden:NO];
    //[_settingButton setTransparent:NO];
    [_settingButton setEnabled:YES];

}


-(void) showcustomChangeTimeView {
    [_customShowTimeTextField setAlphaValue:0];
    [_customChangTimeView setFrame:NSRectFromCGRect(CGRectMake(20, 50, _customChangTimeView.frame.size.width, _customChangTimeView.frame.size.height))];
    [_customSettingView addSubview:_customChangTimeView];
}


-(void) showTimeTextField {
    if(_customChangTimeView)
        [_customChangTimeView removeFromSuperview];
    [_customShowTimeTextField setAlphaValue:1];
    _customShowTimeTextField.font = [NSFont systemFontOfSize:40];
    if(timerIsRunning == NO)
        _customShowTimeTextField.font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
        
}

- (IBAction)sliderValueChanged:(id)sender {
    NSSlider *slider = sender;
    [_customMinTextField setStringValue:[NSString stringWithFormat:@"%i",[slider intValue]] ];
}

-(NSString *) text {
    
    NSArray *array = [[NSArray alloc] initWithObjects:
                      @"Would you kindly take a break from the computer ? ^^",
                      [NSString stringWithFormat:@"Fancy a cup of tea?\nHow about a nice sandwich?\nHow about a walk in the nice weather?"],
                      @"How about stretching those legs a bit? You've been sitting there for quite some time now...",
                      @"Is there other stuff you need to finish today? Check your schedule",
                      @"Self destruct in T minus 10 seconds",
                      [NSString stringWithFormat:@"Seriously,\nit's time to stop posting on reddit !"],
                      @"Take a break every now,you don't wanna be fat"
                      @"Forgot something in the kitchen ? Is the water boiling?",
                      @"Forgot your pain on the soulder? Take a break now or it will get worse!",
                      nil];
    NSInteger i = arc4random() % [array count];
    
    return [array objectAtIndex:i];
}





@end
