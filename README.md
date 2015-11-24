# NewtonFractal
A Haskell implementation of the Newton Fractal. Uses Graphics.Gloss.Raster.Field to emulate the complex plane, and applies the newton method to a predetermined function (also using its derivative) to work out which root it converges to, and colours it accordingly.

There is currently no 'interface' that can set the fractal up correctly. The .hs files must be edited to adjust the functions and the values.

Fractal Examples are all generated using ghci and Main.hs:

nf1.png: p(z) = z^7 - 1

nf2.png: p(z) = sin(z), adjusted center to x = -pi/2

nf3.png: p(z) = z^7 + sin(z), generalised NF with a = 0.8

nf4.png: p(z) = (sin(z))^3

nf5.png: p(z) = (sin(z))^3, rotated 90deg upwards.

nf6.png: p(z) = (sin(z))^5 - 2

nf7.png: p(z) = (sin(z))^5 - 4sin(z)

nf8.png: p(z) = (sin(z))^3 - 2

nf9.png: p(z) = sin(z^3) + sin(z)
