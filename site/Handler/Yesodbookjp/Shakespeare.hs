module Handler.Yesodbookjp.Shakespeare (
  getYShakespeareR
) where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler)
import Settings (widgetFile)
import Modules.RawString (rawstring)
import Handler.Yesodbookjp.Layout (withSidebar)

getYShakespeareR :: Handler Y.Html
getYShakespeareR = do
    Y.defaultLayout $ do
        withSidebar (Just "Shakespeareテンプレート") $ do
            $(widgetFile "yesodbookjp/shakespeare")



code1 :: String
code1 = [rawstring|
!!!
<html>
    <head>
        <title>#{pageTitle} - My Site
        <link rel=stylesheet href=@{Stylesheet}>
    <body>
        <h1 .page-title>#{pageTitle}
        <p>Here is a list of your friends:
        $if null friends
            <p>Sorry, I lied, you don't have any friends.
        $else
            <ul>
                $forall friend <- friends
                    <li>#{friendName friend} (#{friendAge friend} years old)
        <footer>^{copyright}
|]

code2 :: String
code2 = [rawstring|#myid
    color: #{red}
    font-size: #{bodyFontSize}
foo bar baz
    background-image: url(@{MyBackgroundR})
|]

code3 :: String
code3 = [rawstring|
section.blog {
    padding: 1em;
    border: 1px solid #000;
    h1 {
        color: #{headingColor};
    }
}
|]

code4 :: String
code4 = [rawstring|
$(function(){
    $("section.#{sectionClass}").hide();
    $("#mybutton").click(function(){document.location = "@{SomeRouteR}";});
    ^{addBling}
});
|]

code5 :: String
code5 = [rawstring|
<p>Hello, my name is #{name}
|]

code6 :: String
code6 = [rawstring|
data MyRoute = Home | Time
|]

code7 :: String
code7 = [rawstring|
renderMyRoute :: MyRoute -> Text
renderMyRoute Home = "http://example.com/profile/home"
renderMyRoute Time = "http://example.com/display/time"
|]

code8 :: String
code8 = [rawstring|
type Query = [(Text, Text)]
type Render url = url -> Query -> Text
renderMyRoute :: Render MyRoute
renderMyRoute Home _ = ...
renderMyRoute Time _ = ...
|]

code9 :: String
code9 = [rawstring|
<a href=@{Time}>The time
|]

code10 :: String
code10 = [rawstring|
\render -> mconcat ["<a href='", render Time, "'>The time</a>"]
|]

code11 :: String
code11 = [rawstring|
<body>
<p>Some paragraph.</p>
<ul>
<li>Item 1</li>
<li>Item 2</li>
</ul>
</body>
|]

code12 :: String
code12 = [rawstring|
<body>
    <p>Some paragraph.
    <ul>
        <li>Item 1
        <li>Item 2
|]

code13 :: String
code13 = [rawstring|
<p>Paragraph <i>italic</i> end.</p>
|]

code14 :: String
code14 = [rawstring|
<p>
    Paragraph #
    <i>italic
    \ end.
|]

code15 :: String
code15 = [rawstring|
<p>Paragraph <i>italic</i> end.
|]

code16 :: String
code16 = [rawstring|
<head>
    <title>#{title}
|]

