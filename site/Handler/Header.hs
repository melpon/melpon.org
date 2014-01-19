module Handler.Header where

import Import
import qualified Yesod                                  as Y
import qualified Data.List                              as List

import Settings (widgetFile)
import Foundation (Widget, App, Route(HomeR, AboutmeR))

type Header = (String, Y.Route App, String)
type Headers = [Header]

headers :: Headers
headers =
  [ ("home", HomeR, "Home")
  , ("aboutme", AboutmeR, "About Me")
  ]

getPageTitle :: String -> Maybe String
getPageTitle name =
    (\(_, _, title) -> title) <$> List.find (\(name', _, _) -> name == name') headers

getHeader :: String -> Widget
getHeader name = do
    let pageTitle = maybe (fail "name not found") id $ getPageTitle name
    Y.setTitle $ Y.toHtml $ pageTitle ++ " - Licensed by Meatware"
    Y.addScriptRemote "//codeorigin.jquery.com/jquery-1.10.2.min.js"
    Y.addScriptRemote "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"
    Y.addStylesheetRemote "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css"
    $(widgetFile "header")
