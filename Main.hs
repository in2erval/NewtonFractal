import Graphics.Gloss
import Graphics.Gloss.Raster.Field
import GHC.Float
import Data.Complex
import Complex


scl = 2 -- Zoom level of the generated fractal. Higher values zooms out, values less than 1 zooms in.
xAdj = 1 -- Translate the picture horizontally. Positive values will move it to the right, Negatives to the left.
yAdj = 0 -- Same as xAdj, but vertically.
colorList = [red, blue, green, yellow, orange, violet, cyan, magenta, azure, aquamarine, chartreuse, rose] -- Colour list to match with different roots.



main :: IO()
main = animateField (InWindow "Newton Fractal" (1000,1000) (400,0)) (1,1) frame -- Opens a 1000x1000 window at (400,0) position, with 1 pixel representing each point.

frame :: Float -> Point -> Color
frame _ (a, b) = f (newtWithIter (g ((scl * a) - xAdj) :+ g ((scl * b) - yAdj)) 0) -- For each (a,b) point, represent it as a complex number and apply newtWithIter to it.
    where
    f (iter, x) = dim' iter $ head ([a | (a, b) <- roots, b == x] ++ [black]) -- Matches all found roots with what newtWithIter gives and colours it accordingly. If none are found, it colours it black.
    g = float2Double -- The base type is (Complex Double) so needs to convert from Float to Double.

roots = zip ((concat . repeat) colorList) (getRoots (ceiling scl, ceiling scl)) -- Pairs each found root with a colour. getRoots must be bigger than scale.

dim' 0 color = color -- Repeated application of dim. 
dim' n color = dim' (n `div` 2) (dim color) -- Theoretically it dims the colour log2(iter) times.