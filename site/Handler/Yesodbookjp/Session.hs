module Handler.Yesodbookjp.Session (
  getYSessionR
) where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler, Route(StaticR))
import Settings (widgetFile)
import Modules.RawString (rawstring)
import Settings.StaticFiles
  ( yesodbookjp_img_messages_1
  , yesodbookjp_img_messages_2
  , yesodbookjp_img_messages_3
  , yesodbookjp_img_messages_4
  )
import Handler.Yesodbookjp.Layout (withSidebar)

getYSessionR :: Handler Y.Html
getYSessionR = do
    Y.defaultLayout $ do
        withSidebar (Just "セッション") $ do
            $(widgetFile "yesodbookjp/session")

code1 :: String
code1 = [rawstring|
{-# LANGUAGE TypeFamilies, QuasiQuotes, TemplateHaskell, MultiParamTypeClasses, OverloadedStrings #-}
import Yesod
import Control.Applicative ((<$>), (<*>))
import qualified Web.ClientSession as CS

data SessionExample = SessionExample

mkYesod "SessionExample" [parseRoutes|
/ Root GET POST
｜]

getRoot :: Handler RepHtml
getRoot = do
    sess <- getSession
    hamletToRepHtml [hamlet|
<form method=post>
    <input type=text name=key>
    <input type=text name=val>
    <input type=submit>
<h1>#{show sess}
｜]

postRoot :: Handler ()
postRoot = do
    (key, mval) <- runInputPost $ (,) <$> ireq textField "key" <*> iopt textField "val"
    case mval of
        Nothing -> deleteSession key
        Just val -> setSession key val
    liftIO $ print (key, mval)
    redirect Root

instance Yesod SessionExample where
    -- １分でタイムアウトするセッションを作る。
    -- こうすると簡単にテストできるようになる。
    makeSessionBackend _ = do
        key <- CS.getKey CS.defaultKeyFile
        return $ Just $ clientSessionBackend key 1

instance RenderMessage SessionExample FormMessage where
    renderMessage _ _ = defaultFormMessage

main :: IO ()
main = warpDebug 3000 SessionExample
|]

code2 :: String
code2 = [rawstring|
{-# LANGUAGE OverloadedStrings, TypeFamilies, TemplateHaskell,
             QuasiQuotes, MultiParamTypeClasses #-}
import Yesod

data Messages = Messages

mkYesod "Messages" [parseRoutes|
/ RootR GET
/set-message SetMessageR POST
｜]

instance Yesod Messages where
    defaultLayout widget = do
        pc <- widgetToPageContent widget
        mmsg <- getMessage
        hamletToRepHtml [hamlet|
$doctype 5
<html>
    <head>
        <title>#{pageTitle pc}
        ^{pageHead pc}
    <body>
        $maybe msg <- mmsg
            <p>Your message was: #{msg}
        ^{pageBody pc}
｜]

instance RenderMessage Messages FormMessage where
    renderMessage _ _ = defaultFormMessage

getRootR :: Handler RepHtml
getRootR = defaultLayout [whamlet|
<form method=post action=@{SetMessageR}>
    My message is: #
    <input type=text name=message>
    <input type=submit>
｜]

postSetMessageR :: Handler ()
postSetMessageR = do
    msg <- runInputPost $ ireq textField "message"
    setMessage $ toHtml msg
    redirect RootR

main :: IO ()
main = warpDebug 3000 Messages
|]

code3 :: String
code3 = [rawstring|
{-# LANGUAGE OverloadedStrings, TypeFamilies, TemplateHaskell,
             QuasiQuotes, MultiParamTypeClasses #-}
import Yesod

data UltDest = UltDest

mkYesod "UltDest" [parseRoutes|
/ RootR GET
/setname SetNameR GET POST
/sayhello SayHelloR GET
｜]

instance Yesod UltDest

instance RenderMessage UltDest FormMessage where
    renderMessage _ _ = defaultFormMessage

getRootR = defaultLayout [whamlet|
<p>
    <a href=@{SetNameR}>Set your name
<p>
    <a href=@{SayHelloR}>Say hello
｜]

-- 名前を設定するフォームを表示する
getSetNameR = defaultLayout [whamlet|
<form method=post>
    My name is #
    <input type=text name=name>
    . #
    <input type=submit value="Set name">
｜]

-- ユーザから POST された名前を取得する
postSetNameR :: Handler ()
postSetNameR = do
    -- POST された名前を取得し、セッションに設定する
    name <- runInputPost $ ireq textField "name"
    setSession "name" name

    -- その後、最終転送先へリダイレクトする。
    -- もし転送先がセットされてないなら、デフォルトのページへ転送される。
    redirectUltDest RootR

getSayHelloR = do
    -- セッションから "name" の値を検索する
    mname <- lookupSession "name"
    case mname of
        Nothing -> do
            -- セッションに名前が設定されていない場合、
            -- 現在のページを最終転送先として設定し、
            -- SetName ページヘリダイレクトする。
            setUltDestCurrent
            setMessage "Please tell me your name"
            redirect SetNameR
        Just name -> defaultLayout [whamlet|
<p>Welcome #{name}
｜]

main :: IO ()
main = warpDebug 3000 UltDest
|]