code17 :: String
code17 = [rawstring|
-- shamlet による準クォートについては今は無視する。
-- それは後で説明する。
{-# LANGUAGE QuasiQuotes #-}
import Text.Hamlet (shamlet)
import Text.Blaze.Renderer.String (renderHtml)
import Data.Char (toLower)
import Data.List (sort)

data Person = Person
    { name :: String
    , age  :: Int
    }

main :: IO ()
main = putStrLn $ renderHtml [shamlet|
<p>Hello, my name is #{name person} and I am #{show $ age person}.
<p>
    Let's do some funny stuff with my name: #
    <b>#{sort $ map toLower (name person)}
<p>Oh, and in 5 years I'll be #{show $ (+) 5 (age person)} years old.
｜］
  where
    person = Person "Michael" 26
|]

code18 :: String
code18 = [rawstring|
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
import Text.Hamlet (HtmlUrl, hamlet)
import Text.Blaze.Renderer.String (renderHtml)
import Data.Text (Text)

data MyRoute = Home

render :: MyRoute -> [(Text, Text)] -> Text
render Home _ = "/home"

footer :: HtmlUrl MyRoute
footer = [hamlet|
<footer>
    Return to #
    <a href=@{Home}>Homepage
    .
｜］

main :: IO ()
main = putStrLn $ renderHtml $ [hamlet|
<body>
    <p>This is my page.
    ^{footer}
｜］ render
|]

code19 :: String
code19 = [rawstring|
$if isAdmin
    <p>Welcome to the admin section.
$elseif isLoggedIn
    <p>You are not the administrator.
$else
    <p>I don't know who you are. Please log in so I can decide if you get access.
|]

code20 :: String
code20 = [rawstring|
$maybe name <- maybeName
    <p>Your name is #{name}
$nothing
    <p>I don't know your name.
|]

code21 :: String
code21 = [rawstring|
$if null people
    <p>No people.
$else
    <ul>
        $forall person <- people
            <li>#{person}
|]

code22 :: String
code22 = [rawstring|
$with foo <- (一度だけ実行されるべき、とても長くて汚い式)
    <p>しかし私は #{foo} を何度も使うだろう。#{foo}
|]

code23 :: String
code23 = [rawstring|
!!!
<html>
    <head>
        <title>Hamlet is Awesome
    <body>
        <p>All done.
|]

code24 :: String
code24 = [rawstring|#banner
    border: 1px solid #{bannerColor}
    background-image: url(@{BannerImageR})
|]

code25 :: String
code25 = [rawstring|
article code { background-color: grey; }
article p { text-indent: 2em; }
article a { text-decoration: none; }
|]

code26 :: String
code26 = [rawstring|
article {
    code { background-color: grey; }
    p { text-indent: 2em; }
    a { text-decoration: none; }
}
|]

code27 :: String
code27 = [rawstring|
@textcolor: #ccc; /* just because we hate our users */
body { color: #{textcolor} }
a:link, a:visited { color: #{textcolor} }
|]

code28 :: String
code28 = [rawstring|
{-# LANGUAGE OverloadedStrings #-} -- we're using Text below
{-# LANGUAGE QuasiQuotes #-}
import Text.Hamlet (HtmlUrl, hamlet)
import Data.Text (Text)
import Text.Blaze.Renderer.String (renderHtml)

data MyRoute = Home | Time | Stylesheet

render :: MyRoute -> [(Text, Text)] -> Text
render Home _ = "/home"
render Time _ = "/time"
render Stylesheet _ = "/style.css"

template :: Text -> HtmlUrl MyRoute
template title = [hamlet|
$doctype 5
<html>
    <head>
        <title>#{title}
        <link rel=stylesheet href=@{Stylesheet}>
    <body>
        <h1>#{title}
｜］

main :: IO ()
main = putStrLn $ renderHtml $ template "My Title" render
|]

code29 :: String
code29 = [rawstring|
{-# LANGUAGE OverloadedStrings #-} -- we're using Text below
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE CPP #-} -- to control production versus debug
import Text.Lucius (CssUrl, luciusFile, luciusFileDebug, renderCss)
import Data.Text (Text)
import qualified Data.Text.Lazy.IO as TLIO

data MyRoute = Home | Time | Stylesheet

render :: MyRoute -> [(Text, Text)] -> Text
render Home _ = "/home"
render Time _ = "/time"
render Stylesheet _ = "/style.css"

template :: CssUrl MyRoute
＃if PRODUCTION
template = $(luciusFile "template.lucius")
＃else
template = $(luciusFileReload "template.lucius")
＃endif

main :: IO ()
main = TLIO.putStrLn $ renderCss $ template render
|]

code30 :: String
code30 = [rawstring|
-- @template.lucius
foo { bar: baz }
|]

code31 :: String
code31 = [rawstring|
data Msg = Hello | Apples Int
|]

code32 :: String
code32 = [rawstring|
renderJapanese :: Msg -> Text
renderJapanese Hello = "こんにちは"
renderJapanese (Apples 0) = "あなたはリンゴを買っていない"
renderJapanese (Apples i) = T.concat ["あなたは", T.pack $ show i, "個のリンゴを買った"]
|]

code33 :: String
code33 = [rawstring|
$doctype 5
<html>
    <head>
        <title>i18n
    <body>
        <h1>_{Hello}
        <p>_{Apples count}
|]

code34 :: String
code34 = [rawstring|
type Render url = url -> [(Text, Text)] -> Text
type Translate msg = msg -> Html
type HtmlUrlI18n msg url = Translate msg -> Render url -> Html
|]

code35 :: String
code35 = [rawstring|
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
import Data.Text (Text)
import qualified Data.Text as T
import Text.Hamlet (HtmlUrlI18n, ihamlet)
import Text.Blaze (toHtml)
import Text.Blaze.Renderer.String (renderHtml)

data MyRoute = Home | Time | Stylesheet

renderUrl :: MyRoute -> [(Text, Text)] -> Text
renderUrl Home _ = "/home"
renderUrl Time _ = "/time"
renderUrl Stylesheet _ = "/style.css"

data Msg = Hello | Apples Int

renderJapanese :: Msg -> Text
renderJapanese Hello = "こんにちは"
renderJapanese (Apples 0) = "あなたはリンゴを買っていない"
renderJapanese (Apples i) = T.concat ["あなたは", T.pack $ show i, "個のリンゴを買った"]

template :: Int -> HtmlUrlI18n Msg MyRoute
template count = [ihamlet|
$doctype 5
<html>
    <head>
        <title>i18n
    <body>
        <h1>_{Hello}
        <p>_{Apples count}
｜］

main :: IO ()
main = putStrLn $ renderHtml
     $ (template 5) (toHtml . renderJapanese) renderUrl
|]

code36 :: String
code36 = [rawstring|
{-# LANGUAGE QuasiQuotes, OverloadedStrings #-}
import Text.Shakespeare.Text
import qualified Data.Text.Lazy.IO as TLIO
import Data.Text (Text)
import Control.Monad (forM_)

data Item = Item
    { itemName :: Text
    , itemQty :: Int
    }

items :: [Item]
items =
    [ Item "apples" 5
    , Item "bananas" 10
    ]

main :: IO ()
main = forM_ items $ \item -> TLIO.putStrLn
    [lt|You have #{show $ itemQty item} #{itemName item}.｜］
|]
