module Handler.Blog.Tag
  ( getBTagR
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Data.Text                              as T

import Foundation (Handler)
import Handler.Blog.Blog (taggedBlogs)
import Handler.Blog.Renderer (renderBlogs)

getBTagR :: T.Text -> Handler Y.Html
getBTagR tag = do
    Y.defaultLayout $ do
        renderBlogs $ taggedBlogs tag
