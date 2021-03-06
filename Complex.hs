module Complex
(limit, newt, newtWithIter, createFractal, createFractalWithIter, createFractalWithValues, printValues, getRoots) where

import Data.Complex
import Data.List

limit = 256 -- Stop after iteration count reaches limit.
scale = 100 -- Between 0 and 1, there are {scale} steps. This gets used in createMap, which in turn gets used in getRoots.
a =  1 :+ 0 -- For generalised NF.
notRoot = 1 :+ 0 -- For filtering out non-converging values.


-- Base function
p :: (RealFloat a) => Complex a -> Complex a
p z = sin z

-- Derivative
p' :: (RealFloat a) => Complex a -> Complex a
p' z = cos z

func zn = (zn - (a * (p zn)/(p' zn))) -- Newton method.

newt :: Complex Double -> Int -> Complex Double
newt val iter 
    | val == func val   = val -- If input value equals func(value), then it reached a root.
    | iter == limit     = notRoot -- Iteration count reached limit, so we regard it as non-convergent.
    | otherwise         = newt (func val) (iter + 1) -- Iterate again, with new value and iteration + 1.

newtWithIter :: Complex Double -> Int -> (Int, Complex Double) -- Same function as newt, but returns (iter, val) instead.
newtWithIter val iter 
    | val == func val   = (iter, val)
    | iter == limit     = (limit, notRoot)
    | otherwise         = newtWithIter (func val) (iter + 1)



-- (a, b) represents depth in x and depth in y. (1,1) represents a field from (-1 + i) to (1 - i):

--        Im ^ 1
--           |
--           |
--           |
--           |          1
-- ----------O---------->
--           |         Re
--           |
--           |
--           |

createMap :: (Int, Int) -> (Int, Int) -> [(Double, Double)]
createMap (x, y) (adjX, adjY) = rowIter (max x y) (adjX * scale, adjY * scale) (((-x)+adjX)*scale) ((x+adjX)*scale) ((y+adjY)*scale) (((-y)+adjY)*scale)  -- Generates the plane
rowIter p (adjX,adjY) x limX y limY 
    | x > limX = rowIter p (adjX,adjY) (-(limX - adjX) + adjX) limX (y - p) limY
    | y < limY = []
    | otherwise = [((fromIntegral x) / (fromIntegral scale), (fromIntegral y) / (fromIntegral scale))] ++ rowIter p (adjX,adjY) (x + p) limX y limY -- Weird workaround with Int to prevent stupid float inaccuracies.

pairToComplex (a, b) = a :+ b -- For each value in the plane, represent it as a complex number.

createFractal (a, b) (x, y) = map (`newt` 0) (map pairToComplex $ createMap (a, b) (x, y)) -- Apply newton method to all the values in the complex plane.
createFractalWithIter (a, b) (x, y) = map (`newtWithIter` 0) (map pairToComplex $ createMap (a, b) (x, y)) -- Same as above, but using newtWithIter instead.
createFractalWithValues (a, b) (x, y) = zip (map (`newt` 0) values) values -- Similar to createFractal, but returns a list of (root, initial value).
    where values = (map pairToComplex $ createMap (a, b) (x, y))



getRoots (a, b) (x, y) = ((filter (/= notRoot)) . nub . (map head) . group . (`createFractal` (x, y))) (a, b) -- From a given (a, b) field, finds all the different roots that the values converge to.

printValues (a, b) (x, y) = putStr $ unlines $ zipWith (++) (map (f . show) $ map pairToComplex $ createMap (a, b) (x, y)) (map show $ createFractalWithIter (a, b) (x, y)) -- Print the values in ghc to make it more readable.
   where f str = take 20 (str ++ repeat '.')