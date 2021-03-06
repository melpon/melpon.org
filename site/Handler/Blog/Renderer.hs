module Handler.Blog.Renderer
  ( Renderer
  , blogToHtml
  , renderBlogs
  , renderBlogsGuide
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Text.Hamlet                            as Hamlet
import qualified Text.Hamlet.RT                         as HamletRT
import qualified Data.Text                              as T
import qualified Data.Text.IO                           as TIO

import Yesod (hamlet)

import Foundation (Widget, App, Route(BTagR, BUrlR, BFeedR, StaticR))
import Settings (widgetFile)
import Settings.StaticFiles (blog_feed_icon_14x14_png)
import Handler.Blog.Blog (Blog(..), allTags, sortedBlogs)
import Modules.DateTime (strftime)

type Renderer = Route App -> [(T.Text, T.Text)] -> T.Text

loadHamlet
  :: HamletRT.HamletMap (Route App)
  -> Renderer
  -> FilePath
  -> IO Y.Html
loadHamlet m f fp = do
    text <- T.unpack <$> TIO.readFile fp
    hrt <- HamletRT.parseHamletRT Hamlet.defaultHamletSettings text
    html <- HamletRT.renderHamletRT hrt m f
    return html

blogToHtml :: Renderer -> Blog -> IO Y.Html
blogToHtml renderer blog' = do
    let datetime = strftime "%Y-%m-%d %H:%M:%S" $ blogDateTime blog'
    let tags = blogTags blog'
    let url = blogURL blog'
    let title = blogTitle blog'
    let filepath = blogWidgetFile blog'
    let nameToMap name =
            [ (["link"], HamletRT.HDUrl $ BTagR name)
            , (["name"], HamletRT.HDHtml $ Y.toHtml name)
            ]
    let hdTags = HamletRT.HDList $ map nameToMap tags
    let hamletMap =
            [ (["datetime"], HamletRT.HDHtml $ Y.toHtml $ datetime)
            , (["tags"], hdTags)
            , (["urlLink"], HamletRT.HDUrl $ BUrlR $ url)
            , (["urlName"], HamletRT.HDHtml $ Y.toHtml $ url)
            , (["title"], HamletRT.HDHtml $ Y.toHtml $ title)
            ]
    blog <- loadHamlet
        hamletMap
        renderer
        filepath
    let template = $(Hamlet.hamletFile "templates/blog/templates/blog-template.hamlet") renderer
    return template

getSidebar :: Widget
getSidebar = do
    let tags = allTags
    $(widgetFile "blog/templates/sidebar")

makeGuide :: Maybe (T.Text, Route App) -> Maybe (T.Text, Route App) -> Widget
makeGuide mNext mPrev = do
    Y.toWidget [hamlet|
      <ul .pager>
        $maybe (title, route) <- mNext
          <li .previous>
            <a href="@{route}">&larr; #{title}
        $maybe (title, route) <- mPrev
          <li .next>
            <a href="@{route}">#{title} &rarr;
    |]

renderBlogs :: Widget -> [Blog] -> Widget
renderBlogs header blogs' =
    renderBlogsGuide header blogs' Nothing Nothing

renderBlogsGuide :: Widget -> [Blog] -> Maybe (T.Text, Route App) -> Maybe (T.Text, Route App) -> Widget
renderBlogsGuide header blogs' next prev = do
    Y.toWidgetHead [hamlet|<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href=@{BFeedR}>|]
    Y.addScriptRemote "//cdnjs.cloudflare.com/ajax/libs/prettify/r298/prettify.js"
    Y.addScriptRemote "//cdnjs.cloudflare.com/ajax/libs/prettify/r298/lang-hs.min.js"

    renderer <- Y.getUrlRenderParams
    blogs <- Y.liftIO $ mapM (blogToHtml renderer) blogs'
    let guide = makeGuide next prev
    let blogData = $(widgetFile "blog/templates/blog-list")
    $(widgetFile "blog/templates/layout")
