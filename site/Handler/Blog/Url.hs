module Handler.Blog.Url
  ( getBUrlR
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Data.Text                              as T

import Foundation (Handler, Route(BUrlR))
import Handler.Blog.Blog (urlBlogNextPrev, Blog(blogTitle, blogURL))
import Handler.Blog.Renderer (renderBlogsGuide)
import Handler.Header (getSubHeader)

getBUrlR :: T.Text -> Handler Y.Html
getBUrlR url = do
    Y.defaultLayout $ do
        let (blog, next, prev) = urlBlogNextPrev url
        let mNext = (,)
                        <$> (blogTitle <$> next)
                        <*> ((BUrlR . blogURL) <$> next)
        let mPrev = (,)
                        <$> (blogTitle <$> prev)
                        <*> ((BUrlR . blogURL) <$> prev)
        let header = getSubHeader "blog" $ T.unpack $ blogTitle blog
        renderBlogsGuide header [blog] mNext mPrev
