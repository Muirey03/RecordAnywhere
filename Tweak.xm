%group Daemon
%hook RPRecordingManager
//the device is NEVER locked ;)
-(void)setUpDeviceLockNotifications {}
-(void)setDeviceLocked:(BOOL)arg1
{
    %orig(NO);
}
-(BOOL)deviceLocked
{
    return NO;
}
%end
%end

%group SB
//always authenticate
//(allows button to be pressed on lockscreen)
%hook RPControlCenterModuleViewController
-(void)moduleAuthenticateWithCompletionHandler:(void(^)(BOOL))arg1
{
    arg1(YES);
}
%end
%end

%ctor
{
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"])
    {
        //load ReplayKitModule bundle so we can hook it:
        NSBundle* moduleBundle = [NSBundle bundleWithPath:@"/System/Library/ControlCenter/Bundles/ReplayKitModule.bundle"];
        if (!moduleBundle.loaded)
            [moduleBundle load];
        [moduleBundle release];
        %init(SB);
    }
    else
    {
        %init(Daemon);
    }
}