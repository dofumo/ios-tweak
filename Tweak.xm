#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static const NSInteger kAZButtonTag = 0xA70A;
static const NSInteger kAZPanelTag  = 0xA70B;

@interface AZPanelManager : NSObject
+ (instancetype)shared;
- (void)togglePanelFromButton:(UIButton *)sender;
- (void)moveButton:(UIPanGestureRecognizer *)gesture;
- (void)closePanel:(UIButton *)sender;
@end

@implementation AZPanelManager

+ (instancetype)shared {
    static AZPanelManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AZPanelManager new];
    });
    return manager;
}

- (UIView *)makePanelForWindow:(UIWindow *)window {
    CGFloat width = MIN(320.0, CGRectGetWidth(window.bounds) - 32.0);
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(16.0, 70.0, width, 250.0)];
    panel.tag = kAZPanelTag;
    panel.backgroundColor = [UIColor secondarySystemBackgroundColor];
    panel.layer.cornerRadius = 16.0;
    panel.layer.borderWidth = 1.0;
    panel.layer.borderColor = [UIColor.separatorColor CGColor];
    panel.layer.shadowColor = [UIColor blackColor].CGColor;
    panel.layer.shadowOpacity = 0.20;
    panel.layer.shadowRadius = 14.0;
    panel.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    panel.hidden = YES;
    panel.clipsToBounds = NO;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 12.0, width - 76.0, 28.0)];
    title.text = @"Azota Companion";
    title.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    title.textColor = [UIColor labelColor];
    [panel addSubview:title];

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(width - 48.0, 8.0, 36.0, 36.0);
    [close setTitle:@"×" forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont systemFontOfSize:25.0 weight:UIFontWeightRegular];
    [close addTarget:self action:@selector(closePanel:) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:close];

    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(12.0, 48.0, width - 24.0, 1.0)];
    separator.backgroundColor = [UIColor separatorColor];
    [panel addSubview:separator];

    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 60.0, width - 32.0, 42.0)];
    status.text = @"Floating panel is loaded in Azota Student.";
    status.font = [UIFont systemFontOfSize:13.0];
    status.textColor = [UIColor secondaryLabelColor];
    status.numberOfLines = 2;
    [panel addSubview:status];

    UILabel *notesLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 108.0, width - 32.0, 20.0)];
    notesLabel.text = @"Personal notes";
    notesLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    notesLabel.textColor = [UIColor labelColor];
    [panel addSubview:notesLabel];

    UITextView *notes = [[UITextView alloc] initWithFrame:CGRectMake(12.0, 132.0, width - 24.0, 104.0)];
    notes.backgroundColor = [UIColor tertiarySystemBackgroundColor];
    notes.textColor = [UIColor labelColor];
    notes.font = [UIFont systemFontOfSize:14.0];
    notes.layer.cornerRadius = 10.0;
    notes.layer.borderWidth = 1.0;
    notes.layer.borderColor = [UIColor separatorColor].CGColor;
    notes.text = @"Write your own notes here…";
    [panel addSubview:notes];

    return panel;
}

- (void)ensurePanelInWindow:(UIWindow *)window {
    if (!window || [window viewWithTag:kAZPanelTag]) return;
    UIView *panel = [self makePanelForWindow:window];
    [window addSubview:panel];
}

- (void)togglePanelFromButton:(UIButton *)sender {
    UIWindow *window = sender.window;
    if (!window) return;
    [self ensurePanelInWindow:window];
    UIView *panel = [window viewWithTag:kAZPanelTag];
    if (!panel) return;
    panel.hidden = !panel.hidden;
    if (!panel.hidden) {
        [window bringSubviewToFront:panel];
        [window bringSubviewToFront:sender];
    }
}

- (void)moveButton:(UIPanGestureRecognizer *)gesture {
    UIButton *button = (UIButton *)gesture.view;
    UIWindow *window = button.window;
    if (!button || !window) return;

    CGPoint delta = [gesture translationInView:window];
    CGPoint center = button.center;
    center.x += delta.x;
    center.y += delta.y;

    CGFloat halfW = CGRectGetWidth(button.bounds) / 2.0;
    CGFloat halfH = CGRectGetHeight(button.bounds) / 2.0;
    UIEdgeInsets safe = window.safeAreaInsets;
    center.x = MAX(halfW + 8.0, MIN(CGRectGetWidth(window.bounds) - halfW - 8.0, center.x));
    center.y = MAX(safe.top + halfH + 8.0, MIN(CGRectGetHeight(window.bounds) - safe.bottom - halfH - 8.0, center.y));
    button.center = center;
    [gesture setTranslation:CGPointZero inView:window];
}

- (void)closePanel:(UIButton *)sender {
    sender.superview.hidden = YES;
    [sender.superview endEditing:YES];
}

@end

static void AZInstallFloatingPanel(UIWindow *window) {
    if (!window || [window viewWithTag:kAZButtonTag]) return;

    CGFloat width = CGRectGetWidth(window.bounds);
    CGFloat height = CGRectGetHeight(window.bounds);
    UIEdgeInsets safe = window.safeAreaInsets;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = kAZButtonTag;
    button.frame = CGRectMake(width - 68.0, height - safe.bottom - 150.0, 54.0, 54.0);
    button.backgroundColor = [UIColor colorWithRed:0.18 green:0.38 blue:0.86 alpha:1.0];
    button.layer.cornerRadius = 27.0;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOpacity = 0.28;
    button.layer.shadowRadius = 8.0;
    button.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    [button setTitle:@"Aa" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold];
    [button addTarget:[AZPanelManager shared]
               action:@selector(togglePanelFromButton:)
     forControlEvents:UIControlEventTouchUpInside];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:[AZPanelManager shared]
                                                                           action:@selector(moveButton:)];
    pan.cancelsTouchesInView = NO;
    [button addGestureRecognizer:pan];

    [window addSubview:button];
    [[AZPanelManager shared] ensurePanelInWindow:window];
}

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    if (![[NSBundle mainBundle].bundleIdentifier isEqualToString:@"azt.azt"]) return;

    UIWindow *window = self.view.window;
    if (!window) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        AZInstallFloatingPanel(window);
    });
}
%end
