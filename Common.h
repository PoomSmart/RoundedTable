#import "../PS.h"

#define tweakIdentifier @"com.PS.RoundedTable"

#define enabledKey @"enabled"
#define forceKey @"force"
#define insetKey @"inset"
#define radiusKey @"radius"

#define defaultInset 16.0
#define defaultRadius 2.5

@interface UITableViewCell (Private)
- (void)_setupSelectedBackgroundView;
@end

@interface UITableView (Private)
- (UIEdgeInsets)_sectionContentInset;
- (void)_setSectionContentInset:(UIEdgeInsets)insets;
- (void)_layoutMarginsDidChange;
- (void)_rebuildGeometry;
- (void)_updateWrapperFrame;
- (void)_updateVisibleCellsImmediatelyIfNecessary;
- (void)_updateVisibleCellsNow:(BOOL)arg1 isRecursive:(BOOL)arg2;
- (void)_setNeedsVisibleCellsUpdate:(BOOL)arg1 withFrames:(BOOL)arg2;
- (void)layoutMarginsDidChange;
@end