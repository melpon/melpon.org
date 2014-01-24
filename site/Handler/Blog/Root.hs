module Handler.Blog.Root
  ( getBRootR
  ) where

import Import
import qualified Yesod                                  as Y
import qualified Text.Hamlet                            as Hamlet
import qualified Text.Hamlet.RT                         as HamletRT
import qualified Data.Text                              as T
import qualified Data.Text.IO                           as TIO

import Foundation (Handler, Widget, App, Route(StaticR))
import Settings.StaticFiles (publication_img_pad_png)
import Settings (widgetFile)
import Handler.Blog.Blog (Blog(..), recentBlogs)
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
    let hdTags = HamletRT.HDList $ map (\tag -> [(["value"], HamletRT.HDHtml $ Y.toHtml tag)]) tags
    let hamletMap =
            [ (["datetime"], HamletRT.HDHtml $ Y.toHtml $ strftime "%Y-%m-%d %H:%M:%S" $ blogDateTime blog)
            , (["tags"], hdTags)
            , (["url"], HamletRT.HDHtml $ Y.toHtml $ blogURL blog)
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

renderBlogs :: [Blog] -> Widget
renderBlogs blogs = do
    Y.setTitle ""
    Y.addScriptRemote "//codeorigin.jquery.com/jquery-1.10.2.min.js"
    Y.addScriptRemote "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"
    Y.addStylesheetRemote "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css"
    renderer <- Y.getUrlRenderParams
    htmlBlogs <- Y.liftIO $ mapM (blogToHtml renderer) blogs
    let hdBlogs = HamletRT.HDList $ map (\blog -> [(["value"], HamletRT.HDHtml blog)]) htmlBlogs
    renderer <- Y.getUrlRenderParams
    html <- Y.liftIO $ loadHamlet
                            [(["blogs"], hdBlogs)]
                            renderer
                            "templates/blog/blog-list.hamlet"
    Y.toWidget html

getBRootR :: Handler Y.Html
getBRootR = do
    Y.defaultLayout $ do
        renderBlogs recentBlogs
