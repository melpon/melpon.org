module Modules.RawString (
  rawstring
) where

import Import
import Language.Haskell.TH
import Language.Haskell.TH.Quote

convert :: String -> String
convert = map conv
  where
    conv '｜' = '|'
    conv '］' = ']'
    conv '＃' = '#'
    conv c = c

rawstring :: QuasiQuoter
rawstring = QuasiQuoter { quoteExp = litE . StringL . convert }

