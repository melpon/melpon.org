module Handler.Yesodbookjp.Introduction where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler)
import Settings (widgetFile)
import Handler.Yesodbookjp.Layout (withSidebar)

getYIntroductionR :: Handler Y.Html
getYIntroductionR = do
    Y.defaultLayout $ do
        withSidebar (Just "導入") $ do
            $(widgetFile "yesodbookjp/introduction")
