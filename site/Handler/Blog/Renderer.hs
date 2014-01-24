module Handler.Blog.Renderer
  ( renderBlogs
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Text.Hamlet                            as Hamlet
import qualified Text.Hamlet.RT                         as HamletRT
import qualified Data.Text                              as T
import qualified Data.Text.IO                           as TIO

import Foundation (Widget, App, Route(BTagR, BUrlR))
import Settings (widgetFile)
import Handler.Blog.Blog (Blog(..), allTags)
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
blogToHtml renderer blog = do
    let filepath = blogWidgetFile blog
    let tags = blogTags blog
    let nameToMap name =
            [ (["link"], HamletRT.HDUrl $ BTagR name)
            , (["name"], HamletRT.HDHtml $ Y.toHtml name)
            ]
    let hdTags = HamletRT.HDList $ map nameToMap tags
    let hamletMap =
            [ (["datetime"], HamletRT.HDHtml $ Y.toHtml $ strftime "%Y-%m-%d %H:%M:%S" $ blogDateTime blog)
            , (["tags"], hdTags)
            , (["urlLink"], HamletRT.HDUrl $ BUrlR $ blogURL blog)
            , (["urlName"], HamletRT.HDHtml $ Y.toHtml $ blogURL blog)
            , (["title"], HamletRT.HDHtml $ Y.toHtml $ blogTitle blog)
            ]
    htmlBlog <- loadHamlet
        hamletMap
        renderer
        filepath
    let hamletMap' = (["blog"], HamletRT.HDHtml htmlBlog) : hamletMap
    template <- loadHamlet
        hamletMap'
        renderer
        "templates/blog/blog-template.hamlet"
    return template

getSidebar :: Widget
getSidebar = do
    let tags = allTags
    $(widgetFile "blog/sidebar")

renderBlogs :: Widget -> [Blog] -> Widget
renderBlogs header blogs = do
    renderer <- Y.getUrlRenderParams
    htmlBlogs <- Y.liftIO $ mapM (blogToHtml renderer) blogs
    let hdBlogs = HamletRT.HDList $ map (\blog -> [(["value"], HamletRT.HDHtml blog)]) htmlBlogs
    blog <- Y.liftIO $ loadHamlet
                            [(["blogs"], hdBlogs)]
                            renderer
                            "templates/blog/blog-list.hamlet"
    $(widgetFile "blog/layout")
