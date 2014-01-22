{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application
    ( makeApplication
    , getApplicationDev
    , makeFoundation
    ) where

import Import
import qualified Yesod                                  as Y
import qualified Yesod.Core.Types                       as YCoreTypes
import qualified Yesod.Default.Config                   as YDConfig
import qualified Yesod.Default.Main                     as YDMain
import qualified Network.Wai.Middleware.RequestLogger   as RequestLogger
import qualified Network.Wai.Logger                     as WaiLogger
import qualified Data.Default                           as Default
import qualified System.Log.FastLogger                  as FastLogger
import qualified GHC.IO.FD

import Yesod.Default.Handlers (getFaviconR, getRobotsR)
import Network.Wai.Middleware.Autohead (autohead)

import Foundation (resourcesApp, App(..), getStatic, Route(..))
import Settings (Extra, parseExtra)
import Settings.StaticFiles (staticSite)
import Settings.Development (development)

-- Import all relevant handler modules here.
-- Don't forget to add new modules to your cabal file!
import Handler.Home (getHomeR)
import Handler.Aboutme (getAboutmeR)
import Handler.Publication.Root (getPRootR)
import Handler.Publication.Wandbox (getPWandboxR)
import Handler.Publication.KabukizaWandboxLt (getPKabukizaWandboxLtR)
import Handler.Publication.Cocos2dx3Lt (getPCocos2dx3LtR)
import Handler.Yesodbookjp.Root (getYRootR)
import Handler.Yesodbookjp.Auth (getYAuthAndAuthR)
import Handler.Yesodbookjp.Conduit (getYConduitR)
import Handler.Yesodbookjp.Introduction (getYIntroductionR)
import Handler.Yesodbookjp.Session (getYSessionR)
import Handler.Yesodbookjp.Shakespeare (getYShakespeareR)
import Handler.Yesodbookjp.Widgets (getYWidgetsR)

-- This line actually creates our YesodDispatch instance. It is the second half
-- of the call to mkYesodData which occurs in Foundation.hs. Please see the
-- comments there for more details.
Y.mkYesodDispatch "App" resourcesApp

-- This function allocates resources (such as a database connection pool),
-- performs initialization and creates a WAI application. This is also the
-- place to put your migrate statements to have automatic database
-- migrations handled by Yesod.
makeApplication :: YDConfig.AppConfig YDConfig.DefaultEnv Extra -> IO Y.Application
makeApplication conf = do
    foundation <- makeFoundation conf

    -- Initialize the logging middleware
    logWare <- RequestLogger.mkRequestLogger Default.def
        { RequestLogger.outputFormat =
            if development
                then RequestLogger.Detailed True
                else RequestLogger.Apache RequestLogger.FromSocket
        , RequestLogger.destination = RequestLogger.Logger $ YCoreTypes.loggerSet $ appLogger foundation
        }

    -- Create the WAI application and apply middlewares
    app <- Y.toWaiAppPlain foundation
    return $ (logWare . autohead) app

-- | Loads up any necessary settings, creates your foundation datatype, and
-- performs some initialization.
makeFoundation :: YDConfig.AppConfig YDConfig.DefaultEnv Extra -> IO App
makeFoundation conf = do
    s <- staticSite

    loggerSet' <- FastLogger.newLoggerSet FastLogger.defaultBufSize GHC.IO.FD.stdout
    (getter, _) <- WaiLogger.clockDateCacher
    let logger = YCoreTypes.Logger loggerSet' getter

    let foundation = App conf s logger

    return foundation

-- for yesod devel
getApplicationDev :: IO (Int, Y.Application)
getApplicationDev =
    YDMain.defaultDevelApp loader makeApplication
  where
    loader = YDConfig.loadConfig (YDConfig.configSettings YDConfig.Development)
        { YDConfig.csParseExtra = parseExtra
        }
