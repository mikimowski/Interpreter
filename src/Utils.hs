module Utils where

import Data.List

import AbsPswift


type TypeMeta = (Type Position)
type ExprMeta = (Expr Position)
type TupleIdentMeta = (TupleIdent Position)
type BlockMeta = (Block Position)
type FuncArgMeta = (FuncArg Position)
type StmtMeta = (Stmt Position)
type ProgramMeta = (Program Position)
type ItemMeta = (Item Position)

-- Utility function used to extract position allowing to throw meaningful errors
extractExprPosition :: ExprMeta -> Position
extractExprPosition expr = case expr of
        (EVar position _) -> position
        (ELitInt position _) -> position
        (ELitTrue position) -> position
        (ELitFalse position) -> position
        (EString position _) -> position
        (Neg position _) -> position
        (Not position _) -> position
        (EAnd position _ _) -> position
        (EOr position _ _) -> position
        (ERel position _ _ _) -> position
        (EAdd position _ _ _) -> position
        (EMul position _ _ _) -> position
        (EList position _) -> position
        (EGetEl position _ _) -> position
        (ETuple position _ _) -> position
        (EApp position _ _) -> position

allUniqueId :: [Ident] -> Bool
allUniqueId ids = all (\group -> (length group) == 1) (group $ sort ids)

-- concatenateTypes :: String -> [Type a] -> String
-- concatenateTypes _ [] = ""
-- concatenateTypes sep types = intercalate sep (fmap show types)
--concatenateTypes sep (type1:[]) = show type1
--concatenateTypes sep (type1:types) = show type1 ++ sep ++ (concatenateTypes sep types)