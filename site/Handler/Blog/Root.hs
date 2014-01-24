module Handler.Blog.Root
  ( getBRootR
  ) where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler)
import Handler.Blog.Blog (recentBlogs)
import Handler.Blog.Renderer (renderBlogs)
import Handler.Header (getHeader)

getBRootR :: Handler Y.Html
getBRootR = do
    Y.defaultLayout $ do
        let header = getHeader "blog"
        renderBlogs header recentBlogs
