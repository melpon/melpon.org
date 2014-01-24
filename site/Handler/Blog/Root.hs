module Handler.Blog.Root
  ( getBRootR
  ) where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler)
import Handler.Blog.Blog (recentBlogs)
import Handler.Blog.Renderer (renderBlogs)

getBRootR :: Handler Y.Html
getBRootR = do
    Y.defaultLayout $ do
        renderBlogs recentBlogs
