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
#import "SUTSpecificationExporter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SUTImageExporter *png32BitExporter = [[SUTImageExporter alloc] init];
    png32BitExporter.type = SUTImageExporterPNG32Type;
    [[SUTExporterRegistry sharedRegistry] registerExporter:png32BitExporter];
    
    SUTImageExporter *png8BitExporter = [[SUTImageExporter alloc] init];
    [[SUTExporterRegistry sharedRegistry] registerExporter:png8BitExporter];
    
    SUTImageExporter *jpegExporter = [[SUTImageExporter alloc] init];
    jpegExporter.type = SUTImageExporterJPEGType;
    [[SUTExporterRegistry sharedRegistry] registerExporter:jpegExporter];
    
    SUTSpecificationExporter *specificationExporter = [[SUTSpecificationExporter alloc] init];
    [[SUTExporterRegistry sharedRegistry] registerExporter:specificationExporter];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
