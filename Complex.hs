import Data.Complex

limit = 100 --Stop after iteration count reaches limit.
scale :: Int
scale = 10 -- Between 0 and 1, there are {scale} steps.
a = 1 -- For generalised NF.

-- Base function
p :: (RealFloat a) => Complex a -> Complex a
p z = sin z

-- Derivative
p' :: (RealFloat a) => Complex a -> Complex a
p' z = cos z

newt :: Complex Double -> Int -> Int
newt val iter 
	| val == func val	= iter
	| iter == limit 	= limit
	| otherwise 		= newt (func val) (iter + 1)
	where func zn = (zn - (a * (p zn)/(p' zn)))
	
	
createMap x y = rowIter ((-x)*scale) (x*scale) (y*scale) ((-y)*scale)
rowIter x limX y limY 
	| x > limX = rowIter (-limX) limX (y - 1) limY
	| y < limY = []
	| otherwise = [((fromIntegral x) / (fromIntegral scale), (fromIntegral y)	/ (fromIntegral scale))] ++ rowIter (x + 1) limX y limY
	
pairToComplex (a, b) = a :+ b


createFractal a b = map (`newt` 0) (map pairToComplex $ createMap a b)