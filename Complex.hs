module Complex
(newt, newtWithIter, createMap, createFractal, printValues, getRoots) where

import Data.Complex
import Data.List

limit = 256 --Stop after iteration count reaches limit.
scale :: Int
scale = 10 -- Between 0 and 1, there are {scale} steps.
a =  1 -- For generalised NF.
notRoot = 0 :+ 0

-- Base function
p :: (RealFloat a) => Complex a -> Complex a
--p z = (z ^ 7) + sin z
--p z = sin z
--p z = (z ^ 7) - 2
p z = (sin z) ^ 3 - 1

-- Derivative
p' :: (RealFloat a) => Complex a -> Complex a
--p' z = 7 * (z ^ 6) + cos z
--p' z = cos z
--p' z = 7 * (z ^ 6)
p' z = 3 * cos z * ((sin z) ^ 2)

newtWithIter :: Complex Double -> Int -> (Int, Complex Double)
newtWithIter val iter 
    | val == func val   = (iter, val)
    | iter == limit     = (limit, notRoot)
    | otherwise         = newtWithIter (func val) (iter + 1)
    where func zn = (zn - (a * (p zn)/(p' zn)))

newt :: Complex Double -> Int -> Complex Double
newt val iter 
    | val == func val   = val
    | iter == limit     = notRoot
    | otherwise         = newt (func val) (iter + 1)
    where func zn = (zn - (a * (p zn)/(p' zn)))

getRoots (a, b) = ((filter (/= notRoot)) . nub . (map head) . group . createFractal) (a, b)


createMap (x, y) = rowIter ((-x)*scale) (x*scale) (y*scale) ((-y)*scale)
rowIter x limX y limY 
    | x > limX = rowIter (-limX) limX (y - 1) limY
    | y < limY = []
    | otherwise = [((fromIntegral x) / (fromIntegral scale), (fromIntegral y) / (fromIntegral scale))] ++ rowIter (x + 1) limX y limY

pairToComplex (a, b) = a :+ b


createFractal (a, b) = map (`newt` 0) (map pairToComplex $ createMap (a, b))
createFractal' (a, b) = map (`newtWithIter` 0) (map pairToComplex $ createMap (a, b))
createFractalWithValues (a, b) = zip (map (`newt` 0) values) values
    where values = (map pairToComplex $ createMap (a, b))

printValues (a, b) = putStr $ unlines $ zipWith (++) (map (f . show) $ map pairToComplex $ createMap (a, b)) (map show $ createFractal' (a, b))
   where f str = take 20 (str ++ repeat '.')