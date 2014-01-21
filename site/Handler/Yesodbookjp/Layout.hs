module Handler.Yesodbookjp.Layout
  ( withSidebar
  ) where

import Import

import Yesod (whamlet)

import Foundation (Widget, Route(..))
import Settings (widgetFile)
import Handler.Header (getHeader, getSubHeader)

makeContents :: String -> Widget
makeContents title = do
    let xs = [ (YIntroductionR, "導入")
             , (YShakespeareR, "Shakespeareテンプレート")
             , (YWidgetsR, "ウィジェット")
             , (YSessionR, "セッション")
             , (YAuthAndAuthR, "認証と認可")
             , (YConduitR, "コンジット") ]
    [whamlet|
        <ul .nav .nav-pills .nav-stacked>
          $forall (route, title') <- xs
              ^{makePage (title == title') route title'}
    |]
  where
    makePage active route title' = do
        [whamlet|
            $if active
              <li .active>
                <a href=@{route}>#{title'}
            $else
              <li>
                <a href=@{route}>#{title'}
        |]


withSidebar :: Maybe String -> Widget -> Widget
withSidebar mTitle widget = do
    $(widgetFile "yesodbookjp/description")
    let contents = makeContents $ maybe "" id mTitle
    [whamlet|
        $maybe title <- mTitle
          ^{getSubHeader "yesodbookjp" title}
        $nothing
          ^{getHeader "yesodbookjp"}

        <div .container-fluid>
          <div .span3>
            ^{contents}
            <a href="@{YRootR}">Home
          <div .span8>
            ^{widget}
    |]
