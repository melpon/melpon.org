module Handler.Yesodbookjp.Root where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler)
import Settings (widgetFile)
import Handler.Yesodbookjp.Layout (withSidebar)

-- This is a handler function for the GET request method on the RootR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getYRootR :: Handler Y.Html
getYRootR = do
    Y.defaultLayout $ do
        withSidebar Nothing $ do
            $(widgetFile "yesodbookjp/homepage")
