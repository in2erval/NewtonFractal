import Graphics.Gloss
import Graphics.Gloss.Raster.Field
import GHC.Float
import Data.Complex
import Complex


scl = 1.2
xAdj = 1
colorList = [red, blue, green, yellow, orange, violet, cyan, magenta, azure, aquamarine, chartreuse, rose]

main :: IO()

main = animateField (InWindow "Newton Fractal" (1000,1000) (400,0)) (1,1) frame

frame :: Float -> Point -> Color
frame _ (a, b) = f (newtWithIter (g ((scl * a) - xAdj) :+ g (scl * b)) 0)
    where
    f (iter, x) = dim' iter $ head ([a | (a, b) <- roots, b == x] ++ [black])
    g = float2Double

roots = zip ((concat . repeat) colorList) (getRoots (2,2))

dim' 0 color = color
dim' n color = dim' (n `div` 2) (dim color)