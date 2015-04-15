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


png8_image SUTCreate8BitPNGImageFrom24BitImage(png24_image image)
{
    liq_image *input_image = liq_image_create_rgba_rows(options, (void**)input_image_p->row_pointers, input_image_p->width, input_image_p->height, input_image_p->gamma);
    
    if (!*liq_image_p)
    {
        return OUT_OF_MEMORY_ERROR;
    }
    
    if (!keep_input_pixels) {
        if (LIQ_OK != liq_image_set_memory_ownership(*liq_image_p, LIQ_OWN_ROWS | LIQ_OWN_PIXELS)) {
            return OUT_OF_MEMORY_ERROR;
        }
        input_image_p->row_pointers = NULL;
        input_image_p->rgba_data = NULL;
    }
    
    return (png8_image){};
};