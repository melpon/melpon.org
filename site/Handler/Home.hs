{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler, Widget, Route(AboutmeR))
import Settings (widgetFile)
import Handler.Header(getHeader)

getHomeR :: Handler Y.Html
getHomeR = do
    Y.defaultLayout $ do
        $(widgetFile "homepage")
