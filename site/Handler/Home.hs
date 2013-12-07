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
        Y.setTitle "melpon's Homepage"
        Y.addScriptRemote "//codeorigin.jquery.com/jquery-1.10.2.min.js"
        Y.addScriptRemote "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"
        Y.addStylesheetRemote "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css"
        $(widgetFile "homepage")
