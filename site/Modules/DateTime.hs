module Modules.DateTime
  ( strptime
  , strftime
  , DateTime
  ) where

import Import
import qualified Data.Time                              as Time
import qualified System.Locale                          as Locale

type DateTime = Time.UTCTime
type Format = String

strptime :: Format -> String -> DateTime
strptime format string = Time.readTime Locale.defaultTimeLocale format string

strftime :: Format -> DateTime -> String
strftime format datetime = Time.formatTime Locale.defaultTimeLocale format datetime

