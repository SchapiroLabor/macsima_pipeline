import tifffile as tifff
import numpy as np
import os
from pathlib import Path
import argparse
import sys

#---CLI-BLOCK---#
def setup_cli():

    parser=argparse.ArgumentParser()


    parser.add_argument('-i',
                    '--input',
                    required=True,
                    help='path to the image to be corrected'
                    )

    parser.add_argument('-o',
                    '--output',
                    required=True,
                    help='Directory where the corrected image will be written'
                    )

    args=parser.parse_args()

    return args

#---END_CLI-BLOCK---#

def args2dict():
    args_dict={}
    for index,element in enumerate(sys.argv):
        if type(element)==str:
            if element.startswith('-'):
                args_dict[element]=sys.argv[index+1]
    return args_dict



def cast_canvas(img_path):
    with tifff.TiffFile(img_path) as tif:
        im=tif.series[0].asarray()
        stack_len=len(tif.pages)
        channels=int(stack_len/len(tif.series))
        x_size=im.shape[2]
        y_size=im.shape[1]
    canvas_img=np.zeros( (stack_len,y_size,x_size) ,dtype='uint16')

    return canvas_img,(stack_len,channels)

def ill_profile(img_path):

    file_name=img_path.stem
    flat_field_path=img_path.parents[1] / 'illumination'  / '{x}-ffp.tiff'.format(x=file_name)

    return flat_field_path

def ill_correction(img_path,ffp_path):
    
    ffp=tifff.imread( ffp_path )
    canvas,(z_size,no_of_chan)=cast_canvas(img_path)

    for ch in range(no_of_chan):
        range_of_interest=range(ch,z_size,no_of_chan)
        img=tifff.imread(img_path,key=range_of_interest)
        ffp_tile=np.tile(ffp[:,:,ch],(img.shape[0],1,1))
        img_corrected= img.astype(float) / ffp_tile

        canvas[range_of_interest,:,:]=np.uint16( np.clip(img_corrected,0,65535) )


    return canvas

def apply_correction(img_path,out_dir):

    img_corr=ill_correction(img_path,ill_profile(img_path))
    output_img_path=out_dir / '{tag}_{stem}{file_format}'.format(stem=img_path.stem ,file_format=img_path.suffix,tag='corr')
    ome_metadata=tifff.tiffcomment(img_path)
    tifff.imwrite( output_img_path ,img_corr )
    tifff.tiffcomment(output_img_path,ome_metadata)

    return



def main(args_dict):
    #read CLI arguments
    img_path=Path(args_dict['-i'])
    out_dir =Path(args_dict['-o'])
    #apply correction to image and write result in out_dir
    apply_correction(img_path,out_dir)



if __name__=='__main__':
    args=setup_cli()
    main(args2dict())







