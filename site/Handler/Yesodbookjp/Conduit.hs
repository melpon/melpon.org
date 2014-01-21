module Handler.Yesodbookjp.Conduit (
  getYConduitR
) where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler)
import Settings (widgetFile)
import Modules.RawString (rawstring)
import Handler.Yesodbookjp.Layout (withSidebar)

getYConduitR :: Handler Y.Html
getYConduitR = do
    Y.defaultLayout $ do
        withSidebar (Just "コンジット") $ do
            $(widgetFile "yesodbookjp/conduit")


code1 :: String
code1 = [rawstring|
{-# LANGUAGE OverloadedStrings #-}
import Data.Conduit -- コアライブラリ
import qualified Data.Conduit.List as CL -- リストのように使える関数
import qualified Data.Conduit.Binary as CB -- バイトデータ用
import qualified Data.Conduit.Text as CT

import Data.ByteString (ByteString)
import Data.Text (Text)
import qualified Data.Text as T
import Control.Monad.ST (runST)

-- まずは source から sink に connect するところから始めてみよう。
-- コンジットの組み込みのファイル関数をつかって、効果的で、定数メモリで、
-- リソースに優しいファイルコピーを行なう関数を実装する。
--
-- source から sink に connect するために $$ を使っていることと、
-- その後に runResourceT を使うということを覚えておこう。
copyFile :: FilePath -> FilePath -> IO ()
copyFile src dest = runResourceT $ CB.sourceFile src $$ CB.sinkFile dest


-- Data.Conduit.List モジュールは、リストに対する source, sink, conduit を
-- 生成するためのヘルパ関数を提供している。
-- その中の典型的な関数である fold を使い、値を合計してみよう。
sumSink :: Resource m => Sink Int m Int
sumSink = CL.fold (+) 0

-- もっと低レベルで処理したいなら、sinkState 関数をつかって sink を作っても
-- 構わない。この関数は３つのパラメータを取る。
-- 初期状態、push 関数、close 関数である。
sumSink2 :: Resource m => Sink Int m Int
sumSink2 = sinkState
    0 -- 初期値

    -- 新しい入力を使って状態を更新し、
    -- もっと入力が必要だということを明示する。
    (\accum i -> return $ StateProcessing (accum + i))
    (\accum -> return accum) -- 終了時に現在の accum 値を返す

-- 他のヘルパ関数としては sourceList がある。これをどのように組み合わせるかを
-- 見ていこう。ここでは、さっき作った sumSink を使って sum 関数を再実装している。
sum' :: [Int] -> Int
sum' input = runST $ runResourceT $ CL.sourceList input $$ sumSink

-- Haskell と言えばフィボナッチ数である。フィボナッチ数を生成する source を
-- 書いてみよう。これには sourceState を使う。この関数は状態と push 関数を
-- 引数に取る。
-- fibs 関数は、状態として２つの値が必要で、push 関数では次の値を返し、
-- 状態を更新する必要がある。
fibs :: Resource m => Source m Int
fibs = sourceState
    (0, 1) -- initial state
    (\(x, y) -> return $ StateOpen (y, x + y) x)

-- 最初の 10 個のフィボナッチ数の合計を取得したいとする。
-- これは isolate という conduit を使うことで 10 個だけ値を生産し、
-- それを sumSink によって消費して合計する。
sumTenFibs :: Int
sumTenFibs =
       runST -- 副作用のないコードとして実行する
     $ runResourceT
     $ fibs
    $= CL.isolate 10 -- source と conduit を fuse する。
    $$ sumSink

-- あるいは conduit と sink を fuse しても構わない。
sumTenFibs2 :: Int
sumTenFibs2 =
       runST
     $ runResourceT
     $ fibs
    $$ CL.isolate 10
    =$ sumSink

-- 次はいくつか conduit を作ってみよう。まずは数字からテキストに変換する
-- conduit を作る。こういった処理は map 関数が役に立つ。

intToText :: Int -> Text -- ヘルパ関数
intToText = T.pack . show

textify :: Resource m => Conduit Int m Text
textify = CL.map intToText

-- sinkState, sourceState と同様、conduitState というヘルパ関数もある。
-- ただし今回は状態を必要としないため、ダミーの状態を与えている。
textify2 :: Resource m => Conduit Int m Text
textify2 = conduitState
    ()
    (\() input -> return $ StateProducing () [intToText input])
    (\() -> return [])

-- 次は conduit を unline する関数を作ろう。この関数はそれぞれの入力の終端に
-- 改行を付け加える。これにも CL.map が使える。
-- 練習のために conduitState を使って書き換えてもいいだろう。
unlines' :: Resource m => Conduit Text m Text
unlines' = CL.map $ \t -> t `T.append` "\n"

-- 最後に、fibs 関数から出力される最初の N 個のフィボナッチ数をファイルへ
-- 出力する関数を作ってみよう。UTF8 エンコーディングでファイルに出力する。
writeFibs :: Int -> FilePath -> IO ()
writeFibs count dest =
      runResourceT
    $ fibs
   $= CL.isolate count
   $= textify
   $= unlines'
   $= CT.encode CT.utf8
   $$ CB.sinkFile dest

-- 先ほどの関数は $= 演算子を使って conduit と source を fuse し、新しい source
-- を作った。これを逆にすることもできる。つまり conduit と sink を fuse し、
-- 新しい sink を作ることもできる。そしてその２つを両方利用すると、こうなる。
writeFibs2 :: Int -> FilePath -> IO ()
writeFibs2 count dest =
      runResourceT
    $ fibs
   $= CL.isolate count
   $= textify
   $$ unlines'
   =$ CT.encode CT.utf8
   =$ CB.sinkFile dest

-- あるいは全ての conduit を fuse して、新しい conduit を作ることもできる。
someIntLines :: ResourceThrow m -- エンコーディングは例外を投げる可能性がある
             => Int
             -> Conduit Int m ByteString
someIntLines count =
      CL.isolate count
  =$= textify
  =$= unlines'
  =$= CT.encode CT.utf8

-- そして someIntLines という conduit を使うと、こうなる。
writeFibs3 :: Int -> FilePath -> IO ()
writeFibs3 count dest =
      runResourceT
    $ fibs
   $= someIntLines count
   $$ CB.sinkFile dest

main :: IO ()
main = do
    putStrLn $ "First ten fibs: " ++ show sumTenFibs
    writeFibs 20 "fibs.txt"
    copyFile "fibs.txt" "fibs2.txt"
|]
