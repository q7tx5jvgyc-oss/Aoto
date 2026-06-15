#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

// Define a custom view controller for our overlay UI
@interface YallaLudoOverlayViewController : UIViewController <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation YallaLudoOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8]; // Dark transparent background
    self.view.layer.cornerRadius = 10;
    self.view.clipsToBounds = YES;

    // Add a close button for the overlay
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(self.view.frame.size.width - 40, 10, 30, 30);
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeOverlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];

    // Initialize WKWebView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [self.view addSubview:self.webView];

    // Load HTML content from a local file (assuming it's in a bundle)
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"YallaLudoTweakResources.bundle"];
    if (htmlPath) {
        NSURL *fileURL = [NSURL fileURLWithPath:htmlPath];
        [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL.URLByDeletingLastPathComponent];
    } else {
        // Fallback: Load a simple HTML string if file not found
        NSString *htmlString = @"<body style=\"background-color: transparent; color: white; text-align: center;\"><h1>أداة التكبيس 🚀</h1><p>الواجهة قيد التطوير...</p></body>";
        [self.webView loadHTMLString:htmlString baseURL:nil];
    }
}

- (void)closeOverlay {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end

// Hook into the application launch
%hook UIApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) {
            keyWindow = [[UIApplication sharedApplication].windows firstObject];
        }

        if (keyWindow) {
            YallaLudoOverlayViewController *overlayVC = [[YallaLudoOverlayViewController alloc] init];
            CGFloat width = 350;
            CGFloat height = 450;
            CGFloat x = (keyWindow.bounds.size.width - width) / 2;
            CGFloat y = (keyWindow.bounds.size.height - height) / 2;
            overlayVC.view.frame = CGRectMake(x, y, width, height);

            UIViewController *rootVC = keyWindow.rootViewController;
            if (rootVC) {
                [rootVC addChildViewController:overlayVC];
                [rootVC.view addSubview:overlayVC.view];
                [overlayVC didMoveToParentViewController:rootVC];
            } else {
                [keyWindow addSubview:overlayVC.view];
            }
        }
    });

    return YES;
}

%end
