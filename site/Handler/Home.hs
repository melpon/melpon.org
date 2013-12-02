{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler)
import Settings (widgetFile)

getHomeR :: Handler Y.Html
getHomeR = do
    Y.defaultLayout $ do
        Y.setTitle "melpon's Homepage"
        $(widgetFile "homepage")
