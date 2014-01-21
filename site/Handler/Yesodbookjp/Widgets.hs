module Handler.Yesodbookjp.Widgets (
  getYWidgetsR
) where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler)
import Settings (widgetFile)
import Modules.RawString (rawstring)
import Handler.Yesodbookjp.Layout (withSidebar)

getYWidgetsR :: Handler Y.Html
getYWidgetsR = do
    Y.defaultLayout $ do
        withSidebar (Just "ウィジェット") $ do
            $(widgetFile "yesodbookjp/widgets")



code1 :: String
code1 = [rawstring|
getRootR = defaultLayout $ do
    setTitle "My Page Title"
    toWidget [lucius| h1 { color: green; } ｜］
    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"
    toWidget [julius|
$(function() {
    $("h1").click(function(){ alert("You clicked on the heading!"); });
});
｜］
    toWidgetHead [hamlet| <meta name=keywords content="some sample keywords">｜］
    toWidget [hamlet| <h1>Here's one way of including content ｜］
    [whamlet| <h2>Here's another ｜］
    toWidgetBody [julius| alert("This is included in the body itself"); ｜］
|]

code2 :: String
code2 = [rawstring|
<!DOCTYPE html> 
<html>
    <head>
        <title>My Page Title</title>
        <style>h1 { color : green }</style>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
        <script>
$(function() {
    $("h1").click(function(){ alert("You clicked on the heading!"); });
});
</script>
        <meta name="keywords" content="some sample keywords">
    </head>
    <body>
        <h1>Here's one way of including content </h1>
        <h2>Here's another </h2>
        <script> alert("This is included in the body itself"); </script>
    </body>
</html>
|]

code3 :: String
code3 = [rawstring|
myWidget1 = do
    toWidget [hamlet|<h1>My Title｜］
    toWidget [lucius|h1 { color: green } ｜］

myWidget2 = do
    setTitle "My Page Title"
    addScriptRemote "http://www.example.com/script.js"

myWidget = do
    myWidget1
    myWidget2

-- あるいはこう書いてもいい
myWidget' = myWidget1 >> myWidget2
|]

code4 :: String
code4 = [rawstring|
getRootR = defaultLayout $ do
    headerClass <- lift newIdent
    toWidget [hamlet|<h1 .#{headerClass}>My Header｜］
    toWidget [lucius| .#{headerClass} { color: green; } ｜］
|]

code5 :: String
code5 = [rawstring|
page = [hamlet|
<p>This is my page. I hope you enjoyed it.
^{footer}
｜］

footer = [hamlet|
<footer>
    <p>That's all folks!
｜］
|]

code6 :: String
code6 = [rawstring|
footer = do
    toWidget [lucius| footer { font-weight: bold; text-align: center } ｜］
    toWidget [hamlet|
<footer>
    <p>That's all folks!
｜］
|]

code7 :: String
code7 = [rawstring|
page = [whamlet|
<p>This is my page. I hope you enjoyed it.
^{footer}
｜］
|]

code8 :: String
code8 = [rawstring|
footer :: Widget
footer = do
    toWidget [lucius| footer { font-weight: bold; text-align: center } ｜］
    toWidget [hamlet|
<footer>
    <p>That's all folks!
｜］

page :: Widget
page = [whamlet|
<p>This is my page. I hope you enjoyed it.
^{footer}
｜］
|]

code9 :: String
code9 = [rawstring|
widgetToPageContent :: Widget -> Handler (PageContent url)
data PageContent url = PageContent
    { pageTitle :: Html
    , pageHead :: HtmlUrl url
    , pageBody :: HtmlUrl url
    }
|]

code10 :: String
code10 = [rawstring|
myLayout :: GWidget s MyApp () -> GHandler s MyApp RepHtml
myLayout widget = do
    pc <- widgetToPageContent widget
    hamletToRepHtml [hamlet|
$doctype 5
<html>
    <head>
        <title>#{pageTitle pc}
        <meta charset=utf-8>
        <style>body { font-family: verdana }
        ^{pageHead pc}
    <body>
        <article>
            ^{pageBody pc}
｜］

instance Yesod MyApp where
    defaultLayout = myLayout
|]

code11 :: String
code11 = [rawstring|
myLayout :: GWidget s MyApp () -> GHandler s MyApp RepHtml
myLayout widget = do
    pc <- widgetToPageContent $ do
        widget
        toWidget [lucius| body { font-family: verdana } ｜］
    hamletToRepHtml [hamlet|
$doctype 5
<html>
    <head>
        <title>#{pageTitle pc}
        <meta charset=utf-8>
        ^{pageHead pc}
    <body>
        <article>
            ^{pageBody pc}
｜］
|]

