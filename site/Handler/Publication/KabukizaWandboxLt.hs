{-# LANGUAGE OverloadedStrings #-}
module Handler.Publication.KabukizaWandboxLt
  ( getPKabukizaWandboxLtR
  ) where

import Import
import qualified Yesod                                  as Y

import Yesod (shamlet)

import Settings (widgetFile)
import Foundation (Handler, Route(StaticR), Widget)
import Settings.StaticFiles
  ( publication_io_2012_slides_js_require_1_0_8_min_js
  )
import Handler.Publication.Slide (defaultLayout, withDefaultIO, toTakahashi, toTakahashiI)

toWandboxURL :: Widget
toWandboxURL = Y.toWidget [shamlet|
<slide>
  <article .takahashi .flexbox .vcenter>
    <h1><a href="http://melpon.org/wandbox">http://melpon.org/wandbox</a>
|]

getPKabukizaWandboxLtR :: Handler Y.Html
getPKabukizaWandboxLtR = do
    defaultLayout $ do
        withDefaultIO $ do
            Y.setTitle "Wandbox の紹介 at 歌舞伎座.tech#2"
            Y.addScriptAttrs
                (StaticR publication_io_2012_slides_js_require_1_0_8_min_js)
                [("data-main", "../static/publication/js/kabukiza-wandbox-lt-slides")]
            $(widgetFile "publication/kabukiza-wandbox-lt")
