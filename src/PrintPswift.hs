{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}
module PrintPswift where

-- pretty-printer generated by the BNF converter

import AbsPswift
import Data.Char


-- the top-level printing method
printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 (map ($ "") $ d []) "" where
  rend i ss = case ss of
    "["      :ts -> showChar '[' . rend i ts
    "("      :ts -> showChar '(' . rend i ts
    "{"      :ts -> showChar '{' . new (i+1) . rend (i+1) ts
    "}" : ";":ts -> new (i-1) . space "}" . showChar ';' . new (i-1) . rend (i-1) ts
    "}"      :ts -> new (i-1) . showChar '}' . new (i-1) . rend (i-1) ts
    ";"      :ts -> showChar ';' . new i . rend i ts
    t  : "," :ts -> showString t . space "," . rend i ts
    t  : ")" :ts -> showString t . showChar ')' . rend i ts
    t  : "]" :ts -> showString t . showChar ']' . rend i ts
    t        :ts -> space t . rend i ts
    _            -> id
  new i   = showChar '\n' . replicateS (2*i) (showChar ' ') . dropWhile isSpace
  space t = showString t . (\s -> if null s then "" else ' ':s)

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- the printer class does the job
class Print a where
  prt :: Int -> a -> Doc
  prtList :: Int -> [a] -> Doc
  prtList i = concatD . map (prt i)

instance Print a => Print [a] where
  prt = prtList

instance Print Char where
  prt _ s = doc (showChar '\'' . mkEsc '\'' s . showChar '\'')
  prtList _ s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q s = case s of
  _ | s == q -> showChar '\\' . showChar s
  '\\'-> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  _ -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j<i then parenth else id


instance Print Integer where
  prt _ x = doc (shows x)


instance Print Double where
  prt _ x = doc (shows x)


instance Print Ident where
  prt _ (Ident i) = doc (showString ( i))



instance Print (Program a) where
  prt i e = case e of
    Program _ stmts -> prPrec i 0 (concatD [prt 0 stmts])

instance Print (Stmt a) where
  prt i e = case e of
    DeclVar _ type_ items -> prPrec i 0 (concatD [prt 0 type_, prt 0 items, doc (showString ";")])
    DeclFunc _ type_ id declargs block -> prPrec i 0 (concatD [prt 0 type_, prt 0 id, doc (showString "("), prt 0 declargs, doc (showString ")"), prt 0 block])
    Empty _ -> prPrec i 0 (concatD [doc (showString ";")])
    BStmt _ block -> prPrec i 0 (concatD [prt 0 block])
    Ass _ id expr -> prPrec i 0 (concatD [prt 0 id, doc (showString "="), prt 0 expr, doc (showString ";")])
    ListAss _ expr1 expr2 expr3 -> prPrec i 0 (concatD [prt 6 expr1, doc (showString "["), prt 0 expr2, doc (showString "]"), doc (showString "="), prt 0 expr3, doc (showString ";")])
    TupleAssUnpack _ tupleidents expr -> prPrec i 0 (concatD [doc (showString "<"), prt 0 tupleidents, doc (showString ">"), doc (showString "="), prt 0 expr, doc (showString ";")])
    Ret _ expr -> prPrec i 0 (concatD [doc (showString "return"), prt 0 expr, doc (showString ";")])
    Cond _ expr block -> prPrec i 0 (concatD [doc (showString "if"), prt 0 expr, prt 0 block])
    CondElse _ expr block1 block2 -> prPrec i 0 (concatD [doc (showString "if"), prt 0 expr, prt 0 block1, doc (showString "else"), prt 0 block2])
    While _ expr block -> prPrec i 0 (concatD [doc (showString "while"), prt 0 expr, prt 0 block])
    Break _ -> prPrec i 0 (concatD [doc (showString "break"), doc (showString ";")])
    Continue _ -> prPrec i 0 (concatD [doc (showString "continue"), doc (showString ";")])
    SExp _ expr -> prPrec i 0 (concatD [prt 0 expr, doc (showString ";")])
  prtList _ [] = (concatD [])
  prtList _ (x:xs) = (concatD [prt 0 x, prt 0 xs])
instance Print (Item a) where
  prt i e = case e of
    NoInit _ id -> prPrec i 0 (concatD [prt 0 id])
    Init _ id expr -> prPrec i 0 (concatD [prt 0 id, doc (showString "="), prt 0 expr])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print (DeclArg a) where
  prt i e = case e of
    DeclArg _ type_ id -> prPrec i 0 (concatD [prt 0 type_, prt 0 id])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print (Block a) where
  prt i e = case e of
    Block _ stmts -> prPrec i 0 (concatD [doc (showString "{"), prt 0 stmts, doc (showString "}")])

