module Handler.Aboutme where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler, Widget)
import Settings (widgetFile)
import Handler.Header (getHeader)

getAboutmeR :: Handler Y.Html
getAboutmeR = do
    Y.defaultLayout $ do
        $(widgetFile "aboutme")
