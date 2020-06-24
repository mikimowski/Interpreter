{-# OPTIONS_GHC -w #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParPswift where
import AbsPswift
import LexPswift
import ErrM
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.8

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 ((Maybe (Int, Int), Ident))
	| HappyAbsSyn5 ((Maybe (Int, Int), Integer))
	| HappyAbsSyn6 ((Maybe (Int, Int), String))
	| HappyAbsSyn7 ((Maybe (Int, Int), Program (Maybe (Int, Int))))
	| HappyAbsSyn8 ((Maybe (Int, Int), Stmt (Maybe (Int, Int))))
	| HappyAbsSyn9 ((Maybe (Int, Int), Item (Maybe (Int, Int))))
	| HappyAbsSyn10 ((Maybe (Int, Int), [Item (Maybe (Int, Int))]))
	| HappyAbsSyn11 ((Maybe (Int, Int), DeclArg (Maybe (Int, Int))))
	| HappyAbsSyn12 ((Maybe (Int, Int), [DeclArg (Maybe (Int, Int))]))
	| HappyAbsSyn13 ((Maybe (Int, Int), Block (Maybe (Int, Int))))
	| HappyAbsSyn14 ((Maybe (Int, Int), [Stmt (Maybe (Int, Int))]))
	| HappyAbsSyn15 ((Maybe (Int, Int), [TupleIdent (Maybe (Int, Int))]))
	| HappyAbsSyn16 ((Maybe (Int, Int), TupleIdent (Maybe (Int, Int))))
	| HappyAbsSyn17 ((Maybe (Int, Int), Type (Maybe (Int, Int))))
	| HappyAbsSyn18 ((Maybe (Int, Int), [Type (Maybe (Int, Int))]))
	| HappyAbsSyn19 ((Maybe (Int, Int), SimpleType (Maybe (Int, Int))))
	| HappyAbsSyn20 ((Maybe (Int, Int), CompositeType (Maybe (Int, Int))))
	| HappyAbsSyn21 ((Maybe (Int, Int), Expr (Maybe (Int, Int))))
	| HappyAbsSyn22 ((Maybe (Int, Int), FuncArg (Maybe (Int, Int))))
	| HappyAbsSyn23 ((Maybe (Int, Int), [FuncArg (Maybe (Int, Int))]))
	| HappyAbsSyn30 ((Maybe (Int, Int), [Expr (Maybe (Int, Int))]))
	| HappyAbsSyn31 ((Maybe (Int, Int), AddOp (Maybe (Int, Int))))
	| HappyAbsSyn32 ((Maybe (Int, Int), MulOp (Maybe (Int, Int))))
	| HappyAbsSyn33 ((Maybe (Int, Int), RelOp (Maybe (Int, Int))))

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124,
 action_125,
 action_126,
 action_127,
 action_128,
 action_129,
 action_130,
 action_131,
 action_132,
 action_133,
 action_134,
 action_135,
 action_136,
 action_137,
 action_138,
 action_139,
 action_140,
 action_141,
 action_142,
 action_143,
 action_144,
 action_145,
 action_146,
 action_147,
 action_148,
 action_149,
 action_150,
 action_151,
 action_152,
 action_153 :: () => Int -> ({-HappyReduction (Err) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71,
 happyReduce_72,
 happyReduce_73,
 happyReduce_74,
 happyReduce_75,
 happyReduce_76,
 happyReduce_77,
 happyReduce_78,
 happyReduce_79,
 happyReduce_80,
 happyReduce_81,
 happyReduce_82,
 happyReduce_83,
 happyReduce_84,
 happyReduce_85,
 happyReduce_86,
 happyReduce_87,
 happyReduce_88 :: () => ({-HappyReduction (Err) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,554) ([0,0,0,0,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,33824,56582,3711,0,0,8200,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32768,0,0,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,33792,8,0,0,0,2560,0,0,0,18432,7552,0,0,0,0,0,32,0,0,256,0,0,0,1024,16640,3592,0,16384,264,4226,28,0,4096,1024,14369,0,0,0,0,0,0,16384,20480,8528,0,0,4228,43168,449,0,0,0,0,0,0,0,1,0,0,0,512,0,0,0,0,0,0,0,32768,528,8452,56,0,0,0,0,0,0,2114,33808,224,0,0,0,0,0,0,0,0,0,0,0,512,0,0,0,33824,16640,3592,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16896,53352,63485,0,0,128,0,0,0,0,16384,0,0,0,0,0,32,0,8192,132,2113,14,0,0,2560,42,0,0,2048,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,0,0,128,0,0,0,32,0,0,0,0,512,0,0,0,0,2,0,0,0,256,0,0,0,512,0,0,0,0,0,8192,0,0,128,41120,66,0,0,0,321,0,0,0,128,0,0,0,72,0,0,0,0,512,0,0,0,0,0,0,0,8448,2052,28738,0,0,2114,33808,224,0,0,0,0,0,0,8456,4160,898,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16896,4104,57476,0,0,0,0,0,0,0,0,0,0,0,16912,8320,1796,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8448,2052,28738,0,0,64,1,0,0,0,8,0,0,0,32768,0,0,0,36864,32834,1056,7,0,33824,16640,3592,0,0,1024,0,0,0,0,1,0,0,0,64,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,0,256,0,0,0,5381,0,0,2112,33281,7184,0,0,0,8,0,0,0,0,0,0,0,4360,0,0,0,0,0,0,0,0,10240,0,0,0,0,0,0,0,0,33824,16640,3592,0,0,0,0,0,0,4224,1026,14369,0,0,64,0,0,0,0,0,0,0,0,128,41120,66,0,0,1024,0,0,0,16912,8320,1796,0,0,0,0,0,0,2112,33281,7184,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,8,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5120,84,0,0,0,0,2,0,0,0,0,0,0,0,64,0,0,2048,16417,33296,3,0,0,0,0,0,0,0,0,0,0,4096,0,0,0,0,0,8,0,0,0,128,0,0,0,0,0,0,0,0,8,0,0,0,512,0,0,0,0,0,0,1,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20992,4104,57476,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,0,0,0,2560,42,0,32768,528,8452,56,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pProgram_internal","Ident","Integer","String","Program","Stmt","Item","ListItem","DeclArg","ListDeclArg","Block","ListStmt","ListTupleIdent","TupleIdent","Type","ListType","SimpleType","CompositeType","Expr6","FuncArg","ListFuncArg","Expr5","Expr4","Expr3","Expr2","Expr1","Expr","ListExpr","AddOp","MulOp","RelOp","'!'","'!='","'%'","'&'","'&&'","'('","')'","'*'","'+'","','","'-'","'/'","';'","'<'","'<='","'='","'=='","'>'","'>='","'['","']'","'bool'","'break'","'continue'","'else'","'false'","'if'","'int'","'return'","'string'","'true'","'tuple'","'while'","'{'","'||'","'}'","L_ident","L_integ","L_quoted","%eof"]
        bit_start = st * 73
        bit_end = (st + 1) * 73
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..72]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (7) = happyGoto action_3
action_0 (14) = happyGoto action_4
action_0 _ = happyReduce_28

action_1 (70) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (73) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (34) = happyShift action_20
action_4 (39) = happyShift action_21
action_4 (44) = happyShift action_22
action_4 (46) = happyShift action_23
action_4 (47) = happyShift action_24
action_4 (53) = happyShift action_25
action_4 (55) = happyShift action_26
action_4 (56) = happyShift action_27
action_4 (57) = happyShift action_28
action_4 (59) = happyShift action_29
action_4 (60) = happyShift action_30
action_4 (61) = happyShift action_31
action_4 (62) = happyShift action_32
action_4 (63) = happyShift action_33
action_4 (64) = happyShift action_34
action_4 (65) = happyShift action_35
action_4 (66) = happyShift action_36
action_4 (67) = happyShift action_37
action_4 (70) = happyShift action_2
action_4 (71) = happyShift action_38
action_4 (72) = happyShift action_39
action_4 (4) = happyGoto action_5
action_4 (5) = happyGoto action_6
action_4 (6) = happyGoto action_7
action_4 (8) = happyGoto action_8
action_4 (13) = happyGoto action_9
action_4 (17) = happyGoto action_10
action_4 (19) = happyGoto action_11
action_4 (20) = happyGoto action_12
action_4 (21) = happyGoto action_13
action_4 (24) = happyGoto action_14
action_4 (25) = happyGoto action_15
action_4 (26) = happyGoto action_16
action_4 (27) = happyGoto action_17
action_4 (28) = happyGoto action_18
action_4 (29) = happyGoto action_19
action_4 _ = happyReduce_4

action_5 (39) = happyShift action_83
action_5 (49) = happyShift action_84
action_5 _ = happyReduce_47

action_6 _ = happyReduce_48

action_7 _ = happyReduce_52

action_8 _ = happyReduce_29

action_9 _ = happyReduce_8

action_10 (70) = happyShift action_2
action_10 (4) = happyGoto action_80
action_10 (9) = happyGoto action_81
action_10 (10) = happyGoto action_82
action_10 _ = happyFail (happyExpListPerState 10)

action_11 _ = happyReduce_37

action_12 _ = happyReduce_38

action_13 (53) = happyShift action_79
action_13 _ = happyReduce_64

action_14 _ = happyReduce_66

action_15 (36) = happyShift action_76
action_15 (41) = happyShift action_77
action_15 (45) = happyShift action_78
action_15 (32) = happyGoto action_75
action_15 _ = happyReduce_68

action_16 (42) = happyShift action_73
action_16 (44) = happyShift action_74
action_16 (31) = happyGoto action_72
action_16 _ = happyReduce_70

action_17 (35) = happyShift action_65
action_17 (38) = happyShift action_66
action_17 (47) = happyShift action_67
action_17 (48) = happyShift action_68
action_17 (50) = happyShift action_69
action_17 (51) = happyShift action_70
action_17 (52) = happyShift action_71
action_17 (33) = happyGoto action_64
action_17 _ = happyReduce_72

action_18 (68) = happyShift action_63
action_18 _ = happyReduce_74

action_19 (46) = happyShift action_62
action_19 _ = happyFail (happyExpListPerState 19)

action_20 (39) = happyShift action_21
action_20 (53) = happyShift action_44
action_20 (59) = happyShift action_29
action_20 (64) = happyShift action_34
action_20 (70) = happyShift action_2
action_20 (71) = happyShift action_38
action_20 (72) = happyShift action_39
action_20 (4) = happyGoto action_41
action_20 (5) = happyGoto action_6
action_20 (6) = happyGoto action_7
action_20 (21) = happyGoto action_61
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (34) = happyShift action_20
action_21 (39) = happyShift action_21
action_21 (44) = happyShift action_22
action_21 (53) = happyShift action_44
action_21 (59) = happyShift action_29
action_21 (64) = happyShift action_34
action_21 (70) = happyShift action_2
action_21 (71) = happyShift action_38
action_21 (72) = happyShift action_39
action_21 (4) = happyGoto action_41
action_21 (5) = happyGoto action_6
action_21 (6) = happyGoto action_7
action_21 (21) = happyGoto action_42
action_21 (24) = happyGoto action_14
action_21 (25) = happyGoto action_15
action_21 (26) = happyGoto action_16
action_21 (27) = happyGoto action_17
action_21 (28) = happyGoto action_18
action_21 (29) = happyGoto action_60
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (39) = happyShift action_21
action_22 (53) = happyShift action_44
action_22 (59) = happyShift action_29
action_22 (64) = happyShift action_34
action_22 (70) = happyShift action_2
action_22 (71) = happyShift action_38
action_22 (72) = happyShift action_39
action_22 (4) = happyGoto action_41
action_22 (5) = happyGoto action_6
action_22 (6) = happyGoto action_7
action_22 (21) = happyGoto action_59
action_22 _ = happyFail (happyExpListPerState 22)

action_23 _ = happyReduce_7

action_24 (39) = happyShift action_57
action_24 (53) = happyShift action_58
action_24 (55) = happyShift action_26
action_24 (61) = happyShift action_31
action_24 (63) = happyShift action_33
action_24 (65) = happyShift action_35
action_24 (70) = happyShift action_2
action_24 (4) = happyGoto action_53
action_24 (15) = happyGoto action_54
action_24 (16) = happyGoto action_55
action_24 (17) = happyGoto action_56
action_24 (19) = happyGoto action_11
action_24 (20) = happyGoto action_12
action_24 _ = happyReduce_30

action_25 (34) = happyShift action_20
action_25 (39) = happyShift action_21
action_25 (44) = happyShift action_22
action_25 (53) = happyShift action_44
action_25 (55) = happyShift action_26
action_25 (59) = happyShift action_29
action_25 (61) = happyShift action_31
action_25 (63) = happyShift action_33
action_25 (64) = happyShift action_34
action_25 (70) = happyShift action_2
action_25 (71) = happyShift action_38
action_25 (72) = happyShift action_39
action_25 (4) = happyGoto action_41
action_25 (5) = happyGoto action_6
action_25 (6) = happyGoto action_7
action_25 (19) = happyGoto action_50
action_25 (21) = happyGoto action_42
action_25 (24) = happyGoto action_14
action_25 (25) = happyGoto action_15
action_25 (26) = happyGoto action_16
action_25 (27) = happyGoto action_17
action_25 (28) = happyGoto action_18
action_25 (29) = happyGoto action_51
action_25 (30) = happyGoto action_52
action_25 _ = happyReduce_75

action_26 _ = happyReduce_44

action_27 (46) = happyShift action_49
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (46) = happyShift action_48
action_28 _ = happyFail (happyExpListPerState 28)

action_29 _ = happyReduce_50

action_30 (34) = happyShift action_20
action_30 (39) = happyShift action_21
action_30 (44) = happyShift action_22
action_30 (53) = happyShift action_44
action_30 (59) = happyShift action_29
action_30 (64) = happyShift action_34
action_30 (70) = happyShift action_2
action_30 (71) = happyShift action_38
action_30 (72) = happyShift action_39
action_30 (4) = happyGoto action_41
action_30 (5) = happyGoto action_6
action_30 (6) = happyGoto action_7
action_30 (21) = happyGoto action_42
action_30 (24) = happyGoto action_14
action_30 (25) = happyGoto action_15
action_30 (26) = happyGoto action_16
action_30 (27) = happyGoto action_17
action_30 (28) = happyGoto action_18
action_30 (29) = happyGoto action_47
action_30 _ = happyFail (happyExpListPerState 30)

action_31 _ = happyReduce_42

action_32 (34) = happyShift action_20
action_32 (39) = happyShift action_21
action_32 (44) = happyShift action_22
action_32 (53) = happyShift action_44
action_32 (59) = happyShift action_29
action_32 (64) = happyShift action_34
action_32 (70) = happyShift action_2
action_32 (71) = happyShift action_38
action_32 (72) = happyShift action_39
action_32 (4) = happyGoto action_41
action_32 (5) = happyGoto action_6
action_32 (6) = happyGoto action_7
action_32 (21) = happyGoto action_42
action_32 (24) = happyGoto action_14
action_32 (25) = happyGoto action_15
action_32 (26) = happyGoto action_16
action_32 (27) = happyGoto action_17
action_32 (28) = happyGoto action_18
action_32 (29) = happyGoto action_46
action_32 _ = happyFail (happyExpListPerState 32)

action_33 _ = happyReduce_43

action_34 _ = happyReduce_49

action_35 (47) = happyShift action_45
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (34) = happyShift action_20
action_36 (39) = happyShift action_21
action_36 (44) = happyShift action_22
action_36 (53) = happyShift action_44
action_36 (59) = happyShift action_29
action_36 (64) = happyShift action_34
action_36 (70) = happyShift action_2
action_36 (71) = happyShift action_38
action_36 (72) = happyShift action_39
action_36 (4) = happyGoto action_41
action_36 (5) = happyGoto action_6
action_36 (6) = happyGoto action_7
action_36 (21) = happyGoto action_42
action_36 (24) = happyGoto action_14
action_36 (25) = happyGoto action_15
action_36 (26) = happyGoto action_16
action_36 (27) = happyGoto action_17
action_36 (28) = happyGoto action_18
action_36 (29) = happyGoto action_43
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (14) = happyGoto action_40
action_37 _ = happyReduce_28

action_38 _ = happyReduce_2

action_39 _ = happyReduce_3

action_40 (34) = happyShift action_20
action_40 (39) = happyShift action_21
action_40 (44) = happyShift action_22
action_40 (46) = happyShift action_23
action_40 (47) = happyShift action_24
action_40 (53) = happyShift action_25
action_40 (55) = happyShift action_26
action_40 (56) = happyShift action_27
action_40 (57) = happyShift action_28
action_40 (59) = happyShift action_29
action_40 (60) = happyShift action_30
action_40 (61) = happyShift action_31
action_40 (62) = happyShift action_32
action_40 (63) = happyShift action_33
action_40 (64) = happyShift action_34
action_40 (65) = happyShift action_35
action_40 (66) = happyShift action_36
action_40 (67) = happyShift action_37
action_40 (69) = happyShift action_116
action_40 (70) = happyShift action_2
action_40 (71) = happyShift action_38
action_40 (72) = happyShift action_39
action_40 (4) = happyGoto action_5
action_40 (5) = happyGoto action_6
action_40 (6) = happyGoto action_7
action_40 (8) = happyGoto action_8
action_40 (13) = happyGoto action_9
action_40 (17) = happyGoto action_10
action_40 (19) = happyGoto action_11
action_40 (20) = happyGoto action_12
action_40 (21) = happyGoto action_13
action_40 (24) = happyGoto action_14
action_40 (25) = happyGoto action_15
action_40 (26) = happyGoto action_16
action_40 (27) = happyGoto action_17
action_40 (28) = happyGoto action_18
action_40 (29) = happyGoto action_19
action_40 _ = happyFail (happyExpListPerState 40)

action_41 (39) = happyShift action_83
action_41 _ = happyReduce_47

action_42 (53) = happyShift action_100
action_42 _ = happyReduce_64

action_43 (67) = happyShift action_37
action_43 (13) = happyGoto action_115
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (34) = happyShift action_20
action_44 (39) = happyShift action_21
action_44 (44) = happyShift action_22
action_44 (53) = happyShift action_44
action_44 (59) = happyShift action_29
action_44 (64) = happyShift action_34
action_44 (70) = happyShift action_2
action_44 (71) = happyShift action_38
action_44 (72) = happyShift action_39
action_44 (4) = happyGoto action_41
action_44 (5) = happyGoto action_6
action_44 (6) = happyGoto action_7
action_44 (21) = happyGoto action_42
action_44 (24) = happyGoto action_14
action_44 (25) = happyGoto action_15
action_44 (26) = happyGoto action_16
action_44 (27) = happyGoto action_17
action_44 (28) = happyGoto action_18
action_44 (29) = happyGoto action_51
action_44 (30) = happyGoto action_52
action_44 _ = happyReduce_75

action_45 (53) = happyShift action_58
action_45 (55) = happyShift action_26
action_45 (61) = happyShift action_31
action_45 (63) = happyShift action_33
action_45 (65) = happyShift action_35
action_45 (17) = happyGoto action_113
action_45 (18) = happyGoto action_114
action_45 (19) = happyGoto action_11
action_45 (20) = happyGoto action_12
action_45 _ = happyReduce_39

action_46 (46) = happyShift action_112
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (67) = happyShift action_37
action_47 (13) = happyGoto action_111
action_47 _ = happyFail (happyExpListPerState 47)

action_48 _ = happyReduce_17

action_49 _ = happyReduce_16

action_50 (54) = happyShift action_110
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (43) = happyShift action_109
action_51 _ = happyReduce_76

action_52 (54) = happyShift action_108
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (53) = happyShift action_107
action_53 _ = happyReduce_33

action_54 (51) = happyShift action_106
action_54 _ = happyFail (happyExpListPerState 54)

action_55 (43) = happyShift action_105
action_55 _ = happyReduce_31

action_56 (70) = happyShift action_2
action_56 (4) = happyGoto action_104
action_56 _ = happyFail (happyExpListPerState 56)

action_57 (39) = happyShift action_57
action_57 (53) = happyShift action_58
action_57 (55) = happyShift action_26
action_57 (61) = happyShift action_31
action_57 (63) = happyShift action_33
action_57 (65) = happyShift action_35
action_57 (70) = happyShift action_2
action_57 (4) = happyGoto action_53
action_57 (15) = happyGoto action_103
action_57 (16) = happyGoto action_55
action_57 (17) = happyGoto action_56
action_57 (19) = happyGoto action_11
action_57 (20) = happyGoto action_12
action_57 _ = happyReduce_30

action_58 (55) = happyShift action_26
action_58 (61) = happyShift action_31
action_58 (63) = happyShift action_33
action_58 (19) = happyGoto action_50
action_58 _ = happyFail (happyExpListPerState 58)

action_59 (53) = happyShift action_100
action_59 _ = happyReduce_62

action_60 (40) = happyShift action_101
action_60 (43) = happyShift action_102
action_60 _ = happyFail (happyExpListPerState 60)

action_61 (53) = happyShift action_100
action_61 _ = happyReduce_63

action_62 _ = happyReduce_18

action_63 (34) = happyShift action_20
action_63 (39) = happyShift action_21
action_63 (44) = happyShift action_22
action_63 (53) = happyShift action_44
action_63 (59) = happyShift action_29
action_63 (64) = happyShift action_34
action_63 (70) = happyShift action_2
action_63 (71) = happyShift action_38
action_63 (72) = happyShift action_39
action_63 (4) = happyGoto action_41
action_63 (5) = happyGoto action_6
action_63 (6) = happyGoto action_7
action_63 (21) = happyGoto action_42
action_63 (24) = happyGoto action_14
action_63 (25) = happyGoto action_15
action_63 (26) = happyGoto action_16
action_63 (27) = happyGoto action_17
action_63 (28) = happyGoto action_18
action_63 (29) = happyGoto action_99
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (34) = happyShift action_20
action_64 (39) = happyShift action_21
action_64 (44) = happyShift action_22
action_64 (53) = happyShift action_44
action_64 (59) = happyShift action_29
action_64 (64) = happyShift action_34
action_64 (70) = happyShift action_2
action_64 (71) = happyShift action_38
action_64 (72) = happyShift action_39
action_64 (4) = happyGoto action_41
action_64 (5) = happyGoto action_6
action_64 (6) = happyGoto action_7
action_64 (21) = happyGoto action_42
action_64 (24) = happyGoto action_14
action_64 (25) = happyGoto action_15
action_64 (26) = happyGoto action_98
action_64 _ = happyFail (happyExpListPerState 64)

action_65 _ = happyReduce_88

action_66 (34) = happyShift action_20
action_66 (39) = happyShift action_21
action_66 (44) = happyShift action_22
action_66 (53) = happyShift action_44
action_66 (59) = happyShift action_29
action_66 (64) = happyShift action_34
action_66 (70) = happyShift action_2
action_66 (71) = happyShift action_38
action_66 (72) = happyShift action_39
action_66 (4) = happyGoto action_41
action_66 (5) = happyGoto action_6
action_66 (6) = happyGoto action_7
action_66 (21) = happyGoto action_42
action_66 (24) = happyGoto action_14
action_66 (25) = happyGoto action_15
action_66 (26) = happyGoto action_16
action_66 (27) = happyGoto action_17
action_66 (28) = happyGoto action_97
action_66 _ = happyFail (happyExpListPerState 66)

action_67 _ = happyReduce_83

action_68 _ = happyReduce_84

action_69 _ = happyReduce_87

action_70 _ = happyReduce_85

action_71 _ = happyReduce_86

action_72 (34) = happyShift action_20
action_72 (39) = happyShift action_21
action_72 (44) = happyShift action_22
action_72 (53) = happyShift action_44
action_72 (59) = happyShift action_29
action_72 (64) = happyShift action_34
action_72 (70) = happyShift action_2
action_72 (71) = happyShift action_38
action_72 (72) = happyShift action_39
action_72 (4) = happyGoto action_41
action_72 (5) = happyGoto action_6
action_72 (6) = happyGoto action_7
action_72 (21) = happyGoto action_42
action_72 (24) = happyGoto action_14
action_72 (25) = happyGoto action_96
action_72 _ = happyFail (happyExpListPerState 72)

action_73 _ = happyReduce_78

action_74 _ = happyReduce_79

action_75 (34) = happyShift action_20
action_75 (39) = happyShift action_21
action_75 (44) = happyShift action_22
action_75 (53) = happyShift action_44
action_75 (59) = happyShift action_29
action_75 (64) = happyShift action_34
action_75 (70) = happyShift action_2
action_75 (71) = happyShift action_38
action_75 (72) = happyShift action_39
action_75 (4) = happyGoto action_41
action_75 (5) = happyGoto action_6
action_75 (6) = happyGoto action_7
action_75 (21) = happyGoto action_42
action_75 (24) = happyGoto action_95
action_75 _ = happyFail (happyExpListPerState 75)

action_76 _ = happyReduce_82

action_77 _ = happyReduce_80

action_78 _ = happyReduce_81

action_79 (34) = happyShift action_20
action_79 (39) = happyShift action_21
action_79 (44) = happyShift action_22
action_79 (53) = happyShift action_44
action_79 (59) = happyShift action_29
action_79 (64) = happyShift action_34
action_79 (70) = happyShift action_2
action_79 (71) = happyShift action_38
action_79 (72) = happyShift action_39
action_79 (4) = happyGoto action_41
action_79 (5) = happyGoto action_6
action_79 (6) = happyGoto action_7
action_79 (21) = happyGoto action_42
action_79 (24) = happyGoto action_14
action_79 (25) = happyGoto action_15
action_79 (26) = happyGoto action_16
action_79 (27) = happyGoto action_17
action_79 (28) = happyGoto action_18
action_79 (29) = happyGoto action_94
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (39) = happyShift action_92
action_80 (49) = happyShift action_93
action_80 _ = happyReduce_19

action_81 (43) = happyShift action_91
action_81 _ = happyReduce_21

action_82 (46) = happyShift action_90
action_82 _ = happyFail (happyExpListPerState 82)

action_83 (34) = happyShift action_20
action_83 (37) = happyShift action_89
action_83 (39) = happyShift action_21
action_83 (44) = happyShift action_22
action_83 (53) = happyShift action_44
action_83 (59) = happyShift action_29
action_83 (64) = happyShift action_34
action_83 (70) = happyShift action_2
action_83 (71) = happyShift action_38
action_83 (72) = happyShift action_39
action_83 (4) = happyGoto action_41
action_83 (5) = happyGoto action_6
action_83 (6) = happyGoto action_7
action_83 (21) = happyGoto action_42
action_83 (22) = happyGoto action_86
action_83 (23) = happyGoto action_87
action_83 (24) = happyGoto action_14
action_83 (25) = happyGoto action_15
action_83 (26) = happyGoto action_16
action_83 (27) = happyGoto action_17
action_83 (28) = happyGoto action_18
action_83 (29) = happyGoto action_88
action_83 _ = happyReduce_59

action_84 (34) = happyShift action_20
action_84 (39) = happyShift action_21
action_84 (44) = happyShift action_22
action_84 (53) = happyShift action_44
action_84 (59) = happyShift action_29
action_84 (64) = happyShift action_34
action_84 (70) = happyShift action_2
action_84 (71) = happyShift action_38
action_84 (72) = happyShift action_39
action_84 (4) = happyGoto action_41
action_84 (5) = happyGoto action_6
action_84 (6) = happyGoto action_7
action_84 (21) = happyGoto action_42
action_84 (24) = happyGoto action_14
action_84 (25) = happyGoto action_15
action_84 (26) = happyGoto action_16
action_84 (27) = happyGoto action_17
action_84 (28) = happyGoto action_18
action_84 (29) = happyGoto action_85
action_84 _ = happyFail (happyExpListPerState 84)

action_85 (46) = happyShift action_137
action_85 _ = happyFail (happyExpListPerState 85)

action_86 (43) = happyShift action_136
action_86 _ = happyReduce_60

action_87 (40) = happyShift action_135
action_87 _ = happyFail (happyExpListPerState 87)

action_88 _ = happyReduce_57

action_89 (70) = happyShift action_2
action_89 (4) = happyGoto action_134
action_89 _ = happyFail (happyExpListPerState 89)

action_90 _ = happyReduce_5

action_91 (70) = happyShift action_2
action_91 (4) = happyGoto action_132
action_91 (9) = happyGoto action_81
action_91 (10) = happyGoto action_133
action_91 _ = happyFail (happyExpListPerState 91)

action_92 (53) = happyShift action_58
action_92 (55) = happyShift action_26
action_92 (61) = happyShift action_31
action_92 (63) = happyShift action_33
action_92 (65) = happyShift action_35
action_92 (11) = happyGoto action_129
action_92 (12) = happyGoto action_130
action_92 (17) = happyGoto action_131
action_92 (19) = happyGoto action_11
action_92 (20) = happyGoto action_12
action_92 _ = happyReduce_24

action_93 (34) = happyShift action_20
action_93 (39) = happyShift action_21
action_93 (44) = happyShift action_22
action_93 (53) = happyShift action_44
action_93 (59) = happyShift action_29
action_93 (64) = happyShift action_34
action_93 (70) = happyShift action_2
action_93 (71) = happyShift action_38
action_93 (72) = happyShift action_39
action_93 (4) = happyGoto action_41
action_93 (5) = happyGoto action_6
action_93 (6) = happyGoto action_7
action_93 (21) = happyGoto action_42
action_93 (24) = happyGoto action_14
action_93 (25) = happyGoto action_15
action_93 (26) = happyGoto action_16
action_93 (27) = happyGoto action_17
action_93 (28) = happyGoto action_18
action_93 (29) = happyGoto action_128
action_93 _ = happyFail (happyExpListPerState 93)

action_94 (54) = happyShift action_127
action_94 _ = happyFail (happyExpListPerState 94)

action_95 _ = happyReduce_65

action_96 (36) = happyShift action_76
action_96 (41) = happyShift action_77
action_96 (45) = happyShift action_78
action_96 (32) = happyGoto action_75
action_96 _ = happyReduce_67

action_97 _ = happyReduce_71

action_98 (42) = happyShift action_73
action_98 (44) = happyShift action_74
action_98 (31) = happyGoto action_72
action_98 _ = happyReduce_69

action_99 _ = happyReduce_73

action_100 (34) = happyShift action_20
action_100 (39) = happyShift action_21
action_100 (44) = happyShift action_22
action_100 (53) = happyShift action_44
action_100 (59) = happyShift action_29
action_100 (64) = happyShift action_34
action_100 (70) = happyShift action_2
action_100 (71) = happyShift action_38
action_100 (72) = happyShift action_39
action_100 (4) = happyGoto action_41
action_100 (5) = happyGoto action_6
action_100 (6) = happyGoto action_7
action_100 (21) = happyGoto action_42
action_100 (24) = happyGoto action_14
action_100 (25) = happyGoto action_15
action_100 (26) = happyGoto action_16
action_100 (27) = happyGoto action_17
action_100 (28) = happyGoto action_18
action_100 (29) = happyGoto action_126
action_100 _ = happyFail (happyExpListPerState 100)

action_101 _ = happyReduce_56

action_102 (34) = happyShift action_20
action_102 (39) = happyShift action_21
action_102 (44) = happyShift action_22
action_102 (53) = happyShift action_44
action_102 (59) = happyShift action_29
action_102 (64) = happyShift action_34
action_102 (70) = happyShift action_2
action_102 (71) = happyShift action_38
action_102 (72) = happyShift action_39
action_102 (4) = happyGoto action_41
action_102 (5) = happyGoto action_6
action_102 (6) = happyGoto action_7
action_102 (21) = happyGoto action_42
action_102 (24) = happyGoto action_14
action_102 (25) = happyGoto action_15
action_102 (26) = happyGoto action_16
action_102 (27) = happyGoto action_17
action_102 (28) = happyGoto action_18
action_102 (29) = happyGoto action_51
action_102 (30) = happyGoto action_125
action_102 _ = happyReduce_75

action_103 (40) = happyShift action_124
action_103 _ = happyFail (happyExpListPerState 103)

action_104 _ = happyReduce_34

action_105 (39) = happyShift action_57
action_105 (53) = happyShift action_58
action_105 (55) = happyShift action_26
action_105 (61) = happyShift action_31
action_105 (63) = happyShift action_33
action_105 (65) = happyShift action_35
action_105 (70) = happyShift action_2
action_105 (4) = happyGoto action_53
action_105 (15) = happyGoto action_123
action_105 (16) = happyGoto action_55
action_105 (17) = happyGoto action_56
action_105 (19) = happyGoto action_11
action_105 (20) = happyGoto action_12
action_105 _ = happyReduce_30

action_106 (49) = happyShift action_122
action_106 _ = happyFail (happyExpListPerState 106)

action_107 (34) = happyShift action_20
action_107 (39) = happyShift action_21
action_107 (44) = happyShift action_22
action_107 (53) = happyShift action_44
action_107 (59) = happyShift action_29
action_107 (64) = happyShift action_34
action_107 (70) = happyShift action_2
action_107 (71) = happyShift action_38
action_107 (72) = happyShift action_39
action_107 (4) = happyGoto action_41
action_107 (5) = happyGoto action_6
action_107 (6) = happyGoto action_7
action_107 (21) = happyGoto action_42
action_107 (24) = happyGoto action_14
action_107 (25) = happyGoto action_15
action_107 (26) = happyGoto action_16
action_107 (27) = happyGoto action_17
action_107 (28) = happyGoto action_18
action_107 (29) = happyGoto action_121
action_107 _ = happyFail (happyExpListPerState 107)

action_108 _ = happyReduce_53

action_109 (34) = happyShift action_20
action_109 (39) = happyShift action_21
action_109 (44) = happyShift action_22
action_109 (53) = happyShift action_44
action_109 (59) = happyShift action_29
action_109 (64) = happyShift action_34
action_109 (70) = happyShift action_2
action_109 (71) = happyShift action_38
action_109 (72) = happyShift action_39
action_109 (4) = happyGoto action_41
action_109 (5) = happyGoto action_6
action_109 (6) = happyGoto action_7
action_109 (21) = happyGoto action_42
action_109 (24) = happyGoto action_14
action_109 (25) = happyGoto action_15
action_109 (26) = happyGoto action_16
action_109 (27) = happyGoto action_17
action_109 (28) = happyGoto action_18
action_109 (29) = happyGoto action_51
action_109 (30) = happyGoto action_120
action_109 _ = happyReduce_75

action_110 _ = happyReduce_45

action_111 (58) = happyShift action_119
action_111 _ = happyReduce_13

action_112 _ = happyReduce_12

action_113 (43) = happyShift action_118
action_113 _ = happyReduce_40

action_114 (51) = happyShift action_117
action_114 _ = happyFail (happyExpListPerState 114)

action_115 _ = happyReduce_15

action_116 _ = happyReduce_27

action_117 _ = happyReduce_46

action_118 (53) = happyShift action_58
action_118 (55) = happyShift action_26
action_118 (61) = happyShift action_31
action_118 (63) = happyShift action_33
action_118 (65) = happyShift action_35
action_118 (17) = happyGoto action_113
action_118 (18) = happyGoto action_148
action_118 (19) = happyGoto action_11
action_118 (20) = happyGoto action_12
action_118 _ = happyReduce_39

action_119 (67) = happyShift action_37
action_119 (13) = happyGoto action_147
action_119 _ = happyFail (happyExpListPerState 119)

action_120 _ = happyReduce_77

action_121 (54) = happyShift action_146
action_121 _ = happyFail (happyExpListPerState 121)

action_122 (34) = happyShift action_20
action_122 (39) = happyShift action_21
action_122 (44) = happyShift action_22
action_122 (53) = happyShift action_44
action_122 (59) = happyShift action_29
action_122 (64) = happyShift action_34
action_122 (70) = happyShift action_2
action_122 (71) = happyShift action_38
action_122 (72) = happyShift action_39
action_122 (4) = happyGoto action_41
action_122 (5) = happyGoto action_6
action_122 (6) = happyGoto action_7
action_122 (21) = happyGoto action_42
action_122 (24) = happyGoto action_14
action_122 (25) = happyGoto action_15
action_122 (26) = happyGoto action_16
action_122 (27) = happyGoto action_17
action_122 (28) = happyGoto action_18
action_122 (29) = happyGoto action_145
action_122 _ = happyFail (happyExpListPerState 122)

action_123 _ = happyReduce_32

action_124 _ = happyReduce_36

action_125 (40) = happyShift action_144
action_125 _ = happyFail (happyExpListPerState 125)

action_126 (54) = happyShift action_143
action_126 _ = happyFail (happyExpListPerState 126)

action_127 (49) = happyShift action_142
action_127 _ = happyReduce_54

action_128 _ = happyReduce_20

action_129 (43) = happyShift action_141
action_129 _ = happyReduce_25

action_130 (40) = happyShift action_140
action_130 _ = happyFail (happyExpListPerState 130)

action_131 (70) = happyShift action_2
action_131 (4) = happyGoto action_139
action_131 _ = happyFail (happyExpListPerState 131)

action_132 (49) = happyShift action_93
action_132 _ = happyReduce_19

action_133 _ = happyReduce_22

action_134 _ = happyReduce_58

action_135 _ = happyReduce_51

action_136 (34) = happyShift action_20
action_136 (37) = happyShift action_89
action_136 (39) = happyShift action_21
action_136 (44) = happyShift action_22
action_136 (53) = happyShift action_44
action_136 (59) = happyShift action_29
action_136 (64) = happyShift action_34
action_136 (70) = happyShift action_2
action_136 (71) = happyShift action_38
action_136 (72) = happyShift action_39
action_136 (4) = happyGoto action_41
action_136 (5) = happyGoto action_6
action_136 (6) = happyGoto action_7
action_136 (21) = happyGoto action_42
action_136 (22) = happyGoto action_86
action_136 (23) = happyGoto action_138
action_136 (24) = happyGoto action_14
action_136 (25) = happyGoto action_15
action_136 (26) = happyGoto action_16
action_136 (27) = happyGoto action_17
action_136 (28) = happyGoto action_18
action_136 (29) = happyGoto action_88
action_136 _ = happyReduce_59

action_137 _ = happyReduce_9

action_138 _ = happyReduce_61

action_139 _ = happyReduce_23

action_140 (67) = happyShift action_37
action_140 (13) = happyGoto action_152
action_140 _ = happyFail (happyExpListPerState 140)

action_141 (53) = happyShift action_58
action_141 (55) = happyShift action_26
action_141 (61) = happyShift action_31
action_141 (63) = happyShift action_33
action_141 (65) = happyShift action_35
action_141 (11) = happyGoto action_129
action_141 (12) = happyGoto action_151
action_141 (17) = happyGoto action_131
action_141 (19) = happyGoto action_11
action_141 (20) = happyGoto action_12
action_141 _ = happyReduce_24

action_142 (34) = happyShift action_20
action_142 (39) = happyShift action_21
action_142 (44) = happyShift action_22
action_142 (53) = happyShift action_44
action_142 (59) = happyShift action_29
action_142 (64) = happyShift action_34
action_142 (70) = happyShift action_2
action_142 (71) = happyShift action_38
action_142 (72) = happyShift action_39
action_142 (4) = happyGoto action_41
action_142 (5) = happyGoto action_6
action_142 (6) = happyGoto action_7
action_142 (21) = happyGoto action_42
action_142 (24) = happyGoto action_14
action_142 (25) = happyGoto action_15
action_142 (26) = happyGoto action_16
action_142 (27) = happyGoto action_17
action_142 (28) = happyGoto action_18
action_142 (29) = happyGoto action_150
action_142 _ = happyFail (happyExpListPerState 142)

action_143 _ = happyReduce_54

action_144 _ = happyReduce_55

action_145 (46) = happyShift action_149
action_145 _ = happyFail (happyExpListPerState 145)

action_146 _ = happyReduce_35

action_147 _ = happyReduce_14

action_148 _ = happyReduce_41

action_149 _ = happyReduce_11

action_150 (46) = happyShift action_153
action_150 _ = happyFail (happyExpListPerState 150)

action_151 _ = happyReduce_26

action_152 _ = happyReduce_6

action_153 _ = happyReduce_10

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn4
		 ((Just (tokenLineCol happy_var_1), Ident (prToken happy_var_1))
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn5
		 ((Just (tokenLineCol happy_var_1), read (prToken happy_var_1))
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_1  6 happyReduction_3
happyReduction_3 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn6
		 ((Just (tokenLineCol happy_var_1), prToken happy_var_1)
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  7 happyReduction_4
happyReduction_4 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn7
		 ((fst happy_var_1, AbsPswift.Program (fst happy_var_1)(reverse (snd happy_var_1)))
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_3  8 happyReduction_5
happyReduction_5 _
	(HappyAbsSyn10  happy_var_2)
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn8
		 ((fst happy_var_1, AbsPswift.DeclVar (fst happy_var_1)(snd happy_var_1)(snd happy_var_2))
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happyReduce 6 8 happyReduction_6
happyReduction_6 ((HappyAbsSyn13  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyAbsSyn17  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((fst happy_var_1, AbsPswift.DeclFunc (fst happy_var_1)(snd happy_var_1)(snd happy_var_2)(snd happy_var_4)(snd happy_var_6))
	) `HappyStk` happyRest

happyReduce_7 = happySpecReduce_1  8 happyReduction_7
happyReduction_7 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn8
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Empty (Just (tokenLineCol happy_var_1)))
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_1  8 happyReduction_8
happyReduction_8 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn8
		 ((fst happy_var_1, AbsPswift.BStmt (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_8 _  = notHappyAtAll 

happyReduce_9 = happyReduce 4 8 happyReduction_9
happyReduction_9 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((fst happy_var_1, AbsPswift.Ass (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_10 = happyReduce 7 8 happyReduction_10
happyReduction_10 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((fst happy_var_1, AbsPswift.ListAss (fst happy_var_1)(snd happy_var_1)(snd happy_var_3)(snd happy_var_6))
	) `HappyStk` happyRest

happyReduce_11 = happyReduce 6 8 happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((Just (tokenLineCol happy_var_1), AbsPswift.TupleAssUnpack (Just (tokenLineCol happy_var_1)) (snd happy_var_2)(snd happy_var_5))
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_3  8 happyReduction_12
happyReduction_12 _
	(HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn8
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Ret (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  8 happyReduction_13
happyReduction_13 (HappyAbsSyn13  happy_var_3)
	(HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn8
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Cond (Just (tokenLineCol happy_var_1)) (snd happy_var_2)(snd happy_var_3))
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happyReduce 5 8 happyReduction_14
happyReduction_14 ((HappyAbsSyn13  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_3) `HappyStk`
	(HappyAbsSyn21  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((Just (tokenLineCol happy_var_1), AbsPswift.CondElse (Just (tokenLineCol happy_var_1)) (snd happy_var_2)(snd happy_var_3)(snd happy_var_5))
	) `HappyStk` happyRest

happyReduce_15 = happySpecReduce_3  8 happyReduction_15
happyReduction_15 (HappyAbsSyn13  happy_var_3)
	(HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn8
		 ((Just (tokenLineCol happy_var_1), AbsPswift.While (Just (tokenLineCol happy_var_1)) (snd happy_var_2)(snd happy_var_3))
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_2  8 happyReduction_16
happyReduction_16 _
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn8
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Break (Just (tokenLineCol happy_var_1)))
	)
happyReduction_16 _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_2  8 happyReduction_17
happyReduction_17 _
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn8
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Continue (Just (tokenLineCol happy_var_1)))
	)
happyReduction_17 _ _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_2  8 happyReduction_18
happyReduction_18 _
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn8
		 ((fst happy_var_1, AbsPswift.SExp (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_18 _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  9 happyReduction_19
happyReduction_19 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn9
		 ((fst happy_var_1, AbsPswift.NoInit (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  9 happyReduction_20
happyReduction_20 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn9
		 ((fst happy_var_1, AbsPswift.Init (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  10 happyReduction_21
happyReduction_21 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  10 happyReduction_22
happyReduction_22 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_3))
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  11 happyReduction_23
happyReduction_23 (HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn11
		 ((fst happy_var_1, AbsPswift.DeclArg (fst happy_var_1)(snd happy_var_1)(snd happy_var_2))
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_0  12 happyReduction_24
happyReduction_24  =  HappyAbsSyn12
		 ((Nothing, [])
	)

happyReduce_25 = happySpecReduce_1  12 happyReduction_25
happyReduction_25 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn12
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  12 happyReduction_26
happyReduction_26 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn12
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_3))
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_3  13 happyReduction_27
happyReduction_27 _
	(HappyAbsSyn14  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn13
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Block (Just (tokenLineCol happy_var_1)) (reverse (snd happy_var_2)))
	)
happyReduction_27 _ _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_0  14 happyReduction_28
happyReduction_28  =  HappyAbsSyn14
		 ((Nothing, [])
	)

happyReduce_29 = happySpecReduce_2  14 happyReduction_29
happyReduction_29 (HappyAbsSyn8  happy_var_2)
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 ((fst happy_var_1, flip (:) (snd happy_var_1)(snd happy_var_2))
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_0  15 happyReduction_30
happyReduction_30  =  HappyAbsSyn15
		 ((Nothing, [])
	)

happyReduce_31 = happySpecReduce_1  15 happyReduction_31
happyReduction_31 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn15
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_3  15 happyReduction_32
happyReduction_32 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn15
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_3))
	)
happyReduction_32 _ _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  16 happyReduction_33
happyReduction_33 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn16
		 ((fst happy_var_1, AbsPswift.TupleAssIdent (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_2  16 happyReduction_34
happyReduction_34 (HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn16
		 ((fst happy_var_1, AbsPswift.TupleAssVarInit (fst happy_var_1)(snd happy_var_1)(snd happy_var_2))
	)
happyReduction_34 _ _  = notHappyAtAll 

happyReduce_35 = happyReduce 4 16 happyReduction_35
happyReduction_35 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 ((fst happy_var_1, AbsPswift.TupleAssListEl (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_36 = happySpecReduce_3  16 happyReduction_36
happyReduction_36 _
	(HappyAbsSyn15  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn16
		 ((Just (tokenLineCol happy_var_1), AbsPswift.TupleAssNested (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  17 happyReduction_37
happyReduction_37 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, AbsPswift.SimpleType (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  17 happyReduction_38
happyReduction_38 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, AbsPswift.CompositeType (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_0  18 happyReduction_39
happyReduction_39  =  HappyAbsSyn18
		 ((Nothing, [])
	)

happyReduce_40 = happySpecReduce_1  18 happyReduction_40
happyReduction_40 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  18 happyReduction_41
happyReduction_41 (HappyAbsSyn18  happy_var_3)
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_3))
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  19 happyReduction_42
happyReduction_42 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn19
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Int (Just (tokenLineCol happy_var_1)))
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  19 happyReduction_43
happyReduction_43 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn19
		 ((Just (tokenLineCol happy_var_1), AbsPswift.String (Just (tokenLineCol happy_var_1)))
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_1  19 happyReduction_44
happyReduction_44 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn19
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Bool (Just (tokenLineCol happy_var_1)))
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  20 happyReduction_45
happyReduction_45 _
	(HappyAbsSyn19  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 ((Just (tokenLineCol happy_var_1), AbsPswift.List (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happyReduce 4 20 happyReduction_46
happyReduction_46 (_ `HappyStk`
	(HappyAbsSyn18  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Tuple (Just (tokenLineCol happy_var_1)) (snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_47 = happySpecReduce_1  21 happyReduction_47
happyReduction_47 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, AbsPswift.EVar (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  21 happyReduction_48
happyReduction_48 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, AbsPswift.ELitInt (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  21 happyReduction_49
happyReduction_49 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 ((Just (tokenLineCol happy_var_1), AbsPswift.ELitTrue (Just (tokenLineCol happy_var_1)))
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  21 happyReduction_50
happyReduction_50 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 ((Just (tokenLineCol happy_var_1), AbsPswift.ELitFalse (Just (tokenLineCol happy_var_1)))
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happyReduce 4 21 happyReduction_51
happyReduction_51 (_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 ((fst happy_var_1, AbsPswift.EApp (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_52 = happySpecReduce_1  21 happyReduction_52
happyReduction_52 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, AbsPswift.EString (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  21 happyReduction_53
happyReduction_53 _
	(HappyAbsSyn30  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 ((Just (tokenLineCol happy_var_1), AbsPswift.EList (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happyReduce 4 21 happyReduction_54
happyReduction_54 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 ((fst happy_var_1, AbsPswift.EGetEl (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_55 = happyReduce 5 21 happyReduction_55
happyReduction_55 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 ((Just (tokenLineCol happy_var_1), AbsPswift.ETuple (Just (tokenLineCol happy_var_1)) (snd happy_var_2)(snd happy_var_4))
	) `HappyStk` happyRest

happyReduce_56 = happySpecReduce_3  21 happyReduction_56
happyReduction_56 _
	(HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 ((Just (tokenLineCol happy_var_1), snd happy_var_2)
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_1  22 happyReduction_57
happyReduction_57 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, AbsPswift.FuncArgVal (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_57 _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_2  22 happyReduction_58
happyReduction_58 (HappyAbsSyn4  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((Just (tokenLineCol happy_var_1), AbsPswift.FuncArgRef (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_58 _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_0  23 happyReduction_59
happyReduction_59  =  HappyAbsSyn23
		 ((Nothing, [])
	)

happyReduce_60 = happySpecReduce_1  23 happyReduction_60
happyReduction_60 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  23 happyReduction_61
happyReduction_61 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_3))
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_2  24 happyReduction_62
happyReduction_62 (HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Neg (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_62 _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_2  24 happyReduction_63
happyReduction_63 (HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Not (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_63 _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  24 happyReduction_64
happyReduction_64 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  25 happyReduction_65
happyReduction_65 (HappyAbsSyn21  happy_var_3)
	(HappyAbsSyn32  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, AbsPswift.EMul (fst happy_var_1)(snd happy_var_1)(snd happy_var_2)(snd happy_var_3))
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_1  25 happyReduction_66
happyReduction_66 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_3  26 happyReduction_67
happyReduction_67 (HappyAbsSyn21  happy_var_3)
	(HappyAbsSyn31  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, AbsPswift.EAdd (fst happy_var_1)(snd happy_var_1)(snd happy_var_2)(snd happy_var_3))
	)
happyReduction_67 _ _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_1  26 happyReduction_68
happyReduction_68 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_68 _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_3  27 happyReduction_69
happyReduction_69 (HappyAbsSyn21  happy_var_3)
	(HappyAbsSyn33  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, AbsPswift.ERel (fst happy_var_1)(snd happy_var_1)(snd happy_var_2)(snd happy_var_3))
	)
happyReduction_69 _ _ _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_1  27 happyReduction_70
happyReduction_70 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_3  28 happyReduction_71
happyReduction_71 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, AbsPswift.EAnd (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	)
happyReduction_71 _ _ _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_1  28 happyReduction_72
happyReduction_72 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_72 _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_3  29 happyReduction_73
happyReduction_73 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, AbsPswift.EOr (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	)
happyReduction_73 _ _ _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_1  29 happyReduction_74
happyReduction_74 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_74 _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_0  30 happyReduction_75
happyReduction_75  =  HappyAbsSyn30
		 ((Nothing, [])
	)

happyReduce_76 = happySpecReduce_1  30 happyReduction_76
happyReduction_76 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn30
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_76 _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_3  30 happyReduction_77
happyReduction_77 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn30
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_3))
	)
happyReduction_77 _ _ _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_1  31 happyReduction_78
happyReduction_78 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn31
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Plus (Just (tokenLineCol happy_var_1)))
	)
happyReduction_78 _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_1  31 happyReduction_79
happyReduction_79 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn31
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Minus (Just (tokenLineCol happy_var_1)))
	)
happyReduction_79 _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_1  32 happyReduction_80
happyReduction_80 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Times (Just (tokenLineCol happy_var_1)))
	)
happyReduction_80 _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_1  32 happyReduction_81
happyReduction_81 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Div (Just (tokenLineCol happy_var_1)))
	)
happyReduction_81 _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_1  32 happyReduction_82
happyReduction_82 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((Just (tokenLineCol happy_var_1), AbsPswift.Mod (Just (tokenLineCol happy_var_1)))
	)
happyReduction_82 _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_1  33 happyReduction_83
happyReduction_83 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), AbsPswift.LTH (Just (tokenLineCol happy_var_1)))
	)
happyReduction_83 _  = notHappyAtAll 

happyReduce_84 = happySpecReduce_1  33 happyReduction_84
happyReduction_84 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), AbsPswift.LE (Just (tokenLineCol happy_var_1)))
	)
happyReduction_84 _  = notHappyAtAll 

happyReduce_85 = happySpecReduce_1  33 happyReduction_85
happyReduction_85 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), AbsPswift.GTH (Just (tokenLineCol happy_var_1)))
	)
happyReduction_85 _  = notHappyAtAll 

happyReduce_86 = happySpecReduce_1  33 happyReduction_86
happyReduction_86 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), AbsPswift.GE (Just (tokenLineCol happy_var_1)))
	)
happyReduction_86 _  = notHappyAtAll 

happyReduce_87 = happySpecReduce_1  33 happyReduction_87
happyReduction_87 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), AbsPswift.EQU (Just (tokenLineCol happy_var_1)))
	)
happyReduction_87 _  = notHappyAtAll 

happyReduce_88 = happySpecReduce_1  33 happyReduction_88
happyReduction_88 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), AbsPswift.NE (Just (tokenLineCol happy_var_1)))
	)
happyReduction_88 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 73 73 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 34;
	PT _ (TS _ 2) -> cont 35;
	PT _ (TS _ 3) -> cont 36;
	PT _ (TS _ 4) -> cont 37;
	PT _ (TS _ 5) -> cont 38;
	PT _ (TS _ 6) -> cont 39;
	PT _ (TS _ 7) -> cont 40;
	PT _ (TS _ 8) -> cont 41;
	PT _ (TS _ 9) -> cont 42;
	PT _ (TS _ 10) -> cont 43;
	PT _ (TS _ 11) -> cont 44;
	PT _ (TS _ 12) -> cont 45;
	PT _ (TS _ 13) -> cont 46;
	PT _ (TS _ 14) -> cont 47;
	PT _ (TS _ 15) -> cont 48;
	PT _ (TS _ 16) -> cont 49;
	PT _ (TS _ 17) -> cont 50;
	PT _ (TS _ 18) -> cont 51;
	PT _ (TS _ 19) -> cont 52;
	PT _ (TS _ 20) -> cont 53;
	PT _ (TS _ 21) -> cont 54;
	PT _ (TS _ 22) -> cont 55;
	PT _ (TS _ 23) -> cont 56;
	PT _ (TS _ 24) -> cont 57;
	PT _ (TS _ 25) -> cont 58;
	PT _ (TS _ 26) -> cont 59;
	PT _ (TS _ 27) -> cont 60;
	PT _ (TS _ 28) -> cont 61;
	PT _ (TS _ 29) -> cont 62;
	PT _ (TS _ 30) -> cont 63;
	PT _ (TS _ 31) -> cont 64;
	PT _ (TS _ 32) -> cont 65;
	PT _ (TS _ 33) -> cont 66;
	PT _ (TS _ 34) -> cont 67;
	PT _ (TS _ 35) -> cont 68;
	PT _ (TS _ 36) -> cont 69;
	PT _ (TV _) -> cont 70;
	PT _ (TI _) -> cont 71;
	PT _ (TL _) -> cont 72;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 73 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

happyThen :: () => Err a -> (a -> Err b) -> Err b
happyThen = (thenM)
happyReturn :: () => a -> Err a
happyReturn = (returnM)
happyThen1 m k tks = (thenM) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Err a
happyReturn1 = \a tks -> (returnM) a
happyError' :: () => ([(Token)], [String]) -> Err a
happyError' = (\(tokens, _) -> happyError tokens)
pProgram_internal tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn7 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    t:_ -> " before `" ++ id(prToken t) ++ "'"

myLexer = tokens

pProgram = (>>= return . snd) . pProgram_internal
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 8 "<command-line>" #-}
# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4














































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/usr/lib/ghc/include/ghcversion.h" #-}

















{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/tmp/ghc8814_0/ghc_2.h" #-}




























































































































































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 









{-# LINE 43 "templates/GenericTemplate.hs" #-}

data Happy_IntList = HappyCons Int Happy_IntList







{-# LINE 65 "templates/GenericTemplate.hs" #-}

{-# LINE 75 "templates/GenericTemplate.hs" #-}

{-# LINE 84 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 137 "templates/GenericTemplate.hs" #-}

{-# LINE 147 "templates/GenericTemplate.hs" #-}
indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x < y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `div` 16)) (bit `mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 267 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 333 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.