module Handler.Blog.Blog
  ( Blog(..)
  , recentBlogs
  ) where

import Import
import qualified Data.Text                              as T

import Modules.DateTime (DateTime, strptime)

data Blog = Blog
  { blogDateTime :: DateTime
  , blogTags :: [T.Text]
  , blogURL :: T.Text
  , blogTitle :: T.Text
  , blogWidgetFile :: FilePath
  }

strptime' :: String -> DateTime
strptime' string = strptime "%Y-%m-%d %H:%M:%S" string

blogs :: [Blog]
blogs =
  [ Blog
      (strptime' "2013-01-01 10:23:45")
      ["tag1", "tag2"]
      "hoge-"
      "たいとる"
      "templates/blog/test.hamlet"
  ]

recentBlogs :: [Blog]
recentBlogs = blogs
