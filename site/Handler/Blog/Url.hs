module Handler.Blog.Url
  ( getBUrlR
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Data.Text                              as T

import Foundation (Handler)
import Handler.Blog.Blog (urlBlog)
import Handler.Blog.Renderer (renderBlogs)

getBUrlR :: T.Text -> Handler Y.Html
getBUrlR url = do
    Y.defaultLayout $ do
        renderBlogs $ [urlBlog url]