instance Print (TupleIdent a) where
  prt i e = case e of
    TupleAssIdent _ id -> prPrec i 0 (concatD [prt 0 id])
    TupleAssVarInit _ type_ id -> prPrec i 0 (concatD [prt 0 type_, prt 0 id])
    TupleAssListEl _ id expr -> prPrec i 0 (concatD [prt 0 id, doc (showString "["), prt 0 expr, doc (showString "]")])
    TupleAssNested _ tupleidents -> prPrec i 0 (concatD [doc (showString "("), prt 0 tupleidents, doc (showString ")")])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print (Type a) where
  prt i e = case e of
    SimpleType _ simpletype -> prPrec i 0 (concatD [prt 0 simpletype])
    CompositeType _ compositetype -> prPrec i 0 (concatD [prt 0 compositetype])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print (SimpleType a) where
  prt i e = case e of
    Int _ -> prPrec i 0 (concatD [doc (showString "int")])
    String _ -> prPrec i 0 (concatD [doc (showString "string")])
    Bool _ -> prPrec i 0 (concatD [doc (showString "bool")])

instance Print (CompositeType a) where
  prt i e = case e of
    List _ simpletype -> prPrec i 0 (concatD [doc (showString "["), prt 0 simpletype, doc (showString "]")])
    Tuple _ types -> prPrec i 0 (concatD [doc (showString "tuple"), doc (showString "<"), prt 0 types, doc (showString ">")])

instance Print (FuncArg a) where
  prt i e = case e of
    FuncArgVal _ expr -> prPrec i 0 (concatD [prt 0 expr])
    FuncArgRef _ id -> prPrec i 0 (concatD [doc (showString "&"), prt 0 id])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print (Expr a) where
  prt i e = case e of
    EVar _ id -> prPrec i 6 (concatD [prt 0 id])
    ELitInt _ n -> prPrec i 6 (concatD [prt 0 n])
    ELitTrue _ -> prPrec i 6 (concatD [doc (showString "True")])
    ELitFalse _ -> prPrec i 6 (concatD [doc (showString "False")])
    EApp _ id funargs -> prPrec i 6 (concatD [prt 0 id, doc (showString "("), prt 0 funargs, doc (showString ")")])
    EString _ str -> prPrec i 6 (concatD [prt 0 str])
    EList _ exprs -> prPrec i 6 (concatD [doc (showString "["), prt 0 exprs, doc (showString "]")])
    EGetEl _ expr1 expr2 -> prPrec i 6 (concatD [prt 6 expr1, doc (showString "["), prt 0 expr2, doc (showString "]")])
    ETuple _ expr exprs -> prPrec i 6 (concatD [doc (showString "("), prt 0 expr, doc (showString ","), prt 0 exprs, doc (showString ")")])
    Neg _ expr -> prPrec i 5 (concatD [doc (showString "-"), prt 6 expr])
    Not _ expr -> prPrec i 5 (concatD [doc (showString "!"), prt 6 expr])
    EMul _ expr1 mulop expr2 -> prPrec i 4 (concatD [prt 4 expr1, prt 0 mulop, prt 5 expr2])
    EAdd _ expr1 addop expr2 -> prPrec i 3 (concatD [prt 3 expr1, prt 0 addop, prt 4 expr2])
    ERel _ expr1 relop expr2 -> prPrec i 2 (concatD [prt 2 expr1, prt 0 relop, prt 3 expr2])
    EAnd _ expr1 expr2 -> prPrec i 1 (concatD [prt 2 expr1, doc (showString "&&"), prt 1 expr2])
    EOr _ expr1 expr2 -> prPrec i 0 (concatD [prt 1 expr1, doc (showString "||"), prt 0 expr2])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print (AddOp a) where
  prt i e = case e of
    Plus _ -> prPrec i 0 (concatD [doc (showString "+")])
    Minus _ -> prPrec i 0 (concatD [doc (showString "-")])

instance Print (MulOp a) where
  prt i e = case e of
    Times _ -> prPrec i 0 (concatD [doc (showString "*")])
    Div _ -> prPrec i 0 (concatD [doc (showString "/")])
    Mod _ -> prPrec i 0 (concatD [doc (showString "%")])

instance Print (RelOp a) where
  prt i e = case e of
    LTH _ -> prPrec i 0 (concatD [doc (showString "<")])
    LE _ -> prPrec i 0 (concatD [doc (showString "<=")])
    GTH _ -> prPrec i 0 (concatD [doc (showString ">")])
    GE _ -> prPrec i 0 (concatD [doc (showString ">=")])
    EQU _ -> prPrec i 0 (concatD [doc (showString "==")])
    NE _ -> prPrec i 0 (concatD [doc (showString "!=")])

