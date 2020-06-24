module Main where

import AbsPswift
import ParPswift
import ErrM

import System.Environment (getArgs)
import System.IO (IOMode (ReadMode), hGetContents, openFile, hPrint, hPutStrLn, stderr, stdin)

import TypeChecker
import Interpreter

main :: IO()
main = do
    args <- getArgs
    case args of
        [file] -> do
            handle <- openFile file ReadMode
            content <- hGetContents handle
            pswift content
        [] -> do
            input <- getContents
            pswift input
        _ -> putStrLn "Usage: ./interpreter program.ps"

pswift :: String -> IO ()
pswift s =
    let program = pProgram (myLexer s) in
    case program of
        Ok programTree -> do
            let typeCheckerResult = runTypeChecker programTree
            case typeCheckerResult of
                Left error -> hPrint stderr error
                Right _ -> do
                    interpreterResult <- runInterpreter programTree 
                    case interpreterResult of
                        Left error -> hPrint stderr error
                        Right _ -> return ()
        Bad error -> hPutStrLn stderr error