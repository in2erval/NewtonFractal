import Data.Complex

limit = 1000000 --Stop after iteration count reaches limit.
increment :: Double
increment = 0.1 -- Increment between complex numbers for evaluation
a = 1 -- For generalised NF.

-- Base function
p :: (RealFloat a) => Complex a -> Complex a
p z = (z ^ 3) - 1

-- Derivative
p' :: (RealFloat a) => Complex a -> Complex a
p' z = (3 * (z ^ 2))

newt :: Complex Double -> Int -> Int
newt val iter 
	| val == func val	= iter
	| iter == limit 	= limit
	| otherwise 		= newt (func val) (iter + 1)
	where func zn = (zn - (a * (p zn)/(p' zn)))
	
	
createMap x y = rowIter (-x) x y (-y)
rowIter x limX y limY 
	| x > limX = rowIter (-limX) limX (y - increment) limY
	| y < limY = []
	| otherwise = [x :+ y] ++ rowIter (x + increment) limX y limY