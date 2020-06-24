{-# LANGUAGE FlexibleContexts #-}

module TypeChecker where

import Control.Monad.State
import Control.Monad.Except
import Data.Map (Map)
import qualified Data.Map as Map

import AbsPswift

import Utils


-------- Static Errors --------

data StaticErrorType = InvalidType (TypeMeta, [TypeMeta])
                        | IndexOutOfBound
                        | ObjectNotSubscriptable
                        | TupleIndexUnknown
                        | InvalidNumOfArgs (Int, Int)
                        | VarNotDefined (Ident)
                        | FuncNotDefined (Ident)
                        | BreakOutsideLoop
                        | ContinueOutsideLoop
                        | ReturnOutsideFunc
                        | NoReturnInFunc (Ident)
                        | InvalidNumberOfValuesToUnpack
                        | FunctionArgumentsNotUnique (Ident)

showInvalidTypeError :: TypeMeta -> [TypeMeta] -> String
showInvalidTypeError actual (expected:[]) =
    case expected of
        (CompositeType _ (ListUntyped _)) -> "Invalid type: expected one of " ++ (concatenateTypes ", " typeList) ++ " got " ++ show actual
        _ -> "Invalid type: expected " ++ show expected ++ " got " ++ show actual
showInvalidTypeError actual expected = "Invalid type: expected one of: " ++ (concatenateTypes ", " expected) ++ " got " ++ show actual

instance Show StaticErrorType where
    show (InvalidType (actual, expected)) = showInvalidTypeError actual expected
    show IndexOutOfBound = "Index out of bound"
    show ObjectNotSubscriptable = "Object not subscriptable"
    show TupleIndexUnknown = "Tuple index unknown"
    show (InvalidNumOfArgs (expected, actual)) = "Invalid number of arguments: expected " ++ show expected ++ " got " ++ show actual
    show (VarNotDefined (Ident varName)) = "Variable not defined: " ++ varName
    show (FuncNotDefined (Ident funcName)) = "Function not defined: " ++ funcName
    show BreakOutsideLoop = "Break outside a loop"
    show ContinueOutsideLoop = "Continue outside a loop"
    show ReturnOutsideFunc = "Return outside a function"
    show (NoReturnInFunc (Ident funcName)) = "No return in function: " ++ funcName
    show InvalidNumberOfValuesToUnpack = "Invalid number of values to unpack from tuple"
    show (FunctionArgumentsNotUnique (Ident funcName)) = "Function arguments are not unique " ++ funcName

data StaticError = StaticError {
    position :: Position,
    info :: StaticErrorType
}

instance Show StaticError where
    show error = "StaticError at line " ++ show line ++ ", column = " ++ show column ++ ": " ++ show err
        where
            err = info error
            (Just (line, column)) = position error

type VarType = (Type Position)
type FuncType = (VarType, [VarType])

data TypeCheckerState = TypeCheckerState {
    types :: Map Ident (Either VarType FuncType),
    returnType :: Maybe (TypeMeta),  -- expected return type for a current function
    validReturn :: Bool,  -- tells whether valid return was found (valid type / each execution path)                             
    insideLoop :: Bool
}

typeCheckerInitState = TypeCheckerState {
    types = Map.empty :: Map Ident (Either VarType FuncType),
    returnType = Nothing,  -- Nothing means we are just parsing script and we are not inside any function
    validReturn = False,
    insideLoop = False
}

type TypeCheckerMonad = StateT TypeCheckerState (Except StaticError)

-------- Types --------

-- Variables used to compare whether given type is e.g. Integer
-- Simple Types
typeInt = (SimpleType Nothing (Int Nothing))
typeString = (SimpleType Nothing (String Nothing))
typeBool = (SimpleType Nothing (Bool Nothing))
-- Composite Types
typeIntList = (CompositeType Nothing (List Nothing (Int Nothing)))
typeStringList = (CompositeType Nothing (List Nothing (String Nothing)))
typeBoolList = (CompositeType Nothing (List Nothing (Bool Nothing)))
typeTuple = (CompositeType Nothing (TupleGeneric Nothing))
-- Any of:
typeSimple = [typeInt, typeString, typeBool]
typeList = [typeIntList, typeStringList, typeBoolList]
-- used to validate e.g. my_array == [] - empty array has unique type
typeEmptyList = (CompositeType Nothing (ListUntyped Nothing))
typeAny = typeSimple ++ typeList

convertListTypeToSimpleType :: TypeMeta -> TypeMeta
convertListTypeToSimpleType listType = case listType of
    (CompositeType _ (List _ (Int _))) -> typeInt
    (CompositeType _ (List _ (String _))) -> typeString
    (CompositeType _ (List _(Bool _))) -> typeBool

convertSimpleTypeToListType :: TypeMeta -> TypeMeta
convertSimpleTypeToListType simpleType = case simpleType of
    (SimpleType _ (Int _)) -> typeIntList
    (SimpleType _ (String _)) -> typeStringList
    (SimpleType _ (Bool _)) -> typeBoolList

-------- Builts in functions --------
printFunction = (Ident "print", typeInt, [JokerType Nothing])
printlnFunction = (Ident "println", typeInt, [JokerType Nothing])
toStringFunction = (Ident "toString", typeString, [JokerType Nothing])
builtInFunctions = [printFunction, printlnFunction, toStringFunction]

addBuiltInFunctions :: TypeCheckerMonad ()
addBuiltInFunctions = 
    mapM_ (\(funcName, returnType, argsTypes) -> do
        addFuncType funcName returnType argsTypes
    ) builtInFunctions

-------- Utilities --------

-- Adds var type to the map
addVarType :: Ident -> TypeMeta -> TypeCheckerMonad ()
addVarType varName varType = modify (\state -> state {
    types = Map.insert varName (Left varType) (types state)
})

-- Adds function type to the map
addFuncType :: Ident -> TypeMeta -> [TypeMeta] -> TypeCheckerMonad ()
addFuncType funcName returnType argTypes = modify (\state -> state {
    types = Map.insert funcName (Right (returnType, argTypes)) (types state)
})

getVarType :: Ident -> Position -> TypeCheckerMonad (VarType)
getVarType varName errorPosition = do
    state <- get
    case Map.lookup varName (types state) of
        (Just (Left varType)) -> return (varType)
        _ -> throwError (StaticError errorPosition (VarNotDefined varName))

getFuncType :: Ident -> Position -> TypeCheckerMonad (FuncType)
getFuncType funcName errorPosition = do
    state <- get
    case Map.lookup funcName (types state) of
        (Just (Right funcType)) -> return (funcType)
        _ -> throwError (StaticError errorPosition (FuncNotDefined funcName))

setInsideLoop :: Bool -> TypeCheckerMonad ()
setInsideLoop val = modify (\state -> state {
    insideLoop = val
})

isInsideLoop :: TypeCheckerMonad (Bool)
isInsideLoop = do
    state <- get
    return (insideLoop state)

setValidReturn :: Bool -> TypeCheckerMonad ()
setValidReturn val = modify (\state -> state {
    validReturn = val
})

isValidReturn :: TypeCheckerMonad (Bool)
isValidReturn = do
    state <- get
    return (validReturn state)

-- Called when some block of function was parsed and return is expected to be found
runValidReturnCheck :: Ident -> Position -> TypeCheckerMonad ()
runValidReturnCheck funcName position = do
    state <- get
    if (validReturn state) then return ()
    else throwError (StaticError position (NoReturnInFunc funcName))

setReturnType :: Maybe (TypeMeta) -> TypeCheckerMonad ()
setReturnType val = modify (\state -> state {
    returnType = val
})

getReturnType :: Position -> TypeCheckerMonad (TypeMeta)
getReturnType errorPosition = do
    state <- get
    case (returnType state) of
        Nothing -> throwError (StaticError errorPosition ReturnOutsideFunc)
        (Just rType) -> return (rType)



------------------------------------------------------------------------------------------------------------


-- Given list of valid types check whether actual type is any of them
typeCheck :: TypeMeta -> [TypeMeta] -> Position -> TypeCheckerMonad ()
typeCheck actualType validTypes errorPosition =
    if any (==actualType) validTypes then return ()
    else throwError $ StaticError {
        position = errorPosition,
        info = InvalidType (actualType, validTypes)
        }

-- Runs given block locally -> current state is preserved
typeCheckLocally :: MonadState s m => m b -> m b
typeCheckLocally block = do
    state <- get
    returnVal <- block
    put state
    return returnVal

-- It's the same as typeCheckLocally but preserves value of 'validReturn' after execution
typeCheckLocallyMemorizeValidReturn :: MonadState TypeCheckerState m => m b -> m b
typeCheckLocallyMemorizeValidReturn block = do
    oldState <- get
    returnVal <- block
    newState <- get
    put oldState
    -- preserve validReturn value
    modify (\state -> state {
        validReturn = (validReturn newState)
    })
    return returnVal

typeCheckBlockLocally :: BlockMeta -> TypeCheckerMonad ()
typeCheckBlockLocally block = typeCheckLocallyMemorizeValidReturn (typeCheckBlock block)

typeCheckBlock :: BlockMeta -> TypeCheckerMonad ()
typeCheckBlock (Block _ stmts) = mapM_ typeCheckStmt stmts

runTypeChecker :: ProgramMeta -> Either StaticError ()
runTypeChecker (Program _ stmts)= do
    let doRunTypeChecker = mapM_ typeCheckStmt stmts
    runExcept $ evalStateT (addBuiltInFunctions >> doRunTypeChecker) typeCheckerInitState












------------------------  Statements ------------------------

typeCheckStmt :: StmtMeta -> TypeCheckerMonad ()
typeCheckStmt (Empty _) = return ()
typeCheckStmt (BStmt _ block) = typeCheckBlockLocally block
typeCheckStmt (SExp _ expr) = void (typeCheckExpr expr)

typeCheckStmt (DeclVar _ varType items)
    = mapM_ (\item -> do
        case item of
            (NoInit _ varName) -> addVarType varName varType
            (Init position varName expr) -> do
                exprType <- typeCheckExpr expr
                typeCheck exprType [varType] position
                addVarType varName varType
        ) items

typeCheckStmt (DeclFunc position returnType funcName funcArgs funcBlock) = do
    checkArgsUniqueness funcArgs funcName position
    addFuncType funcName returnType [argType | (DeclArg _ argType _) <- funcArgs]
    typeCheckLocally (do
        setReturnType (Just returnType)
        mapM_ (\(DeclArg _ argType argName) -> addVarType argName argType) funcArgs
        setValidReturn False
        typeCheckBlock funcBlock
        runValidReturnCheck funcName position)
    where
        checkArgsUniqueness :: [DeclArg Position] -> Ident -> Position -> TypeCheckerMonad ()
        checkArgsUniqueness args funcName errorPosition = 
            if allUniqueId [argName | (DeclArg _ _ argName) <- args] then return ()
            else throwError (StaticError position (FunctionArgumentsNotUnique funcName))


typeCheckStmt (Ret position expr) = do
    expectedReturnType <- getReturnType position
    typeCheckExprType expr [expectedReturnType]
    setValidReturn True

typeCheckStmt (Cond _ expr block) = typeCheckLocally (do
    typeCheckExprType expr [typeBool]
    typeCheckBlockLocally block)

typeCheckStmt (CondElse _ expr block1 block2) = do
    typeCheckExprType expr [typeBool]
    stateBeforeIfElse <- get
    typeCheckBlockLocally block1
    stateAfterIf <- get
    setValidReturn False
    typeCheckBlockLocally block2
    stateAfterElse <- get
    let validReturnFound = ((validReturn stateBeforeIfElse) || ((validReturn stateAfterIf) && (validReturn stateAfterElse)))
    setValidReturn validReturnFound

typeCheckStmt (While _ expr block) = typeCheckLocally (do
    setInsideLoop True
    typeCheckExprType expr [typeBool]
    typeCheckBlockLocally block)

typeCheckStmt (Break position) = do
    insideLoop <- isInsideLoop
    if insideLoop then return ()
    else throwError (StaticError position BreakOutsideLoop)

typeCheckStmt (Continue position) = do
    insideLoop <- isInsideLoop
    if insideLoop then return ()
    else throwError (StaticError position ContinueOutsideLoop)

typeCheckStmt (Ass position varName expr) = do
    varType <- getVarType varName position
    void (typeCheckExprType expr [varType])

typeCheckStmt (ListAss _ exprList exprIndex exprVal) = do
    listType <- typeCheckExpr exprList
    typeCheck listType typeList (extractExprPosition exprList)
    typeCheckExprType exprIndex [typeInt]
    void (typeCheckExprType exprVal [convertListTypeToSimpleType listType])

typeCheckStmt (TupleAssUnpack position unpackVars exprTuple) = do
    tupleExprType <- typeCheckExpr exprTuple
    typeCheck tupleExprType [typeTuple] (extractExprPosition exprTuple)
    case tupleExprType of
        (CompositeType _ (Tuple _ types)) -> typeCheckUnpackVars position unpackVars types
        _ -> typeCheckUnpackVars position unpackVars []
    return ()

typeCheckUnpackVars :: Position -> [TupleIdentMeta] -> [TypeMeta] -> TypeCheckerMonad ()
typeCheckUnpackVars position unpackVars types =
    if (length unpackVars) /= (length types) then throwError (StaticError position InvalidNumberOfValuesToUnpack)
    else case unpackVars of
        [] -> return ()
        var:vars -> do
            unpackElement var (head types)
            typeCheckUnpackVars position vars (tail types)
    where unpackElement unpackVar unpackType =
            case unpackVar of
                (TupleAssIdent position varName) -> do
                    varType <- getVarType varName position
                    typeCheck varType [unpackType] position
                (TupleAssVarInit position varType varName) -> do
                    typeCheck varType [unpackType] position
                    addVarType varName varType
                (TupleAssListEl position listName indexExpr) -> do
                    listType <- getVarType listName position
                    typeCheck listType typeList position
                    indexType <- typeCheckExpr indexExpr
                    typeCheck indexType [typeInt] (extractExprPosition indexExpr)
                    typeCheck unpackType [(convertListTypeToSimpleType listType)] position
                (TupleAssNested position unpackVars) ->
                    case unpackVars of
                        (var:[]) -> unpackElement var unpackType
                        _ -> case unpackType of
                            (CompositeType _ (Tuple _ types)) -> typeCheckUnpackVars position unpackVars types
                            _ -> typeCheckUnpackVars position unpackVars []




------------------------  Expressions ------------------------

typeCheckExpr :: ExprMeta -> TypeCheckerMonad (TypeMeta)
typeCheckExpr (EVar position varName) = getVarType varName position
typeCheckExpr (ELitInt position _) = return (SimpleType position (Int position))
typeCheckExpr (ELitTrue position) = return (SimpleType position (Bool position))
typeCheckExpr (ELitFalse position) = return (SimpleType position (Bool position))
typeCheckExpr (EString position _) = return (SimpleType position (String position))
typeCheckExpr (Not _ expr) = typeCheckExprType expr [typeBool]
typeCheckExpr (Neg _ expr) = typeCheckExprType expr [typeInt]
typeCheckExpr (EAnd _ expr1 expr2) = typeCheckLogicalOp expr1 expr2
typeCheckExpr (EOr _ expr1 expr2) = typeCheckLogicalOp expr1 expr2
typeCheckExpr (EMul _ expr1 _ expr2) = typeCheckNumericalOp expr1 expr2

typeCheckExpr (EAdd _ expr1 (Minus _) expr2) = typeCheckNumericalOp expr1 expr2
typeCheckExpr (EAdd _ expr1 (Plus _) expr2) = typeCheckBinaryOp (typeList ++ [typeInt, typeString]) expr1 expr2

typeCheckExpr (ERel _ expr1 (EQU _) expr2) = do
    typeCheckBinaryOp typeAny expr1 expr2
    return (typeBool)
typeCheckExpr (ERel _ expr1 (NE _) expr2) = do
    typeCheckBinaryOp typeAny expr1 expr2
    return (typeBool)
typeCheckExpr (ERel _ expr1 _ expr2) = do
    typeCheckBinaryOp typeSimple expr1 expr2
    return (typeBool)

typeCheckExpr (EList _ []) = return (typeEmptyList)
typeCheckExpr (EList _ (expr:exprs)) = do
    headType <- typeCheckExpr expr
    let position = extractExprPosition expr
    typeCheck headType typeSimple position
    mapM_ (\expr -> do
            currType <- typeCheckExpr expr
            typeCheck currType [headType] position
        ) exprs
    return (convertSimpleTypeToListType headType)

typeCheckExpr (ETuple _ expr exprs) = do
    types <- (mapM typeCheckExpr $ expr:exprs)
    return (CompositeType Nothing (Tuple Nothing types))

typeCheckExpr (EApp position funcName funcArgs) = do
    (returnType, argsTypes) <- getFuncType funcName position
    let argsExprs = map (\funcArg -> case funcArg of
            (FuncArgVal _ expr) -> expr
            (FuncArgRef position varName) -> EVar position varName) funcArgs
    let numExpected = length argsTypes
    let numGiven = length argsExprs
    if (numExpected /= numGiven) then throwError (StaticError position (InvalidNumOfArgs (numExpected, numGiven)))
    else zipWithM (\expectedType expr -> do
        actualType <- typeCheckExpr expr
        typeCheck actualType [expectedType] (extractExprPosition expr)) argsTypes argsExprs
    return (returnType)

typeCheckExpr (EGetEl _ exprStruct exprIndex) = do
    structType <- typeCheckExpr exprStruct
    if structType == typeTuple then typeCheckGetElFromTuple structType exprIndex
    else typeCheckGetElFromList exprStruct exprIndex
    where
        typeCheckGetElFromList :: ExprMeta -> ExprMeta -> TypeCheckerMonad (TypeMeta)
        typeCheckGetElFromList listExpr indexExpr = do
            listType <- typeCheckExpr listExpr
            let position = extractExprPosition listExpr
            case listType of
                (CompositeType _ (ListUntyped _)) -> throwError (StaticError position ObjectNotSubscriptable)
                _ -> do
                    typeCheck listType typeList position
                    indexType <- typeCheckExpr indexExpr
                    typeCheck indexType [typeInt] (extractExprPosition indexExpr)
                    return (convertListTypeToSimpleType listType)

        typeCheckGetElFromTuple :: TypeMeta -> ExprMeta -> TypeCheckerMonad (TypeMeta)
        typeCheckGetElFromTuple tupleExpr indexExpr = do
            case indexExpr of
                (ELitInt position index) -> 
                    case tupleExpr of
                        (CompositeType _ (Tuple position types)) -> do
                            let ind = fromInteger index
                            let isValidIndex = ind >= 0 && ind < (length types)
                            if isValidIndex then return (types !! ind)
                            else throwError (StaticError position IndexOutOfBound)
                _ -> throwError (StaticError (extractExprPosition indexExpr) TupleIndexUnknown)


----- Functions used by typeCheckExpr -----
typeCheckBinaryOp :: [TypeMeta] -> ExprMeta -> ExprMeta -> TypeCheckerMonad (TypeMeta)
typeCheckBinaryOp validTypes expr1 expr2 = do
    type1 <- typeCheckExpr expr1
    typeCheck type1 validTypes (extractExprPosition expr1)
    type2 <- typeCheckExpr expr2
    typeCheck type2 [type1] (extractExprPosition expr2)
    return (type1)

typeCheckLogicalOp :: ExprMeta -> ExprMeta -> TypeCheckerMonad (TypeMeta)
typeCheckLogicalOp expr1 expr2 = typeCheckBinaryOp [typeBool] expr1 expr2

typeCheckNumericalOp :: ExprMeta -> ExprMeta -> TypeCheckerMonad (TypeMeta)
typeCheckNumericalOp expr1 expr2 = typeCheckBinaryOp [typeInt] expr1 expr2

-- Checks whether expression type is in the list
typeCheckExprType :: ExprMeta -> [TypeMeta] -> TypeCheckerMonad (TypeMeta)
typeCheckExprType expr validTypes = do
    exprType <- typeCheckExpr expr
    typeCheck exprType validTypes (extractExprPosition expr)
    return (exprType)