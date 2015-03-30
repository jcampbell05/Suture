//
//  AppDelegate.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "AppDelegate.h"
#import "SUTExporterRegistry.h"
#import "SUTImageExporter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SUTImageExporter *pngExporter = [[SUTImageExporter alloc] init];
    SUTImageExporter *jpegExporter = [[SUTImageExporter alloc] init];
    jpegExporter.type = SUTImageExporterJPEGType;
    
    [[SUTExporterRegistry sharedRegistry] registerExporter:pngExporter];
    [[SUTExporterRegistry sharedRegistry] registerExporter:jpegExporter];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
