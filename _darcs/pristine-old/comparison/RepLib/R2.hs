{-# OPTIONS -fglasgow-exts -fth -fallow-undecidable-instances #-}

{----------------------------------------------------------------------------

 Module      :  R2
 Author      :  Alex Gerdes (agerdes@mac.com)
 Copyright   :  (c) Open University Netherlands, 2007
 License     :  BSD
 
 This is the arity-2 type representation for RepLib

----------------------------------------------------------------------------}

module R2 where

import RepLib
import BinTreeDatatype

-- Definition of arity 2 GADT type representation

data R2 c a b where
  Int2   :: R2 c Int Int
  Char2  :: R2 c Char Char
  Data2  :: String -> [Con2 c a b] -> R2 c a b

data Con2 c a b    = forall l1 l2. Con2 (Emb l1 a) (Emb l2 b) (MTup2 c l1 l2)

data MTup2 c l1 l2 where
  MNil2  :: MTup2 c Nil Nil
  (:**:) :: c a b -> MTup2 c l1 l2 -> MTup2 c (a :*: l1) (b :*: l2)
infixr 7 :**:

-- Type rep of a binary tree

rBinTree2 :: forall a b c.c a b -> c (BinTree a) (BinTree b) 
                                -> R2 c (BinTree a) (BinTree b)
rBinTree2 a t = Data2 "BinTree" [Con2 rLeafEmb rLeafEmb (a :**: MNil2),
                                 Con2 rBinEmb rBinEmb (t :**: t :**: MNil2)]
rLeafEmb :: Emb (a :*: Nil) (BinTree a)
rLeafEmb = Emb { to   = \ (a :*: Nil) -> (Leaf a),
                 from = \ x -> case x of 
                          Leaf a -> Just (a :*: Nil)
                          _      -> Nothing }
rBinEmb :: Emb (BinTree a :*: BinTree a :*: Nil) (BinTree a)
rBinEmb = Emb { to   = \ (l :*: r :*: Nil) -> (Bin l r),
                from = \ x -> case x of
                         Bin l r -> Just (l :*: r :*: Nil)
                         _       -> Nothing}

-- Lists
rList2 :: forall a b c. Rep a => c a b -> c [a] [b] -> R2 c [a] [b]
rList2 a l = Data2 "[]" [rCons2 a l, rNil2]

rNil2  :: Con2 c [a] [b]
rNil2  = Con2 rNilEmb rNilEmb MNil2

rCons2 :: Rep a => c a b -> c [a] [b] -> Con2 c [a] [b]
rCons2 a l = Con2 rConsEmb rConsEmb (a :**: l :**: MNil2)

--instance (Rep a, Sat (ctx a), Sat (ctx [a])) => Rep1 ctx [a] where
--  rep1 = rList1 dict dict