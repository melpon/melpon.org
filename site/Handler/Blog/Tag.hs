module Handler.Blog.Tag
  ( getBTagR
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Data.Text                              as T

import Foundation (Handler)
import Handler.Blog.Blog (taggedBlogs)
import Handler.Blog.Renderer (renderBlogs)
import Handler.Header (getSubHeader)

getBTagR :: T.Text -> Handler Y.Html
getBTagR tag = do
    Y.defaultLayout $ do
        let header = getSubHeader "blog" $ T.unpack $ T.concat ["tag:", tag]
        renderBlogs header $ taggedBlogs tag
