module Handler.Header
  ( getHeader
  , getSubHeader
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Data.List                              as List

import Settings (widgetFile)
import Foundation (Widget, App, Route(HomeR, AboutmeR, YRootR))

type Header = (String, Y.Route App, String)
type Headers = [Header]

headers :: Headers
headers =
  [ ("home", HomeR, "Home")
  , ("aboutme", AboutmeR, "About Me")
  , ("yesodbookjp", YRootR, "YesodBookJp")
  ]

getPageTitle :: String -> Maybe String
getPageTitle name =
    (\(_, _, title) -> title) <$> List.find (\(name', _, _) -> name == name') headers

loadHeader :: String -> Widget
loadHeader name = do
    Y.addScriptRemote "//codeorigin.jquery.com/jquery-1.10.2.min.js"
    Y.addScriptRemote "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"
    Y.addStylesheetRemote "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css"
    $(widgetFile "header")

getHeader :: String -> Widget
getHeader name = do
    let pageTitle = maybe (fail "name not found") id $ getPageTitle name
    Y.setTitle $ Y.toHtml $ pageTitle ++ " :: Licensed by Meatware"
    loadHeader name

getSubHeader :: String -> String -> Widget
getSubHeader parent title = do
    let parentTitle = maybe (fail "name not found") id $ getPageTitle parent
    Y.setTitle $ Y.toHtml $ concat [title, " - ", parentTitle, " :: Licensed by Meatware"]
    loadHeader parent
