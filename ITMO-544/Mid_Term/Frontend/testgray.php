<?php

$im = @imagecreatefrompng('dave.png');

if($im && imagefilter($im, IMG_FILTER_GRAYSCALE))
{
    echo 'Image converted to grayscale.';

    imagepng($im, 'dave.png');
}
else
{
    echo 'Conversion to grayscale failed.';
}

imagedestroy($im);
?>