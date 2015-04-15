//
//  SUTPNGQuan.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTPNGQuant.h"

png24_image SUTCreate24BitPNGImageFromContext(CGContextRef context)
{
    png24_image image = {};
   
    if (context)
    {
        CGSize size = (CGSize)
        {
            CGBitmapContextGetWidth(context),
            CGBitmapContextGetHeight(context)
        };
        
        rgba_pixel *pixel_data = CGBitmapContextGetData(context);
        
        //Reverse premultiplication
        for(int i=0; i < size.width * size.height; i++)
        {
            if (pixel_data[i].a)
            {
                pixel_data[i] = (rgba_pixel)
                {
                    .a = pixel_data[i].a,
                    .r = (pixel_data[i].r * 255) / pixel_data[i].a,
                    .g = (pixel_data[i].g * 255) / pixel_data[i].a,
                    .b = (pixel_data[i].b * 255) / pixel_data[i].a,
                };
            }
        }
        
        image.gamma = 0.45455;
        image.width = size.width;
        image.height = size.height;
        image.rgba_data = (unsigned char *)pixel_data;
        image.row_pointers = malloc(sizeof(image.row_pointers[0]) * image.height);
        
        for(int i=0; i < image.height; i++)
        {
            image.row_pointers[i] = (unsigned char *)&pixel_data[image.width * i];
        }
    }
    
    return image;
}

liq_image * SUTCreateQuantImageFrom24BitPNGImage(png24_image image,
                                               liq_attr *attributes)
{
    liq_image *input_image = liq_image_create_rgba_rows(attributes,
                                                        (void**)image.row_pointers,
                                                        image.width,
                                                        image.height,
                                                        image.gamma);
    
    liq_image_set_memory_ownership(input_image, LIQ_OWN_ROWS | LIQ_OWN_PIXELS);
    
    image.row_pointers = NULL;
    image.rgba_data = NULL;
    
    return input_image;
}

png8_image SUTCreate8BitPNGImageFrom24BitPNGImage(png24_image image)
{
    liq_attr *attributes = liq_attr_create();
    liq_image *input_image = SUTCreateQuantImageFrom24BitPNGImage(image,
                                                                  attributes);
    
    liq_result *remap = liq_quantize_image(attributes,
                                           input_image);
    liq_set_output_gamma(remap, 0.45455); // fixed gamma ~2.2 for the web. PNG can't store exact 1/2.2
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