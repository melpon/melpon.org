module Handler.Blog.Feed
  ( getBFeedR
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Yesod.Feed                             as YFeed

import Prelude (head)

import Foundation (Handler, Route(BUrlR, BRootR), App)
import Handler.Blog.Blog (recentBlogs, Blog(..))
import Handler.Blog.Renderer (Renderer, blogToHtml)

toEntry :: Renderer -> Blog -> IO (YFeed.FeedEntry (Route App))
toEntry renderer blog = do
    html <- blogToHtml renderer blog
    return YFeed.FeedEntry
        { YFeed.feedEntryLink    = BUrlR $ blogURL blog
        , YFeed.feedEntryUpdated = blogDateTime blog
        , YFeed.feedEntryTitle   = blogTitle blog
        , YFeed.feedEntryContent = html
        }

toFeed :: Renderer -> [Blog] -> IO (YFeed.Feed (Route App))
toFeed renderer blogs = do
    entries <- mapM (toEntry renderer) blogs
    return YFeed.Feed
        { YFeed.feedAuthor      = "melpon"
        , YFeed.feedTitle       = "Blog :: Licensed by Meatware"
        , YFeed.feedDescription = "blog by melpon"
        , YFeed.feedLanguage    = "ja"
        , YFeed.feedLinkSelf    = BRootR
        , YFeed.feedLinkHome    = BRootR
        , YFeed.feedUpdated     = YFeed.feedEntryUpdated $ head entries
        , YFeed.feedEntries     = entries
        }

getBFeedR :: Handler Y.TypedContent
getBFeedR = do
    renderer <- Y.getUrlRenderParams
    feed <- Y.liftIO $ toFeed renderer recentBlogs
    YFeed.newsFeed feed
