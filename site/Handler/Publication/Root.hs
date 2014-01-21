module Handler.Publication.Root
  ( getPRootR
  ) where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler, Route(..))
import Settings (widgetFile)
import Handler.Header (getHeader)

getPRootR :: Handler Y.Html
getPRootR = do
    Y.defaultLayout $ do
        $(widgetFile "publication/homepage")
