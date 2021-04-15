
#Note: This solution is unique in that it uses the Keychain Access menu bar status functionality, but it does not require you to enable the Show keychain status in menu bar option as the AppleScript methods do.
#
#I was also looking for a solution for this. Today I just had some time to play around and found a way to programmatically actually call the functionality from the keychain menu plugin. This solution works perfectly as long as Apple doesn't change the relevant parts in the keychain menu plugin. You can create a small binary for locking your screen by pasting this into your terminal...
#
# Do our work in the temporary directory that gets cleaned on boot
cd /tmp

# Create the source file
cat > main.m <<END_OF_FILE

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

int main () {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Applications/Utilities/Keychain Access.app/Contents/Resources/Keychain.menu"];

    Class principalClass = [bundle principalClass];

    id instance = [[principalClass alloc] init];

    [instance performSelector:@selector(_lockScreenMenuHit:) withObject:nil];

    return 0;
}

END_OF_FILE

# Compile the source file
clang -framework Foundation main.m -o lockscreen
