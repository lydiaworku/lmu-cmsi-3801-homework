module Exercises
    ( change,
    meaningfulLineCount
    firstThenApply,
    meaningfulLineCount, 
    Shape,
    BST
    ) where

import qualified Data.Map as Map
import Data.Text (pack, unpack, replace)
import Data.List(isPrefixOf, find)
import Data.Char(isSpace)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
        where
          changeHelper [] remaining counts = counts
          changeHelper (d:ds) remaining counts =
            changeHelper ds newRemaining newCounts
              where
                (count, newRemaining) = remaining `divMod` d
                newCounts = Map.insert d count counts


-- finds first element in list that satisfies pred
firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs pred f = fmap f (find pred xs)

-- makes infinite list of powers of a base
powers :: Integral num => num -> [num]
powers base = map (base^) [0..]

-- counts number of meaningful lines in a file
meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount filePath = do
    document <- readFile filePath
    let allWhitespace line = all isSpace line
        trimStart = dropWhile isSpace
        isMeaningful line = 
            not (allWhitespace line) && -- checks if line is all whitespace
            not ("#" `isPrefixOf` (trimStart line)) -- checks if line starts with #
    return $ length $ filter isMeaningful (lines document)

-- creates sphere and box shape objects
data Shape
  = Sphere Double
  | Box Double Double Double
  deriving (Eq, Show)

-- calculates volume of given shape
volume :: Shape -> Double
volume (Sphere r) = (4 / 3) * pi * r^3
volume (Box l w h) = l * w * h

-- calculates surface area of given shape
surfaceArea :: Shape -> Double
surfaceArea (Sphere r) = 4 * pi * r^2
surfaceArea (Box l w h) = 2 * (l * w + l * h + w * h)

-- creates BST that can hold Empty or Node objects
data BST a
  = Empty
  | Node a (BST a) (BST a)

-- calculates size of BST
size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

-- traverses the BST in order and returns the values
inorder :: BST a -> [a]
inorder Empty = []
inorder (Node value left right) = inorder left ++ [value] ++ inorder right

-- inserts a value into the BST
insert :: Ord a => a -> BST a -> BST a
insert value Empty = Node value Empty Empty
insert value (Node nodeValue left right)
  | value < nodeValue = Node nodeValue (insert value left) right
  | value > nodeValue = Node nodeValue left (insert value right)
  | otherwise = Node nodeValue left right

-- checks if the BST contains a given value
contains :: Ord a => a -> BST a -> Bool
contains _ Empty = False
contains value (Node nodeValue left right)
  | value == nodeValue = True
  | value < nodeValue = contains value left
  | otherwise = contains value right

-- turns the BST into a string and returns it, taking care of superfluous parentheses
instance (Show a) => Show (BST a) where
  show Empty = "()"
  show (Node value Empty Empty) = "(" ++ show value ++ ")"
  show (Node value left Empty) = "(" ++ show left ++ show value ++ ")"
  show (Node value Empty right) = "(" ++ show value ++ show right ++ ")"
  show (Node value left right) = "(" ++ show left ++ show value ++ show right ++ ")"

