# Newton Fractal

## Abstract

A Haskell implementation of the Newton Fractal. Uses Graphics.Gloss.Raster.Field to emulate the complex plane, and applies the newton method to a predetermined function (also using its derivative) to work out which root it converges to, and colours it accordingly.

There is currently no 'interface' that can set the fractal up correctly. The .hs files must be edited to adjust the functions and the values. Also, because this is using gloss, there is currently no way to "save" the generated image as a bitmap file. The images in the FractalExamples folder are all screenshots taken at 1000x1000 resolution.

To generate the image, run **Main.hs** on GHCI and type **"main"**. Please note that the fractals can take a **very long time** to generate depending on the function and the parameters.


## Dependencies

This is meant to run on GHCI.

Use cabal to install the packages by opening cmd and typing **"cabal install {package name}"**. Make sure to update cabal first by typing **"cabal update"**.

* **gloss**
* **gloss-raster** (package will install gloss also if you don't have it yet)


## How it works

### Complex.hs

Complex.hs contains definitions for the actual calculation. This file contains functions which calculate the root that a value will converge to (based on the given base and derivative functions), return the number of iterations it takes to converge, find roots of the function, generate a list of complex numbers to emulate the complex plane, and print values in a readable way.

### Main.hs

Main.hs contains definitions which render the fractal. It uses *display* from Graphics.Gloss to form a window, and *makePicture* from Graphics.Gloss.Raster.Field to create a fractal picture for the window. The function *frame* will calculate the root that the complex representation of the point (doesn't) converge to, and uses the function *f* to colour the point appropriately.


## Editable parameters

Complex.hs:

* **limit** - Max number of newton method iteration. Increasing this will potentially allow more roots to be found, but will increase the time taken to generate the image.
* **scale** - For use in complex plane generation. Increasing this will allow more roots to be found, but will increase the time *significantly*.
* **a** - A complex number for the generalised newton method where the default is 1. Changing this could yield interesting results, but it can break the fractal very easily. Please use printValues first to make sure it actually returns proper values.
* **notRoot** - For filtering out non-convergent values. Please make sure the function does not have this number as a root.
* **p z** - Base function. You can safely use polynomials and trigs, but exponentials (e.g. e^z) are likely not going to work.
* **p' z** - Derivative function. This program *will not* work out what the derivative is. Please enter the appropriate derivative of the base function.

Main.hs:

* **scl** - Zoom level. Higher values zoom out, lower values zoom in. Must be above 0.
* **xAdj** - Horizontal adjustment. Positive values shifts the image to the right, negatives to the left.
* **yAdj** - Vertical adjustment. Positive values shifts the image down, negatives up.
* **windowSize** - The size of the fractal image - the window size will always be a square. Only integers are allowed.
* **pixelSize** - Size of each computed point on the image. Increasing this will make the picture blockier and pixellated, but generate faster.

You can also define your own colours and change the colourList.


## Fractal Examples

Fractal Examples are all generated using ghci and Main.hs:

* nf1.png: p(z) = z^7 - 1

* nf2.png: p(z) = sin(z), adjusted center to x = -pi/2

* nf3.png: p(z) = z^7 + sin(z)

* nf4_1.png: p(z) = (sin(z))^3 - 2

* nf4_2.png: p(z) = (sin(z))^3 - 2, adjusted center to x = -pi/2, zoomed in

* nf5.png: p(z) = (1+i)cosh(z^2)

* nf6.png: p(z) = cosh(sin(z))

* nf7_1.png: p(z) = (sin(z))^5 - 4sin(z), adjusted center to x = -pi/2

* nf7_2.png: p(z) = (sin(z))^5 - 4sin(z), adjusted center to x = -pi/2, zoomed in

* nf8.png: p(z) = sinh(z ^ 2)/cosh(z) + z

* nf9.png: p(z) = sin(z^3) + sin(z)

* nf10.png: p(z) = sin((z^4) + 2), generalised NF with a = 1 + 0.2i

For the exact parameters of each examples, look at Parameters.txt in the folder.
