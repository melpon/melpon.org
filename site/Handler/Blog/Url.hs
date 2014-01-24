module Handler.Blog.Url
  ( getBUrlR
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Data.Text                              as T

import Foundation (Handler)
import Handler.Blog.Blog (urlBlog, Blog(blogTitle))
import Handler.Blog.Renderer (renderBlogs)
import Handler.Header (getSubHeader)

getBUrlR :: T.Text -> Handler Y.Html
getBUrlR url = do
    Y.defaultLayout $ do
        let blog = urlBlog url
        let header = getSubHeader "blog" $ T.unpack $ blogTitle blog
        renderBlogs header $ [blog]
