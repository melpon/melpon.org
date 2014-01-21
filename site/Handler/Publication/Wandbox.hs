{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Publication.Wandbox
  ( getPWandboxR
  ) where

import Import
import qualified Yesod                                  as Y

import Settings (widgetFile)
import Foundation (Handler, Widget, Route(StaticR))
import Settings.StaticFiles
  ( publication_io_2012_slides_js_require_1_0_8_min_js
  , publication_img_wandbox_actor_png
  , publication_img_mighttpd_001_png
  , publication_img_mighttpd_002_png
  )
import Modules.RawString (rawstring)
import Handler.Publication.Slide (getTitleWidget, indexToWidget, Index(..), Title(..), defaultLayout, withDefaultIO)

widgetUI :: Widget
widgetUI = $(widgetFile "publication/wandbox-ui")

internalIndexData :: Index
internalIndexData = Index "目次"
  [ TitleOnly ("relation", "牛舎と犬小屋の関係")
  , TitleOnly ("cattleshed", "牛舎")
  , Title ("kennel", "犬小屋")
      [ TitleOnly ("yesod", "Yesod")
      , TitleOnly ("templates", "Templates")
      , TitleOnly ("eventsource", "EventSource")
      ]
  , TitleOnly ("kurou", "苦労話")
  ]

internalIndex :: Maybe String -> Widget
internalIndex = indexToWidget internalIndexData

internalTitle :: String -> Widget
internalTitle = getTitleWidget internalIndexData

widgetInternal :: Widget
widgetInternal = $(widgetFile "publication/wandbox-internal")

serverIndexData :: Index
serverIndexData = Index "目次"
  [ Title ("all", "全体構成")
      [ TitleOnly ("mighttpd", "Mighttpd")
      ]
  , Title ("management", "サーバ管理")
      [ TitleOnly ("chef", "Chef")
      , TitleOnly ("deploy", "Deploy")
      ]
  ]

serverIndex :: Maybe String -> Widget
serverIndex = indexToWidget serverIndexData

serverTitle :: String -> Widget
serverTitle = getTitleWidget serverIndexData

widgetServer :: Widget
widgetServer = $(widgetFile "publication/wandbox-server")

sourceHamletSample1 :: String
sourceHamletSample1 = [rawstring|
<div .span2 #editor-settings>
  <label .row-fluid>choose key binding:
  <select .span12 size=3>
    <option value="ace" selected>default
    <option value="vim">Vim
    <option value="emacs">Emacs
  <label .checkbox>
    <input type="checkbox" value="use-legacy-editor">Use Legacy Editor
|]

sourceHamletSample1Html :: String
sourceHamletSample1Html = [rawstring|
<div class="span2" id="editor-settings">
  <label class="row-fluid">choose key binding:</label>
  <select class="span12" size=3>
    <option value="ace" selected>default</option>
    <option value="vim">Vim</option>
    <option value="emacs">Emacs</option>
  </select>
  <label class="checkbox">
    <input type="checkbox" value="use-legacy-editor">Use Legacy Editor</input>
  </label>
</div>
|]

sourceHamletSample2 :: String
sourceHamletSample2 = [rawstring|
<div .row-fluid>
  <div #compile-options>
    $forall info <- compilerInfos
      <div compiler="#{verName $ ciVersion info}">
        $forall sw <- ciSwitches info
          ^{makeSwitch (verName (ciVersion info)) sw}
|]

sourceLuciusSample :: String
sourceLuciusSample = [rawstring|
@textcolor: #ccc;
body {
  color: #{textcolor};
  a {
    color: #{textcolor};
  }
}
|]

sourceLuciusSampleCss :: String
sourceLuciusSampleCss = [rawstring|
body {
  color: #ccc;
}
body a {
  color: #ccc;
}
|]

sourceJuliusSample :: String
sourceJuliusSample = [rawstring|
$(function() {
  var result_container = new ResultContainer('#result-container')
  result_container.onfinish = function() {
    $('#compile').show();
    $('#compiling').hide();
  };
  ...
  var compiler = new Compiler('#compiler', '#compile-options');
  compiler.set_compiler(#{defaultCompiler});
});
|]

sourceLoopSample :: String
sourceLoopSample = [rawstring|
main = mapM_ print [1..]
|]

getPWandboxR :: Handler Y.Html
getPWandboxR = do
    defaultLayout $ do
        withDefaultIO $ do
            Y.setTitle "Wandbox"
            Y.addScriptAttrs
                (StaticR publication_io_2012_slides_js_require_1_0_8_min_js)
                [("data-main", "../static/publication/js/wandbox-slides")]
            $(widgetFile "publication/io-2012-ext")
            $(widgetFile "publication/wandbox")
