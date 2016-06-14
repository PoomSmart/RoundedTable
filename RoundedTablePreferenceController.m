#import "Common.h"
#import "../PSPrefs.x"
#import <UIKit/UIKit.h>
#import <Preferences/PSControlTableCell.h>
#import <Cephei/HBListController.h>
#import <Cephei/HBAppearanceSettings.h>
#import <Social/Social.h>

DeclarePrefsTools()

NSString *updateTableNotification = @"com.PS.RoundedTable.updateTable";

@interface RTSliderTableCell : PSControlTableCell
@end

@implementation RTSliderTableCell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)spec
{
	if (self == [super initWithStyle:style reuseIdentifier:identifier specifier:spec]) {
		UISlider *slider = [[[UISlider alloc] init] autorelease];
		slider.continuous = YES;
		slider.minimumValue = [[spec propertyForKey:@"min"] floatValue];
		slider.maximumValue = [[spec propertyForKey:@"max"] floatValue];
		NSString *key = [spec propertyForKey:@"key"];
		float value = floatForKey(key, [[spec propertyForKey:@"default"] floatValue]);
		slider.value = value;
		slider.autoresizingMask = 0x12;
		self.control = slider;
		[slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
		[slider addTarget:self action:@selector(sliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
	}
	return self;
}

- (void)sliderTouchEnded:(UISlider *)slider
{
	[self sliderValueChanged:slider];
}

- (void)sliderValueChanged:(UISlider *)slider
{
	if (!boolForKey(enabledKey, YES))
		return;
	NSString *key = [self.specifier propertyForKey:@"key"];
	// =______=
	if (![key isEqualToString:insetKey]) {
		setFloatForKey(slider.value, key);
		float val = floatForKey(insetKey, defaultInset);
		setFloatForKey(val + 0.001, insetKey);
		//DoPostNotification();
		[NSNotificationCenter.defaultCenter postNotificationName:updateTableNotification object:nil];
		setFloatForKey(val - 0.001, insetKey);
		//DoPostNotification();
		[NSNotificationCenter.defaultCenter postNotificationName:updateTableNotification object:nil];
	} else {
		setFloatForKey(slider.value, key);
		//DoPostNotification();
		[NSNotificationCenter.defaultCenter postNotificationName:updateTableNotification object:nil];
	}
	DoPostNotification();
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGFloat leftPad = 14.0f;
	CGFloat rightPad = 14.0f;
	UIView *contentView = (UIView *)self.contentView;
	UISlider *slider = (UISlider *)self.control;
	slider.center = contentView.center;
	slider.frame = CGRectMake(leftPad, slider.frame.origin.y, contentView.frame.size.width - leftPad - rightPad, slider.frame.size.height);
}
 
@end

@interface RoundedTablePreferenceController : HBListController
@end

@implementation RoundedTablePreferenceController

_HavePrefs([self updateTable:nil];)

HaveBanner(@"RoundedTable", UIColor.blackColor, 40.0, @"No more boring table", UIColor.systemGrayColor, defaultDesFontSize)

+ (NSString *)hb_specifierPlist
{
	return @"RoundedTable";
}

- (instancetype)init
{
	if (self == [super init]) {
		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
		appearanceSettings.tintColor = UIColor.blackColor;
		appearanceSettings.tableViewCellTextColor = UIColor.blackColor;
		self.hb_appearanceSettings = appearanceSettings;
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"💙" style:UIBarButtonItemStylePlain target:self action:@selector(love)] autorelease];
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateTable:) name:updateTableNotification object:nil];
	}
	return self;
}

- (void)updateTable:(id)arg1
{
	// =______=
	[self.table _updateWrapperFrame];
	[self.table _rebuildGeometry];
	[self.table layoutSubviews];
}

- (void)reset:(id)arg1
{
	// =______=
	setBoolForKey(NO, forceKey);
	setFloatForKey(defaultInset, insetKey);
	setFloatForKey(defaultRadius, radiusKey);
	DoPostNotification();
	[NSUserDefaults.standardUserDefaults synchronize];
	[self.table reloadData];
	[self updateTable:nil];
}

- (void)love
{
	SLComposeViewController *twitter = [[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter] retain];
	twitter.initialText = @"#RoundedTable by @PoomSmart is really awesome!";
	[self.navigationController presentViewController:twitter animated:YES completion:nil];
	[twitter release];
}

@end