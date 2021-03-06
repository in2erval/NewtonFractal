import Graphics.Gloss
import Graphics.Gloss.Raster.Field
import GHC.Float
import Data.Complex
import Complex


-- Self-defined colours - blue-themed.
-- Format is "makeColorI R G B A".
dodger = makeColorI 30 144 255 255
navy = makeColorI 0 0 128 255
midnight = makeColorI 25 25 112 255
cobalt = makeColorI 61 89 171 255
royal1 = makeColorI 65 105 225 255
royal2 = makeColorI 72 118 255 255
royal3 = makeColorI 58 95 205 255
royal4 = makeColorI 39 64 139 255
cfblue = makeColorI 100 149 237 255
steel = makeColorI 176 196 222 255
steelblue1 = makeColorI 99 184 255 255
steelblue2 = makeColorI 79 148 205 255
skyblue1 = makeColorI 135 206 255 255
skyblue2 = makeColorI 108 166 205 255
deepsky1 = makeColorI 0 178 238 255
deepsky2 = makeColorI 0 191 255 255
peacock = makeColorI 51 161 201 255
cadet = makeColorI 152 245 255 255
turquiose = makeColorI 0 229 238 255
mangblue = makeColorI 3 168 158 255

nonconverge = makeColorI 140 140 140 255

colourList = [dodger, navy, deepsky2, midnight, cobalt, royal1, royal2, royal3, royal4, cfblue, steel, steelblue1, steelblue2, skyblue1, skyblue2, deepsky1, peacock, cadet, turquiose, mangblue] -- Colour list to match with different roots.


scl = 1/2 -- Zoom level of the generated fractal. Higher values zooms out, values less than 1 zooms in.
xAdj = pi/2 -- Translate the picture horizontally. Positive values will move it to the right, Negatives to the left.
yAdj = 0 -- Same as xAdj, but vertically.

windowSize = 500
pixelSize = 1


main1 :: IO()
main1 = display (InWindow "Newton Fractal" (windowSize, windowSize) (0,0)) white (makePicture windowSize windowSize pixelSize pixelSize frame) -- Opens a window at (400,0) position. Window size and pixel size are adjusted by variables above.

main2 :: IO()
main2 = display (InWindow "Newton Fractal" (windowSize, windowSize) (0,0)) white (makePicture windowSize windowSize pixelSize pixelSize frameIter) -- For colouring based on iteration count.


g = float2Double -- The base type is (Complex Double) so needs to convert from Float to Double.

frame :: Point -> Color
frame (a, b) = f (newtWithIter (g ((scl * a) - xAdj) :+ g ((scl * b) - yAdj)) 0) -- For each (a,b) point, represent it as a complex number and apply newtWithIter to it.
    where
    f (iter, x) | iter == limit = nonconverge
                | otherwise     = dim' iter $ head ([a | (a, b) <- roots, b == x] ++ [white]) -- Matches all found roots with what newtWithIter gives and colours it accordingly. If none are found, it colours it white (but because of dim, it'll make it grey.

frameIter :: Point -> Color
frameIter (a, b) = f (newtWithIter (g ((scl * a) - xAdj) :+ g ((scl * b) - yAdj)) 0) -- Very similar to the original frame function, but determines the colour based on iteration count instead of the root it converges to.
    where
    f (iter, _) | iter == limit = nonconverge
                | otherwise     = ((concat . repeat) colourList) !! (iter + 1) -- Different colours will be picked based on iteration count.


roots = zip ((concat . repeat) colourList) (getRoots (ceiling scl + 1, ceiling scl + 1) (-(ceiling xAdj), -(ceiling yAdj))) -- Pairs each found root with a colour. getRoots must be bigger than scale.

dim' 0 colour = colour -- Repeated application of dim. 
dim' n colour = dim' (n `div` 2) (dim colour) -- Theoretically it dims the colour log2(iter) times.

bright' 0 colour = colour -- Same as dim', but using bright.
bright' n colour = bright' (n `div` 2) (bright colour)