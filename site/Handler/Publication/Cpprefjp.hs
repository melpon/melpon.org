module Handler.Publication.Cpprefjp
  ( getPCpprefjpR
  ) where

import Import
import qualified Yesod                                  as Y

import Settings (widgetFile)
import Foundation (Handler, Route(StaticR))
import Settings.StaticFiles
  ( publication_io_2012_slides_js_require_1_0_8_min_js
  )
import Handler.Publication.Slide (defaultLayout, withDefaultIO)

getPCpprefjpR :: Handler Y.Html
getPCpprefjpR = do
    defaultLayout $ do
        withDefaultIO $ do
            Y.setTitle "cpprefjpを支える技術"
            Y.addScriptAttrs
                (StaticR publication_io_2012_slides_js_require_1_0_8_min_js)
                [("data-main", "../static/publication/js/default")]
            $(widgetFile "publication/cpprefjp")
