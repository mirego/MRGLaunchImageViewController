//
// Copyright (c) 2014, Mirego
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// - Neither the name of the Mirego nor the names of its contributors may
//   be used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "MRGLaunchImageViewController.h"

@interface MRGLaunchImageViewController ()

@property (nonatomic, weak) UIViewController *launchStoryboardViewController;
@property (nonatomic, weak) UIImageView *launchImageView;
@property (nonatomic) NSString *launchImagePath;
@end

@implementation MRGLaunchImageViewController {
    BOOL mrg_shouldAutorotate;
#ifdef __IPHONE_9_0
    UIInterfaceOrientationMask mrg_supportedInterfaceOrientations;
#else
    NSUInteger mrg_supportedInterfaceOrientations;
#endif
    BOOL mrg_prefersStatusBarHidden;
    UIStatusBarStyle mrg_preferredStatusBarStyle;
    UIStatusBarAnimation mrg_preferredStatusBarUpdateAnimation;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        mrg_shouldAutorotate = YES;
        mrg_supportedInterfaceOrientations = ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskPortrait : UIInterfaceOrientationMaskAll;
        mrg_prefersStatusBarHidden = [super prefersStatusBarHidden];
        mrg_preferredStatusBarStyle = [super preferredStatusBarStyle];
        mrg_preferredStatusBarUpdateAnimation = [super preferredStatusBarUpdateAnimation];
    }
    
    return self;
}

- (void)loadView {
    NSString *launchStoryboardName = [[NSBundle mainBundle] infoDictionary][@"UILaunchStoryboardName"];
    if ([launchStoryboardName length] > 0) {
        UIStoryboard *launchStoryboard = [UIStoryboard storyboardWithName:launchStoryboardName bundle:nil];
        self.launchStoryboardViewController = [launchStoryboard instantiateInitialViewController];
        if (self.launchStoryboardViewController) {
            self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
            self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [self.launchStoryboardViewController beginAppearanceTransition:YES animated:NO];
            [self addChildViewController:self.launchStoryboardViewController];
            UIView *launchStoryboardViewControllerView = self.launchStoryboardViewController.view;
            launchStoryboardViewControllerView.frame = self.view.bounds;
            launchStoryboardViewControllerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:launchStoryboardViewControllerView];
            [self.launchStoryboardViewController didMoveToParentViewController:self];
            [self.launchStoryboardViewController endAppearanceTransition];
        }
    }
    
    if (self.launchStoryboardViewController == nil) {
        UIImageView *launchImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        launchImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view = self.launchImageView = launchImageView;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLaunchImageView];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLaunchImageView];
}

- (BOOL)shouldAutorotate {
    return mrg_shouldAutorotate;
}

- (void)setShouldAutorotate:(BOOL)shouldAutorotate {
    mrg_shouldAutorotate = shouldAutorotate;
}

#ifdef __IPHONE_9_0
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
#else
- (NSUInteger)supportedInterfaceOrientations {
#endif
    return mrg_supportedInterfaceOrientations;
}

#ifdef __IPHONE_9_0
- (void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)supportedInterfaceOrientations {
#else
- (void)setSupportedInterfaceOrientations:(NSUInteger)supportedInterfaceOrientations {
#endif
    mrg_supportedInterfaceOrientations = supportedInterfaceOrientations;
}

- (BOOL)prefersStatusBarHidden {
    return mrg_prefersStatusBarHidden;
}

- (void)setPrefersStatusBarHidden:(BOOL)prefersStatusBarHidden {
    mrg_prefersStatusBarHidden = prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return mrg_preferredStatusBarStyle;
}

- (void)setPreferredStatusBarStyle:(UIStatusBarStyle)preferredStatusBarStyle {
    mrg_preferredStatusBarStyle = preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return mrg_preferredStatusBarUpdateAnimation;
}

- (void)setPreferredStatusBarUpdateAnimation:(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    mrg_preferredStatusBarUpdateAnimation = preferredStatusBarUpdateAnimation;
}

- (void)updateLaunchImageView {
    if (self.launchImageView) {
        NSString *launchImagePath = [[self class] launchImagePath];
        if ([self.launchImagePath isEqualToString:launchImagePath] == NO) {
            self.launchImagePath = launchImagePath;
            self.launchImageView.image = [UIImage imageWithContentsOfFile:self.launchImagePath];
        }
    }
}

+ (NSString *)launchImagePathForName:(NSString *)name device:(NSString *)device type:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:device] ofType:type];
    if (path == nil) {
        path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    }
    
    return path;
}

