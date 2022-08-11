// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@import GoogleMaps;

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  // Provide the GoogleMaps API key.
  NSString* mapsApiKey = [[NSProcessInfo processInfo] environment][@"AIzaSyCF7J7YB_VCVrpbTe9V7kQB6203EwpH0Y8"];
  if ([mapsApiKey length] == 0) {
    mapsApiKey = @"AIzaSyCF7J7YB_VCVrpbTe9V7kQB6203EwpH0Y8";
  }
  [GMSServices provideAPIKey:mapsApiKey];

  // Register Flutter plugins.
  [GeneratedPluginRegistrant registerWithRegistry:self];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
