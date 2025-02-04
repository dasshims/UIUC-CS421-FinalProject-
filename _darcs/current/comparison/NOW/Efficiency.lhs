> module Efficiency where
> import NOW hiding (equal)
> import GEq
> import BinTreeDatatype


> bigeq :: Int -> Bool
> bigeq n = equalBinTreeChar t t
>   where t = fulltree n '*'

> fulltree :: Int -> a -> BinTree a
> fulltree 0     a = Leaf a
> fulltree (n+1) a = Bin t t
>   where t = fulltree n a

fulltree r = gFullTree (rBinTree r)

> equalBinTreeChar  :: BinTree Char -> BinTree Char -> Bool
> equalBinTreeChar x y  = equal (BinTreeR CharR :> x) (BinTreeR CharR :> y)
