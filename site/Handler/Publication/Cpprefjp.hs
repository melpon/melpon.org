module Handler.Publication.Cpprefjp
  ( getPCpprefjpR
  ) where

import Import
import qualified Yesod                                  as Y

import Settings (widgetFile)
import Foundation (Handler, Widget, Route(StaticR))
import Settings.StaticFiles
  ( publication_io_2012_slides_js_require_1_0_8_min_js
  , publication_img_cpprefjp_to_github_png
  , publication_img_github_to_cpprefjp_png
  , publication_img_cpprefjp_ui_png
  , publication_img_cpprefjp_comtg1_png
  , publication_img_cpprefjp_comtg2_png
  , publication_img_cpprefjp_comtg3_png
  )
import Handler.Publication.Slide (getTitleWidget, indexToWidget, Index(..), Title(..), defaultLayout, withDefaultIO)

indexData :: Index
indexData = Index "目次"
  [ TitleOnly ("overview", "cpprefjpの概要")
  , TitleOnly ("problem", "Google Sitesの問題点")
  , Title ("do", "GitHubへの移行")
      [ TitleOnly ("1st", "Google SitesからGitHubへ(@cpp_akira)")
      , TitleOnly ("2nd", "GitHubからGoogle Sitesへ(@melponn)")
      ]
  ]

index :: Maybe String -> Widget
index = indexToWidget indexData

title :: String -> Widget
title = getTitleWidget indexData

indexData2 :: Index
indexData2 = Index "GitHubからGoogle Siteへ"
  [ TitleOnly ("motivation", "動機")
  , Title ("create", "作ったもの")
      [ Title ("md-to-html", "MarkdownからHTMLへ")
          [ TitleOnly ("highlight", "シンタックスハイライト")
          , TitleOnly ("github", "GitHubの差分管理")
          ]
      , Title ("html-to-google", "HTMLからGoogle Sitesへ")
          [ TitleOnly ("script", "スクリプトの制限")
          , TitleOnly ("error", "エラー通知")
          ]
      ]
  ]

index2 :: Maybe String -> Widget
index2 = indexToWidget indexData2

title2 :: String -> Widget
title2 = getTitleWidget indexData2

getPCpprefjpR :: Handler Y.Html
getPCpprefjpR = do
    defaultLayout $ do
        withDefaultIO $ do
            Y.setTitle "cpprefjpを支える技術"
            Y.addScriptAttrs
                (StaticR publication_io_2012_slides_js_require_1_0_8_min_js)
                [("data-main", "../static/publication/js/default")]
            $(widgetFile "publication/cpprefjp")
