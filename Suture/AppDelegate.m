//
//  AppDelegate.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "AppDelegate.h"
#import "SUTExporterRegistry.h"
#import "SUT32BitPNGExporter.h"
#import "SUT8BitPNGExporter.h"
#import "SUTJPEGExporter.h"
#import "SUTSpecificationExporter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SUT32BitPNGExporter *png32BitExporter = [[SUT32BitPNGExporter alloc] init];
    [[SUTExporterRegistry sharedRegistry] registerExporter:png32BitExporter];
    
    SUT8BitPNGExporter *png8BitExporter = [[SUT8BitPNGExporter alloc] init];
    [[SUTExporterRegistry sharedRegistry] registerExporter:png8BitExporter];
    
    SUTJPEGExporter *jpegExporter = [[SUTJPEGExporter alloc] init];
    [[SUTExporterRegistry sharedRegistry] registerExporter:jpegExporter];
    
    SUTSpecificationExporter *specificationExporter = [[SUTSpecificationExporter alloc] init];
    [[SUTExporterRegistry sharedRegistry] registerExporter:specificationExporter];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
