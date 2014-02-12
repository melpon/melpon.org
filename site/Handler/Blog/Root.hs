module Handler.Blog.Root
  ( getBRootR
  , getBPageR
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Data.Text                              as T

import Foundation (Handler, Route(BPageR))
import Handler.Blog.Blog
    ( recentBlogs
    , recentBlogsNextPrev
    , Blog(blogTitle, blogURL)
    )
import Handler.Blog.Renderer (renderBlogsGuide)
import Handler.Header (getHeader)

nextPage :: Int -> T.Text
nextPage n = T.concat ["次の", T.pack $ show n, "件"]
prevPage :: Int -> T.Text
prevPage n = T.concat ["前の", T.pack $ show n, "件"]

getBRootR :: Handler Y.Html
getBRootR = do
    Y.defaultLayout $ do
        let header = getHeader "blog"
        let (blogs, prev) = recentBlogs
        let mPrev = (,)
                        <$> ((prevPage . snd) <$> prev)
                        <*> ((BPageR . blogURL . fst) <$> prev)
        renderBlogsGuide header blogs Nothing mPrev

getBPageR :: T.Text -> Handler Y.Html
getBPageR url = do
    Y.defaultLayout $ do
        let header = getHeader "blog"
        let (blogs, next, prev) = recentBlogsNextPrev url
        let mNext = (,)
                        <$> ((nextPage . snd) <$> next)
                        <*> ((BPageR . blogURL . fst) <$> next)
        let mPrev = (,)
                        <$> ((prevPage . snd) <$> prev)
                        <*> ((BPageR . blogURL . fst) <$> prev)
        renderBlogsGuide header blogs mNext mPrev
