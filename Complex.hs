import Data.Complex

limit = 1000000 --Stop after iteration count reaches limit.
increment = 0.001 -- Increment between complex numbers for evaluation
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
	
