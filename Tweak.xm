#import "Common.h"
#import "../PS.h"
#import "../PSPrefs.x"

/*

Section Location
1 = Normal
2 = Top
3 = Bottom
4 = Isolated

*/

BOOL enabled;
BOOL force;
CGFloat inset;
CGFloat radius;


%hook UITableView

- (UIEdgeInsets)_sectionContentInset
{
	UIEdgeInsets orig = %orig;
	if (!force && (orig.left > 0 || orig.right > 0))
		return orig;
	return UIEdgeInsetsMake(orig.top, inset, orig.bottom, inset);
}

- (void)_setSectionContentInset:(UIEdgeInsets)insets
{
	if (enabled && force)
		%orig(UIEdgeInsetsMake(insets.top, inset, insets.bottom, inset));
	else
		%orig;
}

%end

%hook UIGroupTableViewCellBackground

- (UIBezierPath *)_roundedRectBezierPathInRect:(CGRect)rect withSectionLocation:(int)location forBorder:(BOOL)border cornerRadiusAdjustment:(CGFloat)cornerRadius
{
	if (enabled)
		cornerRadius = radius - 2.5;
	return %orig(rect, location, border, cornerRadius);
}

%end

HaveCallback()
{
	GetPrefs()
	GetBool2(enabled, YES)
	GetBool2(force, NO)
	GetFloat2(inset, defaultInset)
	GetFloat2(radius, defaultRadius)
}

%ctor
{
	NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
	NSUInteger count = args.count;
	if (count != 0) {
		NSString *executablePath = args[0];
		if (executablePath) {
			NSString *processName = [executablePath lastPathComponent];
			BOOL isSpringBoard = [processName isEqualToString:@"SpringBoard"];
			BOOL isExtensionOrApp = [executablePath rangeOfString:@"/Application"].location != NSNotFound;
			BOOL isExtension = [executablePath rangeOfString:@"appex"].location != NSNotFound;
			if (isSpringBoard || (isExtensionOrApp && !isExtension)) {
				BOOL shouldRun;
				GetPrefs()
				NSString *appKey = [NSString stringWithFormat:@"RTEnabled-%@", NSBundle.mainBundle.bundleIdentifier];
				GetBool(shouldRun, appKey, YES)
				if (!shouldRun)
					return;
				HaveObserver()
				callback();
				%init;
			}
		}
	}
}