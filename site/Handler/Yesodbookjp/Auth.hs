module Handler.Yesodbookjp.Auth (
  getYAuthAndAuthR
) where

import Import
import qualified Yesod                                  as Y

import Foundation (Handler, Route(StaticR))
import Settings (widgetFile)
import Modules.RawString (rawstring)
import Settings.StaticFiles
  ( yesodbookjp_img_initial_screen
  , yesodbookjp_img_login_with_browserid
  , yesodbookjp_img_after_login
  )
import Handler.Yesodbookjp.Layout (withSidebar)

getYAuthAndAuthR :: Handler Y.Html
getYAuthAndAuthR = do
    Y.defaultLayout $ do
        withSidebar (Just "認証と認可") $ do
            $(widgetFile "yesodbookjp/auth")


code1 :: String
code1 = [rawstring|
{-# LANGUAGE OverloadedStrings, TemplateHaskell, TypeFamilies,
             MultiParamTypeClasses, QuasiQuotes #-}
import Yesod
import Yesod.Auth
import Yesod.Auth.BrowserId
import Yesod.Auth.GoogleEmail
import Data.Text (Text)
import Network.HTTP.Conduit (Manager, newManager, def)

data MyAuthSite = MyAuthSite
    { httpManager :: Manager
    }

mkYesod "MyAuthSite" [parseRoutes|
/ RootR GET
/auth AuthR Auth getAuth
｜]

instance Yesod MyAuthSite where
    -- Note: BrowserID を記録するためには、ここに正確なホスト名を書く必要がある。
    approot = ApprootStatic "http://localhost:3000"

instance YesodAuth MyAuthSite where
    type AuthId MyAuthSite = Text
    getAuthId = return . Just . credsIdent

    loginDest _ = RootR
    logoutDest _ = RootR

    authPlugins _ =
        [ authBrowserId
        , authGoogleEmail
        ]

    authHttpManager = httpManager

instance RenderMessage MyAuthSite FormMessage where
    renderMessage _ _ = defaultFormMessage

getRootR :: Handler RepHtml
getRootR = do
    maid <- maybeAuthId
    defaultLayout [whamlet|
<p>Your current auth ID: #{show maid}
$maybe _ <- maid
    <p>
        <a href=@{AuthR LogoutR}>Logout
$nothing
    <p>
        <a href=@{AuthR LoginR}>Go to the login page
｜]

main :: IO ()
main = do
    man <- newManager def
    warpDebug 3000 $ MyAuthSite man
|]

code2 :: String
code2 = [rawstring|
{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes, GADTs,
             TemplateHaskell, MultiParamTypeClasses, FlexibleContexts #-}
import Yesod
import Yesod.Auth
import Yesod.Auth.Email
import Database.Persist.Sqlite
import Database.Persist.TH
import Data.Text (Text)
import Network.Mail.Mime
import qualified Data.Text.Lazy.Encoding
import Text.Shakespeare.Text (stext)
import Text.Blaze.Html.Renderer.Utf8 (renderHtml)
import Text.Hamlet (shamlet)
import Data.Maybe (isJust)
import Control.Monad (join)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persist|
User
    email Text
    password Text Maybe -- パスワードが設定されない場合もある
    verkey Text Maybe -- パスワードリセットで使う
    verified Bool
    UniqueUser email
｜]

data MyEmailApp = MyEmailApp Connection

mkYesod "MyEmailApp" [parseRoutes|
/ RootR GET
/auth AuthR Auth getAuth
｜]

instance Yesod MyEmailApp where
    -- メールにリンクを含めるなら、そのメールには approot を入れるのが正しい。
    -- これはリンクが確実に有効であるようにするためである。
    approot = ApprootStatic "http://localhost:3000"

instance RenderMessage MyEmailApp FormMessage where
    renderMessage _ _ = defaultFormMessage

-- Persistent のセットアップ
instance YesodPersist MyEmailApp where
    type YesodPersistBackend MyEmailApp = SqlPersist
    runDB f = do
        MyEmailApp conn <- getYesod
        runSqlConn f conn

instance YesodAuth MyEmailApp where
    type AuthId MyEmailApp = UserId

    loginDest _ = RootR
    logoutDest _ = RootR
    authPlugins _ = [authEmail]

    -- 渡されたメールアドレスから UserId を探す必要がある。
    getAuthId creds = runDB $ do
        x <- insertBy $ User (credsIdent creds) Nothing Nothing False
        return $ Just $
            case x of
                Left (Entity userid _) -> userid -- newly added user
                Right userid -> userid -- existing user

    authHttpManager = error "Email doesn't need an HTTP manager"

-- ここはメール専用のコード
instance YesodAuthEmail MyEmailApp where
    type AuthEmailId MyEmailApp = UserId

    addUnverified email verkey =
        runDB $ insert $ User email Nothing (Just verkey) False

    sendVerifyEmail email _ verurl =
        liftIO $ renderSendMail (emptyMail $ Address Nothing "noreply")
            { mailTo = [Address Nothing email]
            , mailHeaders =
                [ ("Subject", "Verify your email address")
                ]
            , mailParts = [[textPart, htmlPart]]
            }
      where
        textPart = Part
            { partType = "text/plain; charset=utf-8"
            , partEncoding = None
            , partFilename = Nothing
            , partContent = Data.Text.Lazy.Encoding.encodeUtf8 [stext|
Please confirm your email address by clicking on the link below.

\#{verurl}

Thank you
｜]
            , partHeaders = []
            }
        htmlPart = Part
            { partType = "text/html; charset=utf-8"
            , partEncoding = None
            , partFilename = Nothing
            , partContent = renderHtml [shamlet|
<p>Please confirm your email address by clicking on the link below.
<p>
    <a href=#{verurl}>#{verurl}
<p>Thank you
｜]
            , partHeaders = []
            }
    getVerifyKey = runDB . fmap (join . fmap userVerkey) . get
    setVerifyKey uid key = runDB $ update uid [UserVerkey =. Just key]
    verifyAccount uid = runDB $ do
        mu <- get uid
        case mu of
            Nothing -> return Nothing
            Just u -> do
                update uid [UserVerified =. True]
                return $ Just uid
    getPassword = runDB . fmap (join . fmap userPassword) . get
    setPassword uid pass = runDB $ update uid [UserPassword =. Just pass]
    getEmailCreds email = runDB $ do
        mu <- getBy $ UniqueUser email
        case mu of
            Nothing -> return Nothing
            Just (Entity uid u) -> return $ Just EmailCreds
                { emailCredsId = uid
                , emailCredsAuthId = Just uid
                , emailCredsStatus = isJust $ userPassword u
                , emailCredsVerkey = userVerkey u
                }
    getEmail = runDB . fmap (fmap userEmail) . get

getRootR :: Handler RepHtml
getRootR = do
    maid <- maybeAuthId
    defaultLayout [whamlet|
<p>Your current auth ID: #{show maid}
$maybe _ <- maid
    <p>
        <a href=@{AuthR LogoutR}>Logout
$nothing
    <p>
        <a href=@{AuthR LoginR}>Go to the login page
｜]

main :: IO ()
main = withSqliteConn "email.db3" $ \conn -> do
    runSqlConn (runMigration migrateAll) conn
    warpDebug 3000 $ MyEmailApp conn
|]

code3 :: String
code3 = [rawstring|
{-# LANGUAGE OverloadedStrings, TemplateHaskell, TypeFamilies,
             MultiParamTypeClasses, QuasiQuotes #-}
import Yesod
import Yesod.Auth
import Yesod.Auth.Dummy -- テストのためのライブラリ。実際には利用してはならない。
import Data.Text (Text)
import Network.HTTP.Conduit (Manager, newManager, def)

data MyAuthSite = MyAuthSite
    { httpManager :: Manager
    }

mkYesod "MyAuthSite" [parseRoutes|
/ RootR GET POST
/admin AdminR GET
/auth AuthR Auth getAuth
｜]

instance Yesod MyAuthSite where
    authRoute _ = Just $ AuthR LoginR

    -- ルート名と、書き込みのリクエストであるかの Bool 値を引数に取る
    isAuthorized RootR True = isAdmin
    isAuthorized AdminR _ = isAdmin

    -- 上記のページ以外には誰でもアクセスすることができる。
    isAuthorized _ _ = return Authorized

isAdmin = do
    mu <- maybeAuthId
    return $ case mu of
        Nothing -> AuthenticationRequired
        Just "admin" -> Authorized
        Just _ -> Unauthorized "You must be an admin"

instance YesodAuth MyAuthSite where
    type AuthId MyAuthSite = Text
    getAuthId = return . Just . credsIdent

    loginDest _ = RootR
    logoutDest _ = RootR

    authPlugins _ = [authDummy]

    authHttpManager = httpManager

instance RenderMessage MyAuthSite FormMessage where
    renderMessage _ _ = defaultFormMessage

getRootR :: Handler RepHtml
getRootR = do
    maid <- maybeAuthId
    defaultLayout [whamlet|
<p>Note: Log in as "admin" to be an administrator.
<p>Your current auth ID: #{show maid}
$maybe _ <- maid
    <p>
        <a href=@{AuthR LogoutR}>Logout
<p>
    <a href=@{AdminR}>Go to admin page
<form method=post>
    Make a change (admins only)
    \ #
    <input type=submit>
｜]

postRootR :: Handler ()
postRootR = do
    setMessage "You made some change to the page"
    redirect RootR

getAdminR :: Handler RepHtml
getAdminR = defaultLayout [whamlet|
<p>I guess you're an admin!
<p>
    <a href=@{RootR}>Return to homepage
｜]

main :: IO ()
main = do
    manager <- newManager def
    warpDebug 3000 $ MyAuthSite manager
|]
