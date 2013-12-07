module Handler.Header where

import Import
import qualified Yesod                                  as Y

import Settings (widgetFile)
import Foundation (Widget, App, Route(HomeR, AboutmeR))

type Headers = [(String, Y.Route App, String)]

headers :: Headers
headers =
  [ ("home", HomeR, "Home")
  , ("aboutme", AboutmeR, "About Me")
  ]

getHeader :: String -> Widget
getHeader name = do
    Y.setTitle "melpon's Homepage"
    Y.addScriptRemote "//codeorigin.jquery.com/jquery-1.10.2.min.js"
    Y.addScriptRemote "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"
    Y.addStylesheetRemote "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css"
    $(widgetFile "header")