+ (CGSize)portraitSizeForSize:(CGSize)size {
    if (size.width <= size.height) {
        return size;
    } else {
        return CGSizeMake(size.height, size.width);
    }
}

+ (NSString *)launchImagePath {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    NSString *orientationString = (!isPad || !isLandscape) ? @"Portrait" : @"Landscape";
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *scale = [[UIScreen mainScreen] scale] > 1 ? [NSString stringWithFormat:@"@%.0fx", [[UIScreen mainScreen] scale]] : @"";
    
    // Check the iOS 7 key
    NSArray *launchImages = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    if (launchImages != nil) {
        UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
        if (mainWindow == nil) {
            mainWindow = [[[UIApplication sharedApplication] windows] firstObject];
        }
        
        // Filter down the array to just the matching elements
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UILaunchImageMinimumOSVersion <= %@ AND UILaunchImageOrientation = %@ AND (UILaunchImageSize = %@ OR UILaunchImageSize = %@)", systemVersion, orientationString, NSStringFromCGSize(mainWindow.bounds.size), NSStringFromCGSize([self portraitSizeForSize:mainWindow.bounds.size])];
        launchImages = [launchImages filteredArrayUsingPredicate:predicate];
        
        NSString *imageName = [[launchImages lastObject] objectForKey:@"UILaunchImageName"];
        NSString *baseExt = [imageName pathExtension];
        if (baseExt.length == 0) {
            baseExt = @"png";
        }
        
        imageName = [imageName stringByDeletingPathExtension];
        if (imageName.length > 0) {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:[imageName stringByAppendingString:scale] ofType:baseExt];
            if (imagePath != nil) {
                return imagePath;
            }
        }
    }
    
    // Check the pre iOS 7 key
    NSString *baseName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImageFile"];
    NSString *baseExt = [baseName pathExtension];
    if (baseExt.length == 0) {
        baseExt = @"png";
    }
    
    baseName = [baseName stringByDeletingPathExtension];
    if (baseName.length == 0) {
        baseName = @"Default";
    }
    
    if (!isPad) {
        NSString *imagePath = [self launchImagePathForName:[NSString stringWithFormat:@"%@-%.0fh%@", baseName, [UIScreen mainScreen].bounds.size.height, scale] device:@"~iphone" type:baseExt];
        
        if (imagePath == nil) {
            imagePath = [self launchImagePathForName:[NSString stringWithFormat:@"%@%@", baseName, scale] device:@"~iphone" type:baseExt];
        }
        
        return imagePath;
        
    } else {
        NSString *imagePath = nil;
        switch (orientation) {
#ifdef __IPHONE_8_0
            case UIInterfaceOrientationUnknown:
#endif
            case UIInterfaceOrientationPortrait:
                imagePath = [self launchImagePathForName:[NSString stringWithFormat:@"%@-Portrait%@", baseName, scale] device:@"~ipad" type:baseExt];
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                imagePath = [self launchImagePathForName:[NSString stringWithFormat:@"%@-PortraitUpsideDown%@", baseName, scale] device:@"~ipad" type:baseExt];
                break;
            case UIInterfaceOrientationLandscapeLeft:
                imagePath = [self launchImagePathForName:[NSString stringWithFormat:@"%@-LandscapeLeft%@", baseName, scale] device:@"~ipad" type:baseExt];
                break;
            case UIInterfaceOrientationLandscapeRight:
                imagePath = [self launchImagePathForName:[NSString stringWithFormat:@"%@-LandscapeRight%@", baseName, scale] device:@"~ipad" type:baseExt];
                break;
        }
        
        if (imagePath == nil) {
            imagePath = [self launchImagePathForName:[NSString stringWithFormat:@"%@-%@%@", baseName, orientationString, scale] device:@"~ipad" type:baseExt];
        }
        
        return imagePath;
    }
}


@end