module Handler.Blog.Blog
  ( Blog(..)
  , recentBlogs
  , taggedBlogs
  , urlBlog
  , allTags
  ) where

import Import
import qualified Data.Text                              as T
import qualified Data.Function                          as Func
import qualified Data.List                              as List

import Prelude (head)

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
      (strptime' "2014-01-25 03:28:00")
      ["Haskell", "Yesod"]
      "created-blog"
      "新しいブログ作りました"
      "templates/blog/created-blog.hamlet"
  ]

recentBlogs :: [Blog]
recentBlogs = take 5 $ List.sortBy (compare `Func.on` blogDateTime) blogs

taggedBlogs :: T.Text -> [Blog]
taggedBlogs tag = take 5 $ filter (any (tag==) . blogTags) blogs

urlBlog :: T.Text -> Blog
urlBlog url = maybe (error "url Not Found") id $ List.find ((url==) . blogURL) blogs

allTags :: [T.Text]
allTags = List.nub $ concat $ map blogTags blogs
