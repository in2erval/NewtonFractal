module Complex
(limit, newt, newtWithIter, createFractal, createFractalWithIter, createFractalWithValues, printValues, getRoots) where

import Data.Complex
import Data.List

limit = 256 -- Stop after iteration count reaches limit.
a =  1 -- For generalised NF.
notRoot = 1 :+ 0 -- For filtering out non-converging values.

scale = 1000 -- Between 0 and 1, there are {scale} steps. This gets used in createMap, which in turn gets used in getRoots.

-- Base function
p :: (RealFloat a) => Complex a -> Complex a
--p z = (z ^ 7) + sin z
p z = sin z
--p z = (sin z) ^ 3 - 2
--p z = sin (z ^ 3) + sin z

-- Derivative
p' :: (RealFloat a) => Complex a -> Complex a
--p' z = 7 * (z ^ 6) + cos z
p' z = cos z
--p' z = 3 * cos z * ((sin z) ^ 2)
--p' z = 3 * (z ^ 2) * cos (z ^ 3) + cos z


func zn = (zn - (a * (p zn)/(p' zn))) -- Newton method.

newt :: Complex Double -> Int -> Complex Double
newt val iter 
    | val == func val   = val -- If input value equals func(value), then it reached a root.
    | iter == limit     = notRoot -- Iteration count reached limit, so we regard it as non-convergeant.
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

createMap (x, y) = rowIter ((-x)*scale) (x*scale) (y*scale) ((-y)*scale)  -- Generates the plane
rowIter x limX y limY 
    | x > limX = rowIter (-limX) limX (y - 1) limY
    | y < limY = []
    | otherwise = [((fromIntegral x) / (fromIntegral scale), (fromIntegral y) / (fromIntegral scale))] ++ rowIter (x + 1) limX y limY -- Weird workaround with Int to prevent stupid float inaccuracies.

pairToComplex (a, b) = a :+ b -- For each value in the plane, represent it as a complex number.

createFractal (a, b) = map (`newt` 0) (map pairToComplex $ createMap (a, b)) -- Apply newton method to all the values in the complex plane.
createFractalWithIter (a, b) = map (`newtWithIter` 0) (map pairToComplex $ createMap (a, b)) -- Same as above, but using newtWithIter instead.
createFractalWithValues (a, b) = zip (map (`newt` 0) values) values -- Similar to createFractal, but returns a list of (root, initial value).
    where values = (map pairToComplex $ createMap (a, b))



getRoots (a, b) = ((filter (/= notRoot)) . nub . (map head) . group . createFractal) (a, b) -- From a given (a, b) field, finds all the different roots that the values converge to.

printValues (a, b) = putStr $ unlines $ zipWith (++) (map (f . show) $ map pairToComplex $ createMap (a, b)) (map show $ createFractalWithIter (a, b)) -- Print the values in ghc to make it more readable.
   where f str = take 20 (str ++ repeat '.')