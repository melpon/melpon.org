module Handler.Publication.Cocos2dx3Lt
  ( getPCocos2dx3LtR
  ) where

import Import
import qualified Yesod                                  as Y

import Settings (widgetFile)
import Foundation (Handler, Route(StaticR))
import Settings.StaticFiles
  ( publication_io_2012_slides_js_require_1_0_8_min_js
  , publication_img_pad_png
  )
import Handler.Publication.Slide (defaultLayout, withDefaultIO, toTakahashi, toTakahashiI)

getPCocos2dx3LtR :: Handler Y.Html
getPCocos2dx3LtR = do
    defaultLayout $ do
        withDefaultIO $ do
            Y.setTitle "Cocos2d-x 3.0 と C++11"
            Y.addScriptAttrs
                (StaticR publication_io_2012_slides_js_require_1_0_8_min_js)
                [("data-main", "../static/publication/js/default")]
            $(widgetFile "publication/cocos2dx3-lt")
