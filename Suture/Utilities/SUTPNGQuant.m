//
//  SUTPNGQuan.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTPNGQuant.h"

png8_image SUTCreate8BitPNGImageFromContext(CGContextRef context)
{
    CGSize size = (CGSize)
    {
        CGBitmapContextGetWidth(context),
        CGBitmapContextGetHeight(context)
    };
    
    liq_attr *attributes = liq_attr_create();
    
    liq_image *input_image = liq_image_create_rgba(attributes,
                                                   CGBitmapContextGetData(context),
                                                   size.width,
                                                   size.height,
                                                   0.45455);
    
    liq_image_set_memory_ownership(input_image, LIQ_OWN_ROWS | LIQ_OWN_PIXELS);
    
    liq_result *remap = liq_quantize_image(attributes,
                                           input_image);
    liq_set_dithering_level(remap, 1.f);
    
    png8_image output_image = {};
    
    output_image.width = liq_image_get_width(input_image);
    output_image.height = liq_image_get_height(input_image);
    output_image.gamma = liq_get_output_gamma(remap);
    

    output_image.indexed_data = malloc(output_image.height * output_image.width);
    output_image.row_pointers = malloc(output_image.height * sizeof(output_image.row_pointers[0]));
    
    for(unsigned int row = 0;  row < output_image.height;  ++row)
    {
        output_image.row_pointers[row] = output_image.indexed_data + row*output_image.width;
    }
    
    const liq_palette *palette = liq_get_palette(remap);
    // tRNS, etc.
    output_image.num_palette = palette->count;
    output_image.num_trans = 0;
    
    for(unsigned int i=0; i < palette->count; i++)
    {
        if (palette->entries[i].a < 255)
        {
            output_image.num_trans = i+1;
        }
    }
    
    liq_write_remapped_image_rows(remap,
                                  input_image,
                                  output_image.row_pointers);
    
    output_image.num_palette = palette->count;
    output_image.num_trans = 0;
    
    for(unsigned int i=0; i < palette->count; i++)
    {
        liq_color px = palette->entries[i];
        
        if (px.a < 255)
        {
            output_image.num_trans = i+1;
        }
        output_image.palette[i] = (png_color){.red=px.r, .green=px.g, .blue=px.b};
        output_image.trans[i] = px.a;
    }
    
    double palette_error = liq_get_quantization_error(remap);
    int quality_percent = 90;
    
    if (palette_error >= 0)
    {
        quality_percent = liq_get_quantization_quality(remap);
    }

    liq_result_destroy(remap);

    return output_image;
};