{-# LANGUAGE FlexibleContexts #-}

module Interpreter where

import Data.List
import Data.Maybe
import Control.Monad.State
import Control.Monad.Except
import System.IO
import Data.Map (Map)
import qualified Data.Map as Map

import AbsPswift

import Utils

data Value
    = VBool Bool
    | VInt Integer
    | VString String
    | VListEmpty
    | VListBool [Value]
    | VListInt [Value]
    | VListString [Value]
    | VTuple [Value]

instance Eq Value where
    (VBool val1) == (VBool val2) = val1 == val2
    (VInt val1) == (VInt val2) = val1 == val2
    (VString val1) == (VString val2) = val1 == val2
    (VListEmpty) == (VListEmpty) = True
    (VListEmpty) == (VListBool _) = True
    (VListEmpty) == (VListInt _) = True
    (VListEmpty) == (VListString _) = True
    (VListBool _) == (VListEmpty) = True
    (VListInt _) == (VListEmpty) = True
    (VListString _) == (VListEmpty) = True
    (VListBool val1) == (VListBool val2) = val1 == val2
    (VListInt val1) == (VListInt val2) = val1 == val2
    (VListString val1) == (VListString val2) = val1 == val2
    (VTuple vals1) == (VTuple vals2) = vals1 == vals2
    _ == _ = False

instance Ord Value where
    (VBool val1) <= (VBool val2) = val1 <= val2
    (VInt val1) <= (VInt val2) = val1 <= val2
    (VString val1) <= (VString val2) = val1 <= val2

instance Show Value where
    show (VBool x) = show x
    show (VInt x) = show x
    show (VString x) = x
    show (VListEmpty) = "[]"
    show (VListBool l) = listAsString l
    show (VListInt l) = listAsString l
    show (VListString l) = listAsString l
    show (VTuple t) = tupleAsString t

listAsString :: Show a => [a] -> String
listAsString [] = "[]"
listAsString list = "[" ++ intercalate ", " (fmap show list) ++ "]"

tupleAsString :: Show a => [a] -> String
tupleAsString [] = "()"
tupleAsString tuple = "(" ++ intercalate ", " (fmap show tuple) ++ ")"

getDefault :: TypeMeta -> Value
getDefault (SimpleType _ (Bool _)) = (VBool False)
getDefault (SimpleType _ (Int _)) = (VInt 42)
getDefault (SimpleType _ (String _)) = (VString "I am empty")
getDefault (CompositeType _ (List _ (Bool _))) = (VListBool [])
getDefault (CompositeType _ (List _ (Int _))) = (VListInt [])
getDefault (CompositeType _ (List _ (String _))) = (VListString [])
getDefault (CompositeType _ (Tuple _ types)) = (VTuple $ map getDefault types)


-------- Functions -------- 

type BuildInFunction = ([Value] -> InterpreterMonad (Value))
-- ((FunctionParameters, FunctionBody, Env) ())
type CustomFunction = ([Ident], BlockMeta, Env)
-- Left -> buildInFunction
-- Right -> customFunction
type Function = (Either BuildInFunction CustomFunction)

-- Constant to return on success - each function has to return something
returnSuccess = (VInt 0)

builtInPrint :: [Value] -> InterpreterMonad (Value)
builtInPrint (val:_) = do
    liftIO $ putStr $ show val
    return (returnSuccess)
    
builtInPrintln :: [Value] -> InterpreterMonad (Value)
builtInPrintln (val:_) = do
    liftIO $ putStrLn $ show val
    return (returnSuccess)

builtInToString :: [Value] -> InterpreterMonad (Value)
builtInToString (val:_) = do
    return (VString $ show val)

builtInFunctions = [(Ident "print", (Left builtInPrint)), (Ident "println", (Left builtInPrintln)),  (Ident "toString", (Left builtInToString))]


-------- RuntimeError -------- 
data RuntimeErrorType = DivisionByZero | ModuloByZero | IndexOutOfBound

instance Show RuntimeErrorType where
    show (DivisionByZero) = "Division by zero"
    show (ModuloByZero) = "Modulo by zero"
    show (IndexOutOfBound) = "Index out of bound"

data RuntimeError = RuntimeError {
        position :: Position,
        info :: RuntimeErrorType
    }

instance Show RuntimeError where
    show error = "RuntimeError at line " ++ show line ++ ", column " ++ show column ++ ": " ++ show err
        where
            err = info error
            (Just (line, column)) = position error


-------- InterpreterMonad -------- 
type Loc = Int
type Env = Map Ident Loc
type Store = Map Loc (Either Value Function)

data InterpreterState = InterpreterState {
    env :: Env,
    store :: Store,
    wasBreak :: Bool,
    wasContinue :: Bool,
    returnValue :: Maybe Value
}

interpreterInitState = InterpreterState {
    env = Map.empty :: Env,
    store = Map.empty :: Store,
    wasBreak = False,
    wasContinue = False,
    returnValue = Nothing
}

type InterpreterMonad = ExceptT RuntimeError (StateT InterpreterState IO)


-------- Utilities -------- 
-- Runs given block locally -> current state is preserved
executeLocally :: MonadState InterpreterState m => m b -> m b
executeLocally block = do
    state <- get
    returnVal <- block
    store' <- gets store
    put state
    modify (\state -> state { store = store' })
    return returnVal

executeLocallyKeepEnv :: MonadState InterpreterState m => m b -> m b
executeLocallyKeepEnv block = do
    env' <- gets env
    returnVal <- block
    modify (\state -> state {
        env = env'
    })
    return returnVal

getNewLoc :: InterpreterMonad (Int)
getNewLoc = do
    store' <- gets store
    return (Map.size store')

getLoc :: Ident -> Env -> InterpreterMonad (Loc)
getLoc name env = do
    let (Just loc) = Map.lookup name env
    return (loc)

-- getVarValueLoc :: Ident -> Loc -> InterpreterMonad (Value)
-- getVarValueLoc varName loc = do
--     (InterpreterState _ store' _ _ _) <- get
--     let (Just (Left value)) = Map.lookup loc store'
--     return (value)

getVarValue :: Ident -> InterpreterMonad (Value)
getVarValue varName = do
    (InterpreterState env' store' _ _ _) <- get
    let (Just loc) = Map.lookup varName env'
    let (Just (Left value)) = Map.lookup loc store'
    return (value)

-- getFuncDeclLoc :: Ident -> Loc -> InterpreterMonad (Function)
-- getFuncDeclLoc funcName loc = do
--     (InterpreterState _ store' _ _ _) <- get
--     let (Just (Right func)) = Map.lookup loc store'
--     return (func)

getFuncDecl :: Ident -> InterpreterMonad (Function)
getFuncDecl funcName = do
    (InterpreterState env' store' _ _ _) <- get
    let (Just loc) = Map.lookup funcName env'
    let (Just (Right func)) = Map.lookup loc store'
    return (func)

addVar :: Ident -> Value -> InterpreterMonad ()
addVar varName value = do
    (InterpreterState env' store' _ _ _) <- get
    newLoc <- getNewLoc
    modify (\state -> 
        state {
            env = Map.insert varName newLoc env',
            store = Map.insert newLoc (Left value) store'
        })

addFunc :: Ident -> Function -> InterpreterMonad ()
addFunc funcName func = do
    (InterpreterState env' store' _ _ _) <- get
    newLoc <- getNewLoc
    modify (\state -> 
        state {
            env = Map.insert funcName newLoc env',
            store = Map.insert newLoc (Right func) store'
        }) 

setVarValue :: Ident -> Value -> InterpreterMonad ()
setVarValue varName value = do
    (InterpreterState env' store' _ _ _) <- get
    loc <- getLoc varName env'
    modify (\state ->
        state {
            store = Map.insert loc (Left value) store'
        })


------------------------  Main ------------------------

runInterpreter :: ProgramMeta -> IO (Either RuntimeError ())
runInterpreter (Program _ stmts) = do
    let doRunInterpreter = mapM_ executeStmt stmts
    evalStateT (runExceptT (addBuiltInFunctions >> doRunInterpreter)) interpreterInitState
    where
        addBuiltInFunctions :: InterpreterMonad ()
        addBuiltInFunctions = void (mapM (\(funcName, func) -> addFunc funcName func) builtInFunctions)



------------------------  Statements ------------------------

executeStmts :: [StmtMeta] -> InterpreterMonad ()
executeStmts [] = return ()
executeStmts (stmt:stmts) = do
    (InterpreterState _ _ wasBreak' wasContinue' returnValue') <- get
    let shouldExitBlock = any (==True) [wasBreak', wasContinue', isJust $ returnValue']
    if shouldExitBlock then return ()
    else do
        executeStmt stmt
        executeStmts stmts 

executeBlock :: BlockMeta -> InterpreterMonad ()
executeBlock (Block _ []) = return ()
executeBlock (Block _ stmts) = executeStmts stmts

executeBlockLocally :: BlockMeta -> InterpreterMonad ()
executeBlockLocally block = executeLocallyKeepEnv (executeBlock block)

executeStmt :: StmtMeta -> InterpreterMonad ()
executeStmt (Empty _) = return ()
executeStmt (BStmt _ block) = executeBlockLocally block
executeStmt (SExp _ expr) = void (evalExpr expr)

executeStmt (DeclVar _ varType items) = mapM_ declareVar items
    where
        declareVar :: ItemMeta -> InterpreterMonad ()
        declareVar (Init _ varName expr) = do 
            val <- evalExpr expr
            addVar varName val
        declareVar (NoInit _ varName) = addVar varName (getDefault varType)

executeStmt (DeclFunc _ _ funcName funcParams funcBlock) = do
    -- Trick enabling recursive calls: functions has to have itself declared in env
    env' <- gets env
    addFunc funcName (Right ([paramName | (DeclArg _ _ paramName) <- funcParams], funcBlock, env'))
    env'' <- gets env
    modifyFunc funcName (Right ([paramName | (DeclArg _ _ paramName) <- funcParams], funcBlock, env''))
    where
        modifyFunc :: Ident -> Function -> InterpreterMonad ()
        modifyFunc funcName func = do      
            (InterpreterState env' store' _ _ _) <- get
            loc <- getLoc funcName env'
            modify (\state -> state {
                store = Map.insert loc (Right func) store'
            })

executeStmt (Cond _ expr block) = do
    (VBool condition) <- evalExpr expr
    if condition then executeBlockLocally block else return ()

executeStmt (CondElse _ expr block1 block2) = do
    (VBool condition) <- evalExpr expr
    if condition then executeBlockLocally block1 else executeBlockLocally block2

executeStmt stmt@(While _ expr block) = do
    (InterpreterState _ _ wasBreak' _ returnValue') <- get
    let shouldExitBlock = any (==True) [wasBreak', isJust $ returnValue']
    if shouldExitBlock then do
        modify (\state -> state { wasBreak = False })
        return ()
    else do
        modify (\state -> state { wasContinue = False })
        (VBool condition) <- evalExpr expr
        when condition $ do
            executeBlockLocally block
            executeStmt stmt

executeStmt (Break _) = modify (\state -> state { wasBreak = True })

executeStmt (Continue _) = modify (\state -> state { wasContinue = True })

executeStmt (Ret _ expr) = do
    returnValue <- evalExpr expr
    setReturnValue returnValue
    where
        setReturnValue :: Value -> InterpreterMonad ()
        setReturnValue val = modify (\state -> state {
            returnValue = (Just val)
        })

executeStmt (Ass _ varName expr) = do
    value <- evalExpr expr
    setVarValue varName value

executeStmt (ListAss _ exprList@(EVar _ listName) exprIndex exprVal) = do
    (VInt index) <- evalExpr exprIndex
    value <- evalExpr exprVal
    vList <- getVarValue listName
    doListElAssignment (fromInteger index) value listName vList (extractExprPosition exprIndex)
executeStmt (ListAss _ _ _ _) = return ()

executeStmt (TupleAssUnpack _ unpackVars exprTuple) = do
    (VTuple tupleVals) <- evalExpr exprTuple
    unpackMultiple unpackVars tupleVals
    where
        unpackSingle :: TupleIdentMeta -> Value -> InterpreterMonad ()
        unpackSingle (TupleAssIdent _ varName) val = setVarValue varName val
        unpackSingle (TupleAssVarInit _ _ varName) val = addVar varName val
        unpackSingle (TupleAssListEl _ listName exprIndex) val = do
            (VInt index) <- evalExpr exprIndex
            vList <- getVarValue listName
            doListElAssignment (fromInteger index) val listName vList (extractExprPosition exprIndex)
        unpackSingle (TupleAssNested _ (varName:[])) val = unpackSingle varName val
        -- Nested tuple!
        unpackSingle (TupleAssNested _ varNames) val = do
            let (VTuple vals) = val
            unpackMultiple varNames vals

        unpackMultiple :: [TupleIdentMeta] -> [Value] -> InterpreterMonad ()
        unpackMultiple variables values =
            case variables of
                [] -> return ()
                var:vars -> do
                    let (val:vals) = values
                    unpackSingle var val
                    unpackMultiple vars vals

doListElAssignment :: Int -> Value -> Ident -> Value -> Position -> InterpreterMonad ()
doListElAssignment index value listName (VListBool list) positionError = do
    validateIndex index list positionError
    setVarValue listName (VListBool (setAtIndex index value list))
doListElAssignment index value listName (VListInt list) positionError = do
    validateIndex index list positionError
    setVarValue listName (VListInt (setAtIndex index value list))
doListElAssignment index value listName (VListString list) positionError = do
    validateIndex index list positionError
    setVarValue listName (VListString (setAtIndex index value list))

setAtIndex :: Int -> a -> [a] -> [a]
setAtIndex index value list =
    let (left, _:right) = splitAt index list in
    left ++ (value:right)

validateIndex :: Int -> [Value] -> Position -> InterpreterMonad ()
validateIndex index list errorPosition = do
    if index < 0 || index >= (length list) then throwError (RuntimeError errorPosition IndexOutOfBound)
    else return ()



------------------------  Expressions ------------------------

evalExpr :: ExprMeta -> InterpreterMonad (Value)
evalExpr (EVar _ varName) = getVarValue varName
evalExpr (ELitInt _ value) = return (VInt value)
evalExpr (ELitTrue _) = return (VBool True)
evalExpr (ELitFalse _) = return (VBool False)
evalExpr (EString _ value) = return (VString $ tail (init value))

evalExpr (Not _ expr) = do
    (VBool val) <- evalExpr expr
    return (VBool $ not val)
    
evalExpr (Neg _ expr) = do
    (VInt val) <- evalExpr expr
    return (VInt $ negate val)

-- Lazy
evalExpr (EAnd _ expr1 expr2) = do
    (VBool val1) <- evalExpr expr1
    if val1 == False then return (VBool False) else evalExpr expr2

-- Lazy
evalExpr (EOr _ expr1 expr2) = do
    (VBool val1) <- evalExpr expr1
    if val1 == True then return (VBool True) else evalExpr expr2

evalExpr (EMul position expr1 op expr2) = do
    (VInt val1) <- evalExpr expr1
    (VInt val2) <- evalExpr expr2
    case op of
        Times _ -> return (VInt $ val1 * val2)
        Mod _ -> if val2 == 0 then throwError (RuntimeError position ModuloByZero) else return (VInt $ val1 `mod` val2)
        Div _ -> if val2 == 0 then throwError (RuntimeError position DivisionByZero) else return (VInt $ val1 `div` val2)
 
evalExpr (EAdd _ expr1 op expr2) = do
    val1 <- evalExpr expr1
    val2 <- evalExpr expr2
    doAddition val1 val2
    where
        doAddition :: Value -> Value -> InterpreterMonad (Value)
        doAddition (VInt val1) (VInt val2) =
            case op of
                Plus _ -> return (VInt $ val1 + val2)
                Minus _ -> return (VInt $ val1 - val2) 
        doAddition (VString val1) (VString val2) = return (VString $ val1 ++ val2)
        doAddition val1 (VListEmpty) = return (val1)
        doAddition (VListEmpty) val2 = return (val2)
        doAddition (VListBool val1) (VListBool val2) = return (VListBool $ val1 ++ val2)
        doAddition (VListInt val1) (VListInt val2) = return (VListInt $ val1 ++ val2)
        doAddition (VListString val1) (VListString val2) = return (VListString $ val1 ++ val2)

evalExpr (ERel _ expr1 op expr2) = do
    val1 <- evalExpr expr1
    val2 <- evalExpr expr2
    doRelationalOperation op val1 val2
    where
        doRelationalOperation :: RelOp Position -> Value -> Value -> InterpreterMonad (Value)
        doRelationalOperation (EQU _) val1 val2 = do pure (VBool $ val1 == val2)
        doRelationalOperation (NE _) val1 val2 = do pure (VBool $ val1 == val2)
        doRelationalOperation (LTH _) val1 val2 = do pure (VBool $ val1 < val2)
        doRelationalOperation (LE _) val1 val2 = do pure (VBool $ val1 <= val2)
        doRelationalOperation (GTH _) val1 val2 = do pure (VBool $ val1 > val2)
        doRelationalOperation (GE _) val1 val2 = do pure (VBool $ val1 >= val2)

evalExpr (EList _ []) = return (VListEmpty)
evalExpr (EList _ exprList) = do
    vals@(valh:_) <- mapM evalExpr exprList
    case valh of
        (VBool _) -> return (VListBool vals)
        (VInt _) -> return (VListInt vals)
        (VString _) -> return (VListString vals)

evalExpr (ETuple _ expr exprs) = do
    vals <- mapM (\expr -> do 
        val <- evalExpr expr
        return (val)) (expr:exprs)
    return (VTuple vals)

evalExpr (EGetEl _ exprStruct exprIndex) = do
    struct <- evalExpr exprStruct
    (VInt indexInteger) <- evalExpr exprIndex
    let index = fromInteger indexInteger
    case struct of
        (VListEmpty) -> throwError (RuntimeError (extractExprPosition exprIndex) IndexOutOfBound)
        (VListBool list) -> getAtIndex index list
        (VListInt list) -> getAtIndex index list
        (VListString list) -> getAtIndex index list
        (VTuple vals) -> return (vals !! index)
    where
        getAtIndex :: Int -> [Value] -> InterpreterMonad (Value)
        getAtIndex index list = do
            validateIndex index list (extractExprPosition exprIndex)
            return (list !! index)

evalExpr (EApp _ funcName funcArgs) = do
    eFunc <- getFunc funcName
    case eFunc of
        (Left func) -> executeBuildInFunction func funcArgs
        (Right func) -> executeCustomFunction func funcArgs
        where
            getFunc :: Ident -> InterpreterMonad (Function)
            getFunc funcName = do
                func <- getFuncDecl funcName
                return (func)
                
            executeBuildInFunction :: BuildInFunction -> [FuncArgMeta] -> InterpreterMonad (Value)
            executeBuildInFunction func funcArgs = do
                argsValues <- mapM evalArg funcArgs
                func argsValues
                where
                    evalArg :: FuncArgMeta -> InterpreterMonad (Value)
                    evalArg (FuncArgVal _ expr) = evalExpr expr
                    evalArg (FuncArgRef _ varName) = evalExpr (EVar Nothing varName)
            
            executeCustomFunction :: CustomFunction -> [FuncArgMeta] -> InterpreterMonad (Value)
            executeCustomFunction (params, block, declEnv) args = do
                callEnv <- gets env
                executeLocally (do
                    modify (\state -> state { env = declEnv })
                    mapM_ (declFuncArgs callEnv) (zip params args)
                    executeBlock block
                    res <- gets returnValue
                    return (fromJust res))
                where
                    declFuncArgs :: Env -> (Ident, FuncArgMeta) -> InterpreterMonad ()
                    declFuncArgs callEnv (paramName, (FuncArgVal _ exprVal)) = do
                        argVal <- evalExprInEnv exprVal callEnv
                        addVar paramName argVal
                        return ()
                        where
                            evalExprInEnv :: ExprMeta -> Env -> InterpreterMonad (Value)
                            evalExprInEnv expr evalEnv =
                                executeLocally (do
                                    setEnv evalEnv
                                    evalExpr expr)
                                where 
                                    setEnv :: Env -> InterpreterMonad ()
                                    setEnv env' = modify (\state -> state {
                                        env = env'
                                    })

                    declFuncArgs callEnv (paramName, (FuncArgRef _ varName)) = do
                        loc <- getLoc varName callEnv
                        -- Inserts param into specific location therefore it will affect passed reference
                        modify (\state -> state { env = Map.insert paramName loc (env state) })
